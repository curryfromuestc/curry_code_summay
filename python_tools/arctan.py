import numpy as np
from matplotlib.font_manager import FontProperties

font_path = '/System/Library/Fonts/STHeiti Light.ttc'  # macOS 系统自带的中文字体路径
font_prop = FontProperties(fname=font_path)
def activation(linear_x, method='sigmoid'):
    """
    激活函数， sigmoid / arctan
    """
    if method == 'sigmoid':
        out = np.zeros_like(linear_x, dtype=np.float64)
        biger_bool = np.abs(linear_x) >= 100
        out[biger_bool] = 1 / ( 1 + np.exp(-100 * np.sign(linear_x[biger_bool])) )
        out[~biger_bool] = 1 / ( 1 + np.exp(- linear_x[~biger_bool]))
        return out
    if method == 'arctan': # (arctan / np.pi * 2 + 1)/2 归一化
        return np.arctan(linear_x) / np.pi + 1/2


def activation_derivative(nd,  method='sigmoid'):
    """
    激活函数求导
    """
    if method == 'sigmoid': # sigmoid_out
        return nd - nd * nd
    if method == 'arctan': # linear_x
        return 1 / (1 + nd * nd)  / np.pi

import matplotlib.pyplot as plt
draw_x = np.linspace(-10, 10, 1000)
fig, axes = plt.subplots(1, 2, figsize=(16, 8))
axes[0].plot(draw_x, activation(draw_x, method='sigmoid'), label='sigmoid')
axes[0].plot(draw_x, activation(draw_x, method='arctan'), label='arctan')
axes[0].set_title('(a)激活函数', fontproperties=font_prop)
axes[0].legend()
axes[1].plot(draw_x, activation_derivative(activation(draw_x, method='sigmoid'), method='sigmoid'), label='sigmoid')
axes[1].plot(draw_x, activation_derivative(draw_x, method='arctan'), label='arctan')
axes[1].set_title('(b)激活函数导数', fontproperties=font_prop)
axes[1].legend()
plt.show()

