all: synthesis part map place_route bitgen

synthesis:
	@echo -n "Synthesis..."
	@echo "run -ifn nexys2.prj -ifmt mixed -ofn nexys2 -p xc3s500e-5-fg320 -opt_mode Speed -opt_level 1 -top toplevel" | xst &> log/xst.log
	@echo "done"

part:
	@echo -n "Partitioning..."
	@ngdbuild -p xc3s500e-5-fg320 -uc constraints/nexys2.ucf nexys2.ngc &> log/ngdbuild.log
	@echo "done"

map:
	@echo -n "Mapping..."
	@map -detail -pr b nexys2.ngd &> log/map.log
	@echo "done"

place_route:
	@echo -n "Placing and routing..."
	@par -w nexys2.ncd parout.ncd constraints/nexys2.pcf &> log/par.log
	@echo "done"

bitgen:
	@echo -n "Bitfile generation..."
	@bitgen -w -g StartUpClk:JtagClk -g CRC:Enable parout.ncd nexys2.bit constraints/nexys2.pcf &> log/bitgen
	@echo "done"

program: all
	@sudo djtgcfg prog -d Nexys2 -i 0 -f nexys2.bit 

clean:
	@echo -n "Cleaning..."
	@rm -rf netlist.lst nexys2.bgn nexys2.bit nexys2_bitgen.xwbt nexys2.bld 	\
		nexys2.drc nexys2.map nexys2.mrp nexys2.ncd nexys2.ngc nexys2.ngd 	\
		nexys2_ngdbuild.xrpt nexys2.ngm nexys2.pcf nexys2_summary.xml		\
		nexys2_usage.xml nexys2_xst.xrpt parout.ncd parout.pad parout_pad.csv	\
		parout_pad.txt parout.par parout.ptwx parout.unroutes parout.xpi	\
		toplevel.lso toplevel_map.xrpt toplevel_par.xrpt webtalk.log		\
		xlnx_auto_0_xdb _xmsgs xst log/*.log
	@echo "done"
