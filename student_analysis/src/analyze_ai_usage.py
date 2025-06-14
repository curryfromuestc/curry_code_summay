import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# 设置中文字体
plt.rcParams['font.sans-serif'] = ['SimHei']  # 用来正常显示中文标签
plt.rcParams['axes.unicode_minus'] = False  # 用来正常显示负号

# 读取数据（添加编码参数）
df = pd.read_csv('student_data.csv', encoding='gbk')  # 使用GBK编码

# 创建AI使用频率的区间
bins = np.linspace(0, 1, 11)  # 创建10个等宽区间
labels = [f'{bins[i]:.1f}-{bins[i+1]:.1f}' for i in range(len(bins)-1)]

# 计算每个区间的学生数量和百分比
df['ai_usage_group'] = pd.cut(df['ai_usage_frequency'], bins=bins, labels=labels, include_lowest=True)
usage_stats = df['ai_usage_group'].value_counts().sort_index()
usage_percentages = (usage_stats / len(df) * 100).round(2)

# 创建图形
plt.figure(figsize=(12, 6))

# 绘制直方图
plt.bar(range(len(usage_percentages)), usage_percentages, alpha=0.8)
plt.xticks(range(len(usage_percentages)), labels, rotation=45)

# 在每个柱子上添加百分比标签
for i, v in enumerate(usage_percentages):
    plt.text(i, v + 0.5, f'{v:.1f}%', ha='center')

# 设置标题和标签
plt.title('AI usage frequency distribution', fontsize=14)
plt.xlabel('AI usage frequency interval', fontsize=12)
plt.ylabel('Student percentage (%)', fontsize=12)

# 添加网格线
plt.grid(axis='y', linestyle='--', alpha=0.7)

# 调整布局
plt.tight_layout()

# 保存图片
plt.savefig('../results/ai_usage_distribution.png', dpi=300, bbox_inches='tight')

# 打印统计信息
print("\nAI使用频率统计信息：")
print("\n区间分布：")
for interval, percentage in usage_percentages.items():
    count = usage_stats[interval]
    print(f"区间 {interval}: {count}人 ({percentage:.1f}%)")

print("\n基本统计量：")
print(f"平均值：{df['ai_usage_frequency'].mean():.3f}")
print(f"中位数：{df['ai_usage_frequency'].median():.3f}")
print(f"标准差：{df['ai_usage_frequency'].std():.3f}")
print(f"最小值：{df['ai_usage_frequency'].min():.3f}")
print(f"最大值：{df['ai_usage_frequency'].max():.3f}") 