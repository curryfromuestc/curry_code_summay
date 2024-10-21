import torch
import torch.nn as nn
import torch.nn.functional as F
from BNN import *
from spikingjelly.activation_based import base, functional,neuron,surrogate,layer



def Bconv3x3(in_planes, out_planes, stride=1):
    """3x3 convolution with padding"""
    return layer_BinaryConv2d(in_planes, out_planes, kernel_size=3, stride=stride, padding=1, bias=False)

def Bconv1x1(in_planes, out_planes, stride=1):
    """1x1 convolution"""
    return layer_BinaryConv2d(in_planes, out_planes, kernel_size=1, stride=stride, padding=0, bias=False)

def conv3x3(in_planes, out_planes, stride=1):
    """3x3 convolution with padding"""
    return layer.Conv2d(in_planes, out_planes, kernel_size=3, stride=stride, padding=1, bias=False)

def conv1x1(in_planes, out_planes, stride=1):
    """1x1 convolution"""
    return layer.Conv2d(in_planes, out_planes, kernel_size=1, stride=stride, padding=0, bias=False)

def NeuroNode():
    return neuron.IFNode(surrogate_function=surrogate.Sigmoid(), v_threshold=1.0, v_reset=0.0, detach_reset=True)


class BasicBlock(nn.Module):
    expansion = 1

    def __init__(self, inplanes, planes, stride=1, downsample=None):
        super(BasicBlock, self).__init__()
        
        self.left = nn.Sequential(
            Bconv3x3(inplanes, planes, stride),
            layer.BatchNorm2d(planes),
            NeuroNode(),
            Bconv3x3(planes, planes),
            layer.BatchNorm2d(planes),
            NeuroNode()
        )
        self.shortcut = nn.Sequential()
        if stride != 1 or inplanes != planes:
            self.shortcut = nn.Sequential(
                Bconv1x1(inplanes, planes, stride),
                layer.BatchNorm2d(planes),
                NeuroNode()
            )

    def forward(self, x):
        out = self.left(x)
        residual = self.shortcut(x)
        out = out + residual
        return out
    
class ResNet(nn.Module):
    def __init__(self, block, layers, imagenet=False, num_classes=10, T=4):
        super().__init__()

        self.inplanes = 64
        self.T = T
        self.imagenet = imagenet
        
        if imagenet:
            self.conv1 = layer.Conv2d(3, self.inplanes, kernel_size=7, stride=2, padding=3, bias=False)
            self.maxpool = layer.MaxPool2d(kernel_size=3, stride=2, padding=1)
        else:
            self.conv1 = conv3x3(3, self.inplanes)
            
        self.bn1 = layer.BatchNorm2d(self.inplanes)
        
        self.layer1 = self._make_layer(block, 64, 2, stride=1)
        self.layer2 = self._make_layer(block, 128, 2, stride=2)
        self.layer3 = self._make_layer(block, 256, 2, stride=2)
        self.layer4 = self._make_layer(block, 512, 2, stride=2)
        self.avgpool = layer.AdaptiveAvgPool2d((1, 1))
        self.fc = layer.Linear(512 * block.expansion, num_classes)

        # for m in self.modules():
        #     if isinstance(m, layer.Conv2d):
        #         nn.init.kaiming_normal_(m.weight, mode='fan_in', nonlinearity='relu')
        #     elif isinstance(m, layer.BatchNorm2d):
        #         nn.init.constant_(m.weight, 1)
        #         nn.init.constant_(m.bias, 0)

        # for m in self.modules():
        #     if isinstance(m, Bottleneck):
        #         nn.init.constant_(m.bn3.weight, 0)
        #     elif isinstance(m, BasicBlock):
        #         nn.init.constant_(m.bn2.weight, 0)

    def _make_layer(self, block, planes, num_blocks, stride=1):
        strides = [stride] + [1] * (num_blocks - 1)
        layers = []
        for stride in strides:
            layers.append(block(self.inplanes, planes, stride))
            self.inplanes = planes*block.expansion
        return nn.Sequential(*layers)

    def forward(self, x):
       
        if len(x.shape) == 4:                       # [B, C, H, W]
            x = x.repeat(self.T, 1, 1, 1, 1)        # [T, B, C, H, W]
        elif len(x.shape) == 5:                     # [B, T, C, H, W]
            x = x.permute(1, 0, 2, 3, 4)            # [T, B, C, H, W]
        x = self.conv1(x)
        x = self.bn1(x)      
        if self.imagenet:
            x = self.maxpool(x)

        x = self.layer1(x)
        x = self.layer2(x)
        x = self.layer3(x)
        x = self.layer4(x)
        x = self.avgpool(x)
        if self.avgpool.step_mode == 's':
            x = torch.flatten(x, 1)

        elif self.avgpool.step_mode == 'm':
            x = torch.flatten(x, 2)

        
        x = self.fc(x)

        return x.mean(dim = 0)

def ResNet18(num_classes=1000, imagenet=True, T=4):
    model = ResNet(BasicBlock, [2, 2, 2, 2], imagenet=imagenet, num_classes=num_classes, T=T)
    return model

def ResNet34(num_classes=1000, imagenet=True, T=4):
    model = ResNet(BasicBlock, [6, 8, 12, 6], imagenet=imagenet, num_classes=num_classes, T=T)
    return model

