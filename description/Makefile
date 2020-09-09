
cover: challenge.v serial.v challenge.sby
	sby -f challenge.sby

gtkwave_cover: cover
	gtkwave challenge/engine_0/trace0.vcd challenge.gtkw

challenge.v: tpm2137.pcf challenge.asc 
	icebox_vlog -n top -p $^ > $@

challenge.asc: challenge.bit
	iceunpack $^ > $@ 

debug:
	iverilog -o challenge.out challenge.v challenge_tb.v
	vvp challenge.out -fst
	gtkwave test.vcd challenge.gtkw

dump_serial_vcd_orig:
	iverilog -DTEST_SERIAL -o serial.out serial.v ../generate/challenge.v -I../generate
	vvp serial.out -vcd

dump_serial_vcd: challenge.v
	iverilog -DTEST_SERIAL -o serial.out serial.v challenge.v
	vvp serial.out -vcd

gtkwave_serial:
	gtkwave test.vcd serial.gtkw

decode: dump_serial_vcd
	~/Downloads/sigrok-cli-0.7.1-x86_64.AppImage -i test.vcd -P uart:rx=tx:baudrate=115200 -A uart=rx-data

clean:
	rm -f challenge.v challenge.asc test.vcd
