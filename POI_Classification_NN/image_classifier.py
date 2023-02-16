import base64
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

model_n = 2
epoch = 10


def prepare_data(actual_label):
    result = functions.get_poi(actual_label)
    info = result[3]
    response = {"name": result[1], "opening_hours": result[2]}
    if info[-1] == '.':
        info = info[:-1]
    for index, info in enumerate(info.split('.')):
        response[f"info{index}"] = info
    return response


@app.post("/image_api")
async def classify_image(request: Request):
    data = await request.json()
    # Access the data using the keys
    image64 = data['image64']
    image64 = base64.b64decode(image64)
    image_id = uuid.uuid4()
    image_result = open(f'api_images/{image_id}.jpg', 'wb')  # create a writable image and write the decoding result
    image_result.write(image64)

    model = tf.keras.models.load_model("models/Model/model-{}-updated3(retrain)-epoch_{:0>2d}".format(model_n, epoch))

    target_sizes = {1: (256, 341), 2: (224, 224), 3: (256, 256)}

    target_size = target_sizes[model_n]

    img = image.load_img(f'api_images/{image_id}.jpg', target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)

    if model_n == 2:
        img_array = tf.keras.applications.vgg16.preprocess_input(img_array)

    prediction = model.predict(img_array)
    # print(prediction)

    max_value = max(prediction[0])
    prediction[0] = [1 if x == max_value else 0 for x in prediction[0]]
    # print(prediction[0])

    poi_dict = {'100': 'MetropolitanCathedral', '010': 'NationalTheater', '001': 'PalaceOfCulture'}
    actual_label = ""

    for b in prediction[0]:
        actual_label += str(int(b))
    actual_label = poi_dict[actual_label]

    print(functions.get_poi(actual_label))

    # shutil.move(f'api_images/{image_id}.jpg', f'api_images/{actual_label}/{image_id}.jpg')

    return prepare_data(actual_label)

uvicorn.run(app, host="0.0.0.0", port=8001)


# model2-updated - epoch 5, 10
# model2 epoch 8
# model1 epoch 5
