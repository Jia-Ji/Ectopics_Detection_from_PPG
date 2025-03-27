import torch
from torch import nn, Tensor
from torch.optim.lr_scheduler import ExponentialLR
import torch.nn.functional as F
import torchmetrics
import pytorch_lightning as pl
from typing import Any, List, Tuple
from transformers import get_scheduler
import numpy as np
from omegaconf import DictConfig, OmegaConf
import io
import matplotlib.pyplot as plt
from PIL import Image
from torchvision.transforms import ToTensor
from typing import List, Tuple, Union

from .resnet import resnet18, resnet10
from .loss_function import get_loss_function

class CompeleteModel(nn.Module):
    def __init__(self, config: DictConfig):
        super().__init__()
        self.config = config
        self.__initialize_modules(config)
    

    def __initialize_modules(self, config: DictConfig):
        self.classifier = resnet10(**config.hyperparameters.classifier)
    
    def forward(self, x:Tensor):
        logits = self.classifier(x)
        
        return logits
    

class EctopicsClassifier(pl.LightningModule):
    def __init__(self, 
                 task: str="binary", 
                 num_classes: int=2, 
                 lr: float=0.0001, 
                 loss_name: str="cross_entropy",
                 use_lr_scheduler: bool=True,
                 lr_warmup_ratio: float = 0.1,
                 device: str="cuda",
                 total_training_steps: int=1000,
                 config: DictConfig=None,
                 **kwargs):
        super().__init__()

        self.task = task
        self.num_classes = num_classes
        self.lr = lr
        self.loss_name = loss_name
        self.use_lr_scheduler = use_lr_scheduler
        self.warmup_ratio = lr_warmup_ratio
    

        if device == "cuda" and torch.cuda.is_available():
            self.device_type = torch.device("cuda")
        else:
            self.device_type = torch.device("cpu")
        
        self.total_steps = total_training_steps
        self.config = config

        self.metrics_lst = []
        for metric in self.config.metrics:
            if self.config.metrics[metric]:
                self.metrics_lst.append(metric)

        print("Loss Function: ", self.loss_name, flush=True)
        print("Metrics: ", self.config.metrics, flush=True)

        self.model = CompeleteModel(self.config)
        
        if self.loss_name == 'bce':
            self.loss_fn = get_loss_function(self.loss_name)
        else:
            raise ValueError(f"Invalid loss function: {self.loss_name}")
        
        self.metrics = nn.ModuleDict({
            "metrics_train": nn.ModuleDict({}),
            "metrics_valid": nn.ModuleDict({}),
            "metrics_test": nn.ModuleDict({})
        })

        for phase in ["train", "valid", "test"]:
            for metric in self.config.metrics:
                if metric == "accuracy":
                    self.metrics["metrics_" + phase][metric] = torchmetrics.Accuracy(
                        self.task, num_classes=self.num_classes, average="none"
                    )
                elif metric == "cf_matrix":
                    self.metrics["metrics_" + phase][metric] = torchmetrics.ConfusionMatrix(
                        self.task, num_classes=self.num_classes
                    )
                elif metric == "f1":
                    self.metrics["metrics_" + phase][metric] = torchmetrics.F1Score(
                        self.task, num_classes=self.num_classes
                    )
                elif metric == "specificity":
                    self.metrics["metrics_" + phase][metric] = torchmetrics.Specificity(
                        self.task, num_classes=self.num_classes
                    )
                elif metric == "AUC":
                    self.metrics["metrics_" + phase][metric] = torchmetrics.AUROC(
                        self.task, num_classes=self.num_classes
                    )

        
        self.step_losses = {"train": [], "valid": [], "test": []}

    def configure_optimizers(self):
    
        optimizer = torch.optim.Adam(self.parameters(), lr=self.lr)

        if self.use_lr_scheduler:
            scheduler = {
                "scheduler": get_scheduler(
                    "polynomial",
                    optimizer,
                    num_warmup_steps=round(self.warmup_ratio * self.total_steps),
                    num_training_steps=self.total_steps,
                ),
                "interval": "step",
                "frequency": 1,
            }
            return [optimizer], [scheduler]

        return optimizer

    def forward(self, x: Tensor):
        return self.model(x)

    def plot_confusion_matrix(self, matrix):
        fig, ax = plt.subplots()
        cax = ax.matshow(matrix.cpu().numpy())
        fig.colorbar(cax)
    
        buf = io.BytesIO()
        plt.savefig(buf, format='jpeg')
        plt.close(fig)  # ensure to close the figure to free memory
        buf.seek(0)
    
        image = Image.open(buf)
        image_tensor = ToTensor()(image)
    
        return image_tensor

    def update_metrics(self, outputs, targets, phase: str = "train"):
        # model_device =  next(self.model.parameters()).device
        for k in self.config.metrics:
            # metric_device = self.metrics["metrics_" + phase][k].device
            self.metrics["metrics_" + phase][k].update(outputs, targets)

    def reset_metrics(self, phase: str = "train"):
        for k in self.config.metrics:
            self.metrics["metrics_" + phase][k].reset()
    
    def log_all(self, items: List[Tuple[str, Union[float, torch.Tensor]]], phase: str = "train", prog_bar: bool = True, sync_dist_group: bool = False):
        for key, value in items:
            if value is not None:
                # Check if value is a float
                if isinstance(value, float):
                    self.log(f"{phase}_{key}", value, prog_bar=prog_bar, sync_dist_group=sync_dist_group)
                # Check if value is a tensor
                elif isinstance(value, torch.Tensor):
                    if len(value.shape) == 0:  # Scalar tensor
                        self.log(f"{phase}_{key}", value, prog_bar=prog_bar, sync_dist_group=sync_dist_group)
                    elif len(value.shape) == 2:  # 2D tensor, assume confusion matrix and log as image
                        image_tensor = self.plot_confusion_matrix(value)
                        self.logger.experiment.add_image(f"{phase}_{key}", image_tensor, global_step=self.current_epoch)

    def training_step(self, batch, batch_idx):

        x, targets = batch
        output_logits = self(x)
        preds = torch.argmax(output_logits, dim=1)

        if self.loss_name == "bce":
            loss = self.loss_fn(targets, output_logits)
        else:
            raise ValueError(f"Invalid loss function: {self.loss_name}")
        
        self.update_metrics(preds, targets, "train")
          
        print(type(loss))  
        self.step_losses["train"].append(loss.item())
        return {"loss": loss}

    def on_train_epoch_end(self):
        """End of the training epoch"""
        avg_loss = sum(self.step_losses["train"]) / len(self.step_losses["train"])

        acc, matrix, f1 = None, None, None

        if "accuracy" in self.metrics_lst:
            acc = self.metrics["metrics_" + "train"]["accuracy"].compute()

        if "cf_matrix" in self.metrics_lst:
            matrix = self.metrics["metrics_" + "train"]["cf_matrix"].compute()

        if "f1" in self.metrics_lst:
            f1 = self.metrics["metrics_" + "train"]["f1"].compute()
        
        if "specificity" in self.metrics_lst:
            spec = self.metrics["metrics_" + "train"]["specificity"].compute()

        if "AUC"  in self.metrics_lst:
            auc = self.metrics["metrics_" + "train"]["AUC"].compute()
        
        self.log_all(
                items=[
                    ("loss", avg_loss),
                    ("accuracy", acc),
                    ("specificity", spec),
                    ("AUC", auc),
                    ("confusion_matrix", matrix),
                    ("f1", f1),
                ],
                phase="train",
                prog_bar=True,
                sync_dist_group=False,
            )
        
        self.reset_metrics("train")
        self.step_losses["train"].clear()

    def validation_step(self, batch):
        
        x, targets = batch
        output_logits = self(x)
        preds = torch.argmax(output_logits, dim=1)
        loss = F.cross_entropy(output_logits, targets)

        self.update_metrics(preds, targets, "valid")
        self.step_losses["valid"].append(loss)

        return {"val_loss": loss}
    
    def on_validation_epoch_end(self):
        """End of the training epoch"""
        avg_loss = sum(self.step_losses["valid"]) / len(self.step_losses["valid"])

        acc, matrix, f1 = None, None, None

        if "accuracy" in self.metrics_lst:
            acc = self.metrics["metrics_" + "valid"]["accuracy"].compute()

        if "cf_matrix" in self.metrics_lst:
            matrix = self.metrics["metrics_" + "valid"]["cf_matrix"].compute()

        if "f1" in self.metrics_lst:
            f1 = self.metrics["metrics_" + "valid"]["f1"].compute()
        
        if "specificity" in self.metrics_lst:
            spec = self.metrics["metrics_" + "valid"]["specificity"].compute()

        if "AUC"  in self.metrics_lst:
            auc = self.metrics["metrics_" + "valid"]["AUC"].compute()
        
        self.log_all(
                items=[
                    ("loss", avg_loss),
                    ("accuracy", acc),
                    ("specificity", spec),
                    ("AUC", auc),
                    ("confusion_matrix", matrix),
                    ("f1", f1),
                ],
                phase="valid",
                prog_bar=True,
                sync_dist_group=False,
            )
        
        self.reset_metrics("valid")
        self.step_losses["valid"].clear()
    
    def test_step(self, batch):
        
        x, targets = batch
        output_logits = self(x)
        preds = torch.argmax(output_logits, dim=1)
        loss = F.cross_entropy(output_logits, targets)

        self.update_metrics(preds, targets, "test")
        self.step_losses["test"].append(loss)

        return {'test_loss': loss}

    def on_test_epoch_end(self):
        """End of the training epoch"""
        avg_loss = sum(self.step_losses["test"]) / len(self.step_losses["test"])

        acc, matrix, f1 = None, None, None

        if "accuracy" in self.metrics_lst:
            acc = self.metrics["metrics_" + "test"]["accuracy"].compute()

        if "cf_matrix" in self.metrics_lst:
            matrix = self.metrics["metrics_" + "test"]["cf_matrix"].compute()

        if "f1" in self.metrics_lst:
            f1 = self.metrics["metrics_" + "test"]["f1"].compute()
        
        if "specificity" in self.metrics_lst:
            spec = self.metrics["metrics_" + "test"]["specificity"].compute()

        if "AUC"  in self.metrics_lst:
            auc = self.metrics["metrics_" + "test"]["AUC"].compute()
        
        self.log_all(
                items=[
                    ("loss", avg_loss),
                    ("accuracy", acc),
                    ("specificity", spec),
                    ("AUC", auc),
                    ("confusion_matrix", matrix),
                    ("f1", f1),
                ],
                phase="test",
                prog_bar=True,
                sync_dist_group=False,
            )
        
        self.reset_metrics("test")
        self.step_losses["test"].clear()

    def predict_step(self, batch):
        x, targets = batch
        output_logits = self(x)
        preds = torch.argmax(output_logits, dim=1)
        return preds


    
    













    
