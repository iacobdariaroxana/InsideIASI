import warnings
import os
import tensorflow as tf
import numpy as np


warnings.simplefilter(action='ignore', category=FutureWarning)

vgg16_model = tf.keras.applications.vgg16.VGG16()

# vgg16_model.summary()

model = tf.keras.models.Sequential()
for layer in vgg16_model.layers[:-1]:
    model.add(layer)

# model.summary()


model.add(tf.keras.layers.Dense(units=3, activation='softmax'))
model.summary()

train_path = '../vgg-dataset/train'
val_path = '../vgg-dataset/val'
test_path = '../vgg-dataset/test'

train_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.vgg16.preprocess_input).flow_from_directory(directory=train_path,
                                                                                             target_size=(224, 224),
                                                                                             classes=[
                                                                                                 'MetropolitanCathedral',
                                                                                                 'NationalTheater',
                                                                                                 'PalaceOfCulture'],
                                                                                             batch_size=10)

val_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.vgg16.preprocess_input).flow_from_directory(directory=val_path,
                                                                                             target_size=(224, 224),
                                                                                             classes=[
                                                                                                 'MetropolitanCathedral',
                                                                                                 'NationalTheater',
                                                                                                 'PalaceOfCulture'],
                                                                                             batch_size=10)

test_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.vgg16.preprocess_input).flow_from_directory(directory=test_path,
                                                                                             target_size=(224, 224),
                                                                                             classes=[
                                                                                                 'MetropolitanCathedral',
                                                                                                 'NationalTheater',
                                                                                                 'PalaceOfCulture'],
                                                                                             batch_size=10,
                                                                                             shuffle=False)


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
                    epochs=15,
                    verbose=2
                    )

print(history.history)
np.save(f'History/{filename}-history.npy', history.history)

loss, acc = model.evaluate(test_batches)
print("loss: %.2f" % loss)
print("acc: %.2f" % acc)


