# %%
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch import Tensor
from spikingjelly.activation_based import base, functional,neuron,surrogate,layer,encoding
from torch.autograd import Function
from torch.nn.common_types import _size_2_t
from typing import Union
import spikingjelly
from tqdm import tqdm


# %%
#加载cifar10数据集
import torchvision
import torchvision.transforms as transforms
from torchvision.transforms import ToPILImage

show = ToPILImage()

#定义训练参数
EPOCH = 300
pre_epoch = 0
BATCH_SIZE = 512
LR = 1e-3
T = 4

#对训练数据进行变换（增强数据）
transform_train = transforms.Compose([
    transforms.RandomCrop(32,padding = 4),
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(15),
    transforms.ToTensor(),
    transforms.Normalize((0.485, 0.456, 0.406), (0.229, 0.224, 0.225))
])

transform_test = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.485, 0.456, 0.406), (0.229, 0.224, 0.225))
])

#数据集下载
trainset = torchvision.datasets.CIFAR10(root = '/home/yanggl/code/qutified_resnet18/cifar10',train = True,download = True,transform = transform_train)
trainloader = torch.utils.data.DataLoader(trainset,batch_size = BATCH_SIZE,shuffle = True,num_workers = 2)

testset = torchvision.datasets.CIFAR10(root = '/home/yanggl/code/qutified_resnet18/cifar10',train = False,download = True,transform = transform_test)
testloader = torch.utils.data.DataLoader(testset,batch_size = BATCH_SIZE,shuffle = False,num_workers = 2)

#cifar10数据集标签
classes = ('plane', 'car', 'bird', 'cat',
           'deer', 'dog', 'frog', 'horse', 'ship', 'truck')

# %%
from resnet_step1 import *

# %%
#实例化模型

net = ResNet18(num_classes=10, imagenet=False, T=4)
net = nn.DataParallel(net)

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

net = net.to(device)
functional.set_step_mode(net,'m')
functional.set_backend(net, 'cupy', neuron.IFNode)
#定义损失函数和优化器
import torch.optim as optim
criterion = nn.CrossEntropyLoss()
#使用SGD进行优化
optimizer = optim.Adam(net.parameters(),lr = LR)
lr_scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=EPOCH, eta_min=0, last_epoch=-1)
# optimizer = optim.SGD(net.parameters(),lr = LR)

# %%
print(net)

# %%
from spikingjelly.activation_based import encoding

#训练网络
encoder = encoding.PoissonEncoder()

criterion = nn.CrossEntropyLoss()

print("Start Training")
for epoch in range(pre_epoch, EPOCH):
    print('\nEpoch: %d' % (epoch + 1))
    net.train()
    sum_loss = 0.0
    correct = 0.0
    total = 0.0
    for i, data in enumerate(tqdm(trainloader, 0)):
        length = len(trainloader)
        input, labels = data
        inputs = torch.zeros(len(input),4, 3, 32, 32)
        for j in range(4):
            inputs[:,j,:,:,:] = encoder(input)
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
            input, labels = data
            inputs = torch.zeros(len(input),4, 3, 32, 32)
            for j in range(4):
                inputs[:,j,:,:,:] = encoder(input)
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
print("Saving Model")
torch.save(net.state_dict(), '/home/yanggl/code/qutified_resnet18/cifar10/resnet.pth')



