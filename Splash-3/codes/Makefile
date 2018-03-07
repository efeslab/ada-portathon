.PHONY: all clean

riscvar=$(HOME)/portathon/freedom-u-sdk/toolchain/bin/riscv64-unknown-linux-gnu-ar

all:
	$(MAKE) -C apps/barnes
	$(MAKE) -C apps/fmm
	$(MAKE) -C apps/ocean/contiguous_partitions
	$(MAKE) -C apps/ocean/non_contiguous_partitions
	$(MAKE) -C apps/radiosity
	$(MAKE) -C apps/raytrace
	$(MAKE) -C apps/volrend
	$(MAKE) -C apps/water-nsquared
	$(MAKE) -C apps/water-spatial
	$(MAKE) -C kernels/cholesky
	$(MAKE) -C kernels/fft
	$(MAKE) -C kernels/lu/contiguous_blocks
	$(MAKE) -C kernels/lu/non_contiguous_blocks
	$(MAKE) -C kernels/radix

riscv:
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/barnes
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/fmm
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/ocean/contiguous_partitions
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/ocean/non_contiguous_partitions
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/radiosity
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/raytrace
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/volrend
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/water-nsquared
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C apps/water-spatial
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C kernels/cholesky
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C kernels/fft
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C kernels/lu/contiguous_blocks
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C kernels/lu/non_contiguous_blocks
	$(MAKE) AR=$(riscvar) CC=$(riscvgcc) -C kernels/radix

clean:
	$(MAKE) -C apps/barnes clean
	$(MAKE) -C apps/fmm clean
	$(MAKE) -C apps/ocean/contiguous_partitions clean
	$(MAKE) -C apps/ocean/non_contiguous_partitions clean
	$(MAKE) -C apps/radiosity clean
	$(MAKE) -C apps/raytrace clean
	$(MAKE) -C apps/volrend clean
	$(MAKE) -C apps/water-nsquared clean
	$(MAKE) -C apps/water-spatial clean
	$(MAKE) -C kernels/cholesky clean
	$(MAKE) -C kernels/fft clean
	$(MAKE) -C kernels/lu/contiguous_blocks clean
	$(MAKE) -C kernels/lu/non_contiguous_blocks clean
	$(MAKE) -C kernels/radix clean
