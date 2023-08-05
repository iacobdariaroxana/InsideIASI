import tensorflow as tf
import numpy as np

train_path = '../final_prepdata/train'
val_path = '../final_prepdata/val'
test_path = '../final_prepdata/test'

# train_batches = tf.keras.preprocessing.image.ImageDataGenerator(
#     preprocessing_function=tf.keras.applications.vgg16.preprocess_input).flow_from_directory(directory=train_path,
#                                                                                              target_size=(224, 224),
#                                                                                              classes=[
#                                                                                                  'MetropolitanCathedral',
#                                                                                                  'NationalTheater',
#                                                                                                  'PalaceOfCulture'],
#                                                                                              batch_size=10)
#
# val_batches = tf.keras.preprocessing.image.ImageDataGenerator(
#     preprocessing_function=tf.keras.applications.vgg16.preprocess_input).flow_from_directory(directory=val_path,
#                                                                                              target_size=(224, 224),
#                                                                                              classes=[
#                                                                                                  'MetropolitanCathedral',
#                                                                                                  'NationalTheater',
#                                                                                                  'PalaceOfCulture'],
#                                                                                              batch_size=10)
#
# test_batches = tf.keras.preprocessing.image.ImageDataGenerator(
#     preprocessing_function=tf.keras.applications.vgg16.preprocess_input).flow_from_directory(directory=test_path,
#                                                                                              target_size=(224, 224),
#                                                                                              classes=[
#                                                                                                  'MetropolitanCathedral',
#                                                                                                  'NationalTheater',
#                                                                                                  'PalaceOfCulture'],
#                                                                                              batch_size=10,
#                                                                                              shuffle=False)

train_dataset = tf.keras.preprocessing.image_dataset_from_directory(
    train_path, batch_size=64, image_size=(256, 341))
validation_dataset = tf.keras.preprocessing.image_dataset_from_directory(val_path, batch_size=64,
                                                                         image_size=(256, 341))
test_dataset = tf.keras.preprocessing.image_dataset_from_directory(
    test_path, batch_size=64, image_size=(256, 341))

model = tf.keras.models.load_model("../models/Model/model-1-final-epoch_10")

callbacks = [
    tf.keras.callbacks.ModelCheckpoint(filepath=f'../models/Model/model-1-final(retrain)-epoch_' + '{epoch:02d}',
                                       save_freq='epoch')
]
history = model.fit(x=train_dataset,
                    steps_per_epoch=len(train_dataset),
                    validation_data=validation_dataset,
                    validation_steps=len(validation_dataset),
                    callbacks=callbacks,
                    epochs=5,
                    verbose=2
                    )

print(history.history)
np.save(f'../models/History/model-1-final(retrain)-history.npy', history.history)

loss, acc = model.evaluate(test_dataset)
print("loss: %.2f" % loss)
print("acc: %.2f" % acc)
