BOARD=Nexys2
FPGA=xc3s500e-5-fg320
PROJECT=MessageParsing
TOPLEVEL_BLOCK=main

all: image.bit

${PROJECT}.ngc:
	@echo -n "Synthesis..."
	@echo "run -ifn ${PROJECT}.prj -ifmt mixed -ofn ${PROJECT} -p ${FPGA} -opt_mode Speed -opt_level 1 -top ${TOPLEVEL_BLOCK}" | xst &> log/xst.log
	@echo "done"

${PROJECT}.ngd: ${PROJECT}.ngc
	@echo -n "Partitioning..."
	@ngdbuild -p ${FPGA} -uc constraints/${PROJECT}.ucf $< &> log/ngdbuild.log
	@echo "done"

${PROJECT}.ncd: ${PROJECT}.ngd
	@echo -n "Mapping..."
	@map -detail -pr b $< &> log/map.log
	@echo "done"

parout.ncd: ${PROJECT}.ncd
	@echo -n "Placing and routing..."
	@par -w $< $@ constraints/${PROJECT}.pcf &> log/par.log
	@echo "done"

image.bit: parout.ncd
	@echo -n "Bitfile generation..."
	@bitgen -w -g StartUpClk:JtagClk -g CRC:Enable $< $@ constraints/${PROJECT}.pcf &> log/bitgen.log
	@mkdir -p bitfiles
	@cp image.bit bitfiles/${PROJECT}.bit
	@echo "done"

program: image.bit	
	@sudo djtgcfg prog -d ${BOARD} -i 0 -f bitfiles/${PROJECT}.bit

clean:
	@echo -n "Cleaning..."
	@rm -rf netlist.lst ${PROJECT}.bgn ${PROJECT}.bit ${PROJECT}_bitgen.xwbt ${PROJECT}.bld 	\
		${PROJECT}.drc ${PROJECT}.map ${PROJECT}.mrp ${PROJECT}.ncd ${PROJECT}.ngc ${PROJECT}.ngd 	\
		${PROJECT}_ngdbuild.xrpt ${PROJECT}.ngm ${PROJECT}.pcf ${PROJECT}_summary.xml		\
		${PROJECT}_usage.xml ${PROJECT}_xst.xrpt parout.ncd parout.pad parout_pad.csv	\
		parout_pad.txt parout.par parout.ptwx parout.unroutes parout.xpi	\
		toplevel.lso toplevel_map.xrpt toplevel_par.xrpt webtalk.log		\
		xlnx_auto_0_xdb _xmsgs xst log/*.log bitfiles/ image*
	@echo "done"
