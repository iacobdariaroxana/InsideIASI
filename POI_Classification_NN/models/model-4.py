import warnings
import os
import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
import visualkeras
from PIL import ImageFont

warnings.simplefilter(action='ignore', category=FutureWarning)

vgg19_model = tf.keras.applications.vgg19.VGG19()
# vgg19_model.summary()

model = tf.keras.models.Sequential()
for layer in vgg19_model.layers[:-1]:
    model.add(layer)

# model.summary()


model.add(tf.keras.layers.Dense(units=3, activation='softmax'))
model.summary()

font = ImageFont.truetype("arial.ttf", 48)
visualkeras.layered_view(model, legend=True, font=font, to_file='../results/model-4/model.png', spacing=25, padding=30)

train_path = '../vgg-dataset/train'
val_path = '../vgg-dataset/val'
test_path = '../vgg-dataset/test'

train_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.vgg19.preprocess_input).flow_from_directory(directory=train_path,
                                                                                             target_size=(224, 224),
                                                                                             classes=[
                                                                                                 'MetropolitanCathedral',
                                                                                                 'NationalTheater',
                                                                                                 'PalaceOfCulture'],
                                                                                             batch_size=10)

val_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.vgg19.preprocess_input).flow_from_directory(directory=val_path,
                                                                                             target_size=(224, 224),
                                                                                             classes=[
                                                                                                 'MetropolitanCathedral',
                                                                                                 'NationalTheater',
                                                                                                 'PalaceOfCulture'],
                                                                                             batch_size=10)

test_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.vgg19.preprocess_input).flow_from_directory(directory=test_path,
                                                                                             target_size=(224, 224),
                                                                                             classes=[
                                                                                                 'MetropolitanCathedral',
                                                                                                 'NationalTheater',
                                                                                                 'PalaceOfCulture'],
                                                                                             batch_size=10,
                                                                                             shuffle=False)

# images, labels = next(train_batches)
#
#
# def plot_images(images_arr):
#     fig, axes = plt.subplots(1, 10, figsize=(10, 10))
#     axes = axes.flatten()
#     for img, ax in zip(images_arr, axes):
#         ax.imshow(img)
#         ax.axis('off')
#     plt.tight_layout()
#     plt.show()
#
#
# plot_images(images)
# plt.show()
# print(labels)

filename = os.path.splitext(os.path.basename(__file__))[0]

callbacks = [
    tf.keras.callbacks.ModelCheckpoint(filepath=f'Model/{filename}-epoch_' + '{epoch:02d}',
                                       save_freq='epoch')
]

model.compile(optimizer=tf.keras.optimizers.Adam(learning_rate=0.0001), loss='categorical_crossentropy',
              metrics=['accuracy'])

history = model.fit(x=train_batches,
                    steps_per_epoch=len(train_batches),
                    validation_data=val_batches,
                    validation_steps=len(val_batches),
                    callbacks=callbacks,
                    epochs=10,
                    verbose=2
                    )

print(history.history)
np.save(f'History/{filename}-history.npy', history.history)

loss, acc = model.evaluate(test_batches)
print("loss: %.2f" % loss)
print("acc: %.2f" % acc)
