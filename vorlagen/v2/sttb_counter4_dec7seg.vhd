-- Self-testing testbench for counter4_dec7seg (small "c" letter)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity sttb is
end entity sttb;


architecture struct of sttb is
	function bool2stdlogic(val : boolean) return std_logic is
	begin
		if val then
			return('1');
		else
			return('0');
		end if;
	end function bool2stdlogic;
	
	function dec7seg(data : std_logic_vector(3 downto 0)) return std_logic_vector is
		variable segout : std_logic_vector(6 downto 0);
	begin
		segout(6) :=   ( not data(0) and not data(1) and      data(2) )
			or (                 not data(1) and     data(2) and     data(3) )
			or (     data(0) and not data(1) and not data(2) and not data(3) )
			or (     data(0) and     data(1) and not data(2) and     data(3) );

		segout(5) :=   (     data(0) and     data(1)                 and     data(3) )
			or ( not data(0) and     data(1) and     data(2)                 )
			or ( not data(0) and                     data(2) and     data(3) )
			or (     data(0) and not data(1) and     data(2) and not data(3) );
			
		segout(4) :=   (                     data(1) and     data(2) and     data(3) )
			or ( not data(0) and                     data(2) and     data(3) )
			or ( not data(0) and     data(1) and not data(2) and not data(3) );
			
		segout(3) :=   ( not data(0) and not data(1) and     data(2) and not data(3) )
			or ( not data(0) and     data(1) and not data(2) and     data(3) )
			or (     data(0) and not data(1) and not data(2) and not data(3) )
			or (     data(0) and     data(1) and     data(2)                 );
			
		segout(2) :=   (     data(0) and not data(1) and not data(2)                 )
			or (                 not data(1) and     data(2) and not data(3) )
			or (     data(0) and                                 not data(3) );
			
		segout(1) :=   (     not data(1) and     data(2) and     data(3) )
			or (     data(0) and     data(1)                 and not data(3) )
			or (     data(0) and                 not data(2) and not data(3) )
			or (                     data(1) and not data(2) and not data(3) );
			
		segout(0) :=   (     data(0) and     data(1) and     data(2) and not data(3) )
			or (                 not data(1) and not data(2) and not data(3) );
			
		return segout;
	end function dec7seg;
	
	
	component counter4_dec7seg is
		port (
			reset : in	std_logic;
			clk   : in	std_logic;
			cnt   : out	std_logic_vector(3 downto 0);
			a : out std_logic;
			b : out std_logic;
			c : out std_logic;
			d : out std_logic;
			e : out std_logic;
			f : out std_logic;
			g : out std_logic
		);
	end component;
	
	
	signal tb_clk   : std_logic;
	signal tb_reset : std_logic;
	signal tb_cnt   : std_logic_vector(3 downto 0);
	signal tb_segout: std_logic_vector(6 downto 0);
	
	constant clk_period : time := 10 ns;
	constant clk_rising_edge : boolean := true;
	constant reset_active_time  : time := clk_period;
	constant reset_active_level : std_logic := '1';
	
	shared variable ENDSIM : boolean := false;
	
	
begin	-- arch struct
	uut:counter4_dec7seg port map (
		clk				=> tb_clk,				
		reset			=> tb_reset,			
		cnt(3 downto 0)	=> tb_cnt(3 downto 0),
		a				=> tb_segout(6),
		b				=> tb_segout(5),
		c				=> tb_segout(4),
		d				=> tb_segout(3),
		e				=> tb_segout(2),
		f				=> tb_segout(1),
		g				=> tb_segout(0)
	);
	
	clk_proc:process
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
	
	reset_proc:process
	begin
		-- reset pulse
		tb_reset <= reset_active_level;
		wait for reset_active_time;
		tb_reset <= not reset_active_level;
		
		wait;
	end process;
	
	stimulus_proc:process
	begin
		wait for reset_active_time - clk_period / 4;
		
		for i in 0 to 15 loop
			assert (to_integer(unsigned(tb_cnt)) = i) report "cnt value wrong" severity failure;
			assert tb_segout = dec7seg(tb_cnt) report "dec7seg output value wrong" severity failure;
			wait for clk_period;
		end loop;
		
		assert (to_integer(unsigned(tb_cnt)) = 0) report "cnt value wrong" severity failure;
		assert tb_segout = dec7seg(tb_cnt) report "dec7seg output value wrong" severity failure;
		
		assert false report "Test finished. No errors." severity note;
		ENDSIM := true;
		
		wait;
	end process;
	
end architecture struct;
