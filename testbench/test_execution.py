# testbench/test_matadd_simple.py

import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

@cocotb.test()
async def test_matadd_simple(dut):
    """
    Simplified Testbench for Matrix Addition on GPU Simulation using Cocotb.
    """

    # 1. Create a 10 ns period clock on port clk
    clock = Clock(dut.clk, 10, units="ns")  # 10 ns period
    cocotb.start_soon(clock.start())
    dut.reset.value = 1
    cocotb.log.info("Clock started with 10 ns period. Asserting reset.")

    # 2. Initialize reset
    await RisingEdge(dut.clk)
    dut.reset.value = 0
    cocotb.log.info("Deasserting reset.")
    await RisingEdge(dut.clk)

    # 3. Wait for 'halt' signal or timeout after max_cycles
    cocotb.log.info("Waiting for 'halt' signal.")
    max_cycles = 1000            # Maximum number of clock cycles to wait
    cycle = 0

    while dut.halt.value != 1 and cycle < max_cycles:
        await RisingEdge(dut.clk)
        cycle += 1
        if cycle % 100 == 0:
            cocotb.log.info(f"Cycle {cycle}: 'halt' not yet asserted.")

    # 4. Check if 'halt' was asserted
    if dut.halt.value != 1:
        cocotb.log.error(f"Test FAILED: 'halt' signal not asserted after {max_cycles} cycles.")
        assert False, f"'halt' not asserted after {max_cycles} cycles."
    else:
        cocotb.log.info(f"Test PASSED: 'halt' signal asserted after {cycle} cycles.")
        assert True
