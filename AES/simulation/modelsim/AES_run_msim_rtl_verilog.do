transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES {D:/Programme/Verilog/AES/AES_top.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/decryp {D:/Programme/Verilog/AES/src/decryp/subColMix_inverse.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/decryp {D:/Programme/Verilog/AES/src/decryp/subByte_rowShift_inverse.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/decryp {D:/Programme/Verilog/AES/src/decryp/roundFunc_inverse.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/decryp {D:/Programme/Verilog/AES/src/decryp/roundFunc_10_inverse.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/decryp {D:/Programme/Verilog/AES/src/decryp/colMix_keyAdd_inverse.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/decryp {D:/Programme/Verilog/AES/src/decryp/AES_decryp.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/encryp {D:/Programme/Verilog/AES/src/encryp/subColMix.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/encryp {D:/Programme/Verilog/AES/src/encryp/subByte_rowShift.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/encryp {D:/Programme/Verilog/AES/src/encryp/roundFunc_10.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/encryp {D:/Programme/Verilog/AES/src/encryp/roundFunc.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/encryp {D:/Programme/Verilog/AES/src/encryp/keyExp.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/encryp {D:/Programme/Verilog/AES/src/encryp/colMix_keyAdd.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES/src/encryp {D:/Programme/Verilog/AES/src/encryp/AES_encryp_top.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES {D:/Programme/Verilog/AES/rom_2p.v}
vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES {D:/Programme/Verilog/AES/rom_2p_inverse.v}

vlog -vlog01compat -work work +incdir+D:/Programme/Verilog/AES {D:/Programme/Verilog/AES/AES_top_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclone10lp_ver -L rtl_work -L work -voptargs="+acc"  AES_top_tb

add wave *
view structure
view signals
run 3 us
