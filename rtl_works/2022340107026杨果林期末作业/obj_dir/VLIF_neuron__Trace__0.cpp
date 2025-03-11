// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VLIF_neuron__Syms.h"


void VLIF_neuron___024root__trace_chg_sub_0(VLIF_neuron___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void VLIF_neuron___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root__trace_chg_top_0\n"); );
    // Init
    VLIF_neuron___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VLIF_neuron___024root*>(voidSelf);
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    VLIF_neuron___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void VLIF_neuron___024root__trace_chg_sub_0(VLIF_neuron___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    bufp->chgBit(oldp+0,(vlSelf->clk));
    bufp->chgBit(oldp+1,(vlSelf->reset));
    bufp->chgBit(oldp+2,(vlSelf->x1));
    bufp->chgBit(oldp+3,(vlSelf->x2));
    bufp->chgIData(oldp+4,(vlSelf->s1),32);
    bufp->chgIData(oldp+5,(vlSelf->s2),32);
    bufp->chgIData(oldp+6,(vlSelf->alpha),32);
    bufp->chgBit(oldp+7,(vlSelf->spike));
    bufp->chgIData(oldp+8,(vlSelf->LIF_neuron__DOT__membrane_potential),32);
}

void VLIF_neuron___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root__trace_cleanup\n"); );
    // Init
    VLIF_neuron___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VLIF_neuron___024root*>(voidSelf);
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        __Vm_traceActivity[__Vi0] = 0;
    }
    // Body
    vlSymsp->__Vm_activity = false;
    __Vm_traceActivity[0U] = 0U;
}
