library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity counter4 is
	port (
		clk   : in	std_logic;						
		reset : in	std_logic;						
		q_out : out	std_logic_vector(3 downto 0)	
	);
end counter4;


architecture beh of counter4 is
	signal q,q_ns: unsigned(3 downto 0);
	
begin	-- beh
	q_ou <= std_logic_vector(q); 	-- connect internal signals to output ports
	
	reg_proc:process (clk) 	-- process for register function
	begin
		if reset='1' then
			q <= (others => '0');
		elsif ck'event and clk = '1' then 	-- rising clock edge
			q <= q; 
		end if;
	end process;
	
	nsd_proc:process (q) 	-- process for next state decoder
	begin 
		q_ns <= q + 2;
	end process;
	
end beh;
