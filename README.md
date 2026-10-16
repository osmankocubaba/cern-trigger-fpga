# CERN Particle Detector Trigger Unit (FPGA Simulation)

A Verilog-based event trigger logic design and verification environment modeling real-time data acquisition (DAQ) in high-energy physics experiments. 

The pipeline simulates incoming high-speed ADC streams from calorimeter sensors, compares energy levels against a programmable threshold, and asserts an event trigger flag with zero-latency response.

# Architecture and Workflow

1. **Synthetic Data Generator (`generate_data.py`)**: 
   - Generates simulated baseline detector noise and injects high-energy particle collision hits using NumPy.
   - Formats and exports the sample sequence to `detector_stream.txt`.

2. **RTL Trigger Unit (`trigger_unit.v`)**:
   - Synthesizable synchronous hardware block.
   - Continuously evaluates incoming 16-bit ADC samples (`adc_data`) against `threshold` (default: 2000 / `0x07D0`).
   - Asserts single-cycle `trigger_out` pulses and increments a 32-bit hardware `event_counter`.

3. **Behavioral Testbench (`tb_trigger_unit.v`)**:
   - Emulates a 100 MHz master clock and system active-low reset.
   - Ingests `detector_stream.txt` via `$fopen` / `$fscanf` to stimulate the RTL design cycle-by-cycle.

# Tools and Specifications
- **HDL:** Verilog-2001
- **EDA Tool:** AMD Vivado 2026.1
- **Simulator:** XSim (Behavioral Simulation)
- **Target Architecture:** AMD/Xilinx Artix-7 (`xc7a35tcpg236-1`)
