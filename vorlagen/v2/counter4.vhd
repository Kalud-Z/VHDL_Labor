library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity counter4 is
	port (
		clk   : in  std_logic;						
		reset : in  std_logic;						
		q_out : out std_logic_vector(3 downto 0)	
	);
end counter4;


architecture beh of counter4 is
	signal q, q_ns : unsigned(3 downto 0);
	
begin	-- beh
	q_out <= std_logic_vector(q);
	
	reg_proc:process (clk, reset)
	begin 
		if reset = '0' then
			q <= (others => '1');
		elsif clk'event and clk = '0' then
			q <= q_ns; 
		end if;
	end process;
	
	process (q)
	begin
		q <= q - 2;
	end process;
	
end beh;
