import cv2
import albumentations as A
import os
import numpy as np


def augment_images(images_folder, augmentations, save_folder):
    # Create the save folder if it does not exist
    if not os.path.exists(save_folder):
        os.makedirs(save_folder)

    for i, image_name in enumerate(os.listdir(images_folder)):
        # Read the image
        image = cv2.imread(os.path.join(images_folder, image_name))

        # Apply the augmentations
        augmented = augmentations(image=image)['image']

        # Save the augmented image
        cv2.imwrite(os.path.join(save_folder, f'augmented_{i}.jpg'), augmented)


transform = A.Compose([
    # A.ShiftScaleRotate(shift_limit=0.05, scale_limit=0.05, rotate_limit=15, p=0.5),
    # A.RandomBrightnessContrast(p=0.5, brightness_limit=(-0.10, 0.10), contrast_limit=(-0.2, 0.2)),
    # A.ColorJitter(p=0.4, brightness=(0.8, 1.2), contrast=(0.8, 1.0), saturation=(0.8, 1.0), hue=(-0.05, 0.05)),
    # A.RandomToneCurve(always_apply=False, p=0.5, scale=0.1),
    # A.RGBShift(p=0.5, r_shift_limit=(-10, 10), g_shift_limit=(-10, 10), b_shift_limit=(-10, 10)),
    A.HorizontalFlip(),
    A.Normalize()
    # A.Normalize(mean=(0.285, 0.256, 0.206), std=(0.029, 0.024, 0.025)),
    # A.ShiftScaleRotate(shift_limit=0.05, scale_limit=0.05, rotate_limit=15, p=0.5),
    # A.RGBShift(r_shift_limit=15, g_shift_limit=15, b_shift_limit=15, p=0.5),
    # A.RandomBrightnessContrast(p=0.5),
    # A.ColorJitter(),
])

image = cv2.imread("dataset/MetropolitanCathedral\screenshot_0002.jpg")
# image = image / 255.0
#
# mean = np.mean(image, axis=(0, 1))
# std = np.std(image, axis=(0, 1))
# print(f"Mean = {mean} and std = {std}")

image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

augmented_images = [transform(image=image)["image"] for i in range(5)]
for i, augmented_image in enumerate(augmented_images):
    cv2.imwrite("augmented_dataset/augmented_image_{}.jpg".format(i), augmented_image)
