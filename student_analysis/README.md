# 大学生AI使用与学习成绩关系分析

本项目用于分析大学生AI使用情况与其学习成绩之间的关系。

## 项目结构
```
student_analysis/
├── data/               # 数据文件夹
│   └── student_data.csv  # 学生数据
├── src/               # 源代码
│   └── analysis.py    # 主分析脚本
├── results/           # 分析结果
├── notebooks/         # Jupyter notebooks
└── requirements.txt   # 项目依赖
```

## 数据说明
数据文件(student_data.csv)应包含以下列：
- student_id: 学生ID
- ai_usage_frequency: AI使用频率（0-1之间的浮点数）
- linear_algebra_score: 线性代数与空间解析几何成绩
- ideology_score: 思想道德与法治成绩
- probability_score: 概率论与数理统计成绩
- overall_gpa: 整体GPA

## 安装依赖
```bash
pip install -r requirements.txt
```

## 运行分析
```bash
cd src
python analysis.py
```

## 分析内容
1. 基本统计分析
2. AI使用频率分布分析
3. AI使用频率与整体GPA的相关性分析
4. AI使用频率与各科成绩的关系分析
5. 回归分析
6. 可视化展示

## 输出结果
分析结果将保存在results文件夹中，包括：
- correlation_heatmap.png: 相关性热力图
- regression_plot.png: 回归分析图
- ai_usage_distribution.png: AI使用频率分布图
- 各科目散点图
- correlation_matrix.csv: 相关性矩阵 