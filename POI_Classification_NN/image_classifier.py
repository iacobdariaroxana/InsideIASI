import os

import tensorflow as tf
import numpy as np
import keras.utils as image
from fastapi import FastAPI
import uvicorn

app = FastAPI()


@app.get("/my-first-api")
def classify_image(image_path, model_n, epoch):
    image_path = image_path.replace("'", "")
    model_n = int(model_n)
    epoch = int(epoch)
    model = tf.keras.models.load_model("models/Model/model-{}-updated2-epoch_{:0>2d}".format(model_n, epoch))

    target_size = (224, 224)
    if model_n == 1:
        target_size = (256, 341)

    img = image.load_img(image_path, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    if model_n == 2:
        img_array = tf.keras.applications.vgg16.preprocess_input(img_array)

    prediction = model.predict(img_array)
    print(prediction)
    # prediction = np.round(prediction)
    max_value = max(prediction[0])
    prediction[0] = [1 if x == max_value else 0 for x in prediction[0]]
    print(prediction[0])

    poi_dict = {'100': 'MetropolitanCathedral', '010': 'NationalTheater', '001': 'PalaceOfCulture'}
    actual_label = ""
    for b in prediction[0]:
        actual_label += str(int(b))
    return poi_dict[actual_label]


# uvicorn.run(app, host="0.0.0.0", port=8001)

print(classify_image('img.png', 2, 10))


# model2-updated - epoch 5, 10
# model2 epoch 8
# model1 epoch 5


# import base64
# import keras.utils as image
# image64 = base64.b64decode(b'')
# image_result = open('img.jpg', 'wb') # create a writable image and write the decoding result
# image_result.write(image)
