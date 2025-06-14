import pandas as pd
import scipy.stats as stats
import statsmodels.api as sm
from statsmodels.formula.api import ols
from statsmodels.stats.multicomp import pairwise_tukeyhsd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np # 用于处理可能的无穷大值

# 设置中文字体，确保图表能正确显示中文
plt.rcParams['font.sans-serif'] = ['SimHei']  # Windows系统使用SimHei
plt.rcParams['axes.unicode_minus'] = False  # 解决负号'-'显示为方块的问题

# 1. 数据加载与预处理
try:
    # 尝试使用 gbk 编码，如果不行，可以尝试其他编码，如 'gb2312', 'utf-16', 'latin1'
    df = pd.read_csv('student_data.csv', encoding='gbk')
    # 如果仍然有问题，可以尝试忽略或替换错误字符，但请注意这可能会导致数据丢失
    # df = pd.read_csv('student_data.csv', encoding='gbk', errors='ignore')
    # df = pd.read_csv('student_data.csv', encoding='gbk', errors='replace')
except FileNotFoundError:
    print("错误：找不到 'student_data.csv' 文件。请确保文件路径正确。")
    exit()
except UnicodeDecodeError as e:
    print(f"UnicodeDecodeError: {e}. 请尝试其他编码方式 (如 'gb2312', 'utf-16', 'latin1')。")
    exit()

# 假设列名是 'ai_usage_frequency' 和 'overall_gpa'，请根据你的实际列名修改
# 确保这两列存在
ai_usage_col = 'ai_usage_frequency'  # 正确的AI使用频率列名
score_col = 'overall_gpa'  # 正确的成绩列名 (这里使用总体GPA，你也可以选择其他科目)

if ai_usage_col not in df.columns or score_col not in df.columns:
    print(f"错误：CSV文件中缺少 '{ai_usage_col}' 或 '{score_col}' 列。现有列: {df.columns.tolist()}")
    exit()

# 清理数据：删除这两列中任何一列有缺失值的行
df.dropna(subset=[ai_usage_col, score_col], inplace=True)

# 确保 '成绩' 列是数值类型，如果不是则尝试转换，无法转换的变成NaN再删除
df[score_col] = pd.to_numeric(df[score_col], errors='coerce')
df.dropna(subset=[score_col], inplace=True)

# 确保 'AI使用频率' 是字符串或类别类型，方便分组
df[ai_usage_col] = df[ai_usage_col].astype(str)

# 查看AI使用频率的唯一值及其数量，了解分组情况
print("AI使用频率分组情况:")
print(df[ai_usage_col].value_counts())
print("-" * 30)

if df.empty or df[ai_usage_col].nunique() < 2:
    print("数据不足或分组少于2组，无法进行比较分析。")
    exit()

# 2. 描述性统计
print("\n各组学生成绩的描述性统计:")
descriptive_stats = df.groupby(ai_usage_col)[score_col].describe()
print(descriptive_stats)
print("-" * 30)

# 3. 可视化
# 为了让箱形图和条形图的顺序更有意义，可以定义一个期望的顺序
# 请根据你数据中 'AI使用频率' 的实际类别和期望顺序修改
# 例如: frequency_order = ['从不', '很少', '有时', '经常', '每天']
# 如果不确定或类别没有自然顺序，可以按出现频率排序或默认字母顺序
try:
    # 尝试按数值转换后的均值排序（如果频率是数值型字符串）
    # 或者按特定逻辑顺序
    # 这里我们简单地按当前分组的均值排序，仅为示例
    group_means = df.groupby(ai_usage_col)[score_col].mean().sort_values()
    frequency_order = group_means.index.tolist()
except Exception:
    frequency_order = df[ai_usage_col].unique().tolist() # 默认顺序

plt.figure(figsize=(12, 6))
sns.boxplot(x=ai_usage_col, y=score_col, data=df, order=frequency_order)
plt.title('不同AI使用频率学生的成绩分布 (箱形图)')
plt.xlabel('AI使用频率')
plt.ylabel('成绩')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()

plt.figure(figsize=(12, 6))
sns.barplot(x=ai_usage_col, y=score_col, data=df, order=frequency_order, errorbar='sd') # errorbar='sd' 显示标准差
plt.title('不同AI使用频率学生的平均成绩 (条形图)')
plt.xlabel('AI使用频率')
plt.ylabel('平均成绩')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()

# 4. 统计检验
groups = [df[df[ai_usage_col] == level][score_col].dropna() for level in df[ai_usage_col].unique()]
# 过滤掉样本量过小的组，例如小于3个样本的组，这些组无法进行某些统计检验
groups_for_test = [g for g in groups if len(g) >= 3]

if len(groups_for_test) < 2:
    print("\n经过滤后，有效分组数量不足2组，无法进行统计检验。")
else:
    print("\n进行统计检验...")
    # 检查ANOVA的前提条件
    # a) 正态性检验 (Shapiro-Wilk test) - 对每个组
    print("\n正态性检验 (Shapiro-Wilk):")
    normality_passed_all = True
    for i, group_data in enumerate(groups_for_test):
        group_name = df[ai_usage_col].unique()[i] # 注意：这里获取组名的方式可能需要更稳健
                                                # 如果groups_for_test的顺序与df['AI使用频率'].unique()不一致
                                                # 最好是从创建groups_for_test时就保存组名
        if len(group_data) >= 3: # Shapiro-Wilk test needs at least 3 samples
            stat, p_shapiro = stats.shapiro(group_data)
            print(f"组 '{group_name}': W={stat:.3f}, p-value={p_shapiro:.3f}")
            if p_shapiro < 0.05:
                normality_passed_all = False
        else:
            print(f"组 '{group_name}': 样本量过小 (<3)，跳过正态性检验。")
            normality_passed_all = False # 保守起见

    # b) 方差齐性检验 (Levene's test)
    # Levene's test对非正态数据也比较稳健
    # 确保所有用于检验的组都有数据，并且替换无穷大值
    valid_groups_for_levene = []
    for g in groups_for_test:
        g_finite = g[np.isfinite(g)] # 只取有限值
        if len(g_finite) > 0:
            valid_groups_for_levene.append(g_finite)
    
    if len(valid_groups_for_levene) >= 2:
        # 再次过滤，Levene检验至少需要两个样本
        valid_groups_for_levene = [g for g in valid_groups_for_levene if len(g) >=2]
        if len(valid_groups_for_levene) >= 2:
            stat_levene, p_levene = stats.levene(*valid_groups_for_levene)
            print(f"\n方差齐性检验 (Levene's Test): F={stat_levene:.3f}, p-value={p_levene:.3f}")
            homogeneity_passed = p_levene > 0.05
        else:
            print("\n进行方差齐性检验的有效组别不足 (<2)。")
            homogeneity_passed = False # 保守起见
    else:
        print("\n数据不足以进行方差齐性检验。")
        homogeneity_passed = False # 保守起见


    if normality_passed_all and homogeneity_passed:
        print("\n数据近似满足正态分布且方差齐性，执行ANOVA检验。")
        f_statistic, p_value_anova = stats.f_oneway(*groups_for_test)
        print(f"ANOVA检验结果: F-statistic = {f_statistic:.3f}, p-value = {p_value_anova:.3f}")

        if p_value_anova < 0.05:
            print("ANOVA结果显著 (p < 0.05)，说明不同AI使用频率组的平均成绩存在显著差异。")
            print("进行Tukey's HSD事后检验以确定哪些组之间存在差异:")
            # Tukey's HSD 需要原始数据框和分组列
            # 确保df只包含用于检验的组
            valid_freq_levels = [level for level, group_data in zip(df[ai_usage_col].unique(), groups) if len(group_data) >= 3]
            df_for_tukey = df[df[ai_usage_col].isin(valid_freq_levels)]

            if len(df_for_tukey[ai_usage_col].unique()) >= 2 and len(df_for_tukey) > 0:
                 tukey_results = pairwise_tukeyhsd(df_for_tukey[score_col], df_for_tukey[ai_usage_col], alpha=0.05)
                 print(tukey_results)
            else:
                print("数据不足以进行Tukey's HSD检验。")
        else:
            print("ANOVA结果不显著 (p >= 0.05)，说明不同AI使用频率组的平均成绩没有统计学上的显著差异。")
    else:
        print("\n数据不满足ANOVA的前提条件 (非正态或方差不齐)，执行Kruskal-Wallis H检验。")
        if len(groups_for_test) >= 2 and all(len(g) > 0 for g in groups_for_test):
            h_statistic, p_value_kruskal = stats.kruskal(*groups_for_test)
            print(f"Kruskal-Wallis H检验结果: H-statistic = {h_statistic:.3f}, p-value = {p_value_kruskal:.3f}")

            if p_value_kruskal < 0.05:
                print("Kruskal-Wallis结果显著 (p < 0.05)，说明不同AI使用频率组的成绩分布存在显著差异。")
                print("可以考虑进行Dunn's test等事后检验 (需安装scikit-posthocs库: pip install scikit-posthocs)。")
                # 示例Dunn's test (如果安装了scikit-posthocs)
                try:
                    import scikit_posthocs as sp
                    # 确保df只包含用于检验的组
                    valid_freq_levels = [level for level, group_data in zip(df[ai_usage_col].unique(), groups) if len(group_data) >= 3]
                    df_for_dunn = df[df[ai_usage_col].isin(valid_freq_levels)]

                    if len(df_for_dunn[ai_usage_col].unique()) >= 2 and len(df_for_dunn) > 0:
                        dunn_results = sp.posthoc_dunn(df_for_dunn, val_col=score_col, group_col=ai_usage_col, p_adjust='bonferroni')
                        print("\nDunn's Test (Bonferroni corrected):")
                        print(dunn_results)
                    else:
                        print("数据不足以进行Dunn's test。")

                except ImportError:
                    print("提示: 如需进行 Dunn's test，请先安装 scikit-posthocs 库 (pip install scikit-posthocs)。")
                except Exception as e:
                    print(f"执行Dunn's test时出错: {e}")
            else:
                print("Kruskal-Wallis结果不显著 (p >= 0.05)，说明不同AI使用频率组的成绩分布没有统计学上的显著差异。")
        else:
            print("有效分组数据不足，无法执行Kruskal-Wallis检验。")

print("-" * 30)
print("\n分析完成。请根据上述统计结果和图表进行解读。")