import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import r2_score, mean_squared_error
import os
import matplotlib as mpl

class StudentAnalysis:
    def __init__(self, data_path):
        self.df = pd.read_csv(data_path, encoding='gbk')
        self.subjects = [
            'linear_algebra_score',
            'ideology_score',
            'probability_score',
            'Microelectronic_devices_score',
            'signal_and_system_score',
            'modern_history_score'
        ]
        
        # 设置中文显示
        plt.rcParams['font.sans-serif'] = ['DejaVu Sans', 'Arial Unicode MS', 'SimHei']  # 首选 DejaVu Sans
        plt.rcParams['axes.unicode_minus'] = False
        plt.rcParams['font.family'] = 'sans-serif'
        
    def analyze_ai_correlations(self):
        """Analyze correlations between AI usage and academic performance"""
        # Calculate correlations
        all_metrics = self.subjects + ['overall_gpa']
        for metric in all_metrics:
            correlation = self.df['ai_usage_frequency'].corr(self.df[metric])
            print(f"Correlation between AI usage and {metric}: {correlation:.4f}")
            
            # Create scatter plot
            plt.figure(figsize=(10, 6))
            sns.scatterplot(data=self.df, x='ai_usage_frequency', y=metric)
            plt.title(f'AI Usage vs {metric}')
            plt.xlabel('AI Usage Frequency')
            plt.ylabel('Score')
            plt.savefig(f'../results/{metric}_ai_correlation.png')
            plt.close()

def main():
    # 创建分析对象
    analyzer = StudentAnalysis('../data/student_data.csv')
    
    # 运行分析
    analyzer.analyze_ai_correlations()

if __name__ == "__main__":
    main() 