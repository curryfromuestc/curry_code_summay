import torch
import torch.nn as nn
import os
import sys
import argparse
import yaml
from collections import OrderedDict, namedtuple

ROOT_DIR = '/home/ygl/code/SGMNet'
sys.path.insert(0, ROOT_DIR)
from sgmnet import matcher as SGMnet

sys.argv = [
    'ipykernel_launcher.py',
    '--matcher_name', 'SGM',
    '--config_path', '/home/ygl/code/SGMNet/evaluation/configs/cost/sgm_cost.yaml',
    '--num_kpt', '4000',
    '--iter_num', '100'
]

# 修改 argparse 以忽略未知参数
parser = argparse.ArgumentParser()
parser.add_argument('--matcher_name', type=str, default='SGM', help='number of processes.')
parser.add_argument('--config_path', type=str, default='/home/curry/code/SGMNet/test_tensorrt/configs/sgm_cost.yaml', help='number of processes.')
parser.add_argument('--num_kpt', type=int, default=4000, help='keypoint number, default:100')
parser.add_argument('--iter_num', type=int, default=100, help='keypoint number, default:100')

torch.backends.cudnn.benchmark=False
args = parser.parse_args()
with open(args.config_path, 'r') as f:
    model_config = yaml.load(f,Loader=yaml.FullLoader)

print(model_config)
model_config = namedtuple('model_config', model_config.keys())(*model_config.values())

if args.matcher_name=='SGM':
    model = SGMnet(model_config).cuda()  # 将模型移动到 GPU 上

# 加载权重
checkpoint = torch.load('/home/ygl/code/SGMNet/weights/sgm/root/model_best.pth',weights_only=True)
if list(checkpoint['state_dict'].items())[0][0].split('.')[0]=='module':
    new_stat_dict=OrderedDict()
    for key,value in checkpoint['state_dict'].items():
        new_stat_dict[key[7:]]=value
    checkpoint['state_dict']=new_stat_dict
model.load_state_dict(checkpoint['state_dict'])
#加载权重
#model.load_state_dict(torch.load('/home/curry/code/SGMNet/weights/sgm/root/model_best.pth'))


# 创建测试数据
test_data = {
    'x1': torch.ones(1, args.num_kpt, 2).cuda() - 0.5,
    'x2': torch.ones(1, args.num_kpt, 2).cuda() - 0.5,
    'desc1': torch.ones(1, args.num_kpt, 128).cuda(),
    'desc2': torch.ones(1, args.num_kpt, 128).cuda()
}
x1 = test_data['x1']
x2 = test_data['x2']
desc1 = test_data['desc1']
desc2 = test_data['desc2']

# 修改 forward 方法以接受字典作为输入
# class MatcherWrapper(nn.Module):
#     def __init__(self, model):
#         super(MatcherWrapper, self).__init__()
#         self.model = model

#     def forward(self, x1, x2, desc1, desc2):
#         data = {'x1': x1, 'x2': x2, 'desc1': desc1, 'desc2': desc2}
#         return self.model(data)

# 包装模型
# wrapped_model = MatcherWrapper(model).cuda()  # 将包装后的模型移动到 GPU 上
# wrapped_model.eval()

# 确保所有层都处于评估模式
# for module in wrapped_model.modules():
#     if isinstance(module, nn.InstanceNorm2d):
#         module.eval()

# import torch2trt

# model_trt = torch2trt.torch2trt(wrapped_model, [test_data['x1'], test_data['x2'], test_data['desc1'], test_data['desc2']])

# 尝试导出一个简单的模型，确保导出过程正常工
simple_model = nn.Linear(10, 5).cuda()
dummy_input = torch.randn(1, 10).cuda()
torch.onnx.export(simple_model, dummy_input, 'simple_model.onnx', verbose=True, opset_version=11)

model.eval()
res = model(test_data['x1'], test_data['x2'], test_data['desc1'], test_data['desc2'])
print(res)

# 导出复杂模型为 ONNX 格式
with torch.no_grad():
    model.eval()
    torch.onnx.export(model, (test_data['x1'], test_data['x2'], test_data['desc1'], test_data['desc2']), 'model_onnx.onnx', 
                              opset_version=20,input_names=['x1', 'x2', 'desc1', 'desc2'], verbose=False)