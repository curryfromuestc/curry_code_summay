import torch
import torch.nn as nn
from spikingjelly.activation_based import layer, neuron, surrogate

#处理DVS动作的神经网络
class DVS_gesture(nn.Module):
    def __init__(self, input_channels, output_channels, num_classes=5):
        super(DVS_gesture, self).__init__()
        self.conv1 = layer.Conv2d(input_channels, output_channels, kernel_size=3, stride=1, padding=1, bias=False)
        self.bn1 = layer.BatchNorm2d(output_channels)
        self.relu = layer.ReLU()
        self.pool = nn.MaxPool2d(kernel_size=2, stride=2, padding=0)
        self.neuron = neuron.IFNode(surrogate_function=surrogate.ATan(), v_threshold=1.0, v_reset=0.0, detach_reset=True)
        self.fc = layer.Linear(output_channels, num_classes)
    def forward(self, x):
        x = self.conv1(x)
        x = self.bn1(x)
        x = self.relu(x)
        x = self.pool(x)
        x = self.neuron(x)
        x = self.fc(x)
        return x
        