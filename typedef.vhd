-- name:			typedef.vhd
-- author:		Theodor Fragner
-- date:			2/9/2019
-- content:		package containing typedefinitions

library ieee;
use ieee.std_logic_1164.all;

package typedef is
  -- type for storing binary coded decimals
  type BCD_TYPE is array(integer range <>) of std_logic_vector (3 downto 0);
end package typedef;