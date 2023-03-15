import os
import matplotlib.pyplot as plt
import numpy as np

# print(os.listdir('../dataset'))
# number_of_images = []
# folders = os.listdir('../dataset')
# for path in folders:
#     number_of_images.append(len([f for f in os.listdir(os.path.join('../dataset', path)) if not f.startswith("screenshot")]))
#
# print(number_of_images)
# plt.title('Internet number of images for each point of interest')
# plt.bar(folders, number_of_images, color='mediumseagreen', width=0.45)
# # plt.show()
# plt.savefig('../results/internet_number_of_images.png')


number_of_images = []
m = []
n = []
p = []
folders = os.listdir('../prepdata')
for path in folders:
    for category in ['MetropolitanCathedral', 'NationalTheater', 'PalaceOfCulture']:
        if category == 'MetropolitanCathedral':
            m.append(len([f for f in os.listdir(os.path.join('../prepdata', f"{path}/{category}"))]))
        if category == 'NationalTheater':
            n.append(len([f for f in os.listdir(os.path.join('../prepdata', f"{path}/{category}"))]))
        if category == 'PalaceOfCulture':
            p.append(len([f for f in os.listdir(os.path.join('../prepdata', f"{path}/{category}"))]))

number_of_images = [sum(m), sum(n), sum(p)]
print(number_of_images)
plt.title('Augmented number of images for each point of interest')
plt.bar(['MetropolitanCathedral', 'NationalTheater', 'PalaceOfCulture'], number_of_images, color='darksalmon',
        width=0.45)
# plt.show()
plt.savefig('../results/augmented_number_of_images.png')
