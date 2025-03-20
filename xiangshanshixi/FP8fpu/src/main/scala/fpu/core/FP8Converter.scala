package fpu.core

import chisel3._
import chisel3.util._
import fpu.Parameters._
import fpu._

class FP8Converter extends Module {
    val io = IO(new Bundle {
        val in = Input(UInt(Parameters.FP8_LENGTH.W))
        val inType = Input(UInt(1.W)) // 0: E5M2, 1: E4M3
        val out = Output(UInt(IntermediateFormat.LENGTH.W))
    })

    val adjustedExpE5M2 = io.in(6,2)
    val adjustedExpE4M3 = Cat(0.U(1.W), io.in(6,3)) + 8.U
    val adjustedSigE5M2 = Cat(io.in(1,0), 0.U(1.W))
    val adjustedSigE4M3 = io.in(2,0)

    io.out := Mux(io.inType === 0.U, Cat(io.in(7), adjustedExpE5M2, adjustedSigE5M2), Cat(io.in(7), adjustedExpE4M3, adjustedSigE4M3))
}