library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter4_dec7seg is
    Port ( clk : in std_logic;
           reset : in std_logic;
           a : out std_logic;
           b : out std_logic;
           c : out std_logic;
           d : out std_logic;
           e : out std_logic;
           f : out std_logic;
           g : out std_logic;
           cnt : out std_logic_vector (3 downto 0));
end counter4_dec7seg;

architecture struct of counter4_dec7seg is
-- Deklarationsteil ---------------------------------------------
    component counter4
        port( clk, reset : in std_logic ;
              q_out  : out  std_logic_vector  (3 downto 0));
    end component;
    
    component dec7seg
        port( data : in  std_logic_vector (3 downto 0);
              seg_a ,seg_b ,seg_c ,seg_d ,seg_e ,seg_f ,seg_g : out  std_logic);
    end component;
    
    
-- Deklaration des internen Signals -----------------------------
    signal q_int : std_logic_vector (3 downto 0); --- z.B q_int = 1010 [ MSB ist 1 | LSB ist 0 ]    

begin
-- Instanziierung und Verbinden der Komponenten -----------------------------
    cnt4 : counter4 port map (
        clk   => clk,
        reset => reset,
        q_out => q_int
    );
    
    seg7 : dec7seg port map (
        data  => q_int,
        seg_a => a ,
        seg_b => b ,
        seg_c => c ,
        seg_d => d ,
        seg_e => e ,
        seg_f => f ,
        seg_g => g
    );


    cnt <= q_int;

end struct;




