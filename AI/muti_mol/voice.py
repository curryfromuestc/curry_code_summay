import torch
import torch.nn as nn

#处理声音的神经网络，输入是一个wav文件，输出是一个类别，类别数目是num_classes
class Voice(nn.Module):
    def __init__(self, num_classes=5):
        super(Voice, self).__init__()
        self.conv1 = nn.Conv1d(1, 16, kernel_size=3, stride=1, padding=1, bias=False)
        self.bn1 = nn.BatchNorm1d(16)
        self.relu = nn.ReLU()
        self.pool = nn.MaxPool1d(kernel_size=2, stride=2, padding=0)
        self.fc = nn.Linear(16, num_classes)
    def forward(self, x):
        x = self.conv1(x)
        x = self.bn1(x)
        x = self.relu(x)
        x = self.pool(x)
        x = self.fc(x)
        return x