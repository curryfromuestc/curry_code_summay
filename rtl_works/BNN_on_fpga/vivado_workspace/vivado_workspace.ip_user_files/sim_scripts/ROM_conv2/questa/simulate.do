onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib ROM_conv2_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {ROM_conv2.udo}

run 1000ns

quit -force
