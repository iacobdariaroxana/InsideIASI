import base64
import io
import tensorflow as tf
import numpy as np
import keras.utils as image
from db import functions
from flask import Flask, request, jsonify
from flask_cors import CORS


app = Flask(__name__)
CORS(app, support_credentials=True)


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


# model = tf.keras.models.load_model("model-{}-epoch_{:0>2d}".format(1, 7))
model = tf.keras.models.load_model("model-1-last-epoch_08")


def get_poi_label(image64):
    img = image.load_img(io.BytesIO(image64), target_size=(256, 341))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)

    prediction = model.predict(img_array)
    # print(prediction)

    max_value = max(prediction[0])
    prediction[0] = [1 if x == max_value else 0 for x in prediction[0]]
    # print(prediction[0])

    poi_dict = {'10000': 'CityHall', '01000': 'MetropolitanCathedral', '00100': 'MihaiEminescuUniversityLibrary',
                '00010': 'NationalTheater',
                '00001': 'PalaceOfCulture'}
    actual_label = ""

    for b in prediction[0]:
        actual_label += str(int(b))
    actual_label = poi_dict[actual_label]

    return prepare_data(actual_label)


@app.route("/image_api", methods=['POST'])
def classify_image():
    data = request.json
    image64 = data.get('image64')
    image64 = base64.b64decode(image64)
    response = jsonify(get_poi_label(image64))
    return response


app.run(host="0.0.0.0", port=8003)
