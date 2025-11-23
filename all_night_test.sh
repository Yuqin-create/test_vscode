#!/bin/bash
echo "🌙 开始整晚自动化测试 - $(date)"

# 创建测试目录
mkdir -p overnight_results

# 1. 系统监控（整晚运行）
echo "启动系统监控..." > overnight_results/system.log
nohup bash -c '
while true; do
    echo "=== $(date) ===" >> overnight_results/system.log
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk "{print \$2}")% | 内存: $(free -h | grep Mem | awk "{print \$3}/\$2}")" >> overnight_results/system.log
    echo "编译进程: $(ps aux | grep -c latexmk)" >> overnight_results/system.log
    sleep 60
done' &

# 2. 深度编译测试（运行3-4小时）
echo "开始深度编译测试..." > overnight_results/compile.log
for round in {1..3}; do
    echo "=== 测试轮次 $round ===" >> overnight_results/compile.log
    
    # 测试不同引擎
    for engine in xelatex lualatex pdflatex; do
        echo "测试引擎: $engine" >> overnight_results/compile.log
        latexmk -pdf -$engine chinese_test.tex >> overnight_results/compile.log 2>&1
        if [ $? -eq 0 ]; then
            echo "✅ $engine 成功" >> overnight_results/compile.log
            cp chinese_test.pdf overnight_results/chinese_test_${engine}_round${round}.pdf
        else
            echo "❌ $engine 失败" >> overnight_results/compile.log
        fi
        latexmk -c >> overnight_results/compile.log 2>&1
        sleep 30
    done
    
    # 批量生成测试文档
    for i in {1..5}; do
        cat > overnight_results/test_doc_${round}_${i}.tex << DOCEOF
\\documentclass[UTF8]{ctexart}
\\title{自动化测试 轮次$round-文档$i}
\\begin{document}
\\maketitle
\\section{测试章节}
这是第 $round 轮测试的第 $i 个文档。
\\subsection{数学测试}
公式: \$\\\\int_0^\\\\infty e^{-x^2} dx = \\\\frac{\\\\sqrt{\\\\pi}}{2}\$
\\subsection{性能测试}
生成时间: \\\\today \\\\ \\\\currenttime
\\end{document}
DOCEOF
        latexmk -pdf -xelatex overnight_results/test_doc_${round}_${i}.tex >> overnight_results/compile.log 2>&1
        sleep 20
    done
    
    echo "轮次 $round 完成，等待1小时后继续..." >> overnight_results/compile.log
    sleep 3600  # 等待1小时
done

# 3. 最终汇总
echo "=== 最终测试报告 ===" > overnight_results/final_report.txt
echo "测试时间: $(date)" >> overnight_results/final_report.txt
echo "生成的PDF数量: $(find overnight_results -name "*.pdf" | wc -l)" >> overnight_results/final_report.txt
echo "编译成功率: $(grep -c "✅" overnight_results/compile.log)/$(grep -c "测试引擎" overnight_results/compile.log)" >> overnight_results/final_report.txt
echo "系统平均负载: $(grep "CPU" overnight_results/system.log | awk -F: "{sum+=\$2} END {print sum/NR}")%" >> overnight_results/final_report.txt

echo "🎉 所有测试完成! 查看报告: cat overnight_results/final_report.txt"
