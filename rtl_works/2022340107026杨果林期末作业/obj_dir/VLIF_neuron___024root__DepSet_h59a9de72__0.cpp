// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See VLIF_neuron.h for the primary calling header

#include "verilated.h"

#include "VLIF_neuron___024root.h"

void VLIF_neuron___024root___eval_act(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___eval_act\n"); );
}

VL_INLINE_OPT void VLIF_neuron___024root___nba_sequent__TOP__0(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___nba_sequent__TOP__0\n"); );
    // Init
    IData/*31:0*/ __Vdly__LIF_neuron__DOT__membrane_potential;
    __Vdly__LIF_neuron__DOT__membrane_potential = 0;
    // Body
    __Vdly__LIF_neuron__DOT__membrane_potential = vlSelf->LIF_neuron__DOT__membrane_potential;
    if (vlSelf->reset) {
        __Vdly__LIF_neuron__DOT__membrane_potential = 0U;
        vlSelf->spike = 0U;
    } else {
        __Vdly__LIF_neuron__DOT__membrane_potential 
            = (((vlSelf->LIF_neuron__DOT__membrane_potential 
                 + ((IData)(vlSelf->x1) ? vlSelf->s1
                     : 0U)) + ((IData)(vlSelf->x2) ? vlSelf->s2
                                : 0U)) - vlSelf->alpha);
        if (VL_LTES_III(32, 1U, vlSelf->LIF_neuron__DOT__membrane_potential)) {
            vlSelf->spike = 1U;
            __Vdly__LIF_neuron__DOT__membrane_potential = 0U;
        } else {
            vlSelf->spike = 0U;
        }
    }
    vlSelf->LIF_neuron__DOT__membrane_potential = __Vdly__LIF_neuron__DOT__membrane_potential;
}

void VLIF_neuron___024root___eval_nba(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___eval_nba\n"); );
    // Body
    if (vlSelf->__VnbaTriggered.at(0U)) {
        VLIF_neuron___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void VLIF_neuron___024root___eval_triggers__act(VLIF_neuron___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void VLIF_neuron___024root___dump_triggers__act(VLIF_neuron___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void VLIF_neuron___024root___dump_triggers__nba(VLIF_neuron___024root* vlSelf);
#endif  // VL_DEBUG

void VLIF_neuron___024root___eval(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___eval\n"); );
    // Init
    VlTriggerVec<1> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            VLIF_neuron___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    VLIF_neuron___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("LIF_neuron.v", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.set(vlSelf->__VactTriggered);
                VLIF_neuron___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                VLIF_neuron___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("LIF_neuron.v", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            VLIF_neuron___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void VLIF_neuron___024root___eval_debug_assertions(VLIF_neuron___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    VLIF_neuron___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->reset & 0xfeU))) {
        Verilated::overWidthError("reset");}
    if (VL_UNLIKELY((vlSelf->x1 & 0xfeU))) {
        Verilated::overWidthError("x1");}
    if (VL_UNLIKELY((vlSelf->x2 & 0xfeU))) {
        Verilated::overWidthError("x2");}
}
#endif  // VL_DEBUG
