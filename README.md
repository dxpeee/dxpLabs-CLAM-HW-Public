# dxpLabs-CLAM-HW-Public

The CLAM project is a collaboration between the University of Rochester (UR) and Rochester Institute of Technology (RIT). This project was supported by NSF between 2021-2025 (UR) and 2021-2026 (RIT). The RIT team has been supported by NSF Award ID 2114285. This is the public repository of the hardware developed by the RIT team.

A summary description of the project is provided below. We will add soon more details about the code and the content of the repository. This is shared with the community in the hope that the programmable and reconfigurable cache architecture can be used by others for cache architecture research.

The CLAM project has developed the Lease Cache — a new programmable hardware cache. The joint research has produced a hardware prototype and demonstrated that lease-based policies can match or exceed traditional replacement policies (like LRU/PLRU) and often approach the performance of an optimal (OPT) cache.

Unlike conventional caches that re-actively evict data based on history (e.g., Least Recently Used), a lease cache is prescriptive. The compiler assigns a "lease" (resident time in cache) to each data block when it is accessed. After the last use, the data block is evicted once its lease expires, rather than waiting for a replacement decision. This allows the cache to be programmed using reference leases. 

The UR team has developed four static lease programming techniques: CLAM, PRL, SHEL, and C-SHEL. In addition, the UR team has developed a formal theory of optimality, which forms the basis for all these lease policies. Extensive benchmarking using PolyBench benchmarks shows consist improvements of cache programming, approaching the optimal performance in these tests.

The RIT team implemented a single- and dual-core RISC-V processor core with a programmable and reconfigurable, single- and dual-level (with shared L2) cache on an Altera Cyclone-V FPGA. The cache can be configured to support traditional PLRU (LRU) or any of the aforementioned static, lease-based replacement policies. The evolution of the hardware prototype from single- to dual-core RISC-V processor and single- to dual-level cache hierarchies demonstrates that the lease concept can scale to more complex architectures.
