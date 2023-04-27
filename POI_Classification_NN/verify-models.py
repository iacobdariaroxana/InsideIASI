from tensorflow import keras, math
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

test_dataset = keras.preprocessing.image_dataset_from_directory(
    'final_prepdata/test', batch_size=64, image_size=(256, 341))
# model = keras.models.load_model("models/Model/model-1-final-epoch_07")
# loss, acc = model.evaluate(test_dataset)
#
# print("loss: %.2f" % loss)
# print("acc: %.2f" % acc)

test_loss = []
test_acc = []
for i in range(1, 16):
    model = keras.models.load_model("models/Model/model-1-last-epoch_{:0>2d}".format(i))
    loss, acc = model.evaluate(test_dataset)
    test_loss += [loss]
    test_acc += [acc]
    print("loss: %.2f" % loss)
    print("acc: %.2f" % acc)

# history loading
history = np.load("models/History/model-1-last-history.npy", allow_pickle=True).item()
# history_re = np.load("models/History/model-6(retrain)-history.npy", allow_pickle=True).item()
print(history)

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

plt.savefig('results/model-1(last)-plot.png')
plt.show()


# test_dataset_color = keras.preprocessing.image_dataset_from_directory(
#     'final_prepdata/test', batch_size=64, image_size=(256, 341))

# test_dataset_grayscale = keras.preprocessing.image_dataset_from_directory(
#     'prepdata/test', batch_size=64, image_size=(256, 256), color_mode='grayscale')


def confusion_matrix(test_dataset, model_n, epoch):
    model = keras.models.load_model("models/Model/model-{}-last-epoch_{:0>2d}".format(model_n, epoch))

    loss, acc = model.evaluate(test_dataset)
    print("loss: %.2f" % loss)
    print("acc: %.2f" % acc)

    predicted = []
    actual = []
    for instances, labels in test_dataset:
        predict_batch = model.predict_on_batch(instances)
        actual += list(labels)
        predicted += [np.argmax(x) for x in predict_batch]

    conf_matrix = math.confusion_matrix(actual, predicted, num_classes=5)

    plt.figure(figsize=(15, 13))
    sns.set()
    sns.heatmap(conf_matrix, annot=True, xticklabels=test_dataset.class_names, yticklabels=test_dataset.class_names)
    plt.xlabel('Predicted')
    plt.ylabel('Actual')
    plt.savefig(f"results/confusion_matrix_model-{model_n}-last_epoch-{epoch}.png")
    # plt.show()


confusion_matrix(test_dataset, 1, 8)
