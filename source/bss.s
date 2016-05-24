  .arch armv6k
  .fpu vfp
  .arm
  .align  2
  
  #include "macros.h"
  
  .bss
   variable frame, 4
   
   @ 512 kib * 2 + iNES = biggest nes rom?
   variable rom_data, (8192*3)+16
   
   @ emulation variables
   variable offset, 4
   variable pc_emu, 4
   variable temp_space, 4
   variable opcode, 1
   variable status_reg, 1
   variable reg_a, 1
   variable reg_x, 1
   variable reg_y, 1
   