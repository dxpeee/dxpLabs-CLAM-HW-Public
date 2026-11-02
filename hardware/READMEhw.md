# Hardware

This folder contains all of the source code for the CLAM project. Each section in this README talks about the top-level folders/applications in this section of the repository.


## Table of Contents
- [Makefile](#makefile)
- [program_fpga.sh](#programming-the-fpga)
- [top/ (Project Variations)](#project-variations)
- [src/ (Project Source Code)](#project-source-code)
    - [cache_l1/](#cache_l1)
    - [cache_l2/](#cache_l2)
    - [cont_l1/](#cont_l1)
    - [cont_l2/](#cont_l2)
    - [core/](#core)
    - [cpc/](#cpc)
    - [ddr3_memory/](#ddr3_memory)
    - [dlease/](#dlease)
    - [etc/](#etc)
    - [internal/](#internal)
    - [issp/](#issp)
    - [mci/](#mci)
    - [misc/](#misc)
    - [opt_evict/](#opt_evict)
    - [peripheral/](#peripheral)
    - [pll/](#pll)
    - [policy_dlease/](#policy_dlease)
    - [policy_dlease_opt/](#policy_dlease_opt)
    - [policy_fifo/](#policy_fifo)
    - [policy_lru/](#policy_lru)
    - [policy_mru/](#policy_mru)
    - [policy_plru/](#policy_plru)
    - [policy_random/](#policy_random)
    - [policy_slider/](#policy_slider)
    - [policy_slider_opt/](#policy_slider_opt)
    - [policy_srrip/](#policy_srrip)
    - [sampler/](#sampler)
    - [sdc/](#sdc)
    - [slider/](#slider)
    - [tracer/](#tracer)
    - [tracker/](#tracker)
- [include/ (Project Macros)](#project-macros)
- [test/ (Unit Tests)](#unit-tests)
- [vivado/](#vivado)

## Makefile
The Makefile can be used to generate different variations of the project


`make all` will generate all the variations across all the projects. You can make individual projects, but the syntax is kinda silly where it is `<project_name>__<METRIC>__<OPTIMIZATIONS>__<CACHESIZE>`. This allows for choosing to conditionally compile the project in whatever configuration you want. This should also be changed to be better in the future with less weirdness!

## Programming the FPGA
program_fpga.sh looks through all projects, highlighting the possible SRAM object (sof) files that can be used to program the FPGA. This makes it easy to quickly switch between system configurations when running benchmarks.

## Project Variations

The top/ file tree contains the quartus projects used to synthesize variations of the lease cache system. Out of the box, this project hierarchy supports:

1. A single-level single-core PLRU system
2. A single-level single-core dynamic lease system
3. A single-level single-core slider system
4. A two-level single-core PLRU system
5. A two-level single-core dynamic lease system
6. A two-level multicore PLRU system
7. A two-level multicore dynamic lease system

There are a few additional variations that exist across these project that can be optionally compiled, such as the degree of metric collection, sampler hardware, tracker hardware, tracer hardware, and hardware for forced eviction optimizations. Specifics about the sies of certain system elements, such as cache size and cache way, can also be conditionally controllerd. To enable or disable certain configurations, one can modify the 'top.vh' file that corresponds to each project. One can also just do a full run of the Makefile to compile all varients.

All projects have a distinct copy of 'top.v' that is used to stitch the top-level of the lease cache system together.

## Project Source Code
The src/ folder encapsulates the design files used in all variations of the lease cache project. Each sub-folder is briefly mentioned below:

### cache_l1
Holds design files used in all L1 caches across all files (tag memories, etc.).

### cache_l2
Holds design files used in all L2 caches across all files (tag memories, etc.).

### cont_l1
Holds cache controllers used in an L1 cache.

### cont_l2
Holds cache controllers used in an L1 cache.

### core
Holds all design files used in the RISC-V compliant core.

### cpc
Holds top-level cache performance controllers used to obtain performance results in hardware.

### ddr3_memory
Holds all generated IP for the Hard Memory Controller (HMC) used to interface with DDR3 memory on the FPGA. This is board specific.

### dlease
Holds all design files for faciliting the dynamic lease eviction policy.

### etc
Holds the code for the Emulation and Test Controller System. This is used hand-in-hand with the Proxy in order to perform commands and read and write to the FPGA. Also contains the UART-JTAG IP that allows us to read and write to the device from the proxy using a UART-JTAG connection

NOTE: in the future this should ideally all be removed. The ideal situation for this project will be a shared interconnect with a communication system, such as PCIe, to directly read and write to and from MMRs in order to control the system

### internal
Contains all top level stichings of the lease cache internal system. This incluese the RISC-V core, caches, and memory controllers.

### issp
This is Quartus IP used to generate resets.

### mci
Holds design files for memory control and arbitrage between system levels.

### misc
Holds miscellaneous design files used in more than one folder.

### opt_evict
Holds design files that enable forced eviction optimizations.

### peripheral
The peripheral system is how we interact with registers in the design. You will write to certain registers to control the design and they are heavily overused. Results downstream take multiple clock cycles to bubble up as its more a request without and ack signals.

### pll
Contains the PLL used to clock the lease cache system.

### policy_dlease
Contains the policy logic for dynamic leasing.

### policy_dlease_opt
Contains the policy logic for dynamic leasing along with optimized evictions.

### policy_fifo
Contains the policy logic for the FIFO policy.

### policy_lru
Contains the policy logic for the LRU policy.

### policy_mru
Contains the policy logic for the MRU policy.

### policy_plru
Contains the policy logic for the PLRU policy.

### policy_random
Contains the policy logic for the RANDOM policy.

### policy_slider
Contains the policy logic for the SLIDER policy.

### policy_slider_opt
Contains the policy logic for the SLIDER policy along with optimized evictions. Not implemented as of present.

### policy_srrip
Contains the policy logic for the SRRIP policy.

### sampler
Contains logic for the lease sampler.

### sdc
Contains timing constraint files used across all projects

### tracer
Contains logic for the memory tracer.

### tracker
Contrains logic for various metric trackers. This may be reworked in the future

## Project Macros
The include/ folder contains all macros in the lease cache project. It also determines all build conifgurations.

## Unit Tests
The test/ folder contains a littany of unit tests created during project developemnt. It's much less formal than the src/ folder as of present, so I won't go into each sub-folder here.


## Vivado
This folder currently serves to encapsulate the vivado cut of the project. Should probably be re-orged in the future.