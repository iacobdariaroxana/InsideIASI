import tensorflow as tf

# convert the model
converter = tf.lite.TFLiteConverter.from_saved_model('../models/Model/model-1-epoch_07')
tflite_model = converter.convert()

# save the model to tflite format
with open('model.tflite', 'wb') as f:
    f.write(tflite_model)
