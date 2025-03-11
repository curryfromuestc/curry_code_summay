// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See VLIF_neuron.h for the primary calling header

#ifndef VERILATED_VLIF_NEURON___024ROOT_H_
#define VERILATED_VLIF_NEURON___024ROOT_H_  // guard

#include "verilated.h"

class VLIF_neuron__Syms;

class VLIF_neuron___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(reset,0,0);
    VL_IN8(x1,0,0);
    VL_IN8(x2,0,0);
    VL_OUT8(spike,0,0);
    CData/*0:0*/ __Vtrigrprev__TOP__clk;
    CData/*0:0*/ __Vtrigrprev__TOP__reset;
    CData/*0:0*/ __VactContinue;
    VL_IN(s1,31,0);
    VL_IN(s2,31,0);
    VL_IN(alpha,31,0);
    IData/*31:0*/ LIF_neuron__DOT__membrane_potential;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    VLIF_neuron__Syms* const vlSymsp;

    // CONSTRUCTORS
    VLIF_neuron___024root(VLIF_neuron__Syms* symsp, const char* v__name);
    ~VLIF_neuron___024root();
    VL_UNCOPYABLE(VLIF_neuron___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);


#endif  // guard
