import torch
import torch.nn as nn

#处理脑电的神经网络，输入是一个脑电数据，格式是csv，输出是一个类别，类别数目是num_classes
class EEG(nn.Module):
    def __init__(self,num_classes=5):
        super(EEG, self).__init__()
        #使用RNN处理脑电数据
        self.rnn = nn.RNN(1, 16, 2, batch_first=True)
        self.fc = nn.Linear(16, num_classes)
    def forward(self, x):
        x, _ = self.rnn(x)
        x = self.fc(x)
        return x