import tensorflow as tf

import matplotlib.pyplot as plt
import numpy as np

train_path = 'vgg-dataset/train'
val_path = 'vgg-dataset/val'
test_path = 'vgg-dataset/test'

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

train_loss = []
train_acc = []

val_loss = []
val_acc = []

test_loss = []
test_acc = []
for i in range(11, 16):
    print(i)
    model = tf.keras.models.load_model("models/Model/model-2-epoch_{:0>2d}".format(i))
    loss, acc = model.evaluate(train_batches)
    train_loss += [loss]
    train_acc += [acc]
    print("loss: %.2f" % loss)
    print("acc: %.2f" % acc)

for i in range(11, 16):
    print(i)
    model = tf.keras.models.load_model("models/Model/model-2-epoch_{:0>2d}".format(i))
    loss, acc = model.evaluate(val_batches)
    val_loss += [loss]
    val_acc += [acc]
    print("loss: %.2f" % loss)
    print("acc: %.2f" % acc)

for i in range(1, 16):
    print(i)
    model = tf.keras.models.load_model("models/Model/model-2-epoch_{:0>2d}".format(i))
    loss, acc = model.evaluate(test_batches)
    test_loss += [loss]
    test_acc += [acc]
    print("loss: %.2f" % loss)
    print("acc: %.2f" % acc)

history = np.load("models/History/model-2-updated3-history.npy", allow_pickle=True).item()

print(history)
history['loss'] += train_loss
history['val_loss'] += val_loss
history['accuracy'] += train_acc
history['val_accuracy'] += val_acc

fig, axs = plt.subplots(2, 1, figsize=(15, 15))
fig.tight_layout(pad=8)
axs[0].plot(history['loss'])
axs[0].plot(history['val_loss'])
axs[0].plot(test_loss)
axs[0].title.set_text('Training Loss vs Validation Loss vs Test Loss')
axs[0].set_xlabel('Epochs')
axs[0].set_ylabel('Loss')
axs[0].legend(['Train', 'Val', 'Test'])

axs[1].plot(history['accuracy'])
axs[1].plot(history['val_accuracy'])
axs[1].plot(test_acc)
axs[1].title.set_text('Training Accuracy vs Validation Accuracy vs Test Accuracy')
axs[1].set_xlabel('Epochs')
axs[1].set_ylabel('Accuracy')
axs[1].legend(['Train', 'Val', 'Test'])

plt.savefig('results/model-2-plot.png')
# plt.show()

np.save(f'models/History/model-2(try)-history.npy', history)
