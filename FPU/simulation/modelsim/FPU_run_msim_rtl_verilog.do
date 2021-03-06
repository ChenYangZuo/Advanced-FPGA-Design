transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/FPU/src {D:/Programme/Verilog/FPU/src/multiplier.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/FPU/src {D:/Programme/Verilog/FPU/src/divider.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/FPU/src {D:/Programme/Verilog/FPU/src/adder.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/FPU {D:/Programme/Verilog/FPU/FPU.v}

vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/FPU {D:/Programme/Verilog/FPU/FPU_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone10lp_ver -L rtl_work -L work -voptargs="+acc"  FPU_tb

add wave *
view structure
view signals
run 5 us
