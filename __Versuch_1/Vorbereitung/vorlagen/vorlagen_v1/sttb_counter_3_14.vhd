-- Self-testing testbench for counter_3_14

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity sttb is
end entity sttb;


architecture struct of sttb is
	function bool2stdlogic(val: boolean) return std_logic is
	begin
		if val then	return('1');
		else return('0');
		end if;
	end function bool2stdlogic;	
	

	component counter is
		port (
			reset : in  std_logic;
			clk   : in  std_logic;
			q_out : out std_logic_vector(3 downto 0)
		);
	end component;
	
	
	signal tb_clk   : std_logic;
	signal tb_reset : std_logic;
	signal tb_q_out : std_logic_vector(3 downto 0);

	constant clk_period         : time := 10 ns;
	constant clk_rising_edge    : boolean := true;
	constant reset_active_time  : time := clk_period;
	constant reset_active_level : std_logic := '1';
	
	shared variable ENDSIM : boolean := false;
	
	
begin
	uut: counter port map (
		clk               => tb_clk,             
		reset             => tb_reset,           
		q_out(3 downto 0) => tb_q_out(3 downto 0)
	);

	
	clk_process: process
	begin
		if ENDSIM = false then
			tb_clk <= not bool2stdlogic(clk_rising_edge);
			wait for clk_period / 2;
			tb_clk <= not tb_clk;
			wait for clk_period / 2;
		else
			wait;
		end if;
	end process;

	reset_process: process
	begin
		-- reset pulse
		tb_reset <= reset_active_level;
		wait for reset_active_time;
		tb_reset <= not reset_active_level;

		wait;
	end process;

	stimulus_process: process
	begin
		wait for reset_active_time - clk_period / 4;

		for i in 3 to 14 loop
			assert (to_integer(unsigned(tb_q_out)) = i) report "q_out value wrong" severity failure;
			wait for clk_period;
		end loop;

		assert (to_integer(unsigned(tb_q_out)) = 3) report "q_out value wrong" severity failure;
		
		assert false report "Test finished. No errors." severity note;
		ENDSIM := true;
		
		wait;
	end process;

end struct;

