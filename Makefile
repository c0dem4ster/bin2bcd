# name:    Makefile
# author:  Theodor Fragner
# date:    2/9/2019
# content: Makefile for compiling vhdl entities using ghdl

# program to compile and run vhdl simulation
VHDL_CMD = ghdl

# include the standard libraries
VHDL_ARG = --ieee=synopsys

# name of top-level vhdl design entity
TOP_UNIT = tb_bin2bcd

# object files in hierarchical order
UNIT_OBJECTS := typedef.o bin2bcd.o $(TOP_UNIT).o

# program to display waveforms
DISPLAY_CMD = gtkwave

# waveform is stored here
DISPLAY_FILE = wave.ghw

# display generated waveform graphically
display: $(DISPLAY_FILE)
	$(DISPLAY_CMD) $(DISPLAY_FILE)

# remove all compiled files
clean:
	-rm $(UNIT_OBJECTS)
	-rm $(TOP_UNIT)

# create top-level executable
$(TOP_UNIT): $(UNIT_OBJECTS)
	$(VHDL_CMD) -e $(VHDL_ARG) $(TOP_UNIT)

# create waveform by running simulation
$(DISPLAY_FILE): $(TOP_UNIT)
	$(VHDL_CMD) -r $(TOP_UNIT) --stop-time=10ms --wave=$(DISPLAY_FILE)

# compile single vhdl files
%.o: %.vhd
	$(VHDL_CMD) -a $(VHDL_ARG) $(patsubst %.o, %.vhd, $@)