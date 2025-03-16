import numpy as np
from torch.utils.data import Dataset

class TrainDataset(Dataset):
    def __init__(self, x_path: str, y_path: str):
        super().__init__()

        self.x = np.load(x_path)
        self.y = np.load(y_path)
    
    def __getitem__(self, index):
        x_get = self.x[index].astype(np.float32)
        y_get = self.y[index].astype(np.int64)
        return x_get, y_get
    
    def __len__(self):
        return len(self.y)

class ValidDataset(Dataset):
    def __init__(self, x_path: str, y_path: str):
        super().__init__()

        self.x = np.load(x_path)
        self.y = np.load(y_path)
    
    def __getitem__(self, index):
        x_get = self.x[index].astype(np.float32)
        y_get = self.y[index].astype(np.int64)
        return x_get, y_get
    
    def __len__(self):
        return len(self.y)

class TestDataset(Dataset):
    def __init__(self, x_path: str, y_path: str):
        super().__init__()

        self.x = np.load(x_path)
        self.y = np.load(y_path)
    
    def __getitem__(self, index):
        x_get = self.x[index].astype(np.float32)
        y_get = self.y[index].astype(np.int64)
        return x_get, y_get
    
    def __len__(self):
        return len(self.y)