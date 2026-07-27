# async-sync-fifo-verilog

This project contains two parameterized FIFO implementations in Verilog HDL for studying reliable data transfer across clock domains: an asynchronous FIFO that uses Gray-coded pointers and 2-flop synchronizers for robust CDC behavior, and a synchronous FIFO that includes an internal divide-by-6 clock path to model fast-to-slow interface timing.

## CDC Background (Why Gray Code)

In clock-domain crossing (CDC), multi-bit binary counters can toggle several bits at once, so sampling during transitions can produce incoherent pointer values and incorrect full/empty decisions. Gray-coded pointers change only one bit per increment, which reduces transition ambiguity at the receiving domain boundary. Combined with 2-flop synchronizers, this improves metastability containment and makes cross-domain pointer comparison safer and more deterministic.

## Asynchronous FIFO Architecture

The asynchronous FIFO is organized into separate write-clock and read-clock pointer pipelines, dual-port memory, binary-to-Gray conversion, and cross-domain synchronization for pointer status checks (full/empty generation).

![Sunburst FIFO Architecture](./sunburst_architecture.png)

Key architectural elements:
- Parameterized data/address sizing
- Independent read and write clock domains
- Gray-pointer exchange through 2-flop synchronizers
- Full/empty flag logic based on synchronized pointers

## Synchronous FIFO with Internal Clock Division

The synchronous FIFO targets single-domain control while modeling a fast-to-slow timing relationship internally. A built-in divide-by-6 clock divider creates a slower internal clock phase used to emulate reduced-rate operations in the same top-level design. This provides a compact way to evaluate buffering behavior when producer/consumer activity effectively occurs at different rates.

## Testbench Strategy

Verification is split per FIFO type:
- Asynchronous FIFO testbench drives independent read/write clocks, applies concurrent push/pop traffic, and checks full/empty behavior under CDC-like timing skew.
- Synchronous FIFO testbench exercises write/read bursts against the divider-driven slow path and validates ordering, occupancy transitions, and boundary conditions.

## Parameters

| Parameter | Module Context | Purpose |
|---|---|---|
| `DSIZE` | Async FIFO | Data bus width |
| `ASIZE` | Async FIFO | Address width; determines FIFO depth as `2^ASIZE` |
| `DATA_WIDTH` | Sync FIFO | Data bus width for synchronous path |
| `DEPTH` | Sync FIFO | Storage depth in entries |
| `DIV_FACTOR` | `clk_divider_6` | Clock division ratio (set to 6) |

## File Structure

async-sync-fifo-verilog/  
├── async/  
│   ├── ASYNC_FIFO.v  
│   ├── asyc_fifo_mem.v  
│   ├── async_fifo_write_pointer.v  
│   ├── async_fifo_read_pointer.v  
│   ├── b2g.v  
│   ├── synchronizer_2ff.v  
│   └── ASYNC_FIFO_tb.v  
├── sync/  
│   ├── FIFO_SYNC.v  
│   ├── clk_divider_6.v  
│   ├── FIFO_SYNC_tb.v  
│   └── rtl_async_reg_test.v  
└── README.md
