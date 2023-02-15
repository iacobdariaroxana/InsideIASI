import warnings
import os
import matplotlib.pyplot as plt
import tensorflow as tf
import numpy as np
from sklearn.metrics import confusion_matrix
import itertools

warnings.simplefilter(action='ignore', category=FutureWarning)

vgg16_model = tf.keras.applications.vgg16.VGG16()
# vgg16_model.summary()

model = tf.keras.models.Sequential()
for layer in vgg16_model.layers[:-1]:
    model.add(layer)

# model.summary()


model.add(tf.keras.layers.Dense(units=3, activation='softmax'))
model.summary()

train_path = '../vgg16-dataset/train'
val_path = '../vgg16-dataset/val'
test_path = '../vgg16-dataset/test'

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

# test_images, test_labels = next(test_batches)
predictions = model.predict(x=test_batches, steps=len(test_batches), verbose=0)
np.round(predictions)
cm = confusion_matrix(y_true=test_batches.classes, y_pred=np.argmax(predictions, axis=-1))


def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, cm[i, j],
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')


cm_plot_labels = ['MetropolitanCathedral', 'NationalTheater', 'PalaceOfCulture']
plot_confusion_matrix(cm=cm, classes=cm_plot_labels, title='Confusion Matrix')
