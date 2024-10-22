#!/bin/bash

components=("registers" "alu")

mkdir -p sim
rm -rf sim/*

for comp in "${components[@]}"
do
    echo "Simulating $comp..."
    ghdl -a src/*.vhdl
    ghdl -a testbenches/${comp}_tb.vhdl
    ghdl -e ${comp}_tb
    ghdl -r ${comp}_tb --vcd=sim/${comp}.vcd
    echo "Simulation of $comp completed. VCD file: sim/${comp}.vcd"
done
