import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QSlider, QLabel, QGridLayout,QPushButton,QHBoxLayout,QTableWidget
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QPixmap, QImage
import serial
import numpy as np
import struct
from PIL import Image
import time
import threading


def yuv(bgr_image):
    #转换规则是Y = 0.299 * R + 0.587 * G + 0.114 * B，U =-0.169 * R - 0.331 * G + 0.500 * B，V = 0.500 * R - 0.439 * G - 0.081 * B
    #将RGB转换为YUV格式
    yuv_image = np.zeros((240,320,3))
    r_mul= np.zeros((240,320))
    g_mul= np.zeros((240,320))
    b_mul= np.zeros((240,320))
    #读取BGR图像
    r_mul=bgr_image[:,:,0]
    g_mul=bgr_image[:,:,1]
    b_mul=bgr_image[:,:,2]
    for y in range(240):
        for x in range(320):
            yuv_image[y,x,0]=0.299*r_mul[y,x]+0.587*g_mul[y,x]+0.114*b_mul[y,x] 
            yuv_image[y,x,1]=-0.169*r_mul[y,x]-0.331*g_mul[y,x]+0.500*b_mul[y,x] + 128
            yuv_image[y,x,2]=0.500*r_mul[y,x]-0.439*g_mul[y,x]-0.081*b_mul[y,x] + 128
    
    return yuv_image

#进行二值化，将YUV图像转换为二值图像，同时接收到6个参数
def binary(yuv_image, y_min, y_max, u_min, u_max, v_min, v_max):
    #将YUV图像转换为二值图像
    binary_image = np.zeros((240,320,3))
    for y in range(240):
        for x in range(320):
            if yuv_image[y,x,0]>=y_min and yuv_image[y,x,0]<=y_max and yuv_image[y,x,1]>=u_min and yuv_image[y,x,1]<=u_max and yuv_image[y,x,2]>=v_min and yuv_image[y,x,2]<=v_max:
                binary_image[y,x,0]=255
                binary_image[y,x,1]=255
                binary_image[y,x,2]=255
            else:
                binary_image[y,x, 0]=0
                binary_image[y,x, 1]=0
                binary_image[y,x, 2]=0

    return binary_image

def add_pos(serial_port,binary_image):
    header = b"("
    # while True:
    #     line = serial_port.readline()
    #     if line == header:
    #         break
    #     time.sleep(0.1)
    # pos_data = b""
    # while len(pos_data)<14:
    #     pos_data += serial_port.read(14-len(pos_data))
    
    #先用一个固定的位置代替进行测试，后续再接收位置信息
    pos_data = b'\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01\x01'

    pos_image = binary_image.copy()
    square_x = pos_data[1] * 256 + pos_data[2]
    square_y = pos_data[3]
    circle_x = pos_data[8] * 256 + pos_data[9]
    circle_y = pos_data[10]
    hexagon_x = pos_data[11] * 256 + pos_data[12]
    hexagon_y = pos_data[13]
    square_left = pos_data[4] * 256 + pos_data[5]
    square_right = pos_data[6] * 256 + pos_data[7]
    pos_image[square_y,square_x] = [0,255,0]
    pos_image[circle_y,circle_x] = [0,255,0]
    pos_image[hexagon_y,hexagon_x] = [0,255,0]
    pos_image[:,square_left,:] = [0,255,0]
    pos_image[:,square_right,:] = [0,255,0]
    return pos_image
        
    

def receive_image(serial_port):
    # 帧头
    header = b"image:0,153600,320,240,7\n"
    header_length = len(header)
    # 从串口接收数据直到收到完整的帧头
    serial_port.write(b'(t/')
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

def numpy2qimage(array: np.ndarray) -> QImage:
    height,width,channal = array.shape
    bytesPerLine = channal * width
    array = np.array(array.data, dtype=np.uint8)
    return QImage(array.data, width, height, bytesPerLine, QImage.Format_RGB888)#.rgbSwapped()

class SliderUI(QMainWindow):
    def __init__(self):
        super().__init__()
        self.serial_port = serial.Serial('/dev/tty.usbserial-0001', 921600, timeout=1)
        self.bgr_image = np.zeros((240,320,3))
        self.qimage = QImage(self.bgr_image, 320, 240 ,320*3, QImage.Format_RGB888)
        self.binary_image_qimage = QImage(self.bgr_image, 320, 240 , 320*3,QImage.Format_RGB888)
        self.binary_image_pixmap = QPixmap(self.binary_image_qimage)
        self.pixmap = QPixmap(self.qimage)
        self.initUI()
        self.thread1= threading.Thread(target=self.update_yuv_image)
        self.thread1.start()
        self.thread2= threading.Thread(target=self.update_receive_image)
        self.thread2.start()
        self.thread3= threading.Thread(target=self.update_recieve_pos)
        self.thread3.start()
        self.should_exit = False

        
    def initUI(self):
        central_widget = QWidget(self)
        self.setCentralWidget(central_widget)

        main_layout = QHBoxLayout(central_widget)  # 使用 QHBoxLayout 作为主布局
        left_layout = QVBoxLayout()  # 左侧布局
        right_layout = QVBoxLayout()  # 右侧布局

        # 添加图片,设置图片大小
        self.logo = QPixmap('logo.png')
        self.logo = self.logo.scaled(60, 60)
        self.label_logo = QLabel(self)
        self.label_logo.setPixmap(self.logo)
        right_layout.addWidget(self.label_logo)
        #接收图片的逻辑
        self.bgr_image = receive_image(self.serial_port)
        self.qimage = numpy2qimage(self.bgr_image)
        self.pixmap = QPixmap(self.qimage)
        self.label = QLabel(self)
        self.label.setPixmap(self.pixmap)
        right_layout.addWidget(self.label)
        

        self.y_min = QSlider(Qt.Horizontal, self)
        self.y_min.setMinimum(0)
        self.y_min.setMaximum(255)
        self.y_min.setValue(0)
        self.y_min.setTickPosition(QSlider.TicksBelow)
        self.y_min.setTickInterval(1)
        self.y_min.setFixedSize(255, 20)
        #self.y_min.valueChanged.connect(self.update_yuv_image)
        self.y_min_label = QLabel('Y_min:0', self)
        #self.y_min.valueChanged.connect(lambda: self.y_min_label.setText('Y_min:' + str(self.y_min.value())))

        self.y_max = QSlider(Qt.Horizontal, self)
        self.y_max.setMinimum(0)
        self.y_max.setMaximum(255)
        self.y_max.setValue(0)
        self.y_max.setTickPosition(QSlider.TicksBelow)
        self.y_max.setTickInterval(1)
        self.y_max.setFixedSize(255, 20)
        #self.y_max.valueChanged.connect(self.update_yuv_image)
        self.y_max_label = QLabel('Y_max:0', self)
        #self.y_max.valueChanged.connect(lambda: self.y_max_label.setText('Y_max:' + str(self.y_max.value())))

        self.u_min = QSlider(Qt.Horizontal, self)
        self.u_min.setMinimum(0)
        self.u_min.setMaximum(255)
        self.u_min.setValue(0)
        self.u_min.setTickPosition(QSlider.TicksBelow)
        self.u_min.setTickInterval(1)
        self.u_min.setFixedSize(255, 20)
        #self.u_min.valueChanged.connect(self.update_yuv_image)
        self.u_min_label = QLabel('U_min:0', self)
        #self.u_min.valueChanged.connect(lambda: self.u_min_label.setText('U_min:' + str(self.u_min.value())))

        self.u_max = QSlider(Qt.Horizontal, self)
        self.u_max.setMinimum(0)
        self.u_max.setMaximum(255)
        self.u_max.setValue(0)
        self.u_max.setTickPosition(QSlider.TicksBelow)
        self.u_max.setTickInterval(1)
        self.u_max.setFixedSize(255, 20)
        #self.u_max.valueChanged.connect(self.update_yuv_image)
        self.u_max_label = QLabel('U_max:0', self)
        #self.u_max.valueChanged.connect(lambda: self.u_max_label.setText('U_max:' + str(self.u_max.value())))

        self.v_min = QSlider(Qt.Horizontal, self)
        self.v_min.setMinimum(0)
        self.v_min.setMaximum(255)
        self.v_min.setValue(0)
        self.v_min.setTickPosition(QSlider.TicksBelow)
        self.v_min.setTickInterval(1)
        self.v_min.setFixedSize(255, 20)
        #self.v_min.valueChanged.connect(self.update_yuv_image)
        self.v_min_label = QLabel('V_min:0', self)
        #self.v_min.valueChanged.connect(lambda: self.v_min_label.setText('V_min:' + str(self.v_min.value())))

        self.v_max = QSlider(Qt.Horizontal, self)
        self.v_max.setMinimum(0)
        self.v_max.setMaximum(255)
        self.v_max.setValue(0)
        self.v_max.setTickPosition(QSlider.TicksBelow)
        self.v_max.setTickInterval(1)
        self.v_max.setFixedSize(255, 20)
        #self.v_max.valueChanged.connect(self.update_yuv_image)
        self.v_max_label = QLabel('V_max:0', self)
        #self.v_max.valueChanged.connect(lambda: self.v_max_label.setText('V_max:' + str(self.v_max.value())))

        #添加位置信息
        # self.table_widget = QTableWidget()
        # # self.array_data = erial.receive_pos(self.serial_port)
        # #self.table_widget.setRowCount(1)
        # self.table_widget.setColumnCount(4)
        # self.table_widget.setHorizontalHeaderLabels(['Color', 'Square', 'Circle', 'Hexagon'])
        # left_layout.addWidget(self.table_widget)


        # 添加按钮
        self.button_0 = QPushButton('红色', self)
        self.button_0.setFixedSize(100, 20)
        self.button_0.clicked.connect(lambda:self.send_value(0))
        self.button_1 = QPushButton('蓝色', self)
        self.button_1.setFixedSize(100, 20)
        self.button_1.clicked.connect(lambda:self.send_value(1))
        self.button_2 = QPushButton('黄色', self)
        self.button_2.setFixedSize(100, 20)
        self.button_2.clicked.connect(lambda:self.send_value(2))
        self.button_3 = QPushButton('黑色', self)
        self.button_3.setFixedSize(100, 20)
        self.button_3.clicked.connect(lambda:self.send_value(3))
        self.button_send = QPushButton('发送', self)
        self.button_send.setFixedSize(100, 20)
        #self.button_send.clicked.connect(self.send_classes)

        #self.binary_image = erial.binary(self.yuv_image, self.y_min.value(), self.y_max.value(), self.u_min.value(),self.u_max.value(), self.v_min.value(),self.v_max.value())
        #print(self.binary_image)
        #self.binary_image_map = self.binary_image * 255
        self.binary_image_qimage = QImage(np.zeros((240,320,3)), 320, 240 ,320*3, QImage.Format_RGB888)
        self.binary_image_pixmap = QPixmap(self.binary_image_qimage)
        self.binary_image_label = QLabel(self)
        self.binary_image_label.setPixmap(self.binary_image_pixmap)
        right_layout.addWidget(self.binary_image_label)

        left_layout.addWidget(self.y_min)
        left_layout.addWidget(self.y_min_label)
        left_layout.addWidget(self.y_max)
        left_layout.addWidget(self.y_max_label)
        left_layout.addWidget(self.u_min)
        left_layout.addWidget(self.u_min_label)
        left_layout.addWidget(self.u_max)
        left_layout.addWidget(self.u_max_label)
        left_layout.addWidget(self.v_min)
        left_layout.addWidget(self.v_min_label)
        left_layout.addWidget(self.v_max)
        left_layout.addWidget(self.v_max_label)
        left_layout.addWidget(self.button_0)
        left_layout.addWidget(self.button_1)
        left_layout.addWidget(self.button_2)
        left_layout.addWidget(self.button_3)
        left_layout.addWidget(self.button_send)

        main_layout.addLayout(left_layout)  # 将左侧布局添加到主布局
        main_layout.addLayout(right_layout)  # 将右侧布局添加到主布局

    def send_value(self, value):
        #设置一个字符串，用于存储发送的数据，第一位是类别，有0，1，2，3，分别代表红色，蓝色，黄色，黑色，后面是YUV的上下限
        #发送数据
        format=""
        for _ in range(10):
            format+="B"
        self.data = struct.pack(format,ord('('),(value),
            (self.y_min.value()) , (self.y_max.value()),
                 (self.u_min.value()) , (self.u_max.value()) ,
                     (self.v_min.value()) , (self.v_max.value()),
                        ord(')'),ord('/'))
        #将数据显示到pyqt界面上
        self.data_label = QLabel(self)
        self.data_label.setText(str(self.data))
        print(str(self.data))
        pass
    def send_classes(self):
        #发送数据
        serial.serial_send(self.serial_port, self.data)
    # def send_classes(self):
    #     #发送数据
    #     erial.serial_send(self.serial_port, self.data)
    
    def update_yuv_image(self):
        while 1:
            self.yuv_image = yuv(self.bgr_image)
            self.binary_image = binary(self.yuv_image, self.y_min.value(), self.y_max.value(), self.u_min.value(),self.u_max.value(), self.v_min.value(),self.v_max.value())
            self.binary_image = add_pos(self.serial_port,self.binary_image)
            #print(self.binary_image.shape)
            self.binary_image_qimage = numpy2qimage(self.binary_image)
            #print(self.binary_image_qimage.size())
            self.binary_image_pixmap = QPixmap(self.binary_image_qimage)
            self.binary_image_label.setPixmap(self.binary_image_pixmap)
            self.show()
            time.sleep(0.3)
            if (self.should_exit):
                break
    def update_receive_image(self):
        while 1:
            self.bgr_image = receive_image(self.serial_port)
            self.qimage = numpy2qimage(self.bgr_image)
            self.pixmap = QPixmap(self.qimage)
            self.label.setPixmap(self.pixmap)
            self.show()
            time.sleep(0.3)
            if (self.should_exit):
                break
    def update_recieve_pos(self):
        while 1:
            self.pos_image = add_pos(self.serial_port,self.binary_image)
            self.pos_image_qimage = numpy2qimage(self.pos_image)
            self.pos_image_pixmap = QPixmap(self.pos_image_qimage)
            self.pos_image_label.setPixmap(self.pos_image_pixmap)
            self.show()
            time.sleep(0.3)
            if (self.should_exit):
                break


if __name__ == '__main__':
    app = QApplication(sys.argv)
    
    ex = SliderUI()

    


    ex.show()
    app.exec_()
    print("exit")
    ex.should_exit = True

    