import hydra
import numpy as np
import pandas as pd
import pytorch_lightning as pl
import torch
from omegaconf import DictConfig, OmegaConf
from pytorch_lightning.callbacks import EarlyStopping, ModelCheckpoint
from pytorch_lightning.loggers import TensorBoardLogger

from utils import create_train_data_loader


@hydra.main(version_base=None, config_path="config", config_name="train")
def main(cfg: DictConfig) -> None:

    print("Data loading ...", flush=True)
    train_loader, valid_loader = create_train_data_loader(cfg.data)
    print("Done!", flush=True)


if __name__ == '__main__':
    main()
    print("Training Done!")
