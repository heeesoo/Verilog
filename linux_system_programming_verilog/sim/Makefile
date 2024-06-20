SHELL = /bin/sh 
MAKEFILE = Makefile 

ifeq ($(MAKECMDGOALS),$(findstring $(MAKECMDGOALS), "" "all" "elab" "sim"))
	ifeq (, $(shell which iverilog)) 
	$(error iverilog not found.)
	endif
endif

ILOG = iverilog
ISIM = vvp 
#--------------------------------------------------------
TOP = tb_top 
# testbench 모듈 이름 
DIR_RTL = ../rtl
# rtl 파일이 저장되어 있는 폴더의 경로 
#--------------------------------------------------------
all: compile simulate
compile:
	($(ILOG) -o $(TOP).vvp -s $(TOP) -c run.f || exit -1) 2>&1 | tee compile.log

simulate: compile
	$(ISIM) -l vvp.log $(TOP).vvp
