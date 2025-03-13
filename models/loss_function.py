import numpy as np
import torch
import torch.nn.functional as F

def binary_cross_entropy_with_logits(y_true, y_pred):
    return F.binary_cross_entropy_with_logits(y_pred, y_true)

loss_functions = {"bce": binary_cross_entropy_with_logits}

def get_loss_function(loss_name):
    if loss_name in loss_functions:
        return loss_functions[loss_name]
    else:
        raise ValueError(f"Unknown loss function: {loss_name}.")