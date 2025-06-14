#!/bin/bash

# LaTeX编译脚本 - 使用xelatex
echo "开始编译LaTeX文档（使用xelatex）..."

# 第一次编译
xelatex main.tex

# 编译参考文献
bibtex main

# 第二次编译（处理引用）
xelatex main.tex

# 第三次编译（确保所有引用正确）
xelatex main.tex

# 清理临时文件
rm -f *.aux *.bbl *.blg *.log *.out *.toc *.lof *.lot *.fdb_latexmk *.synctex.gz

echo "编译完成！生成的PDF文件：main.pdf" 