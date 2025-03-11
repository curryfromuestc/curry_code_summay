transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+ROM_conv2  -L xpm -L blk_mem_gen_v8_4_8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.ROM_conv2 xil_defaultlib.glbl

do {ROM_conv2.udo}

run 1000ns

endsim

quit -force
