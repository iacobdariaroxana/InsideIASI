import base64
import os
import threading
import shutil
import tensorflow as tf
import numpy as np
import keras.utils as image
from fastapi import FastAPI, Request
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
import uuid
from db import functions

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"])


def move_image_to_directory(image_id, label):
    shutil.move(f'api_images/{image_id}.jpg', f'api_images/{label}/{image_id}.jpg')


def prepare_data(actual_label):
    result = functions.get_poi(actual_label)
    info = result[2]
    response = {"name": result[1]}
    if info[-1] == '.':
        info = info[:-1]
    for index, info in enumerate(info.split('.')):
        response[f"info{index}"] = info

    hours_data = functions.get_opening_hours(result[0])
    opening_hours = "Opening hours:\n"
    for day in hours_data:
        if day[1] is None:
            opening_hours += f"{day[0]} Closed\n"
        else:
            opening_hours += f"{day[0]} {day[1]} - {day[2]}\n"

    lines = opening_hours.split('\n')
    max_day_length = max(len(line.split()[0]) for line in lines[1:-1])

    formatted_lines = [lines[0]]
    for line in lines[1:-1]:
        day, hours = line.split(maxsplit=1)
        padded_day = day.ljust(max_day_length)
        formatted_lines.append(f"{padded_day} {hours}")

    formatted_hours = '\n'.join(formatted_lines)

    response["opening_hours"] = formatted_hours
    response["link"] = result[3]
    return response


model = tf.keras.models.load_model("models/Model/model-{}-epoch_{:0>2d}".format(1, 7))


def get_poi_label(image64, model_n):
    image_id = uuid.uuid4()
    image_result = open(f'api_images/{image_id}.jpg', 'wb')
    image_result.write(image64)
    target_sizes = {1: (256, 341), 2: (224, 224), 4: (224, 224), 6: (224, 224)}
    target_size = target_sizes[model_n]

    img = image.load_img(f'api_images/{image_id}.jpg', target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)

    # if model_n == 2:
    #     img_array = tf.keras.applications.vgg16.preprocess_input(img_array)
    # if model_n in (4, 6):
    #     img_array = tf.keras.applications.vgg19.preprocess_input(img_array)
    prediction = model.predict(img_array)
    print(prediction)

    max_value = max(prediction[0])
    prediction[0] = [1 if x == max_value else 0 for x in prediction[0]]
    # print(prediction[0])

    poi_dict = {'100': 'MetropolitanCathedral', '010': 'NationalTheater', '001': 'PalaceOfCulture'}
    actual_label = ""

    for b in prediction[0]:
        actual_label += str(int(b))
    actual_label = poi_dict[actual_label]

    # t = threading.Timer(2.0, move_image_to_directory, args=(image_id, actual_label))
    # t.start()
    return prepare_data(actual_label)


@app.post("/image_api")
async def classify_image(request: Request):
    data = await request.json()
    image64 = data['image64']
    image64 = base64.b64decode(image64)
    return get_poi_label(image64, 1)


models = {1: 5, 2: 12, 4: 8, 6: 14}
uvicorn.run(app, host="0.0.0.0", port=8003)


# def verify_images():
#     count = 0
#     for file in os.listdir('mtr'):
#         img = image.load_img(os.path.join('mtr', file), target_size=(256, 341))
#         img_array = image.img_to_array(img)
#         img_array = np.expand_dims(img_array, axis=0)
#         prediction = model.predict(img_array)
#         print(prediction)
#
#         max_value = max(prediction[0])
#         prediction[0] = [1 if x == max_value else 0 for x in prediction[0]]
#         # print(prediction[0])
#
#         poi_dict = {'100': 'MetropolitanCathedral', '010': 'NationalTheater', '001': 'PalaceOfCulture'}
#         actual_label = ""
#
#         for b in prediction[0]:
#             actual_label += str(int(b))
#         actual_label = poi_dict[actual_label]
#         if actual_label != "MetropolitanCathedral":
#             count += 1
#         print(actual_label)
#     print(count)
#
#
# verify_images()


# img = image.load_img('utils/23.jpg', target_size=(256, 341))
# img_array = image.img_to_array(img)
# img_array = np.expand_dims(img_array, axis=0)
# prediction = model.predict(img_array)
# print(prediction)
#
# max_value = max(prediction[0])
# prediction[0] = [1 if x == max_value else 0 for x in prediction[0]]
# print(prediction[0])
#
# poi_dict = {'100': 'MetropolitanCathedral', '010': 'NationalTheater', '001': 'PalaceOfCulture'}
# actual_label = ""
#
# for b in prediction[0]:
#     actual_label += str(int(b))
# actual_label = poi_dict[actual_label]
#
# print(actual_label)



