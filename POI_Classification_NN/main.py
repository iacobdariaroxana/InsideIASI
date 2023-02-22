import tensorflow as tf
import itertools
import matplotlib.pyplot as plt
import numpy as np
from sklearn.metrics import confusion_matrix

test_path = 'vgg-dataset/test'
test_batches = tf.keras.preprocessing.image.ImageDataGenerator(
    preprocessing_function=tf.keras.applications.vgg16.preprocess_input).flow_from_directory(directory=test_path,
                                                                                             target_size=(224, 224),
                                                                                             classes=[
                                                                                                 'MetropolitanCathedral',
                                                                                                 'NationalTheater',
                                                                                                 'PalaceOfCulture'],
                                                                                             batch_size=10,
                                                                                             shuffle=False)

model = tf.keras.models.load_model("models/Model/model-2-epoch_14")
loss, acc = model.evaluate(test_batches)

print("loss: %.2f" % loss)
print("acc: %.2f" % acc)
# predictions = model.predict(x=test_batches, steps=len(test_batches), verbose=0)
# np.round(predictions)
# cm = confusion_matrix(y_true=test_batches.classes, y_pred=np.argmax(predictions, axis=-1))

#
# def plot_confusion_matrix(cm, classes,
#                           normalize=False,
#                           title='Confusion matrix',
#                           cmap=plt.cm.Blues):
#     """
#     This function prints and plots the confusion matrix.
#     Normalization can be applied by setting `normalize=True`.
#     """
#     plt.imshow(cm, interpolation='nearest', cmap=cmap)
#     plt.title(title)
#     plt.colorbar()
#     tick_marks = np.arange(len(classes))
#     plt.xticks(tick_marks, classes, rotation=45)
#     plt.yticks(tick_marks, classes)
#
#     if normalize:
#         cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
#         print("Normalized confusion matrix")
#     else:
#         print('Confusion matrix, without normalization')
#
#     print(cm)
#
#     thresh = cm.max() / 2.
#     for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
#         plt.text(j, i, cm[i, j],
#                  horizontalalignment="center",
#                  color="white" if cm[i, j] > thresh else "black")
#
#     plt.tight_layout()
#     plt.ylabel('True label')
#     plt.xlabel('Predicted label')
#     plt.savefig(f"results/confusion_matrix_model-3_epoch-15.png")
#     plt.show()
#
#
# cm_plot_labels = ['MetropolitanCathedral', 'NationalTheater', 'PalaceOfCulture']
# plot_confusion_matrix(cm=cm, classes=cm_plot_labels, title='Confusion Matrix')
#
# test_loss = []
# test_acc = []
# for i in range(1, 16):
#     print(i)
#     model = tf.keras.models.load_model("models/Model/model-3-epoch_{:0>2d}".format(i))
#     loss, acc = model.evaluate(test_batches)
#     test_loss += [loss]
#     test_acc += [acc]
#     print("loss: %.2f" % loss)
#     print("acc: %.2f" % acc)
#
# history = np.load("models/History/model-2-updated3-history.npy", allow_pickle=True).item()
# # # history_re = np.load("models/History/model-6(retrain)-history.npy", allow_pickle=True).item()
# print(history)
#
# fig, axs = plt.subplots(2, 1, figsize=(15, 15))
# fig.tight_layout(pad=8)
# axs[0].plot(history['loss'])
# axs[0].plot(history['val_loss'])
# axs[0].plot(test_loss)
# axs[0].title.set_text('Training Loss vs Validation Loss vs Test Loss')
# axs[0].set_xlabel('Epochs')
# axs[0].set_ylabel('Loss')
# axs[0].legend(['Train', 'Val', 'Test'])
#
# axs[1].plot(history['accuracy'])
# axs[1].plot(history['val_accuracy'])
# axs[1].plot(test_acc)
# axs[1].title.set_text('Training Accuracy vs Validation Accuracy vs Test Accuracy')
# axs[1].set_xlabel('Epochs')
# axs[1].set_ylabel('Accuracy')
# axs[1].legend(['Train', 'Val', 'Test'])

# plt.savefig('results/model-3-plot.png')
# plt.show()
