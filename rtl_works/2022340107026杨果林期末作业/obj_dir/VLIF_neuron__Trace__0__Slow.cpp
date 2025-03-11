// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VLIF_neuron__Syms.h"


VL_ATTR_COLD void VLIF_neuron___024root__trace_init_sub__TOP__0(VLIF_neuron___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+1,"clk", false,-1);
    tracep->declBit(c+2,"reset", false,-1);
    tracep->declBit(c+3,"x1", false,-1);
    tracep->declBit(c+4,"x2", false,-1);
    tracep->declBus(c+5,"s1", false,-1, 31,0);
    tracep->declBus(c+6,"s2", false,-1, 31,0);
    tracep->declBus(c+7,"alpha", false,-1, 31,0);
    tracep->declBit(c+8,"spike", false,-1);
    tracep->pushNamePrefix("LIF_neuron ");
    tracep->declBit(c+1,"clk", false,-1);
    tracep->declBit(c+2,"reset", false,-1);
    tracep->declBit(c+3,"x1", false,-1);
    tracep->declBit(c+4,"x2", false,-1);
    tracep->declBus(c+5,"s1", false,-1, 31,0);
    tracep->declBus(c+6,"s2", false,-1, 31,0);
    tracep->declBus(c+7,"alpha", false,-1, 31,0);
    tracep->declBit(c+8,"spike", false,-1);
    tracep->declBus(c+9,"membrane_potential", false,-1, 31,0);
    tracep->popNamePrefix(1);
}

VL_ATTR_COLD void VLIF_neuron___024root__trace_init_top(VLIF_neuron___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root__trace_init_top\n"); );
    // Body
    VLIF_neuron___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void VLIF_neuron___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void VLIF_neuron___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void VLIF_neuron___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void VLIF_neuron___024root__trace_register(VLIF_neuron___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&VLIF_neuron___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&VLIF_neuron___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&VLIF_neuron___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void VLIF_neuron___024root__trace_full_sub_0(VLIF_neuron___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void VLIF_neuron___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root__trace_full_top_0\n"); );
    // Init
    VLIF_neuron___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VLIF_neuron___024root*>(voidSelf);
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    VLIF_neuron___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void VLIF_neuron___024root__trace_full_sub_0(VLIF_neuron___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullBit(oldp+1,(vlSelf->clk));
    bufp->fullBit(oldp+2,(vlSelf->reset));
    bufp->fullBit(oldp+3,(vlSelf->x1));
    bufp->fullBit(oldp+4,(vlSelf->x2));
    bufp->fullIData(oldp+5,(vlSelf->s1),32);
    bufp->fullIData(oldp+6,(vlSelf->s2),32);
    bufp->fullIData(oldp+7,(vlSelf->alpha),32);
    bufp->fullBit(oldp+8,(vlSelf->spike));
    bufp->fullIData(oldp+9,(vlSelf->LIF_neuron__DOT__membrane_potential),32);
}
