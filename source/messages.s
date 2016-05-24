  .arch armv6k
  .fpu vfp
  .arm
  .align  2
  
  #include "defines.h"
  #include "macros.h"
  
  .text

  .section .rodata

globll begin_msg
  .ascii "MNES3D ", VERSION, "\n"
  .ascii "Start-up successful.\n\0"

globll romfs_failure_message
  .ascii "romfs initialization failed.\0"

globll header_failure_message
  .ascii "invalid iNES header.\0"

globll opcode_failure_message
  .ascii "unknown opcode: 0x%02x.\0"

globll romfs_success
  .ascii "romfs initialization successful.\n\0"

globll rom_load_success
  .ascii "nesasm.nes load successful.\n\0"

globll rom_name
  .ascii "romfs:/nesasm.nes\0"

globll open_type
  .ascii "rb\0"

globll nes_header
  .ascii "NES"
  .byte 0x1A
