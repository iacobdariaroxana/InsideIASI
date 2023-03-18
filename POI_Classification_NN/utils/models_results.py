import matplotlib.pyplot as plt

# plt.xlabel('Model')
# plt.ylabel('Accuracy')
# plt.title('Test dataset results')

# models = ['VGG16(TL)', 'VGG16', 'VGG19(TL)', 'VGG19', 'InceptionV3', 'Custom']
# acc = [0.9969, 0.9984, 0.9984, 0.9984, 1.0, 1.0]
# bar_colors = ['tab:red', 'tab:blue', 'tab:cyan', 'tab:green', 'tab:purple', 'tab:orange']
#
# plt.ylim(min(acc) - 0.005, max(acc))
# plt.bar(models, acc, color=bar_colors)
#
# plt.gca().legend(["TL=Transfer Learning"], loc='upper left')
#
# plt.show()

plt.xlabel('Seconds')
plt.ylabel('Model')
plt.title('Prediction time for one image')

models = ['InceptionV3', 'Custom']
bar_colors = ['tab:purple', 'tab:orange']
speed = [0.8478, 0.1469]
plt.barh(models, speed, align='center', color=bar_colors)
plt.savefig('../results/pred_time.png')
plt.show()
