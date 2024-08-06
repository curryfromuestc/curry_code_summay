import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QPushButton, QTextEdit, QVBoxLayout, QWidget
from erial import SerialDriver

class SerialUI(QMainWindow):
    def __init__(self):
        super().__init__()
        self.initUI()
        self.serial_driver = None

    def initUI(self):
        self.setWindowTitle('串口驱动程序')
        self.setGeometry(100, 100, 400, 300)

        self.text_edit = QTextEdit(self)
        self.send_button = QPushButton('发送数据', self)
        self.receive_button = QPushButton('接收数据', self)
        self.close_button = QPushButton('关闭串口', self)

        self.send_button.clicked.connect(self.send_data)
        self.receive_button.clicked.connect(self.receive_data)
        self.close_button.clicked.connect(self.close_serial)

        layout = QVBoxLayout()
        layout.addWidget(self.text_edit)
        layout.addWidget(self.send_button)
        layout.addWidget(self.receive_button)
        layout.addWidget(self.close_button)

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

    def open_serial(self, port):
        self.serial_driver = SerialDriver(port)

    def send_data(self):
        data = self.text_edit.toPlainText()
        self.serial_driver.send_data(data)

    def receive_data(self):
        data = self.serial_driver.receive_data()
        self.text_edit.setPlainText(data)

    def close_serial(self):
        self.serial_driver.close()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = SerialUI()
    ex.open_serial('COM1')  # 根据实际情况修改端口
    ex.show()
    sys.exit(app.exec_())