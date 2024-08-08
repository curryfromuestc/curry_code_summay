import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QSlider, QLabel, QGridLayout,QPushButton,QHBoxLayout
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QPixmap, QImage
import erial
import serial
import numpy as np

def numpy2qimage(array):
    height,width,channal = array.shape
    bytesPerLine = channal * width
    return QImage(array.data, width, height, bytesPerLine, QImage.Format_RGB888).rgbSwapped()

class SliderUI(QMainWindow):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        #self.serial_port = serial.Serial('COM3', 921600, timeout=1)
        central_widget = QWidget(self)
        self.setCentralWidget(central_widget)

        main_layout = QHBoxLayout(central_widget)  # 使用 QHBoxLayout 作为主布局
        left_layout = QVBoxLayout()  # 左侧布局
        right_layout = QVBoxLayout()  # 右侧布局

        # 显示图片
        # self.serial_port = serial.Serial('COM3', 115200, timeout=1)
        # self.rgb_image = erial.receive_image(self.serial_port)
        self.rgb_image = np.random.randint(0, 255, (240, 320, 3))
        self.yuv_image = erial.yuv(self.rgb_image)
        self.qimage = numpy2qimage(self.rgb_image)
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
        self.y_min.valueChanged.connect(self.send_value)
        self.y_min_label = QLabel('Y_min:0', self)
        self.y_min.valueChanged.connect(lambda: self.y_min_label.setText('Y_min:' + str(self.y_min.value())))

        self.y_max = QSlider(Qt.Horizontal, self)
        self.y_max.setMinimum(0)
        self.y_max.setMaximum(255)
        self.y_max.setValue(0)
        self.y_max.setTickPosition(QSlider.TicksBelow)
        self.y_max.setTickInterval(1)
        self.y_max.setFixedSize(255, 20)
        self.y_max.valueChanged.connect(self.send_value)
        self.y_max_label = QLabel('Y_max:0', self)
        self.y_max.valueChanged.connect(lambda: self.y_max_label.setText('Y_max:' + str(self.y_max.value())))

        self.u_min = QSlider(Qt.Horizontal, self)
        self.u_min.setMinimum(0)
        self.u_min.setMaximum(255)
        self.u_min.setValue(0)
        self.u_min.setTickPosition(QSlider.TicksBelow)
        self.u_min.setTickInterval(1)
        self.u_min.setFixedSize(255, 20)
        self.u_min.valueChanged.connect(self.send_value)
        self.u_min_label = QLabel('U_min:0', self)
        self.u_min.valueChanged.connect(lambda: self.u_min_label.setText('U_min:' + str(self.u_min.value())))

        self.u_max = QSlider(Qt.Horizontal, self)
        self.u_max.setMinimum(0)
        self.u_max.setMaximum(255)
        self.u_max.setValue(0)
        self.u_max.setTickPosition(QSlider.TicksBelow)
        self.u_max.setTickInterval(1)
        self.u_max.setFixedSize(255, 20)
        self.u_max.valueChanged.connect(self.send_value)
        self.u_max_label = QLabel('U_max:0', self)
        self.u_max.valueChanged.connect(lambda: self.u_max_label.setText('U_max:' + str(self.u_max.value())))

        self.v_min = QSlider(Qt.Horizontal, self)
        self.v_min.setMinimum(0)
        self.v_min.setMaximum(255)
        self.v_min.setValue(0)
        self.v_min.setTickPosition(QSlider.TicksBelow)
        self.v_min.setTickInterval(1)
        self.v_min.setFixedSize(255, 20)
        self.v_min.valueChanged.connect(self.send_value)
        self.v_min_label = QLabel('V_min:0', self)
        self.v_min.valueChanged.connect(lambda: self.v_min_label.setText('V_min:' + str(self.v_min.value())))

        self.v_max = QSlider(Qt.Horizontal, self)
        self.v_max.setMinimum(0)
        self.v_max.setMaximum(255)
        self.v_max.setValue(0)
        self.v_max.setTickPosition(QSlider.TicksBelow)
        self.v_max.setTickInterval(1)
        self.v_max.setFixedSize(255, 20)
        self.v_max.valueChanged.connect(self.send_value)
        self.v_max_label = QLabel('V_max:0', self)
        self.v_max.valueChanged.connect(lambda: self.v_max_label.setText('V_max:' + str(self.v_max.value())))

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
        self.button_send.clicked.connect(self.send_classes)

        self.binary_image = erial.binary(self.yuv_image, self.y_min.value(), self.y_max.value(), self.u_min.value(),self.u_max.value(), self.v_min.value(),self.v_max.value())
        self.binary_image_map = self.binary_image * 255
        self.binary_image_qimage = QImage(self.binary_image_map.data, 320, 240, 320, QImage.Format_Grayscale8)
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
        self.data = str('(')+str(value) + str(self.y_min.value()) + str(self.y_max.value()) + str(self.u_min.value()) + str(self.u_max.value()) + str(self.v_min.value()) + str(self.v_max.value())+str(')')
        #将数据显示到pyqt界面上
        self.data_label = QLabel(self)
        self.data_label.setText(self.data)
        print(self.data)

    
    def send_classes(self):
        #发送数据
        self.serial_port = serial.Serial('COM10', 921600, timeout=1)
        erial.serial_send(self.serial_port, self.data)

    def get_position(self):
        self.serial_port = serial.Serial('COM10', 921600, timeout=1)
        self.posi = erial.receive_pos(self.serial_port)

    def get_image(self):
        self.serial_port = serial.Serial('COM10', 921600, timeout=1)
        self.rgb_image = erial.receive_image(self.serial_port)
        


    


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = SliderUI()
    ex.show()
    sys.exit(app.exec_())