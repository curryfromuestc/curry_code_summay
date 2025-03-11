// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header,
// unless using verilator public meta comments.

#ifndef VERILATED_VLIF_NEURON__SYMS_H_
#define VERILATED_VLIF_NEURON__SYMS_H_  // guard

#include "verilated.h"

// INCLUDE MODEL CLASS

#include "VLIF_neuron.h"

// INCLUDE MODULE CLASSES
#include "VLIF_neuron___024root.h"

// SYMS CLASS (contains all model state)
class VLIF_neuron__Syms final : public VerilatedSyms {
  public:
    // INTERNAL STATE
    VLIF_neuron* const __Vm_modelp;
    bool __Vm_activity = false;  ///< Used by trace routines to determine change occurred
    uint32_t __Vm_baseCode = 0;  ///< Used by trace routines when tracing multiple models
    VlDeleter __Vm_deleter;
    bool __Vm_didInit = false;

    // MODULE INSTANCE STATE
    VLIF_neuron___024root          TOP;

    // CONSTRUCTORS
    VLIF_neuron__Syms(VerilatedContext* contextp, const char* namep, VLIF_neuron* modelp);
    ~VLIF_neuron__Syms();

    // METHODS
    const char* name() { return TOP.name(); }
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

#endif  // guard
