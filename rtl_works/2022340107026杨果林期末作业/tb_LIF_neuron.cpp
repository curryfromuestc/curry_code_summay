#include "VLIF_neuron.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    VLIF_neuron* top = new VLIF_neuron;

    // 初始化VCD波形输出
    VerilatedVcdC* tfp = new VerilatedVcdC;
    Verilated::traceEverOn(true);
    top->trace(tfp, 99);
    tfp->open("waveform.vcd");

    // 初始化信号
    top->clk = 0;
    top->reset = 1;
    top->x1 = 0;
    top->x2 = 0;
    top->s1 = 1;
    top->s2 = 1;
    top->alpha = 1;

    // 仿真时钟周期
    for (int i = 0; i < 200; i++) {
        if (i == 10) top->reset = 0;
        if (i%2 == 0) {
            top->x1 = 1;
            top->x2 = 1;
        } else {
            top->x1 = 0;
            top->x2 = 0;
        }

        // 时钟上升沿
        top->clk = 1;
        top->eval();
        tfp->dump(i * 10);

        // 时钟下降沿
        top->clk = 0;
        top->eval();
        tfp->dump(i * 10 + 5);
    }

    tfp->close();
    delete top;
    return 0;
}