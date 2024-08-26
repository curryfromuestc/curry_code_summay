import torch
import torch.nn as nn
import muti_mol

#定义一个模型
model = muti_mol.muti_mol(5)
#预处理数据集，这个需要你们自己改
voice_data = torch.randn(1, 1, 16000)
image_data = torch.randn(1, 3, 16, 112, 112)
eeg_data = torch.randn(1, 10, 1)
dvs_data = torch.randn(1, 2, 128, 128)

#训练参数
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(), lr=0.001, momentum=0.9)
EPOCH = 100

#训练
for epoch in range(EPOCH):
    optimizer.zero_grad()
    out = model(voice_data, image_data, eeg_data, dvs_data)
    loss = criterion(out, torch.tensor([1]))
    loss.backward()
    optimizer.step()
    print('epoch:', epoch, 'loss:', loss.item())
    #测试
    if epoch % 10 == 0:
        model.eval()
        out = model(voice_data, image_data, eeg_data, dvs_data)
        print('out:', out)
        model.train()