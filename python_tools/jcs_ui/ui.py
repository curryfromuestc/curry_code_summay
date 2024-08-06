import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QSlider, QLabel, QGridLayout
from PyQt5.QtCore import Qt

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

        self.y_min = QSlider(Qt.Horizontal, self)
        self.y_min.setMinimum(0)
        self.y_min.setMaximum(255)
        self.y_min.setValue(0)
        self.y_min.setTickPosition(QSlider.TicksBelow)
        self.y_min.setTickInterval(1)
        self.y_min.setFixedSize(255,20)

        self.y_max = QSlider(Qt.Horizontal, self)
        self.y_max.setMinimum(0)
        self.y_max.setMaximum(255)
        self.y_max.setValue(0)
        self.y_max.setTickPosition(QSlider.TicksBelow)
        self.y_max.setTickInterval(1)
        self.y_max.setFixedSize(255,20)

        self.u_min = QSlider(Qt.Horizontal, self)
        self.u_min.setMinimum(0)
        self.u_min.setMaximum(255)
        self.u_min.setValue(0)
        self.u_min.setTickPosition(QSlider.TicksBelow)
        self.u_min.setTickInterval(1)
        self.u_min.setFixedSize(255,20)

        self.u_max = QSlider(Qt.Horizontal, self)
        self.u_max.setMinimum(0)
        self.u_max.setMaximum(255)
        self.u_max.setValue(0)
        self.u_max.setTickPosition(QSlider.TicksBelow)
        self.u_max.setTickInterval(1)
        self.u_max.setFixedSize(255,20)

        self.v_min = QSlider(Qt.Horizontal, self)
        self.v_min.setMinimum(0)
        self.v_min.setMaximum(255)
        self.v_min.setValue(0)
        self.v_min.setTickPosition(QSlider.TicksBelow)
        self.v_min.setTickInterval(1)
        self.v_min.setFixedSize(255,20)

        self.v_max = QSlider(Qt.Horizontal, self)
        self.v_max.setMinimum(0)
        self.v_max.setMaximum(255)
        self.v_max.setValue(0)
        self.v_max.setTickPosition(QSlider.TicksBelow)
        self.v_max.setTickInterval(1)
        self.v_max.setFixedSize(255,20)

        layout.addWidget(self.y_min)
        layout.addWidget(self.y_max)
        layout.addWidget(self.u_min)
        layout.addWidget(self.u_max)
        layout.addWidget(self.v_min)
        layout.addWidget(self.v_max)


    def send_value(self):
        return self.y_min.value(), self.y_max.value(), self.u_min.value(), self.u_max.value(), self.v_min.value(), self.v_max.value()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = SliderUI()
    ex.show()
    sys.exit(app.exec_())