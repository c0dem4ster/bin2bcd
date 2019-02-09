-- name:    tb_bin2bcd.vhd
-- author:  Theodor Fragner
-- date:    2/9/2019
-- content: testbench for testing binary to bcd converter

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

use work.typedef.all;

entity tb_bin2bcd is
end tb_bin2bcd;

architecture bhv of tb_bin2bcd is
  component bin2bcd
    generic(bin_width: integer := 32;
            dec_width: integer := 5);
    port(RESET_n: in std_logic;
         CLK    : in std_logic;
         BIN    : in std_logic_vector;
         BCD    : out BCD_TYPE;
         FIN    : out	std_logic);
  end component;
  signal mRESET_n: std_logic;
  signal mCLK    : std_logic := '0';
  signal mBIN    : std_logic_vector (31 downto 0);
  signal mBCD    : BCD_TYPE(0 to 4) := (others => (others => '0'));
  signal mFIN    : std_logic := '0';
begin
  m_bin2bcd: bin2bcd 
    port map(	RESET_n => mRESET_n,
                  CLK => mCLK,
                  BIN => mBIN,
                  BCD => mBCD,
                  FIN => mFIN);
  mBIN <= std_logic_vector(to_unsigned(53421, mBIN'length));
  mCLK <= not mCLK after 10 ns;
  mRESET_n <= '0', '1' after 5 ns;
end bhv;