// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VLIF_neuron.h for the primary calling header

#include "verilated.h"

#include "VLIF_neuron___024root.h"

VL_ATTR_COLD void VLIF_neuron___024root___eval_static(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___eval_static\n"); );
}

VL_ATTR_COLD void VLIF_neuron___024root___eval_initial(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigrprev__TOP__clk = vlSelf->clk;
    vlSelf->__Vtrigrprev__TOP__reset = vlSelf->reset;
}

VL_ATTR_COLD void VLIF_neuron___024root___eval_final(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___eval_final\n"); );
}

VL_ATTR_COLD void VLIF_neuron___024root___eval_settle(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___eval_settle\n"); );
}

#ifdef VL_DEBUG
VL_ATTR_COLD void VLIF_neuron___024root___dump_triggers__act(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VactTriggered.at(0U)) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk or posedge reset)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void VLIF_neuron___024root___dump_triggers__nba(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk or posedge reset)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void VLIF_neuron___024root___ctor_var_reset(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->reset = VL_RAND_RESET_I(1);
    vlSelf->x1 = VL_RAND_RESET_I(1);
    vlSelf->x2 = VL_RAND_RESET_I(1);
    vlSelf->s1 = VL_RAND_RESET_I(32);
    vlSelf->s2 = VL_RAND_RESET_I(32);
    vlSelf->alpha = VL_RAND_RESET_I(32);
    vlSelf->spike = VL_RAND_RESET_I(1);
    vlSelf->LIF_neuron__DOT__membrane_potential = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigrprev__TOP__clk = VL_RAND_RESET_I(1);
    vlSelf->__Vtrigrprev__TOP__reset = VL_RAND_RESET_I(1);
}
