quit -sim

vlib work;
        
vlog -f run.f

vsim work.tb_uart_tx -Lf 220model -Lf altera_mf_ver -Lf verilog -Lf cycloneive_ver