# BNN_on_fpga

## 网络结构

lenet 2conv3fc  
1bit量化，权重只为1或者-1  
LeNet(  
  (conv1): BinaryConv2d(1, 6, kernel_size=(5, 5), stride=(1, 1), bias=False)  
  (pool1): MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False)  
  (relu1): ReLU()  
  (conv2): BinaryConv2d(6, 12, kernel_size=(5, 5), stride=(1, 1), bias=False)  
  (pool2): MaxPool2d(kernel_size=2, stride=2, padding=0, dilation=1, ceil_mode=False)  
  (relu2): ReLU()  
  (fc1): BinaryLinear(in_features=192, out_features=120, bias=False)  
  (relu3): ReLU()  
  (fc2): BinaryLinear(in_features=120, out_features=84, bias=False)  
  (relu4): ReLU()  
  (fc3): BinaryLinear(in_features=84, out_features=10, bias=False)  
)  

## 硬件架构

conv1的输入是（1，28，28），输出通道为6，所以直接将并行度设置为6，第二个卷积层的输入通道为6，输出通道为12，所以一共是13次卷积操作。  

### 卷积模块

首先是卷积的滑窗模块，由于卷积核尺寸是5*5，所以滑窗模块预存的是28*5=140个像素，需要支持两种模式，第一种模式的输入是28*28，第二种是在经过第一个卷积层和第二个池化层过后，输入变成了12*12，所以预存的像素点变成了12*5=60个，由于对于每五行，从上到下，从左到右读入mem中，所以第一个读入的点应该位于mem的最高位  

```verilog
assign taps = (!state)?
                {mem[139],mem[111],mem[83],mem[55],mem[27]}
                :{mem[59],mem[47],mem[35],mem[23],mem[11]}; 
```

接下来是对该模块进行仿真，需要将图片转化为txt文件，每一行一个像素，用八位二进制无符号数表示。  

接下来是卷积模块的核心部分，卷积相乘的部分，由于所有的权重都已经量化为了  

1bit，所以我们人为规定，1代表权重为1，0代表权重为-1，转化为硬件电路里面，便是为1时加上这个激活值，为0时减掉这个激活值。激活值与权重对应相乘结束过后，进行流水线操作进行结果相加，一共是7级流水线。  

执行流程如下  

- 加载权重矩阵，一共是150个周期，因为并行度是6，所以是6*5*5=150  
- 在滑窗模块加载完过后，还需要4个周期，流水线的第一次运行还需要7个周期，一共就是161个周期。  
- 在卷积计算完成的时候，因为输出是24*24，所以在这里需要移位24*24次，同时滑窗模块换行的时候，需要进行同步操作，一共换行23次，所以是23*4次，加起来就是829  


