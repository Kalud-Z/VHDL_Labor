# ##############################################################
# generate_testbench.tcl
#
# Testbench generator
# 20190509 MG
# 
# Generates vhdl testbench for current_instance
# - Requires top level VHDL source file
# - Generates testbench and imports generated testbench into project
#
# Contains code from xilinx::designutils::write_template
# ##############################################################

variable tfh
variable module
variable inputBitPorts
variable inputBusPorts
variable outputBitPorts
variable outputBusPorts
variable inoutBitPorts
variable inoutBusPorts

# set default values
catch {unset inputBusPorts}
catch {unset outputBusPorts}
catch {unset inoutBusPorts}
set tfh {}

set filename {}
set mode {w}
set cell {}
set returnString 0


# ##############################################################
# Generates a VHDL testbench for the specified module.
# ##############################################################
proc vhdlTestbench {} {
	# Summary :

	# Argument Usage:

	# Return Value:
	# VHDL testbench

	# Categories: xilinxtclstore, designutils

	variable module
	variable inputBitPorts
	variable inputBusPorts
	variable outputBitPorts
	variable outputBusPorts
	variable inoutBitPorts
	variable inoutBusPorts

	set component_port_lines [list]
	set signal_lines [list]
	set instance_port_lines [list]
	# Process input single bit ports
	foreach port [lsort -dictionary $inputBitPorts] {
		lappend component_port_lines [list "$port" "in std_logic;"]
		lappend signal_lines [list "$port" "std_logic;"]
		lappend instance_port_lines [list "$port" "$port,"]
	}
	# Process input bus ports
	foreach {port busInfo} [array2sortedList inputBusPorts] {
		lassign $busInfo width stop start
		if {$start>$stop} {
			lappend component_port_lines [list "$port" "in std_logic_vector($start downto $stop);"]
			lappend signal_lines [list "$port" "std_logic_vector($start downto $stop);"]
		lappend instance_port_lines [list "${port}($start downto $stop)" "${port}($start downto $stop),"]
	 } else {
			lappend component_port_lines [list "$port" "in std_logic_vector($start to $stop);"]
			lappend signal_lines [list "$port" "std_logic_vector($start to $stop);"]
		lappend instance_port_lines [list "${port}($start to $stop)" "${port}($start to $stop),"]
		}
	}
	# Process output single bit ports
	foreach port [lsort -dictionary $outputBitPorts] {
		lappend component_port_lines [list "$port" "out	std_logic;"]
		lappend signal_lines [list "$port" "std_logic;"]
		lappend instance_port_lines [list "$port" "$port,"]
	}
	# Process output bus ports
	foreach {port busInfo} [array2sortedList outputBusPorts] {
		lassign $busInfo width stop start
		if {$start>$stop} {
			lappend component_port_lines [list "$port"	"out std_logic_vector($start downto $stop);"]
			lappend signal_lines [list "$port" "std_logic_vector($start downto $stop);"]
		lappend instance_port_lines [list "${port}($start downto $stop)" "${port}($start downto $stop),"]
		} else {
			lappend component_port_lines [list "$port" "out	std_logic_vector($start to $stop);"]
			lappend signal_lines [list "$port" "std_logic_vector($start to $stop);"]
		lappend instance_port_lines [list "${port}($start to $stop)" "${port}($start to $stop),"]
		}
	}
	# Process inout single bit ports
	foreach port [lsort -dictionary $inoutBitPorts] {
		lappend component_port_lines [list "$port" "inout	std_logic;"]
		lappend signal_lines [list "$port" "std_logic;"]
		lappend instance_port_lines [list "$port" "$port,"]
	}
	# Process inout bus ports
	foreach {port busInfo} [array2sortedList inoutBusPorts] {
		lassign $busInfo width stop start
		if {$start>$stop} {
			lappend component_port_lines [list "$port" "inout std_logic_vector($start downto $stop);"]
			lappend signal_lines [list "$port" "std_logic_vector($start downto $stop);"]
		lappend instance_port_lines [list "${port}($start downto $stop)" "${port}($start downto $stop),"]
		} else {
			lappend component_port_lines [list "$port" "inout std_logic_vector($start to $stop);"]
			lappend signal_lines [list "$port" "std_logic_vector($start to $stop);"]
		lappend instance_port_lines [list "${port}($start to $stop)" "${port}($start to $stop),"]
	 }
	}

	# Build component ports
	# Detect maximum column width to align columns
	set maxWidth 0
	foreach component_port_line $component_port_lines {
		if {[regexp {^\s*\-\-} $component_port_line]} {
			# Skip component_port lines that are just comments
			continue
		}
		set width [string length [lindex $component_port_line 0]]
		if {![info exist maxWidth] || $maxWidth < $width} {
			set maxWidth $width
		}
	}
	set component_ports {}
	foreach component_port_line $component_port_lines {
		if {[regexp {^\s*\-\-} $component_port_line]} {
			# component_port lines that are just comments
			append component_ports "\n			$component_port_line"
			continue
		}
		append component_ports [format "\n			%-${maxWidth}s : %-${maxWidth}s" [lindex $component_port_line 0] [lindex $component_port_line 1]]
	}
	# Remove the last semi-colon
	set index [string last {;} $component_ports]
	set component_ports [string replace $component_ports $index $index {}]

	# Build signals
	# Detect maximum column width to align columns
	set maxWidth 0
	foreach signal_line $signal_lines {
		if {[regexp {^\s*\-\-} $signal_line]} {
			# Skip signal lines that are just comments
			continue
		}
		set width [string length [lindex $signal_line 0]]
		if {![info exist maxWidth] || $maxWidth < $width} {
			set maxWidth $width
		}
	}
	set signals {}
	foreach signal_line $signal_lines {
		if {[regexp {^\s*\-\-} $signal_line]} {
			# signal lines that are just comments
			append signals "\n	$signal_line"
			continue
		}
		append signals [format "\n	signal tb_%-${maxWidth}s : %-${maxWidth}s" [lindex $signal_line 0] [lindex $signal_line 1]]
	}

	# Build instance ports
	# Detect maximum column width to align columns
	set maxWidth 0
	foreach instance_port_line $instance_port_lines {
		if {[regexp {^\s*\-\-} $instance_port_line]} {
			# Skip instance_port lines that are just comments
			continue
		}
		set width [string length [lindex $instance_port_line 0]]
		if {![info exist maxWidth] || $maxWidth < $width} {
			set maxWidth $width
		}
	}
	set instance_ports {}
	foreach instance_port_line $instance_port_lines {
		if {[regexp {^\s*\-\-} $instance_port_line]} {
			# instance_port lines that are just comments
			append instance_ports "\n		$instance_port_line"
			continue
		}
		append instance_ports [format "\n		%-${maxWidth}s => tb_%-${maxWidth}s" [lindex $instance_port_line 0] [lindex $instance_port_line 1]]
	}
	# Remove the last colon
	set index [string last {,} $instance_ports]
	set instance_ports [string replace $instance_ports $index $index {}]


	# generate testbench code
	set content [format "library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb is
end entity tb;

architecture struct of tb is

	component ${module} is
		port (%s
		);
	end component;
	
	%s

	constant clk_period : time := 100 ns;
	constant reset_active_time : time := clk_period;
	constant reset_active_level : std_logic := '0';
	
	
begin
	uut: ${module} port map (%s
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
	" $component_ports $signals $instance_ports]

	return $content
}



# ##############################################################
# Sort list of pins into busses and bit ports by removing
# hiearchical prefixes, and assigns them to the specified
# array and list, respectively.
# ##############################################################
proc sortPins { pins &bus &bit } {
	# Summary : sort list of pins into busses and bit ports by removing hiearchical
	# prefixes, and assigns them to the specified array and list, respectively

	# Argument Usage:
	# pins :
	# &bus :
	# &bit :

	# Return Value:
	# 0

	# Categories: xilinxtclstore, designutils

	 upvar ${&bus} busPorts
	 upvar ${&bit} bitPorts
	 array set busPorts [list ]
	 set bitPorts [list]

	 foreach pin $pins {
			set busName [get_property -quiet BUS_NAME [get_pins $pin]]
			if {![info exist busPorts($busName)] && [llength $busName]} {
				 set busWidth [get_property -quiet BUS_WIDTH [get_pins $pin]]
				 set busStart [get_property -quiet BUS_START [get_pins $pin]]
				 set busStop	[get_property -quiet BUS_STOP	[get_pins $pin]]
				 array set busPorts [list $busName [list $busWidth $busStop $busStart]]
			} elseif {[llength $busName] == 0} {
				 lappend bitPorts [get_property -quiet REF_PIN_NAME $pin]
			}
	 }
	 return 0
}

# ##############################################################
# Sort list of ports into busses and bit ports, and assigns
# them to the specified array and list, respectively.
# ##############################################################
proc sortPorts { ports &bus &bit } {
	# Summary : sort list of ports into busses and bit ports, and assigns
	# them to the specified array and list, respectively

	# Argument Usage:
	# ports :
	# &bus :
	# &bit :

	# Return Value:
	# 0

	# Categories: xilinxtclstore, designutils

	upvar ${&bus} busPorts
	upvar ${&bit} bitPorts
	array set busPorts [list ]
	set bitPorts [list]

	foreach port $ports {
		set busName [get_property -quiet BUS_NAME [get_ports $port]]
		if {![info exist busPorts($busName)] && [llength $busName]} {
			set busWidth [get_property -quiet BUS_WIDTH [get_ports $port]]
			set busStart [get_property -quiet BUS_START [get_ports $port]]
			set busStop	[get_property -quiet BUS_STOP	[get_ports $port]]
			array set busPorts [list $busName [list $busWidth $busStop $busStart]]
		} elseif {[llength $busName] == 0} {
			lappend bitPorts $port
		}
	}
	return 0
}

proc array2sortedList { &ar } {
	# Summary : convert an array into a sorted list

	# Argument Usage:
	# &ar : Array passed by reference

	# Return Value:
	# sorted list

	# Categories: xilinxtclstore, designutils

	upvar ${&ar} ar
	set sortedList [list]
	foreach key [lsort -dictionary [array names ar]] {
		lappend sortedList $key
		lappend sortedList $ar($key)
	}
	return $sortedList
}







# ##############################################################
# Main routine
# ##############################################################

# check syntax
set syntax_check_results [check_syntax -quiet -return_string]
if {$syntax_check_results != ""} {
	puts $syntax_check_results
	error "ERROR: Design contains syntax errors. Cannot continue."
}

# open elaborated design
update_compile_order -fileset sources_1

if {[catch {synth_design -rtl -name rtl_1} msg]} {
	set errMsg $msg
	error $errMsg
}

# If no design is open
if { [catch {current_instance .}]} {
	set errMsg "ERROR: No open design. An elaborated design must be open to run this command."
	error $errMsg
}

# Save the current instance we are in so that it can be restored afterward
set current_instance [current_instance -quiet .]

# Define module name and if command is being run on top or a cell
if {$cell != {}} {
	set module [get_property -quiet REF_NAME $cell]
	set isTop 0
} else {
	# If top-level, then $current_instance is empty
	if {$current_instance == {}} {
		set module [get_property -quiet TOP [current_design]]
		set isTop 1
	} else {
		# We need to change to the top-level so that the list of pins can be extracted from
		# the current instance
		current_instance -quiet
		set module [get_property -quiet REF_NAME [get_cells -quiet $current_instance]]
		set isTop 0
		set cell $current_instance
	}
}

# remove leading and trailing spaces and \'s from module name
regexp {^[\\\s]*(.+?)[\\\s]*$} $module match module

# Generate the default file name
if {$filename == {}} {
	set filename "[get_property DIRECTORY [current_project]]/tb_${module}.vhd"
}

# Get a sorted list of all input and output bit and busses
# If no -cell, this is a list of ports as input and output
# If a cell is specified, a list of pins is given, but a scoped port list is returned
if {$isTop} {
	# Build data structures for IN ports
	set inPorts [lsort [get_ports -quiet -filter DIRECTION==IN]]
	array set inputBusPorts [list ]
	set inputBitPorts [list]
	sortPorts $inPorts inputBusPorts inputBitPorts

	# Build data structures for OUT ports
	set outPorts [lsort [get_ports -quiet -filter DIRECTION==OUT]]
	array set outputBusPorts [list ]
	set outputBitPorts [list]
	sortPorts $outPorts outputBusPorts outputBitPorts

	# Build data structures for INOUT ports
	set inoutPorts [lsort [get_ports -quiet -filter DIRECTION==INOUT]]
	array set inoutBusPorts [list ]
	set inoutBitPorts [list]
	sortPorts $inoutPorts inoutBusPorts inoutBitPorts
} else {
	# Build data structures for IN ports
	set inPins [lsort [get_pins -quiet -of [get_cells -quiet $cell] -filter DIRECTION==IN]]
	array set inputBusPorts [list ]
	set inputBitPorts [list]
	sortPins $inPins inputBusPorts inputBitPorts

	# Build data structures for OUT ports
	set outPins [lsort [get_pins -quiet -of [get_cells -quiet $cell] -filter DIRECTION==OUT]]
	array set outputBusPorts [list ]
	set outputBitPorts [list]
	sortPins $outPins outputBusPorts outputBitPorts

	# Build data structures for INOUT ports
	set inoutPins [lsort [get_pins -quiet -of [get_cells -quiet $cell] -filter DIRECTION==INOUT]]
	array set inoutBusPorts [list ]
	set inoutBitPorts [list]
	sortPorts $inoutPins inoutBusPorts inoutBitPorts
}

# Generate testbench code
set content [vhdlTestbench]
	

# Save the testbench
puts "\nCreating testbench for Module $module in [file normalize $filename]"
set tfh [open $filename $mode]
puts $tfh $content
close $tfh

# Go back to the instance level we were in before calling this command
if {$current_instance != {}} {
	current_instance -quiet
	current_instance -quiet $current_instance
} else {
	current_instance -quiet
}

# close elaborated design
close_design

# Return result as string?
if {$returnString} {
	return $content
}

# import testbench into project
import_files -fileset sim_1 -force $filename

puts "\nINFO: Testbench $filename generated and added to simulation sources.\n"

return 0

	
