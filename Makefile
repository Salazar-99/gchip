SIM_DIR := sim

.PHONY: sim wave test clean

sim:
	$(MAKE) -C $(SIM_DIR) sim

wave:
	$(MAKE) -C $(SIM_DIR) wave

test:
	$(MAKE) -C $(SIM_DIR) test

clean:
	$(MAKE) -C $(SIM_DIR) clean
