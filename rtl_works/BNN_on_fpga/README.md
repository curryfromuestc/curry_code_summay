# BNN_on_fpga
## 网络结构  
lenet 2conv3fc  
1bit量化，权重只为1或者-1  
LeNet(  
  (conv1): BinaryConv2d(1, 6, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1), bias=False)  
  (pool1): MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False)  
  (conv2): BinaryConv2d(6, 12, kernel_size=(3, 3), stride=(1, 1), padding=(1, 1), bias=False)  
  (pool2): MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False)  
  (relu): ReLU()  
  (fc1): BinaryLinear(in_features=588, out_features=120, bias=False)  
  (fc2): BinaryLinear(in_features=120, out_features=84, bias=False)  
  (fc3): BinaryLinear(in_features=84, out_features=10, bias=False)  
)  
## 硬件架构  
conv1的输入是（1，28，28），输出通道为6，所以直接将并行度设置为6，第二个卷积层的输入通道为6，输出通道为12，所以一共是13次卷积操作。  
### 卷积模块  
首先是卷积的滑窗模块，由于卷积核尺寸是5*5，所以滑窗模块预存的是28*5=140个像素，需要支持两种模式，第一种模式的输入是28*28，第二种是在经过第一个卷积层和第二个池化层过后，输入变成了12*12