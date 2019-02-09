-- name:    bin2bcd.vhd
-- author:  Theodor Fragner
-- date:    2/9/2019
-- content: entity for converting a binary number
--          into a binary coded decimal

-- integer, std_logic, natural, unsigned
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- BCD_TYPE
library work;
use work.typedef.all;

entity bin2bcd is
  -- set bandwidth of conversion
  generic(	bin_width	:	integer := 8;
            dec_width	:	integer := 2);

  port(	RESET_n	: in std_logic;
        CLK			:	in std_logic;
        BIN			: in std_logic_vector (bin_width - 1 downto 0);
        BCD 		: out BCD_TYPE(0 to dec_width - 1);
        FIN			: out	std_logic	);
end bin2bcd;

architecture rtl of bin2bcd is
  -- define the states
  type state_type is
    (ST_LOAD, ST_SHIFT, ST_ADJUST, ST_WRITE);
  -- signal declarations
  signal n_bin			:	natural range 0 to bin_width - 1;
  signal n_dec			:	natural range 0 to dec_width - 1;
  signal shift_reg	:	unsigned (bin_width - 1 downto 0);
  signal digit			: BCD_TYPE(0 to dec_width - 1);
  signal state			: state_type;
begin
  FSM: process (RESET_n, CLK)
  begin
    if (RESET_n = '0') then
      n_bin			<= bin_width - 1;
      n_dec			<= 0;
      shift_reg <= (others => '0');
      FIN				<= '0';
      BCD 			<= (others => (others => '0'));
      digit 		<= (others => (others => '0'));
      state 		<= ST_LOAD;
    elsif (CLK'event and CLK = '1') then
      case state is
        -- load the binary number into the shift register
        when ST_LOAD =>
          n_bin 		<= bin_width - 1;
          shift_reg <= unsigned(BIN);
          digit 		<= (others => (others => '0'));
          state 		<= ST_ADJUST;
        -- 
        when ST_ADJUST =>
          if (n_dec = dec_width - 1) then
            state <= ST_SHIFT;
            n_dec <= 0;
          else
            if (digit(n_dec) > 4) then
              digit(n_dec) <= digit(n_dec) + 3;
            end if;
            n_dec <= n_dec + 1;
          end if;

        when ST_SHIFT =>
          for n in 1 to dec_width - 1 loop
            digit(n) <= digit(n)(2 downto 0) & digit(n - 1)(3);
          end loop;
          digit(0)	<= digit(0)(2 downto 0) & shift_reg(bin_width - 1);
          shift_reg <= shift_reg(bin_width - 2 downto 0) & '0';
          if (n_bin = 0) then
            state <= ST_WRITE;
            FIN 	<= '1';
          else
            n_bin <= n_bin - 1;
            state <= ST_ADJUST;
          end if;

        when ST_WRITE =>
          BCD 	<= digit;
          state <= ST_LOAD;
          FIN 	<= '0';
      end case;
    end if;
  end process FSM;
end rtl;