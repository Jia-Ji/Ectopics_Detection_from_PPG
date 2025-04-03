import scipy.io
import numpy as np
import pandas as pd
from skmultilearn.model_selection import iterative_train_test_split
import numpy as np
from sklearn.preprocessing import LabelEncoder

# Load .mat file
mat_file_path = "./PPG_data/Compiled/PPGECG_all.mat"
mat_data = scipy.io.loadmat(mat_file_path)

PPG_ECG = mat_data['S']
labels = mat_data['labels']
PPG = PPG_ECG[:, :, 0]
ECG = PPG_ECG[:, :, 1]
PPG = np.transpose(PPG)
ECG = np.transpose(ECG)

PPG = np.expand_dims(PPG, axis=1)
PPG = np.expand_dims(PPG, axis=1)

# load .csv file
csv_file_path = "./PPG_data/Compiled/PPGECG_all_table.csv"
df = pd.read_csv(csv_file_path)
df['index'] = df.index
ECGcat = df['ECGcat'].to_numpy()
# convert ECGcat from str to one-hot integer label
encoder = LabelEncoder()
ECGcat = encoder.fit_transform(ECGcat) 


summary = (
    df.groupby(['ID0', 'ECGcat'])
    .size()
    .reset_index(name='count')
)

pivot = summary.pivot(index='ID0', columns='ECGcat', values='count').fillna(0)
X = np.array(pivot.index).reshape(-1, 1)
y = pivot.values

# First split: train (60%) vs temp (40%)
X_train, y_train, X_temp, y_temp = iterative_train_test_split(X, y, test_size=0.4)

# Second split: val (20%) vs test (20%) from temp
X_val, y_val, X_test, y_test = iterative_train_test_split(X_temp, y_temp, test_size=0.5)

train_patients = X_train.flatten()
val_patients = X_val.flatten()
test_patients = X_test.flatten()

df_train = df[df['ID0'].isin(train_patients)]
df_val = df[df['ID0'].isin(val_patients)]
df_test = df[df['ID0'].isin(test_patients)]

df_train_index = df_train["index"].tolist()
df_val_index = df_val["index"].tolist()
df_test_index = df_test["index"].tolist()

x_train = PPG[df_train_index]
x_val = PPG[df_val_index]
x_test = PPG[df_test_index]

y_train = ECGcat[df_train_index]
y_val = ECGcat[df_val_index]
y_test = ECGcat[df_test_index]

print(f"The shape of x_train is {x_train.shape}")
print(f"The shape of x_val is {x_val.shape}")
print(f"The shape of x_test is {x_test.shape}")
print(f"The shape of y_train is {y_train.shape}")
print(f"The shape of y_val is {y_val.shape}")
print(f"The shape of y_test is {y_test.shape}")

print(f"The type of y_train is {type(y_train)}")
print(f"The type of x_train is {type(x_train)}")
print(f"The type of y_val is {type(y_val)}")
print(f"The type of x_val is {type(x_val)}")
print(f"The type of y_test is {type(y_test)}")
print(f"The type of x_test is {type(x_test)}")
#  check stratification
print( 'Check stratification.......')
def show_distribution(df_split, name):
    dist = df_split['ECGcat'].value_counts(normalize=True) * 100
    print(f"\n{name} ECG distribution (%):")
    print(dist.round(2))

show_distribution(df_train, "Train")
show_distribution(df_val, "Validation")
show_distribution(df_test, "Test")

# Should be empty sets
print(set(train_patients) & set(val_patients))
print(set(train_patients) & set(test_patients))
print(set(val_patients) & set(test_patients))

command = input("Enter your command (yes/no): ")
if command == "yes":
    with open('./PPG_data/splitted_data/x_train.npy', 'wb') as f:
        np.save(f, x_train)
    with open('./PPG_data/splitted_data/y_train.npy', 'wb') as f:
        np.save(f, y_train)
    with open('./PPG_data/splitted_data/x_val.npy', 'wb') as f:
        np.save(f, x_val)
    with open('./PPG_data/splitted_data/y_val.npy', 'wb') as f:
        np.save(f, y_val)
    with open('./PPG_data/splitted_data/x_test.npy', 'wb') as f:
        np.save(f, x_test)
    with open('./PPG_data/splitted_data/y_test.npy', 'wb') as f:
        np.save(f, y_test)
elif command == "no":
    pass