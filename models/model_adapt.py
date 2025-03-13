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

from resnet import resnet18
from loss_function import get_loss_function

class CompeleteModel(nn.Model):
    def __init__(self, config: DictConfig):
        super().__init__()
        self.config = config
        self.__initialize_modules(config)
    

    def __initialize_modules(self, config: DictConfig):
        self.classifier = resnet18(**config.hyperparameters.classifier)
    
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
                 config: DictConfig=None):
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

        self.model = CompeleteModel(config.model)
        
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
        
        self.step_outputs = {"train": [], "valid": [], "test": []}
        self.step_losses = {"loss_cl": [], "loss_cmc": []}

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







    
