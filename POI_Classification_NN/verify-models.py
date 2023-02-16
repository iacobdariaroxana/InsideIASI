from tensorflow import keras, math
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

test_dataset = keras.preprocessing.image_dataset_from_directory(
    'prepdata/test', batch_size=64, image_size=(256, 256), color_mode='grayscale')
model = keras.models.load_model("models/Model/model-3-epoch_09")
loss, acc = model.evaluate(test_dataset)

print("loss: %.2f" % loss)
print("acc: %.2f" % acc)
#
test_loss = []
test_acc = []
for i in range(1, 10):
    model = keras.models.load_model("models/Model/model-3-epoch_{:0>2d}".format(i))
    loss, acc = model.evaluate(test_dataset)
    test_loss += [loss]
    test_acc += [acc]
    print("loss: %.2f" % loss)
    print("acc: %.2f" % acc)
# for i in range(1, 6):
#     model = keras.models.load_model("models/Model/model-6(retrain)-epoch_{:0>2d}".format(i))
#     loss, acc = model.evaluate(test_dataset)
#     test_loss += [loss]
#     test_accuracy += [acc]
#     print("loss: %.2f" % loss)
#     print("acc: %.2f" % acc)
#
#
# # history loading
history = np.load("models/History/model-3-history.npy", allow_pickle=True).item()
# history_re = np.load("models/History/model-6(retrain)-history.npy", allow_pickle=True).item()
print(history)
#
fig, axs = plt.subplots(2, 1, figsize=(15, 15))
fig.tight_layout(pad=8)
axs[0].plot(history['loss'])
axs[0].plot(history['val_loss'])
axs[0].plot(test_loss)
axs[0].title.set_text('Training Loss vs Validation Loss vs Test Loss')
axs[0].set_xlabel('Epochs')
axs[0].set_ylabel('Loss')
axs[0].legend(['Train', 'Val', 'Test'])
#
#
axs[1].plot(history['accuracy'])
axs[1].plot(history['val_accuracy'])
axs[1].plot(test_acc)
axs[1].title.set_text('Training Accuracy vs Validation Accuracy vs Test Accuracy')
axs[1].set_xlabel('Epochs')
axs[1].set_ylabel('Accuracy')
axs[1].legend(['Train', 'Val', 'Test'])

plt.savefig('results/model-3-plot.png')
plt.show()


# test_dataset_color = keras.preprocessing.image_dataset_from_directory(
#     'prepdata/test', batch_size=64, image_size=(176, 208))
#
test_dataset_grayscale = keras.preprocessing.image_dataset_from_directory(
    'prepdata/test', batch_size=64, image_size=(256, 256), color_mode='grayscale')


def confusion_matrix(test_dataset, model_n, epoch):

    model = keras.models.load_model("models/Model/model-{}-epoch_{:0>2d}".format(model_n, epoch))

    loss, acc = model.evaluate(test_dataset)
    print("loss: %.2f" % loss)
    print("acc: %.2f" % acc)

    predicted = []
    actual = []
    for instances, labels in test_dataset:
        predict_batch = model.predict_on_batch(instances)
        if model_n == 1:
            actual += [np.argmax(x) for x in labels]
        else:
            actual += list(labels)
        predicted += [np.argmax(x) for x in predict_batch]

    conf_matrix = math.confusion_matrix(actual, predicted, num_classes=3)

    plt.figure(figsize=(10, 7))
    sns.set()
    sns.heatmap(conf_matrix, annot=True, xticklabels=test_dataset.class_names, yticklabels=test_dataset.class_names)
    plt.xlabel('Predicted')
    plt.ylabel('Actual')
    plt.savefig(f"results/confusion_matrix_model-{model_n}_epoch-{epoch}.png")
    # plt.show()


# confusion_matrix(keras.preprocessing.image_dataset_from_directory(
#     'prepdata/test', batch_size=64, image_size=(256, 256)),
#     1, 9)
#
# for model_nr in range(2, 11):
#     if model_nr in [2, 8, 9, 10]:
#         confusion_matrix(test_dataset_color, model_nr, epochs[model_nr])
#     else:
confusion_matrix(test_dataset_grayscale, 3, 9)