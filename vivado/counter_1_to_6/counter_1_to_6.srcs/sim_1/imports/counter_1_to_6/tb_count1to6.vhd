library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb is
end entity tb;

architecture struct of tb is

	component count1to6 is
		port (
			clk   : in std_logic;
			reset : in std_logic;
			count : out std_logic_vector(2 downto 0)
		);
	end component;
	
	
	signal tb_clk   : std_logic;
	signal tb_reset : std_logic;
	signal tb_count : std_logic_vector(2 downto 0);

	constant clk_period : time := 10 ns;
	constant reset_active_time : time := clk_period;
	constant reset_active_level : std_logic := '1';
	
	
begin
	uut: count1to6 port map (
		clk               => tb_clk,             
		reset             => tb_reset,           
		count(2 downto 0) => tb_count(2 downto 0)
	);

	clk_process: process
	begin
		tb_clk <= '0';
		wait for clk_period / 2;
		tb_clk <= '1';
		wait for clk_period / 2;
	end process;

	stimulus_process: process
	begin
		tb_reset <= reset_active_level;
		wait for reset_active_time;
		tb_reset <= not reset_active_level;
		-- ...
		wait;
	end process;

end struct;
	



