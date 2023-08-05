import os
import matplotlib.pyplot as plt
import numpy as np

# print(os.listdir('../final_dataset'))
# number_of_images = []
# folders = ['CityHall', 'MetropolitanCathedral', 'MihaiEminescuUniversityLibrary', 'NationalTheater', 'PalaceOfCulture']
# for path in folders:
#     number_of_images.append(
#         len([f for f in os.listdir(os.path.join('../final_dataset', path))]))
#
# print(number_of_images)
# plt.title('Număr de imagini inițial')
# plt.bar(['CityHall', 'Metropolitan\nCathedral', 'Mihai\nEminescu\nUniversity\nLibrary', 'NationalTheater', 'PalaceOfCulture'], number_of_images, color='lightseagreen', width=0.45)
# plt.show()
# plt.savefig('../results/total_number_of_images_all_points.png')


number_of_images = []
primarie = []
catedrala = []
bcu = []
teatru = []
palat = []
folders = os.listdir('../final_prepdata')
for path in folders:
    for category in ['CityHall', 'MetropolitanCathedral', 'MihaiEminescuUniversityLibrary', 'NationalTheater', 'PalaceOfCulture']:
        if category == 'CityHall':
            primarie.append(len([f for f in os.listdir(os.path.join('../final_prepdata', f"{path}/{category}"))]))
        if category == 'MetropolitanCathedral':
            catedrala.append(len([f for f in os.listdir(os.path.join('../final_prepdata', f"{path}/{category}"))]))
        if category == 'MihaiEminescuUniversityLibrary':
            bcu.append(len([f for f in os.listdir(os.path.join('../final_prepdata', f"{path}/{category}"))]))
        if category == 'NationalTheater':
            teatru.append(len([f for f in os.listdir(os.path.join('../final_prepdata', f"{path}/{category}"))]))
        if category == 'PalaceOfCulture':
            palat.append(len([f for f in os.listdir(os.path.join('../final_prepdata', f"{path}/{category}"))]))


number_of_images = [sum(primarie), sum(catedrala), sum(bcu), sum(teatru), sum(palat)]
print(number_of_images)
plt.title('Număr imagini după augmentare')
plt.bar(['CityHall', 'Metropolitan\nCathedral', 'Mihai\nEminescu\nUniversity\nLibrary', 'NationalTheater', 'PalaceOfCulture'], number_of_images, color='darksalmon',
        width=0.45)
plt.show()
# plt.savefig('../results/augmented_number_of_images_all_points.png')
