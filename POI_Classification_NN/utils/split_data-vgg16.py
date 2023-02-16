import os
import shutil
import random

for class_name in ['MetropolitanCathedral', 'NationalTheater', 'PalaceOfCulture']:
    # Define the path to your original data
    original_data_path = f'../dataset/{class_name}'
    # Define the paths to your training, test, and validation directories
    train_data_path = f'../vgg16-dataset-updated3/train/{class_name}'
    test_data_path = f'../vgg16-dataset-updated3/test/{class_name}'
    val_data_path = f'../vgg16-dataset-updated3/val/{class_name}'

    # Get a list of all the files in your original data directory
    files = os.listdir(original_data_path)

    # Shuffle the list of files
    random.shuffle(files)

    # Split the list of files into training, test, and validation sets
    train_files = files[:int(0.8 * len(files))]
    val_files = files[int(0.8 * len(files)):int(0.9 * len(files))]
    test_files = files[int(0.9 * len(files)):]

    # Copy the training files to the train_data_path directory
    for f in train_files:
        src = os.path.join(original_data_path, f)
        dst = os.path.join(train_data_path, f)
        shutil.copy2(src, dst)

    # Copy the test files to the test_data_path directory
    for f in test_files:
        src = os.path.join(original_data_path, f)
        dst = os.path.join(test_data_path, f)
        shutil.copy2(src, dst)

    # Copy the validation files to the val_data_path directory
    for f in val_files:
        src = os.path.join(original_data_path, f)
        dst = os.path.join(val_data_path, f)
        shutil.copy2(src, dst)
