// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VLIF_neuron.h for the primary calling header

#include "verilated.h"

#include "VLIF_neuron__Syms.h"
#include "VLIF_neuron___024root.h"

void VLIF_neuron___024root___ctor_var_reset(VLIF_neuron___024root* vlSelf);

VLIF_neuron___024root::VLIF_neuron___024root(VLIF_neuron__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    VLIF_neuron___024root___ctor_var_reset(this);
}

void VLIF_neuron___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

VLIF_neuron___024root::~VLIF_neuron___024root() {
}
