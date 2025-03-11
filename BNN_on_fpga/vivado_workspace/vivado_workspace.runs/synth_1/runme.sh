#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
# 

echo "This script was generated under a different operating system."
echo "Please update the PATH and LD_LIBRARY_PATH variables below, before executing this script"
exit

if [ -z "$PATH" ]; then
  PATH=F:/xilinx/Vitis/2024.1/bin;F:/xilinx/Vivado/2024.1/ids_lite/ISE/bin/nt64;F:/xilinx/Vivado/2024.1/ids_lite/ISE/lib/nt64:F:/xilinx/Vivado/2024.1/bin
else
  PATH=F:/xilinx/Vitis/2024.1/bin;F:/xilinx/Vivado/2024.1/ids_lite/ISE/bin/nt64;F:/xilinx/Vivado/2024.1/ids_lite/ISE/lib/nt64:F:/xilinx/Vivado/2024.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='C:/Users/21047/code/curry_code_summay/rtl_works/BNN_on_fpga/vivado_workspace/vivado_workspace.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log CNN_top.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source CNN_top.tcl
