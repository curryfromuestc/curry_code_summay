import numpy as np
from PIL import Image

#读取一张PNG图片
a = np.array(Image.open('/Users/curryyang/Pictures/received_image_process.png'))
#将a转换为灰度图像
a = a[:,:,0]
print(a)
#对a进行高斯滤波，进行两次3*3的高斯滤波
b = np.zeros((a.shape[0],a.shape[1]))
for i in range(2,a.shape[0]-2):
    for j in range(2,a.shape[1]-2):
        b[i,j] = (
            a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+
            a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+
            a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+
            a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+
            a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]
        )/25
a = b
a[a>=0.9] = 1
a[a<0.9] = 0
for i in range(2,a.shape[0]-2):
    for j in range(2,a.shape[1]-2):
        b[i,j] = (
            a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+
            a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+
            a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+
            a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+
            a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]
        )/25
a = b
a[a>=0.9] = 1
a[a<0.9] = 0
for i in range(2,a.shape[0]-2):
    for j in range(2,a.shape[1]-2):
        b[i,j] = (
            a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+
            a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+
            a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+
            a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+
            a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]
        )/25
a = b
a[a>=0.9] = 1
a[a<0.9] = 0
print(a)
#将a保存为PNG图片
Image.fromarray(np.uint8(a*255)).save('/Users/curryyang/Pictures/test_out.png')
#将a保存为txt文件
np.savetxt('/Users/curryyang/code/array.txt', a, fmt='%d', delimiter='')