import torch
import torch.nn as nn
#导入四个模态的神经网络
import voice, image_conv3d, eeg_net, dvs_gesture

class muti_mol(nn.Module):
    def __init__(self,num_classes=5):
        super(muti_mol, self).__init__()
        self.voice = voice.Voice(num_classes)
        self.image = image_conv3d.Image(num_classes)
        self.eeg = eeg_net.EEG(num_classes)
        self.dvs = dvs_gesture.DVS_gesture(2, 16, num_classes)
        self.dvs.step_mode = 'm'
        self.fc_weights = nn.Linear(4, num_classes)
        self.softmax = nn.Softmax(dim=1)
    def forward(self, voice_data, image_data, eeg_data, dvs_data):
        voice_out = self.voice(voice_data)
        image_out = self.image(image_data)
        eeg_out = self.eeg(eeg_data)
        dvs_out = self.dvs(dvs_data)
        out = torch.cat((voice_out, image_out, eeg_out, dvs_out), dim=1)
        out = self.fc_weights(out)
        out = self.softmax(out)
        return out