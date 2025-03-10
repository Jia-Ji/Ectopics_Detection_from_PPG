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
                 device: str="cuda",
                 total_training_steps: int=1000,
                 config: DictConfig=None):
        super().__init__()

        self.task = task
        self.num_classes = num_classes
        self.lr = lr
        self.loss_name = loss_name

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

    
