import onnxruntime as rt
import keras.utils as image
import numpy as np

sess = rt.InferenceSession('model.onnx', providers=rt.get_available_providers())
print("input name='{}' and shape={}".format(sess.get_inputs()[0].name, sess.get_inputs()[0].shape))
print("output name='{}' and shape={}".format(sess.get_outputs()[0].name, sess.get_outputs()[0].shape))

input_name = sess.get_inputs()[0].name
label_name = sess.get_outputs()[0].name

img = image.load_img('palat.png', target_size=(256, 341))
img_array = image.img_to_array(img)
img_array = np.expand_dims(img_array, axis=0)

prediction = sess.run([label_name], {input_name: img_array})[0]
print(prediction)
