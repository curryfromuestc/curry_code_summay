import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_squared_error
import os

class StudentAnalysis:
    def __init__(self, data_path):
        self.df = pd.read_csv(data_path)
        self.subjects = ['linear_algebra_score', 'ideology_score', 'probability_score']
        
    def basic_statistics(self):
        """计算基本统计量"""
        print("\n=== 基本统计描述 ===")
        print(self.df.describe())
        
        print("\n=== 各科目平均分 ===")
        print(self.df[self.subjects].mean())
        
    def correlation_analysis(self):
        """相关性分析"""
        # 计算AI使用频率与各科成绩的相关系数
        correlations = self.df[['ai_usage_frequency'] + self.subjects + ['overall_gpa']].corr()
        
        # 绘制相关性热力图
        plt.figure(figsize=(10, 8))
        sns.heatmap(correlations, annot=True, cmap='coolwarm', fmt='.2f')
        plt.title('AI使用频率与各科成绩的相关性分析')
        plt.tight_layout()
        plt.savefig('../results/correlation_heatmap.png')
        plt.close()
        
        return correlations
    
    def regression_analysis(self):
        """回归分析"""
        # AI使用频率与整体GPA的回归分析
        X = self.df[['ai_usage_frequency']]
        y = self.df['overall_gpa']
        
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        model = LinearRegression()
        model.fit(X_train, y_train)
        
        y_pred = model.predict(X_test)
        r2 = r2_score(y_test, y_pred)
        
        print(f"\n=== AI使用频率与整体GPA的回归分析 ===")
        print(f"R²分数: {r2:.4f}")
        print(f"回归系数: {model.coef_[0]:.4f}")
        
        # 绘制回归图
        plt.figure(figsize=(10, 6))
        plt.scatter(X_test, y_test, color='blue', label='实际值')
        plt.plot(X_test, y_pred, color='red', label='预测值')
        plt.xlabel('AI使用频率')
        plt.ylabel('整体GPA')
        plt.title('AI使用频率与整体GPA的关系')
        plt.legend()
        plt.savefig('../results/regression_plot.png')
        plt.close()
        
    def subject_pattern_analysis(self):
        """分析不同学科与AI使用情况的关系"""
        for subject in self.subjects:
            # 计算相关系数
            correlation = self.df['ai_usage_frequency'].corr(self.df[subject])
            print(f"\n=== {subject} 与AI使用频率的关系 ===")
            print(f"相关系数: {correlation:.4f}")
            
            # 绘制散点图
            plt.figure(figsize=(10, 6))
            sns.scatterplot(data=self.df, x='ai_usage_frequency', y=subject)
            plt.title(f'AI使用频率与{subject}的关系')
            plt.savefig(f'../results/{subject}_scatter.png')
            plt.close()
            
            # 进行t检验
            high_ai = self.df[self.df['ai_usage_frequency'] > self.df['ai_usage_frequency'].median()]
            low_ai = self.df[self.df['ai_usage_frequency'] <= self.df['ai_usage_frequency'].median()]
            
            t_stat, p_value = stats.ttest_ind(high_ai[subject], low_ai[subject])
            print(f"t检验p值: {p_value:.4f}")

def main():
    # 设置中文字体
    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False
    
    # 创建分析对象
    analyzer = StudentAnalysis('../data/student_data.csv')
    
    # 运行分析
    analyzer.basic_statistics()
    correlations = analyzer.correlation_analysis()
    analyzer.regression_analysis()
    analyzer.subject_pattern_analysis()
    
    # 保存相关性矩阵
    correlations.to_csv('../results/correlation_matrix.csv')

if __name__ == "__main__":
    main() 