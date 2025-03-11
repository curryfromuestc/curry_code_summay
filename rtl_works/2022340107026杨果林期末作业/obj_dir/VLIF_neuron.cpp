// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "VLIF_neuron.h"
#include "VLIF_neuron__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

VLIF_neuron::VLIF_neuron(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new VLIF_neuron__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , reset{vlSymsp->TOP.reset}
    , x1{vlSymsp->TOP.x1}
    , x2{vlSymsp->TOP.x2}
    , spike{vlSymsp->TOP.spike}
    , s1{vlSymsp->TOP.s1}
    , s2{vlSymsp->TOP.s2}
    , alpha{vlSymsp->TOP.alpha}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

VLIF_neuron::VLIF_neuron(const char* _vcname__)
    : VLIF_neuron(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

VLIF_neuron::~VLIF_neuron() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void VLIF_neuron___024root___eval_debug_assertions(VLIF_neuron___024root* vlSelf);
#endif  // VL_DEBUG
void VLIF_neuron___024root___eval_static(VLIF_neuron___024root* vlSelf);
void VLIF_neuron___024root___eval_initial(VLIF_neuron___024root* vlSelf);
void VLIF_neuron___024root___eval_settle(VLIF_neuron___024root* vlSelf);
void VLIF_neuron___024root___eval(VLIF_neuron___024root* vlSelf);

void VLIF_neuron::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate VLIF_neuron::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    VLIF_neuron___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        VLIF_neuron___024root___eval_static(&(vlSymsp->TOP));
        VLIF_neuron___024root___eval_initial(&(vlSymsp->TOP));
        VLIF_neuron___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    VLIF_neuron___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool VLIF_neuron::eventsPending() { return false; }

uint64_t VLIF_neuron::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* VLIF_neuron::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void VLIF_neuron___024root___eval_final(VLIF_neuron___024root* vlSelf);

VL_ATTR_COLD void VLIF_neuron::final() {
    VLIF_neuron___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* VLIF_neuron::hierName() const { return vlSymsp->name(); }
const char* VLIF_neuron::modelName() const { return "VLIF_neuron"; }
unsigned VLIF_neuron::threads() const { return 1; }
std::unique_ptr<VerilatedTraceConfig> VLIF_neuron::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void VLIF_neuron___024root__trace_init_top(VLIF_neuron___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    VLIF_neuron___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<VLIF_neuron___024root*>(voidSelf);
    VLIF_neuron__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    VLIF_neuron___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void VLIF_neuron___024root__trace_register(VLIF_neuron___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void VLIF_neuron::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'VLIF_neuron::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    VLIF_neuron___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
