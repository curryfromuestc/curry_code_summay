import torch
import torch.nn as nn
import torch.nn.functional as F
from torch import Tensor
from spikingjelly.activation_based import base, functional,neuron,surrogate,layer
from torch.autograd import Function
from torch.nn.common_types import _size_2_t
from typing import Union
import spikingjelly
from tqdm import tqdm
import os
import numpy as np
np.int = int

device = torch.device('cuda:0')

import torchvision
import torchvision.transforms as transforms
from torchvision.transforms import ToPILImage
show = ToPILImage()

EPOCH = 300
pre_epoch = 0
BATCH_SIZE = 256
LR = 1e-3
T = 4

#对imagenet进行图像预处理
transform_train = transforms.Compose([
    transforms.RandomResizedCrop(224),
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(15),
    transforms.ToTensor(),
    transforms.Normalize((0.485, 0.456, 0.406), (0.229, 0.224, 0.225))
])

transform_test = transforms.Compose([
    transforms.Resize((224,224)),
    transforms.ToTensor(),
    transforms.Normalize((0.485, 0.456, 0.406), (0.229, 0.224, 0.225))
])

trainset = torchvision.datasets.ImageFolder(root = '/ssd/Datasets/ImageNet/train',transform = transform_train)
trainloader = torch.utils.data.DataLoader(trainset,batch_size = BATCH_SIZE,shuffle = True,num_workers = 2)
testset = torchvision.datasets.ImageFolder(root = '/ssd/Datasets/ImageNet/val',transform = transform_test)
testloader = torch.utils.data.DataLoader(testset,batch_size = BATCH_SIZE,shuffle = False,num_workers = 2)

from resnet_step1 import *
net = ResNet18()
net = nn.DataParallel(net)
net = net.to(device)

functional.set_step_mode(net,'m')
functional.set_backend(net,'cupy',neuron.IFNode)

import torch.optim as optim
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(net.parameters(), lr=LR)
lr_scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=EPOCH, eta_min=0, last_epoch=-1)
save_path = '/home/ygl/code/curry_code_summay/AI/quantified_resnet18'

print(net)

print("Start Training")

    
for epoch in range(pre_epoch, EPOCH):
    print('\nEpoch: %d' % (epoch + 1))
    net.train()
    sum_loss = 0.0
    correct = 0.0
    total = 0.0
    for i, data in enumerate(tqdm(trainloader, 0)):
        length = len(trainloader)
        inputs, labels = data
        inputs, labels = inputs.to(device), labels.to(device)
        outputs = net(inputs)
        optimizer.zero_grad()
        loss = criterion(outputs, labels)
        
        loss.backward()
        optimizer.step()

        sum_loss += loss.item()
        _, predicted = torch.max(outputs.data, 1)
        total += labels.size(0)
        correct += predicted.eq(labels.data).cpu().sum()
        functional.reset_net(net)

    print('[epoch:%d] Loss: %.03f | Acc: %.3f%% '
            % (epoch + 1, sum_loss / (i + 1), 100. * correct / total))
    
    #测试部分
    print("Waiting Test")
    with torch.no_grad():
        correct = 0
        total = 0
        net.eval()
        for i ,data in enumerate(tqdm(testloader,0)):
            inputs, labels = data
            inputs, labels = inputs.to(device), labels.to(device)
            outputs = net(inputs)
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += predicted.eq(labels.data).cpu().sum()
            functional.reset_net(net)
        print('测试分类准确率为：%.3f%%' % (100 * correct / total))
    for param_group in optimizer.param_groups:
        lr = param_group['lr']
        print('Learning Rate: %.6f' % lr)
        
    lr_scheduler.step()
            

# %%
#保存训练模型
# print("Saving Model")
# torch.save(net.state_dict(), '/home/yanggl/code/qutified_resnet18/resnet.pth')