#! /usr/bin/python

version = "Electra_IC_Wave_Gen_v01"

print("Hex values for version information.")
for letter in version:
	print('X"' + str( hex(ord(letter))[2:]) + '\", ')

print("-"*48)

baudrates = ["115200"," 57600", " 38400", " 19200", "  9600", "  4800", "  2400", "  1200"]
print("Hex values for baudrate array.")
for baud in baudrates:
	for letter in baud:
		print('X\"' + hex(ord(letter))[2:] + '\", ') 
	print("")





