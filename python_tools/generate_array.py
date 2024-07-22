import os
import numpy as np



path_array = 'array.txt'


#读取生成的矩阵文件，在这个矩阵中，每一个元素都是1或者0，同时，生成一个正方形，一个圆形，一个六边形
array = np.zeros((320,240))
for i in range(320):
    for j in range(240):
        if np.abs(i-50)<25 and np.abs(j-50)<25:
            array[i,j] = 1
        if (i-50)**2+(j-120)**2 < 25**2:
            array[i,j] = 1
        if np.abs(i-120)+np.abs(j-50)<25:
            array[i,j] = 1
with open(path_array, 'w') as f:
    for row in array:
        f.write(''.join(format(int(x), 'b') for x in row) + '\n')