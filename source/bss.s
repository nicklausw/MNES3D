  .arch armv6k
  .fpu vfp
  .arm
  .align  2

  @ macro for easy variable declaration
  .macro variable name size
    .global \name
    .type \name, %object
    .size \name, \size
    \name:
      .space \size
  .endm

  .bss
   variable frame, 4
   
   @ 512 kib * 2 + iNES = biggest nes rom?
   variable rom_data, (524288*2)+16
