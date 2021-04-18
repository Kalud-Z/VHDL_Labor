library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity tb is
end entity tb;

architecture struct of tb is

	component counter4 is -- this is should have the same name as the Entity in the main file.
		port (
			clk   : in std_logic;
			reset : in std_logic;
			q_out : out std_logic_vector(3 downto 0)
		);
	end component;
	
	
	signal tb_clk   : std_logic;
	signal tb_reset : std_logic;
	signal tb_q_out : std_logic_vector(3 downto 0);

	constant clk_period : time := 25 ns; --40 Mhz
	constant reset_active_time : time := clk_period * 2;
	constant reset_active_level : std_logic := '1';
	
	
	
begin
	uut: counter4 port map (
		clk               => tb_clk,             
		reset             => tb_reset,           
		q_out(3 downto 0) => tb_q_out(3 downto 0)
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
	
