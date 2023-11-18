quit -sim

vlib work;
        
vlog -f run.f

vsim work.tb_carry_select_adder -Lf 220model -Lf altera_mf_ver -Lf verilog -Lf cycloneive_ver