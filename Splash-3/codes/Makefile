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

run:
	$(MAKE) -C apps/barnes run 
	$(MAKE) -C apps/fmm run
	$(MAKE) -C apps/ocean/contiguous_partitions run
	$(MAKE) -C apps/ocean/non_contiguous_partitions run
	$(MAKE) -C apps/radiosity run
	$(MAKE) -C apps/raytrace run
	$(MAKE) -C apps/volrend run
	$(MAKE) -C apps/water-nsquared run
	$(MAKE) -C apps/water-spatial run
	$(MAKE) -C kernels/cholesky run
	$(MAKE) -C kernels/fft run
	$(MAKE) -C kernels/lu/contiguous_blocks run
	$(MAKE) -C kernels/lu/non_contiguous_blocks run
	$(MAKE) -C kernels/radix run

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
