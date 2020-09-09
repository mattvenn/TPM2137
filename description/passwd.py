#!/usr/bin/python3
#passwd = "hackme12"
#for p in passwd:
#    char = ord(p)
#    print('{0} 0x{1:02x} 0b{2:08b} d{3:3d}'.format(chr(char), char, char, char))
import sys
passwd = int(sys.argv[1], 16)
print(hex(passwd))
for i in range(8):
    char = passwd & 0xFF
    print('{0} 0x{1:02x} 0b{2:08b} d{3:3d}'.format(chr(char), char, char, char))
    passwd = passwd >> 8
