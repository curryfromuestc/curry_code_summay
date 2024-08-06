import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QSlider, QLabel, QGridLayout,QPushButton
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
        self.setWindowTitle('上位机')
        self.setGeometry(100, 100, 1000, 500)

        central_widget = QWidget(self)
        self.setCentralWidget(central_widget)

        layout = QVBoxLayout(central_widget)
        right_layout = QVBoxLayout()

        #显示图片
        # self.serial_port = serial.Serial('COM3', 115200, timeout=1)
        # self.rgb_image = erial.receive_image(self.serial_port)
        self.rgb_image = np.random.randint(0, 255, (240, 320, 3))
        #self.yuv_image = erial.yuv(self.rgb_image)
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
        self.y_min.setFixedSize(255,20)
        self.y_min.valueChanged.connect(self.send_value)
        self.y_min_label = QLabel('Y_min:0', self)
        self.y_min.valueChanged.connect(lambda: self.y_min_label.setText('Y_min:' + str(self.y_min.value())))

        self.y_max = QSlider(Qt.Horizontal, self)
        self.y_max.setMinimum(0)
        self.y_max.setMaximum(255)
        self.y_max.setValue(0)
        self.y_max.setTickPosition(QSlider.TicksBelow)
        self.y_max.setTickInterval(1)
        self.y_max.setFixedSize(255,20)
        self.y_max.valueChanged.connect(self.send_value)
        self.y_max_label = QLabel('Y_max:0', self)
        self.y_max.valueChanged.connect(lambda: self.y_max_label.setText('Y_max:' + str(self.y_max.value())))

        self.u_min = QSlider(Qt.Horizontal, self)
        self.u_min.setMinimum(0)
        self.u_min.setMaximum(255)
        self.u_min.setValue(0)
        self.u_min.setTickPosition(QSlider.TicksBelow)
        self.u_min.setTickInterval(1)
        self.u_min.setFixedSize(255,20)
        self.u_min.valueChanged.connect(self.send_value)
        self.u_min_label = QLabel('U_min:0', self)
        self.u_min.valueChanged.connect(lambda: self.u_min_label.setText('U_min:' + str(self.u_min.value())))

        self.u_max = QSlider(Qt.Horizontal, self)
        self.u_max.setMinimum(0)
        self.u_max.setMaximum(255)
        self.u_max.setValue(0)
        self.u_max.setTickPosition(QSlider.TicksBelow)
        self.u_max.setTickInterval(1)
        self.u_max.setFixedSize(255,20)
        self.u_max.valueChanged.connect(self.send_value)
        self.u_max_label = QLabel('U_max:0', self)
        self.u_max.valueChanged.connect(lambda: self.u_max_label.setText('U_max:' + str(self.u_max.value())))

        self.v_min = QSlider(Qt.Horizontal, self)
        self.v_min.setMinimum(0)
        self.v_min.setMaximum(255)
        self.v_min.setValue(0)
        self.v_min.setTickPosition(QSlider.TicksBelow)
        self.v_min.setTickInterval(1)
        self.v_min.setFixedSize(255,20)
        self.v_min.valueChanged.connect(self.send_value)
        self.v_min_label = QLabel('V_min:0', self)
        self.v_min.valueChanged.connect(lambda: self.v_min_label.setText('V_min:' + str(self.v_min.value())))

        self.v_max = QSlider(Qt.Horizontal, self)
        self.v_max.setMinimum(0)
        self.v_max.setMaximum(255)
        self.v_max.setValue(0)
        self.v_max.setTickPosition(QSlider.TicksBelow)
        self.v_max.setTickInterval(1)
        self.v_max.setFixedSize(255,20)
        self.v_max.valueChanged.connect(self.send_value)
        self.v_max_label = QLabel('V_max:0', self)
        self.v_max.valueChanged.connect(lambda: self.v_max_label.setText('V_max:' + str(self.v_max.value())))

        #添加按钮
        self.button_0 = QPushButton('红色', self)
        self.button_0.setFixedSize(100,20)
        self.button_0.clicked.connect(self.send_classes_0)
        self.button_1 = QPushButton('蓝色', self)
        self.button_1.setFixedSize(100,20)
        self.button_1.clicked.connect(self.send_classes_1)
        self.button_2 = QPushButton('黄色', self)
        self.button_2.setFixedSize(100,20)
        self.button_2.clicked.connect(self.send_classes_2)
        self.button_3 = QPushButton('黑色', self)
        self.button_3.setFixedSize(100,20)
        self.button_3.clicked.connect(self.send_classes_3)
        self.button_send = QPushButton('发送', self)
        self.button_send.setFixedSize(100,20)
        self.button_send.clicked.connect(self.send_classes)

        layout.addWidget(self.y_min)
        layout.addWidget(self.y_min_label)
        layout.addWidget(self.y_max)
        layout.addWidget(self.y_max_label)
        layout.addWidget(self.u_min)
        layout.addWidget(self.u_min_label)
        layout.addWidget(self.u_max)
        layout.addWidget(self.u_max_label)
        layout.addWidget(self.v_min)
        layout.addWidget(self.v_min_label)
        layout.addWidget(self.v_max)
        layout.addWidget(self.v_max_label)
        layout.addWidget(self.button_0)
        layout.addWidget(self.button_1)
        layout.addWidget(self.button_2)
        layout.addWidget(self.button_3)
        layout.addWidget(self.button_send)


    def send_value(self):
        self.binary_image = erial.binary(self.yuv_image, self.y_min.value(), self.y_max.value(), self.u_min.value(), self.u_max.value(), self.v_min.value(), self.v_max.value())

    
    def send_classes_0(self):
        return 0
    def send_classes_1(self):
        return 1
    def send_classes_2(self):
        return 2
    def send_classes_3(self):
        return 3
    def send_classes(self):
        return True
    


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = SliderUI()
    ex.show()
    sys.exit(app.exec_())