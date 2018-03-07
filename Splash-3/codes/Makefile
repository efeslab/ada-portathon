.PHONY: all clean

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
	$(MAKE) CC=$(riscvgcc) -C apps/barnes
	$(MAKE) CC=$(riscvgcc) -C apps/fmm
	$(MAKE) CC=$(riscvgcc) -C apps/ocean/contiguous_partitions
	$(MAKE) CC=$(riscvgcc) -C apps/ocean/non_contiguous_partitions
	$(MAKE) CC=$(riscvgcc) -C apps/radiosity
	$(MAKE) CC=$(riscvgcc) -C apps/raytrace
	$(MAKE) CC=$(riscvgcc) -C apps/volrend
	$(MAKE) CC=$(riscvgcc) -C apps/water-nsquared
	$(MAKE) CC=$(riscvgcc) -C apps/water-spatial
	$(MAKE) CC=$(riscvgcc) -C kernels/cholesky
	$(MAKE) CC=$(riscvgcc) -C kernels/fft
	$(MAKE) CC=$(riscvgcc) -C kernels/lu/contiguous_blocks
	$(MAKE) CC=$(riscvgcc) -C kernels/lu/non_contiguous_blocks
	$(MAKE) CC=$(riscvgcc) -C kernels/radix

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
