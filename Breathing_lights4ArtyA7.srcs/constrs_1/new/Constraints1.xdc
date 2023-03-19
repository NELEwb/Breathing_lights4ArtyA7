#system clock 100MHz
set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
#Module reset
set_property PACKAGE_PIN D9 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# LD0 R
set_property PACKAGE_PIN G6 [get_ports out_r1]
set_property IOSTANDARD LVCMOS33 [get_ports out_r1]
# LD0 G
set_property PACKAGE_PIN F6 [get_ports out_g1]
set_property IOSTANDARD LVCMOS33 [get_ports out_g1]
# LD0 B
set_property PACKAGE_PIN E1 [get_ports out_b1]
set_property IOSTANDARD LVCMOS33 [get_ports out_b1]

# LD1 R
set_property PACKAGE_PIN G3 [get_ports out_r2]
set_property IOSTANDARD LVCMOS33 [get_ports out_r2]
# LD1 G
set_property PACKAGE_PIN J4 [get_ports out_g2]
set_property IOSTANDARD LVCMOS33 [get_ports out_g2]
# LD1 B
set_property PACKAGE_PIN G4 [get_ports out_b2]
set_property IOSTANDARD LVCMOS33 [get_ports out_b2]

# LD2 R
set_property PACKAGE_PIN J3 [get_ports out_r3]
set_property IOSTANDARD LVCMOS33 [get_ports out_r3]
# LD2 G
set_property PACKAGE_PIN J2 [get_ports out_g3]
set_property IOSTANDARD LVCMOS33 [get_ports out_g3]
# LD2 B
set_property PACKAGE_PIN H4 [get_ports out_b3]
set_property IOSTANDARD LVCMOS33 [get_ports out_b3]

# LD3 R
set_property PACKAGE_PIN K1 [get_ports out_r4]
set_property IOSTANDARD LVCMOS33 [get_ports out_r4]
# LD3 G
set_property PACKAGE_PIN H6 [get_ports out_g4]
set_property IOSTANDARD LVCMOS33 [get_ports out_g4]
# LD3 B
set_property PACKAGE_PIN K2 [get_ports out_b4]
set_property IOSTANDARD LVCMOS33 [get_ports out_b4]


# Enable input
set_property PACKAGE_PIN A8 [get_ports SampleInputEnable]
set_property IOSTANDARD LVCMOS33 [get_ports SampleInputEnable]

# Input for mode selection
set_property PACKAGE_PIN C9 [get_ports SelectMode]
set_property IOSTANDARD LVCMOS33 [get_ports SelectMode]

create_clock -period 10 -name clock_clk [get_ports clk]
set_clock_uncertainty -setup 0.100 clock_clk
set_clock_uncertainty -hold 0.050 clock_clk

#SPI X4 and compress bitstream
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set the configuration rate to 50 MHz
set_property BITSTREAM.CONFIG.CONFIGRATE 50  [current_design]

#CFGBVS and CONFIG_VOLTAGE Design Properties
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]