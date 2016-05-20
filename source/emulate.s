  .arch armv6k
  .fpu vfp
  .arm
  .align  2
  
  #include "defines.h"
  #include "macros.h"

  .text
  
get_opcode:
  ldr r3, =rom_data
  ldr r4, =offset
  ldr r4, [r4]
  add r3, r3, r4
  ldrb r0, [r3]
  
  @ raise offset
  ldr r3, =offset
  ldr r4, [r3]
  add r4, r4, #1
  str r4, [r3]
  
  bx lr

globll emulate
  stmfd  sp!, {lr}
  
  bl get_opcode
  bl welp
  
  ldmfd  sp!, {pc}
  
  
welp:
  stmfd  sp!, {lr}
  
  mov r1, r0
  ldr r0,=testmsg
  bl iprintf
  
  ldmfd  sp!, {pc}

.section .rodata
testmsg:
  .ascii "%d \0"
