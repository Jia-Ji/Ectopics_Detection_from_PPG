import hydra
import numpy as np
import pandas as pd
import pytorch_lightning as pl
import torch
from omegaconf import DictConfig, OmegaConf
from pytorch_lightning.callbacks import EarlyStopping, ModelCheckpoint
from pytorch_lightning.loggers import TensorBoardLogger


from utils import create_train_data_loader, create_test_data_loader
from models.model_adapt import EctopicsClassifier



@hydra.main(version_base=None, config_path="config", config_name="train")
def main(cfg: DictConfig) -> None:

    print("Data loading ...", flush=True)
    train_loader, valid_loader = create_train_data_loader(cfg.data)
    test_loader = create_test_data_loader(cfg.data)
    print("Done!", flush=True)

    total_training_steps = len(train_loader) * cfg.trainer.parameters.max_epochs

    model = EctopicsClassifier(**cfg.model, total_training_steps = total_training_steps)

    checkpoint_callback = ModelCheckpoint(**cfg.trainer.callbacks.model_checkpoint)
    early_stop_callback = EarlyStopping(**cfg.trainer.callbacks.early_stop)
    callbacks = [checkpoint_callback, early_stop_callback]

    logger = TensorBoardLogger(**cfg.trainer.callbacks.logger)

    pl.seed_everything(42, workers=True)
    trainer = pl.Trainer(**cfg.trainer.parameters, callbacks=callbacks, logger=logger)

    ckpt_path = None
    if cfg.experiment.resume_ckpt:
        ckpt_path = cfg.experiment.ckpt_path

    if cfg.experiment.train:
        trainer.fit(
            model,
            train_dataloaders=train_loader,
            val_dataloaders=valid_loader,
            ckpt_path=ckpt_path,
        )



if __name__ == '__main__':
    main()
    print("Training Done!")
