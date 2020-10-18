set_property PACKAGE_PIN K16 [get_ports pwm]
set_property IOSTANDARD LVCMOS33 [get_ports pwm]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN U18 [get_ports clk]

create_clock -period 20.000 -name clk -waveform {0.000 10.000} [get_ports clk]
