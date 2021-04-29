library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb is
end entity tb;

architecture struct of tb is

	component counter4_dec7seg is
		port (
			clk   : in std_logic;
			reset : in std_logic;
			a     : out	std_logic;
			b     : out	std_logic;
			c     : out	std_logic;
			d     : out	std_logic;
			e     : out	std_logic;
			f     : out	std_logic;
			g     : out	std_logic;
			cnt   : out std_logic_vector(3 downto 0)
		);
	end component;
	
	
	signal tb_clk   : std_logic;
	signal tb_reset : std_logic;
	signal tb_a     : std_logic;
	signal tb_b     : std_logic;
	signal tb_c     : std_logic;
	signal tb_d     : std_logic;
	signal tb_e     : std_logic;
	signal tb_f     : std_logic;
	signal tb_g     : std_logic;
	signal tb_cnt   : std_logic_vector(3 downto 0);

	constant clk_period : time := 100 ns;
	constant reset_active_time : time := clk_period;
	constant reset_active_level : std_logic := '0';
	
	
begin
	uut: counter4_dec7seg port map (
		clk             => tb_clk,           
		reset           => tb_reset,         
		a               => tb_a,             
		b               => tb_b,             
		c               => tb_c,             
		d               => tb_d,             
		e               => tb_e,             
		f               => tb_f,             
		g               => tb_g,             
		cnt(3 downto 0) => tb_cnt(3 downto 0)
	);

	clk_process: process
	begin
		<clk> <= '0';
		wait for clk_period / 2;
		<clk> <= '1';
		wait for clk_period / 2;
	end process;

	stimulus_process: process
	begin
		<reset> <= reset_active_level;
		wait for reset_active_time;
		<reset> <= not reset_active_level;
		-- ...
		wait;
	end process;

end struct;
	
