

if {[file exist "questa_lib"]} {
	if {[file isdirectory "questa_lib"]} {
		rm -r questa_lib
	} 
}

mkdir  questa_lib/

vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vcom -64 -2008 -work xil_defaultlib  \
"../verif/DAC_RTL_sim_model.vhd" \
"../rtl/uart/baudrate_gen.vhd" \
"../rtl/command_handler/cmd_handler.vhd" \
"../rtl/dac_controller/en_gen.vhd" \
"../rtl/dac_controller/sclk_gen.vhd" \
"../rtl/dac_controller/sync_data_gen.vhd" \
"../rtl/uart/u_tx.vhd" \
"../rtl/uart/u_rx.vhd" \
"../rtl/uart/uart_top.vhd" \
"../rtl/waveform_generator/wave_gen_pkg.vhd" \
"../rtl/waveform_generator/wave_gen.vhd" \
"../rtl/waveform_generator/wave_gen_top.vhd" \
"../verif/tb_top_level.vhd" \

vopt -64 +acc=npr -L xil_defaultlib  -work xil_defaultlib xil_defaultlib.tb_top_level -o tb_top_level_opt

vsim -lib xil_defaultlib tb_top_level_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

#do {tb_top_level.do}

do {wave.do}

view wave
view structure
view signals


run 200ms




