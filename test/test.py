# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)
    dut.rst_n.value = 1
    dut.ui_in.value = 1

    dut._log.info("Test project behavior")

    await ClockCycles(dut.clk, 1)
    values = [0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b, 0x7e, 0x30, 0x6d, 0x79, 0x33, 0x5b, 0x5f, 0x70, 0x7f, 0x7b]
    for value in values:
        dut._log.info('Testing %x', value)
        await ClockCycles(dut.clk, 1)
        assert dut.uo_out.value == value

    assert dut.uo_out.value != 0x7e
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 3)
    assert dut.uo_out.value == 0x7e

    dut.rst_n.value = 1
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 2)

    dut._log.info('Testing negative')
    for value in reversed(values):
        await ClockCycles(dut.clk, 1)
        dut._log.info('Testing negative %x (actual %x)', value, dut.uo_out.value)
        assert dut.uo_out.value == value

    # Wait an extra clock cycle to ensure we're not in reset value
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value != 0x7e
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 3)
    assert dut.uo_out.value == 0x7e

