LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


entity counter is
	port (
		clk		: in  std_logic;						
		reset	: in  std_logic;						
		q_out	: out std_logic_vector(1 downto 0) );
end counter;


architecture beh of counter is
	signal q,q_ns: unsigned(1 downto 0);
	
begin
	q_out <= std_log_vector(q);
	
	process (clk)
	begin 
		if reset='0' then
			q <= (others => '0');
		elsif clk'event and clk = '0' then
				q <= q_ns; 
		end if;
	end process;
	
	process	(q_ns)
	begin 
		if q < 9 then
			q_ns <= q_ns - 2;
		else
			q_ns <= "010";
		end if;
	end process;

end beh;

