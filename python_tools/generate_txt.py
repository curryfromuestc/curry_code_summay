#生成一列全为0和1的txt文件
import random
import os
import numpy as np

def generate_txt(file_path, row, col):
    with open(file_path, 'w') as f:
        for i in range(row):
            for j in range(col):
                f.write(str(random.randint(0, 1)))
            f.write('\n')

if __name__ == '__main__':
    file_path = 'data.txt'
    row = 112
    col = 80
    generate_txt(file_path, row, col)
    print('Generate txt file successfully')