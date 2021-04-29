library IEEE;
use IEEE.std_logic_1164.all;


entity dec7seg is  -- entity is basically an interface
	port(
		data : in std_logic_vector(3 downto 0);
		seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g : out std_logic );
end dec7seg;


architecture beh of dec7seg is
	
begin	-- beh
	seg_a <=   (     data(0) and     data(1) and not data(2) and     data(3) )
			or (     data(0) and not data(1) and not data(2) and not data(3) )
			or ( not data(0) and not data(1) and     data(2) and not data(3) )
			or (     data(0) and not data(1) and     data(2) and     data(3) );
	
	seg_b <=   (     data(0) and     data(1)                 and     data(3) )
			or ( not data(0) and     data(1) and     data(2)                 )
			or ( not data(0) and                     data(2) and     data(3) )
			or (     data(0) and not data(1) and     data(2) and not data(3) );
	
	seg_c <=   (                     data(1) and     data(2) and     data(3) )
			or ( not data(0) and                     data(2) and     data(3) )
			or ( not data(0) and     data(1) and not data(2) and not data(3) );
	
	seg_d <=   ( not data(0) and not data(1) and     data(2) and not data(3) )
			or ( not data(0) and     data(1) and not data(2) and     data(3) )
			or (     data(0) and not data(1) and not data(2) and not data(3) )
			or (     data(0) and     data(1) and     data(2)                 );
	
	seg_e <=   (     data(0) and not data(1) and not data(2)                 )
			or (                 not data(1) and     data(2) and not data(3) )
			or (     data(0) and                                 not data(3) );
	
	seg_f <=   (     data(0) and not data(1) and     data(2) and     data(3) )
			or (     data(0) and     data(1) and                 not data(3) )
			or (     data(0) and                 not data(2) and not data(3) )
			or (                     data(1) and not data(2) and not data(3) );
	
	seg_g <=   ( not data(0) and not data(1) and     data(2) and     data(3) )
			or (     data(0) and     data(1) and     data(2) and not data(3) )
			or (                 not data(1) and not data(2) and not data(3) );
	
end beh;


