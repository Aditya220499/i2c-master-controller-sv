
###############################################################################
# ZedBoard I2C Master Demo
#
# Project:
#   I2C Master Controller (SystemVerilog)
#
# Purpose:
#   Minimal constraints required for first FPGA bring-up.
#
# Signals Used:
#   - 100 MHz System Clock
#   - Center Push Button
#   - LED0
#   - SDA
#   - SCL
###############################################################################

###############################################################################
# SYSTEM CLOCK
###############################################################################

# 100 MHz oscillator

set_property PACKAGE_PIN Y9 [get_ports CLK100MHZ]
create_clock -period 10.000 -name sys_clk [get_ports CLK100MHZ]

###############################################################################
# USER BUTTON
###############################################################################

# Center Push Button

set_property PACKAGE_PIN P16 [get_ports BTN0]

###############################################################################
# USER LED
###############################################################################

# LED0

set_property PACKAGE_PIN T22 [get_ports LED0]

###############################################################################
# I2C SIGNALS
###############################################################################

# Audio Codec I2C Clock

set_property PACKAGE_PIN AB4 [get_ports SCL]

# Audio Codec I2C Data

set_property PACKAGE_PIN AB5 [get_ports SDA]

###############################################################################
# IO STANDARDS
###############################################################################

set_property IOSTANDARD LVCMOS33 [get_ports {CLK100MHZ}]
set_property IOSTANDARD LVCMOS18 [get_ports {BTN0}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED0}]
set_property IOSTANDARD LVCMOS33 [get_ports {SCL}]
set_property IOSTANDARD LVCMOS33 [get_ports {SDA}]
