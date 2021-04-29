library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dec7seg_c is
    Port ( data  : in std_logic_vector (3 downto 0);
           seg_a : out std_logic;
           seg_b : out std_logic;
           seg_c : out std_logic;
           seg_d : out std_logic;
           seg_e : out std_logic;
           seg_f : out std_logic;
           seg_g : out std_logic);
end dec7seg_c;


architecture Behavioral of dec7seg_c is
    --signal seg7 : std_logic_vector (6 downto 0);
    
begin
  
    process(data)
        variable seg7 : std_logic_vector(6 downto 0); --use var instead of signal
    begin
        case data is
            when "0000" => seg7 := "0000001";
            when "0001" => seg7 := "1001111";
            when "0010" => seg7 := "0010010";
            when "0011" => seg7 := "0000110";
            when "0100" => seg7 := "1001100";
            when "0101" => seg7 := "0100100";
            when "0110" => seg7 := "0100000";
            when "0111" => seg7 := "0001111";
            when "1000" => seg7 := "0000000";
            when "1001" => seg7 := "0000100";
            when "1010" => seg7 := "0001000";
            when "1011" => seg7 := "1100000"; 
            when "1100" => seg7 := "1110010";  --old value : 0110001
            when "1101" => seg7 := "1000010";
            when "1110" => seg7 := "0110000";
            when "1111" => seg7 := "0111000"; 
            when others => seg7 := "0000001";     
        end case;
                
        seg_a <= seg7(6);
        seg_b <= seg7(5);
        seg_c <= seg7(4);
        seg_d <= seg7(3);
        seg_e <= seg7(2);
        seg_f <= seg7(1);
        seg_g <= seg7(0);
       
       
--        seg_a <= seg7(0);
--        seg_b <= seg7(1);
--        seg_c <= seg7(2);
--        seg_d <= seg7(3);
--        seg_e <= seg7(4);
--        seg_f <= seg7(5);
--        seg_g <= seg7(6);
         
        
    
     end process;
    
end Behavioral;


