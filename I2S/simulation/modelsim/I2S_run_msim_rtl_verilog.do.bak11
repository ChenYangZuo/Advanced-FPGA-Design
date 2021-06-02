transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/I2S {D:/Programme/Verilog/I2S/i2s_top.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/I2S {D:/Programme/Verilog/I2S/i2s_tx.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/I2S {D:/Programme/Verilog/I2S/i2s_rx.v}

vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/I2S/simulation/modelsim {D:/Programme/Verilog/I2S/simulation/modelsim/i2s_top.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone10lp_ver -L rtl_work -L work -voptargs="+acc"  i2s_top_vlg_tst

add wave *
view structure
view signals
run 1 us
