# Binary to BCD Converter
## Description
This repository aims at providing a simple way to output a binary number in a decimal representation (e.g. 7-segment).
## Run Testbench
To compile and simulate the testbench, you need to install [GHDL](https://github.com/ghdl/ghdl) and [GTKWave](http://gtkwave.sourceforge.net/). Then type:
```python
make display
```
in the source directory and switch to the waveform viewer.
## Integrate
To use it with your own projects, you will need to add the following lines to your design file(s):
```vhdl
-- allows us to use BCD_TYPE
library work;
use work.typedef.all;
```
In the architecture head add:
```vhdl

  component bin2bcd
    -- set bandwidth of conversion here
    generic(bin_width: integer := 32;
            dec_width: integer := 5);
    port(RESET_n: in std_logic;
         CLK    : in std_logic;
         BIN    : in std_logic_vector;
         BCD    : out BCD_TYPE;
         FIN    : out	std_logic);
  end component;
```
And don't forget the port map in the architecture body!