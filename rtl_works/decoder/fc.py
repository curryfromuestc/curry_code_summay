import BNN
import torch
import torch.nn as nn

class FC(nn.Module):
    def __init__(self,in_features,out_features):
        super(FC, self).__init__()
        self.fc = BNN.BinaryLinear(in_features, out_features)
        self.relu = nn.ReLU()

    def forward(self, x):
        x = self.fc(x)
        x = self.relu(x)
        return x
    
EPOCHS = 10
BATCH_SIZE = 64
LR = 0.01
MOMENTUM = 0.9
WEIGHT_DECAY = 0.0005

data_path = 'data.txt'
label_path = 'label.txt'
model_path = 'model.pth'

data = torch.load(data_path)
label = torch.load(label_path)

model = FC(80, 1)
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.Adam(model.parameters(), lr=LR)

for epoch in range(EPOCHS):
    for i in range(0, len(data), BATCH_SIZE):
        x = data[i:i+BATCH_SIZE]
        y = label[i:i+BATCH_SIZE]
        
        optimizer.zero_grad()
        output = model(x)
        loss = criterion(output, y)
        loss.backward()
        optimizer.step()
        
        print('Epoch: %d, Loss: %.5f' % (epoch, loss.item()))
        # Save model
        torch.save(model.state_dict(), model_path)

#测试模型
model = FC(80, 1)
model.load_state_dict(torch.load(model_path))
model.eval()
output = model(data)
print(output)
