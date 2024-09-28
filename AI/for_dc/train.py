import torch
import torch.nn as nn
from model import *
import tqdm
from vedeio_loader import *

model = ResNet(block=4,layers=4)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)
criterion = nn.CrossEntropyLoss()
optmizer = torch.optim.Adam(model.parameters(), lr=0.001)
dataloader = create_dataloader("path_to_video_folder", batch_size=64)


def train(model,data_loader,optmizer,criterion,device):
    model.train()
    running_loss = 0
    for i, data in tqdm.tqdm(enumerate(data_loader), total=len(data_loader)):
        inputs, labels = data
        inputs = inputs.to(device)
        labels = labels.to(device)
        optmizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optmizer.step()
        running_loss += loss.item()
    return running_loss/len(data_loader)
for epoch in range(100):
    loss = train(model,dataloader,optmizer,criterion,device)
    print("Epoch: {} Loss: {}".format(epoch, loss))
