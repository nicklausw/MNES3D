  .arch armv6k
  .fpu vfp
  .arm
  .align  2
  
  #include "macros.h"
  
  .text

globll romfs_failed
  ldr r0, =romfs_failure_message
  bl iprintf
  b failed_inf
  
globll invalid_header
  ldr r0, =header_failure_message
  bl iprintf
  b failed_inf

globll unknown_opcode
  stmfd  sp!, {lr}
  mov r1, r0
  ldr r0, =opcode_failure_message
  bl iprintf
  ldmfd  sp!, {lr}
  bx lr

globll failed_inf
   b failed_inf
