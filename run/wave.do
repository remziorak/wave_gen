onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/clk
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/sw
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/sync
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/dac_data
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/s_clk
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/led
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/tx_dout_UUT1_to_UUT2
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/uart_dout_UUT2_to_UUT1
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/tx_send_sig
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/tx_data_sig
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/tx_active_sig
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/rx_data_ready_sig
add wave -noupdate -expand -group TOP_LEVEL /tb_top_level/rx_data_sig
add wave -noupdate -expand -group TOP_LEVEL -format Analog-Step -height 84 -max 3.2999999999999998 /tb_top_level/Vout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1371 ns}
