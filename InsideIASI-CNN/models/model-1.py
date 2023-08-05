import matplotlib.pyplot as plt
import tensorflow as tf
import visualkeras
from PIL import ImageFont
import numpy as np
import os


train_dataset = tf.keras.preprocessing.image_dataset_from_directory(
    '../final_prepdata/train', batch_size=64, image_size=(341, 256))
validation_dataset = tf.keras.preprocessing.image_dataset_from_directory('../final_prepdata/val', batch_size=64,
                                                                         image_size=(341, 256))
test_dataset = tf.keras.preprocessing.image_dataset_from_directory(
    '../final_prepdata/test', batch_size=64, image_size=(341, 256))

inputs = tf.keras.Input(shape=(341, 256, 3))
x = tf.keras.layers.Rescaling(scale=1.0 / 255)(inputs)
x = tf.keras.layers.Conv2D(filters=64, kernel_size=(3, 3), activation="relu")(x)
x = tf.keras.layers.MaxPooling2D(pool_size=(3, 3))(x)
x = tf.keras.layers.Dense(64)(x)
x = tf.keras.layers.Conv2D(filters=128, kernel_size=(3, 3), activation="relu")(x)
x = tf.keras.layers.MaxPooling2D(pool_size=(3, 3))(x)
x = tf.keras.layers.Conv2D(filters=256, kernel_size=(3, 3), activation="relu")(x)
x = tf.keras.layers.MaxPooling2D(pool_size=(3, 3))(x)
x = tf.keras.layers.Flatten()(x)

num_classes = 5
outputs = tf.keras.layers.Dense(num_classes, activation="softmax")(x)

model = tf.keras.Model(inputs=inputs, outputs=outputs)

# font = ImageFont.truetype("arial.ttf", 24)
# visualkeras.layered_view(model, legend=True, font=font, to_file='../results/model-1/model.png', spacing=25,
#                          scale_xy=0.8)

model.summary()

filename = os.path.splitext(os.path.basename(__file__))[0]

callbacks = [
    tf.keras.callbacks.ModelCheckpoint(filepath=f'Model/{filename}-end-epoch_' + '{epoch:02d}',
                                       save_freq='epoch')
]

model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=["accuracy"])
history = model.fit(train_dataset, epochs=15, callbacks=callbacks, shuffle=True, validation_data=validation_dataset)
print(history.history)
np.save(f'History/{filename}-end-history.npy', history.history)

loss, acc = model.evaluate(test_dataset)
print("loss: %.2f" % loss)
print("acc: %.2f" % acc)