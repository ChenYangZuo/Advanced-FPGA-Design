transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/SPDIF {D:/Programme/Verilog/SPDIF/spdif_core.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/SPDIF {D:/Programme/Verilog/SPDIF/spdif.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/SPDIF {D:/Programme/Verilog/SPDIF/audio_spdif.v}

vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/SPDIF/simulation/modelsim {D:/Programme/Verilog/SPDIF/simulation/modelsim/audio_spdif.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone10lp_ver -L rtl_work -L work -voptargs="+acc"  audio_spdif_vlg_tst

add wave *
view structure
view signals
run 5 us
