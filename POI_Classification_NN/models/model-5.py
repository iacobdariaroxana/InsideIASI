import warnings
import os
import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt

warnings.simplefilter(action='ignore', category=FutureWarning)

inceptionV3_model = tf.keras.applications.InceptionV3(weights='imagenet', include_top=False, input_shape=(299, 299, 3))

# Add a global average pooling layer to reduce the number of parameters
x = inceptionV3_model.output
x = tf.keras.layers.GlobalAveragePooling2D()(x)

# Add a fully connected layer with 512 neurons and ReLU activation
x = tf.keras.layers.Dense(512, activation='relu')(x)

# Add a final output layer with 3 neurons (one for each class) and softmax activation
predictions = tf.keras.layers.Dense(3, activation='softmax')(x)

# Define the complete model with inputs and outputs
model = tf.keras.models.Model(inputs=inceptionV3_model.input, outputs=predictions)
print(model.summary())
# Freeze all the layers in the base model to prevent them from being retrained
for layer in inceptionV3_model.layers:
    layer.trainable = False

train_path = '../vgg-dataset/train'
val_path = '../vgg-dataset/val'
test_path = '../vgg-dataset/test'

train_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.inception_v3.preprocess_input).flow_from_directory(
    directory=train_path,
    target_size=(299, 299),
    classes=[
        'MetropolitanCathedral',
        'NationalTheater',
        'PalaceOfCulture'],
    batch_size=16)

val_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.inception_v3.preprocess_input).flow_from_directory(
    directory=val_path,
    target_size=(
        299, 299),
    classes=[
        'MetropolitanCathedral',
        'NationalTheater',
        'PalaceOfCulture'],
    batch_size=16)

test_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.inception_v3.preprocess_input).flow_from_directory(
    directory=test_path,
    target_size=(
        299, 299),
    classes=[
        'MetropolitanCathedral',
        'NationalTheater',
        'PalaceOfCulture'],
    batch_size=16,
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
                    epochs=15,
                    verbose=2
                    )

print(history.history)
np.save(f'History/{filename}-history.npy', history.history)

loss, acc = model.evaluate(test_batches)
print("loss: %.2f" % loss)
print("acc: %.2f" % acc)
