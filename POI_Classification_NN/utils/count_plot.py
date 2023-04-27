import os
import matplotlib.pyplot as plt
import numpy as np

# print(os.listdir('../final_dataset'))
# number_of_images = []
# folders = ['CityHall', 'MihaiEminescuUniversityLibrary']
# for path in folders:
#     number_of_images.append(
#         len([f for f in os.listdir(os.path.join('../final_dataset', path))]))
#
# print(number_of_images)
# plt.title('Total number of images')
# plt.bar(folders, number_of_images, color='lightseagreen', width=0.45)
# # plt.show()
# plt.savefig('../results/total_number_of_images_last.png')

number_of_images = []
p = []
b = []
folders = os.listdir('../final_prepdata')
for path in folders:
    for category in ['CityHall', 'MihaiEminescuUniversityLibrary']:
        if category == 'CityHall':
            p.append(len([f for f in os.listdir(os.path.join('../final_prepdata', f"{path}/{category}"))]))
        if category == 'MihaiEminescuUniversityLibrary':
            b.append(len([f for f in os.listdir(os.path.join('../final_prepdata', f"{path}/{category}"))]))


number_of_images = [sum(p), sum(b)]
print(number_of_images)
plt.title('Augmented number of images')
plt.bar(['CityHall', 'MihaiEminescuUniversityLibrary'], number_of_images, color='darksalmon',
        width=0.45)
# plt.show()
plt.savefig('../results/augmented_number_of_images_last.png')
