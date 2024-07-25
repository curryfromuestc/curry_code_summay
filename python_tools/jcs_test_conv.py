import numpy as np
from PIL import Image

#读取一张PNG图片
a = np.array(Image.open('C:\\Users\\curry_yang\\BaiduSyncdisk\\图片\\received_image_process.png'))
#将a转换为灰度图像
a = a[:,:,0]*0.299 + a[:,:,1]*0.587 + a[:,:,2]*0.114
a = a/255
#将a保存为PNG图片
Image.fromarray(np.uint8(a*255)).save('C:\\Users\\curry_yang\\curry_code_summay\\rtl_works\\ov5640\\received_image_pre_process.png')
#对a进行高斯滤波，进行两次11*11的高斯滤波
b = np.zeros((a.shape[0],a.shape[1]))
# for i in range(5,a.shape[0]-5):
#     for j in range(5,a.shape[1]-5):
#         b[i,j] = (
#             a[i-5,j-5]+a[i-5,j-4]+a[i-5,j-3]+a[i-5,j-2]+a[i-5,j-1]+a[i-5,j]+a[i-5,j+1]+a[i-5,j+2]+a[i-5,j+3]+a[i-5,j+4]+a[i-5,j+5]+
#             a[i-4,j-5]+a[i-4,j-4]+a[i-4,j-3]+a[i-4,j-2]+a[i-4,j-1]+a[i-4,j]+a[i-4,j+1]+a[i-4,j+2]+a[i-4,j+3]+a[i-4,j+4]+a[i-4,j+5]+
#             a[i-3,j-5]+a[i-3,j-4]+a[i-3,j-3]+a[i-3,j-2]+a[i-3,j-1]+a[i-3,j]+a[i-3,j+1]+a[i-3,j+2]+a[i-3,j+3]+a[i-3,j+4]+a[i-3,j+5]+
#             a[i-2,j-5]+a[i-2,j-4]+a[i-2,j-3]+a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+a[i-2,j+3]+a[i-2,j+4]+a[i-2,j+5]+
#             a[i-1,j-5]+a[i-1,j-4]+a[i-1,j-3]+a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+a[i-1,j+3]+a[i-1,j+4]+a[i-1,j+5]+
#             a[i,j-5]+a[i,j-4]+a[i,j-3]+a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+a[i,j+3]+a[i,j+4]+a[i,j+5]+
#             a[i+1,j-5]+a[i+1,j-4]+a[i+1,j-3]+a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+a[i+1,j+3]+a[i+1,j+4]+a[i+1,j+5]+
#             a[i+2,j-5]+a[i+2,j-4]+a[i+2,j-3]+a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]+a[i+2,j+3]+a[i+2,j+4]+a[i+2,j+5]+
#             a[i+3,j-5]+a[i+3,j-4]+a[i+3,j-3]+a[i+3,j-2]+a[i+3,j-1]+a[i+3,j]+a[i+3,j+1]+a[i+3,j+2]+a[i+3,j+3]+a[i+3,j+4]+a[i+3,j+5]+
#             a[i+4,j-5]+a[i+4,j-4]+a[i+4,j-3]+a[i+4,j-2]+a[i+4,j-1]+a[i+4,j]+a[i+4,j+1]+a[i+4,j+2]+a[i+4,j+3]+a[i+4,j+4]+a[i+4,j+5]+
#             a[i+5,j-5]+a[i+5,j-4]+a[i+5,j-3]+a[i+5,j-2]+a[i+5,j-1]+a[i+5,j]+a[i+5,j+1]+a[i+5,j+2]+a[i+5,j+3]+a[i+5,j+4]+a[i+5,j+5]
#         )/121
#进行9*9的高斯滤波
# for i in range(4,a.shape[0]-4):
#     for j in range(4,a.shape[1]-4):
#         b[i,j] = (
#             a[i-4,j-4]+a[i-4,j-3]+a[i-4,j-2]+a[i-4,j-1]+a[i-4,j]+a[i-4,j+1]+a[i-4,j+2]+a[i-4,j+3]+a[i-4,j+4]+
#             a[i-3,j-4]+a[i-3,j-3]+a[i-3,j-2]+a[i-3,j-1]+a[i-3,j]+a[i-3,j+1]+a[i-3,j+2]+a[i-3,j+3]+a[i-3,j+4]+
#             a[i-2,j-4]+a[i-2,j-3]+a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+a[i-2,j+3]+a[i-2,j+4]+
#             a[i-1,j-4]+a[i-1,j-3]+a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+a[i-1,j+3]+a[i-1,j+4]+
#             a[i,j-4]+a[i,j-3]+a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+a[i,j+3]+a[i,j+4]+
#             a[i+1,j-4]+a[i+1,j-3]+a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+a[i+1,j+3]+a[i+1,j+4]+
#             a[i+2,j-4]+a[i+2,j-3]+a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]+a[i+2,j+3]+a[i+2,j+4]+
#             a[i+3,j-4]+a[i+3,j-3]+a[i+3,j-2]+a[i+3,j-1]+a[i+3,j]+a[i+3,j+1]+a[i+3,j+2]+a[i+3,j+3]+a[i+3,j+4]+
#             a[i+4,j-4]+a[i+4,j-3]+a[i+4,j-2]+a[i+4,j-1]+a[i+4,j]+a[i+4,j+1]+a[i+4,j+2]+a[i+4,j+3]+a[i+4,j+4]
#         )/81
##进行7*7的高斯滤波
# for i in range(3,a.shape[0]-3):
#     for j in range(3,a.shape[1]-3):
#         b[i,j] = (
#             a[i-3,j-3]+a[i-3,j-2]+a[i-3,j-1]+a[i-3,j]+a[i-3,j+1]+a[i-3,j+2]+a[i-3,j+3]+
#             a[i-2,j-3]+a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+a[i-2,j+3]+
#             a[i-1,j-3]+a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+a[i-1,j+3]+
#             a[i,j-3]+a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+a[i,j+3]+
#             a[i+1,j-3]+a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+a[i+1,j+3]+
#             a[i+2,j-3]+a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]+a[i+2,j+3]+
#             a[i+3,j-3]+a[i+3,j-2]+a[i+3,j-1]+a[i+3,j]+a[i+3,j+1]+a[i+3,j+2]+a[i+3,j+3]
#         )/49
#进行5*5的高斯滤波
for i in range(2,a.shape[0]-2):
    for j in range(2,a.shape[1]-2):
        b[i,j] = (
            a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+
            a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+
            a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+
            a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+
            a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]
        )/25
#进行3*3的高斯滤波
# for i in range(1,a.shape[0]-1):
#     for j in range(1,a.shape[1]-1):
#         b[i,j] = (
#             a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+
#             a[i,j-1]+a[i,j]+a[i,j+1]+
#             a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]
#         )/9
a = b
#将b保存为txt文件
np.savetxt('C:\\Users\\curry_yang\\curry_code_summay\\rtl_works\\ov5640\\received_image_process_1.txt', b, fmt='%d', delimiter=' ')
#将b保存为PNG图片
Image.fromarray(np.uint8(b*255)).save('C:\\Users\\curry_yang\\curry_code_summay\\rtl_works\\ov5640\\received_image_process_b.png')
a[a>0.92] = 1
a[a<=0.92] = 0

# for i in range(2,a.shape[0]-2):
#     for j in range(2,a.shape[1]-2):
#         b[i,j] = (
#             a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+
#             a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+
#             a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+
#             a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+
#             a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]
#         )/25
# a = b
# a[a>=0.9] = 1
# a[a<0.9] = 0
# for i in range(2,a.shape[0]-2):
#     for j in range(2,a.shape[1]-2):
#         b[i,j] = (
#             a[i-2,j-2]+a[i-2,j-1]+a[i-2,j]+a[i-2,j+1]+a[i-2,j+2]+
#             a[i-1,j-2]+a[i-1,j-1]+a[i-1,j]+a[i-1,j+1]+a[i-1,j+2]+
#             a[i,j-2]+a[i,j-1]+a[i,j]+a[i,j+1]+a[i,j+2]+
#             a[i+1,j-2]+a[i+1,j-1]+a[i+1,j]+a[i+1,j+1]+a[i+1,j+2]+
#             a[i+2,j-2]+a[i+2,j-1]+a[i+2,j]+a[i+2,j+1]+a[i+2,j+2]
#         )/25
# a = b
# a[a>=0.9] = 1
# a[a<0.9] = 0
# print(a)
#将a保存为PNG图片
Image.fromarray(np.uint8(a*255)).save('C:\\Users\\curry_yang\\curry_code_summay\\rtl_works\\ov5640\\received_image_process_5.png')
#将a保存为txt文件
np.savetxt('C:\\Users\\curry_yang\\curry_code_summay\\rtl_works\\ov5640\\received_image_process_5.txt', a, fmt='%d', delimiter='')