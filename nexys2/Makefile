all:
	cd build/
	cp *.v nexys2.* build/
	echo "run -ifn nexys2.prj -ifmt mixed -ofn nexys2 -p xc3s500e-5-fg320 -opt_mode Speed -opt_level 1 -top toplevel" | xst
	ngdbuild -p xc3s500e-5-fg320 -uc ../nexys2.ucf nexys2.ngc 
	map -detail -pr b nexys2.ngd 
	par -w nexys2.ncd parout.ncd ../nexys2.pcf 
	bitgen -w -g StartUpClk:JtagClk -g CRC:Enable parout.ncd nexys2.bit ../nexys2.pcf
	mv nexys2.bit ../
	cd ../

program:
	@echo -n "Programming device..."	
	sudo djtgcfg prog -d Nexys2 -i 0 -f nexys2.bit 
	@echo "done"

clean:
	@echo -n "Cleaning..."
	@rm -rf nexys2* xst/ _xmsgs/
	@echo "done"

