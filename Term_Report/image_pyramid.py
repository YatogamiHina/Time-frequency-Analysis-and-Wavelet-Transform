# -*- coding: utf-8 -*-
"""
Created on Wed Jan  4 00:13:06 2023

@author: Hina
"""

import cv2
import matplotlib.pyplot as plt

def gaussian(ori_image, down_times):
    temp_gau = ori_image.copy()
    gaussian_pyramid = [temp_gau]
    for i in range(down_times):
        temp_gau = cv2.pyrDown(temp_gau)
        gaussian_pyramid.append(temp_gau)
    return gaussian_pyramid

def laplacian(gaussian_pyramid, up_times):
    laplacian_pyramid = [gaussian_pyramid[-1]]

    for i in range(up_times, 0, -1):
        temp_pyrUp = cv2.pyrUp(gaussian_pyramid[i])
        temp_lap = cv2.subtract(gaussian_pyramid[i-1], temp_pyrUp)
        laplacian_pyramid.append(temp_lap)
    return laplacian_pyramid


img = cv2.imread("lena.bmp")
img = cv2.resize(img, (256,256))
times = 3

gaussian_pyramid = gaussian(img , times)

laplacian_pyramid = laplacian(gaussian_pyramid , times)
plt.subplot(221), plt.imshow(laplacian_pyramid[0], 'gray'), plt.title("0")
plt.subplot(222), plt.imshow(255-laplacian_pyramid[1], 'gray'), plt.title("1")
plt.subplot(223), plt.imshow(255-laplacian_pyramid[2], 'gray'), plt.title("2")
plt.subplot(224), plt.imshow(255-laplacian_pyramid[3], 'gray'), plt.title("3")
plt.show()

# for i in range(len(gaussian_pyramid)):
#     cv2.imwrite('gaussain_pyramid_' + str(i) + '.jpg',gaussian_pyramid[i])
#     cv2.imwrite('laplacian_pyramid_' + str(i) + '.jpg',laplacian_pyramid[i])
