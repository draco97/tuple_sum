# tuple_sum
To output a tuple of three elements from an array where each triplet adds to 0

To run the C++ File:
Compile sum_checker.cc using your C++ compiler. The size and elements of the array are taken as command line input and the tuple of all the triplets that add up to 0 is the output.

Vivado Project:
The execeutable xpr file is added in the github. The project was created using the default settings.
Along with that the verilog modules and system verilog testbench are provided for behavioural simulation.
To change the array values open main/rom_256x8.v file and manually edit the array values.
The testbench currently checks for size 7 and then resets the module to check for size=4.
