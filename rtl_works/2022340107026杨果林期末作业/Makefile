# Makefile for LIF neuron simulation using Verilator

# Verilog源文件
VERILOG_SRC = LIF_neuron.v

# C++测试平台文件
TB_CPP = tb_LIF_neuron.cpp

# 顶层模块名称（与Verilog模块名称一致）
TOP_MODULE = LIF_neuron

# 生成的对象目录
OBJ_DIR = obj_dir

# 波形文件名
WAVEFORM = waveform.vcd

# 目标：编译和运行仿真
.PHONY: all run clean view

# 默认目标：编译生成可执行文件
all: $(OBJ_DIR)/V$(TOP_MODULE)

# 使用Verilator生成仿真模型并编译
$(OBJ_DIR)/V$(TOP_MODULE): $(VERILOG_SRC) $(TB_CPP)
	verilator --cc --trace $(VERILOG_SRC) --exe $(TB_CPP)
	make -j -C $(OBJ_DIR)/ -f V$(TOP_MODULE).mk V$(TOP_MODULE)

# 运行仿真
run: all
	$(OBJ_DIR)/V$(TOP_MODULE)

# 清理生成的文件
clean:
	rm -rf $(OBJ_DIR) $(WAVEFORM)

# 查看生成的波形
view:
	gtkwave $(WAVEFORM)