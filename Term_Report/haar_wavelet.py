# -*- coding: utf-8 -*-
"""
Created on Tue Jan  3 17:40:21 2023

@author: Hina
"""

import numpy as np
import pywt
import cv2
import matplotlib.pyplot as plt

img = cv2.imread("lena.bmp")
img = cv2.resize(img, (500,500))

img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY).astype(np.float32)


plt.figure('2-D Haar wavelet')
coeffs = pywt.dwt2(img, 'haar')
cA, (cH, cV, cD) = coeffs


AH = np.concatenate([cA, cH], axis=1)
VD = np.concatenate([cV, cD], axis=1)
img = np.concatenate([AH, VD], axis=0)

plt.imshow(img,'gray')
plt.title('result')
plt.show()

# key = cv2.waitKey(0)
# if key == 27:
#     cv2.destroyAllWindows()