##Switches
##IO_L19N_T3_VREF_35
set_property PACKAGE_PIN G15 [get_ports {a}]
set_property IOSTANDARD LVCMOS33 [get_ports {a}]

##IO_L24P_T3_34
set_property PACKAGE_PIN P15 [get_ports {b}]
set_property IOSTANDARD LVCMOS33 [get_ports {b}]

##IO_L4N_T0_34
set_property PACKAGE_PIN W13 [get_ports {c}]
set_property IOSTANDARD LVCMOS33 [get_ports {c}]

##LEDs
##IO_L23P_T3_35
set_property PACKAGE_PIN M14 [get_ports {sum}]
set_property IOSTANDARD LVCMOS33 [get_ports {sum}]

#IO_L23N_T3_35
set_property PACKAGE_PIN M15 [get_ports {carry}]
set_property IOSTANDARD LVCMOS33 [get_ports {carry}]

set_property PACKAGE_PIN L16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports clk]

##Buttons
##IO_L20N_T3_34
set_property PACKAGE_PIN R18 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]
