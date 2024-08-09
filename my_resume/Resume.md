<center>
     <h1>杨果林</h1>
     <div>
         <span>
             <img src="assets/phone-solid.svg" width="18px">
             19950791854
         </span>
         ·
         <span>
             <img src="assets/envelope-solid.svg" width="18px">
             curryyang8@gmail.com
         </span>
         ·
         <span>
             <img src="assets/github-brands.svg" width="18px">
             <a href="https://github.com/curryfromuestc">curryfromuestc</a>
         </span>
         ·
     </div>
 </center>

## 个人信息

- 男，2004 年出生
- 科研方向：数字IC，人工智能算法

## 教育经历

- 电子科技大学“强芯铸魂专项"
- 绩点：3.94，年级前 30%
- 通过 CET4/6 英语等级考试

## 工作经历

- 瑞鼎嘉扬防务科技有限公司实习经历

## 项目经历

- **集创赛海云捷迅杯**
  该项目是2024年第八届集成电路创新创业大赛的题目，要求设计一个机械臂，利用altera的FPGA，一共分为图像采集模块，图像处理模块，机械臂控制模块，以及上位机软件，本人负责上位机和图像处理模块的开发，同时完成了整个项目的模块划分以及接口定义，提出了基于连通域的目标检测算法，模块前端设计高斯滤波模块消除噪点，避免了使用深度学习算法造成的巨大资源开销。最后该项目获得了第八届集成电路创新创业大赛的国奖。
- **CannyEdge On Flash项目**
  CannyEdge On Flash项目是一款在FPGA上运行的、能够对Canny算子提供硬件支持的数字IC设计/验证项目，是大二的时候跟随实验室的研究生师兄一起完成的培训类虚拟项目，本人主要负责电路的设计以及功能仿真，基于数字IC的特点，使用移位操作设计canny计算核部分，比起使用MAC的方式，节省了大量的逻辑单元。
- 赛灵思FINN开源项目
  该项目是赛灵思开源的一个FPGA项目，可以将二值化的神经网络部署到FPGA上面，不需要重新用verilog进行部署，直接在jupyter notebook上面经过一系列转化就可以直接将ONNX格式的模型部署上去，本人实现了量化resnet18的部署，在此之前，FINN只能部署lenet这个级别的模型。
- 轻量化脉冲resent18项目
  该项目是“强芯铸魂"计划在大二下学期的项目课，本人设计了一个二值化的spiking- resent，使用了SG函数以及其导数，重写了bacward的function，在前向传播的时候使用量化的权重，但是在反向传播的时候使用之前保存的全精度的权重，但是采用了SG来反向传播梯度，实现了比业界主流的STE方法更好的识别精度，在cifar10数据集上面能达到90+准确率，在cifar100上面能达到70+，在image net上面能达到60+，虽然image net上面表现不如SOTA模型，但是问题根源是因为没有足够的计算资源，进行多次的调参实验。

## 技能清单

- ★★★ 机器学习，深度学习，SNN
- ★★☆ C、Python、verilog
