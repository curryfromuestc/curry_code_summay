import serial
import numpy as np
from PIL import Image

import time

        

def receive_image(serial_port):
    # 帧头
    header = b"image:0,153600,320,240,7\n"
    header_length = len(header)
    
    # 从串口接收数据直到收到完整的帧头
    while True:
        line = serial_port.readline()

        print(line)
        if line == header:
            break
        time.sleep(0.1)
    
    # 接收图像数据
    image_data = b""
    while len(image_data) < 153600:  # 图像数据的字节量
        image_data += serial_port.read(153600 - len(image_data))
    
    # 将图像数据转换为NumPy数组
    image_array = np.frombuffer(image_data, dtype=np.uint16)
    
    # 转换RGB565格式为RGB888格式
    r = ((image_array >> 11) & 0x1F) << 3
    g = ((image_array >> 5) & 0x3F) << 2
    b = (image_array & 0x1F) << 3
    
    # 重新组合RGB通道
    

    r_mul= np.zeros((240,320))
    g_mul= np.zeros((240,320))
    b_mul= np.zeros((240,320))
    
    for y in range(240):
        for x in range(320):
            r_mul[y,x]=r[y*320+x]
            g_mul[y,x]=g[y*320+x]
            b_mul[y,x]=b[y*320+x]
            

    rgb_image = np.dstack((r_mul, g_mul, b_mul))
    return rgb_image

#对色彩空间进行YUV转换，同时接收到6个参数，分别是Y，U，V的上下限

def yuv(rgb_image):
    #转换规则是Y = 0.299 * R + 0.587 * G + 0.114 * B，U =-0.169 * R - 0.331 * G + 0.500 * B，V = 0.500 * R - 0.439 * G - 0.081 * B
    #将RGB转换为YUV格式
    yuv_image = np.zeros((240,320,3))
    r_mul= np.zeros((240,320))
    g_mul= np.zeros((240,320))
    b_mul= np.zeros((240,320))
    #读取RGB图像
    r_mul,g_mul,b_mul = rgb_image.split()
    for y in range(240):
        for x in range(320):
            yuv_image[y,x,0]=0.299*r_mul[y,x]+0.587*g_mul[y,x]+0.114*b_mul[y,x]
            yuv_image[y,x,1]=-0.169*r_mul[y,x]-0.331*g_mul[y,x]+0.500*b_mul[y,x]
            yuv_image[y,x,2]=0.500*r_mul[y,x]-0.439*g_mul[y,x]-0.081*b_mul[y,x]
    
    return yuv_image

#进行二值化，将YUV图像转换为二值图像，同时接收到6个参数
def binary(yuv_image, y_min, y_max, u_min, u_max, v_min, v_max):
    #将YUV图像转换为二值图像
    binary_image = np.zeros((240,320))
    for y in range(240):
        for x in range(320):
            if yuv_image[y,x,0]>=y_min and yuv_image[y,x,0]<=y_max and yuv_image[y,x,1]>=u_min and yuv_image[y,x,1]<=u_max and yuv_image[y,x,2]>=v_min and yuv_image[y,x,2]<=v_max:
                binary_image[y,x]=1
            else:
                binary_image[y,x]=0
    return binary_image

# ser = serial.Serial('COM10', 921600, timeout=1)

# try:
#     receive_image(ser)
# finally:
#     ser.close()
