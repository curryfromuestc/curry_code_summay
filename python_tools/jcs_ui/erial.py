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
    
    # 创建PIL Image对象
    pil_image = Image.fromarray(rgb_image.astype('uint8'))
    
    # 保存图像为BMP文件
    pil_image.save("received_image.bmp")
    print("图像已保存为 received_image.bmp")

# 串口配置
ser = serial.Serial('COM10', 921600, timeout=1)

try:
    receive_image(ser)
finally:
    ser.close()
