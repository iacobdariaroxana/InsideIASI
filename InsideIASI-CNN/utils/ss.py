from PIL import Image
import os


def take_screenshot(img_path, save_folder):
    img = Image.open(img_path)
    screenshot = img.copy()
    screenshot.save(os.path.join(save_folder, "screenshot_" + os.path.basename(img_path)))


img_folder = "C:/Users/Roxana/Desktop/dataset_resized/PalaceOfCulture"
screenshots_folder = "C:/Users/Roxana/Desktop/final/palat"

for filename in os.listdir(img_folder):
    img_path = os.path.join(img_folder, filename)
    if os.path.isfile(img_path):
        take_screenshot(img_path, screenshots_folder)