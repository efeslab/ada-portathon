include common/makefiles/Makefile.include
include common/makefiles/Makefile.recurse

table:
	@echo Generate Table for cycles
	@find cycles/*/ -iname "C_*.txt" -exec python common/support/buildTable.py {} \; | tee cycles.txt
	@find cycles/*/ -iname "Matlab_*.txt" -exec python common/support/buildTable.py {} \; | tee MCycles.txt
	@cat MCycles.txt >> cycles.txt
	@rm MCycles.txt
	@mv cycles.txt cycles/.


