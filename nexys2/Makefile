all: synthesis part map place_route bitgen

synthesis:
	@echo -n "Synthesis..."
	@echo "run -ifn nexys2.prj -ifmt mixed -ofn nexys2 -p xc3s500e-5-fg320 -opt_mode Speed -opt_level 1 -top toplevel" | xst &> log/xst.log
	@echo "done"

part:
	@echo -n "Partitioning..."
	@ngdbuild -p xc3s500e-5-fg320 -uc nexys2.ucf nexys2.ngc &> log/ngdbuild.log
	@echo "done"

map:
	@echo -n "Mapping..."
	@map -detail -pr b nexys2.ngd &> log/map.log
	@echo "done"

place_route:
	@echo -n "Placing and routing..."
	@par -w nexys2.ncd parout.ncd nexys2.pcf &> log/par.log
	@echo "done"

bitgen:
	@echo "Bitfile generation..."
	@bitgen -w -g StartUpClk:JtagClk -g CRC:Enable parout.ncd nexys2.bit nexys2.pcf &> log/bitgen
	@echo "done"

program:
	@echo -n "Programming device..."	
	@sudo djtgcfg prog -d Nexys2 -i 0 -f nexys2.bit 
	@echo "done"

clean:
	@echo -n "Cleaning..."
	@rm -rf nexys2* xst/ _xmsgs/
	@echo "done"
