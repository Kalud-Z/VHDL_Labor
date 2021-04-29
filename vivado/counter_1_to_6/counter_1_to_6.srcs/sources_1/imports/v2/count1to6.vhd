library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity count1to6 is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           count : out  STD_LOGIC_VECTOR (2 downto 0));
end count1to6;

architecture Behavioral of count1to6 is

	signal q, q_next: unsigned(2 downto 0);
	signal reset_int: std_logic := '0';

begin
	reg: process (clk, reset)
	begin
		if reset = '1' then
			q <= "001";
		elsif clk'event and clk='1' then
			q <= q_next;
		end if;
	end process;
	
	nsd: process (q)
	begin
		if reset_int = '1' then
			q_next <= "001";
		elsif q < "110" then  -- 110 = 6
			q_next <= q + 1;
		else
			q_next <= "001";
		end if;
	end process;

	res_int: process (q)
	begin
		if q = "101" then   -- 101 = 5
			reset_int <= '1';
		else
			reset_int <= '0';
		end if;
	end process;

	count <= std_logic_vector(q);

end Behavioral;

