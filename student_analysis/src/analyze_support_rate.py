import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import os

def analyze_support_rates():
    """
    Load, analyze, and visualize the support rates for AI from teachers and students.
    """
    # --- 1. Setup paths and load data ---
    data_dir = '../data/'
    results_dir = '../results/'
    teacher_file = os.path.join(data_dir, 'Teacher.csv')
    student_file = os.path.join(data_dir, 'student.csv')

    # Ensure the results directory exists
    os.makedirs(results_dir, exist_ok=True)

    try:
        # Files have no header, so specify header=None and name the column
        teachers_df = pd.read_csv(teacher_file, header=None, names=['support_rate'])
        students_df = pd.read_csv(student_file, header=None, names=['support_rate'])
    except FileNotFoundError as e:
        print(f"File not found error: {e}")
        print(f"Please ensure '{os.path.basename(teacher_file)}' and '{os.path.basename(student_file)}' are in the '{data_dir}' directory.")
        return

    # --- 2. Descriptive Statistics ---
    print("--- Teacher Support Rate Descriptive Statistics ---")
    print(teachers_df['support_rate'].describe())
    print("\n" + "="*40 + "\n")
    
    print("--- Student Support Rate Descriptive Statistics ---")
    print(students_df['support_rate'].describe())
    print("\n" + "="*40 + "\n")

    # --- 3. Statistical Test (Independent Samples t-test) ---
    # Using Welch's t-test as it does not assume equal variances
    t_stat, p_value = stats.ttest_ind(
        teachers_df['support_rate'].dropna(), 
        students_df['support_rate'].dropna(), 
        equal_var=False
    )

    print("--- Statistical Analysis (Independent Samples t-test) ---")
    print(f"T-statistic: {t_stat:.4f}")
    print(f"P-value: {p_value:.4f}")

    if p_value < 0.05:
        print("\nConclusion: The p-value is less than 0.05, indicating a statistically significant difference between teacher and student support rates.")
    else:
        print("\nConclusion: The p-value is not less than 0.05, indicating no statistically significant difference between teacher and student support rates.")
    print("\n" + "="*40 + "\n")

    # --- 4. Visualization ---
    # Prepare data for plotting
    teachers_df['group'] = 'Teachers'
    students_df['group'] = 'Students'
    combined_df = pd.concat([teachers_df, students_df])

    plt.style.use('seaborn-v0_8-whitegrid')
    fig, axes = plt.subplots(1, 2, figsize=(16, 7))
    fig.suptitle('Comparison of Support Rates for AI in the Classroom: Teachers vs. Students', fontsize=16)

    # Plot 1: Box Plot
    sns.boxplot(x='group', y='support_rate', data=combined_df, ax=axes[0], palette="pastel")
    axes[0].set_title('Box Plot of Support Rate Distribution', fontsize=14)
    axes[0].set_xlabel('Group', fontsize=12)
    axes[0].set_ylabel('Support Rate', fontsize=12)

    # Plot 2: Density Plot
    sns.kdeplot(data=combined_df, x='support_rate', hue='group', fill=True, ax=axes[1], palette="pastel", common_norm=False)
    axes[1].set_title('Density Plot of Support Rate Distribution', fontsize=14)
    axes[1].set_xlabel('Support Rate', fontsize=12)
    axes[1].set_ylabel('Density', fontsize=12)
    
    plt.tight_layout(rect=[0, 0, 1, 0.96])
    
    # Save the figure
    output_path = os.path.join(results_dir, 'support_rate_comparison.png')
    plt.savefig(output_path, dpi=300)

    print(f"Analysis complete. Visualization saved to: '{output_path}'")

if __name__ == '__main__':
    analyze_support_rates() 