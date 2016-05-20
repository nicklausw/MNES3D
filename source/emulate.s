  .arch armv6k
  .fpu vfp
  .arm
  .align  2
  
  #include "defines.h"
  #include "macros.h"

  .text
  
get_byte:
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

parse_opcode:
  ldr r1, =opt_table
  mov r3, #0
  
 .lookup_loop:
  ldrb r2, [r1]
  cmp r0, r2
  beq .lookup_done
  
  add r1, r1, #1
  add r3, r3, #1
  
  cmp r3, #opt_table_end-opt_table
  beq unknown_opcode
  
  b .lookup_loop
  
 .lookup_done:
  ldr r1, =opt_table_funcs
  cmp r3, #0
  beq .mult_done
  
 .mult_loop:
  add r1, r1, #4
  sub r3, r3, #1
  cmp r3, #0
  bne .mult_loop
  
 .mult_done:
  ldr pc, [r1]
  bx lr


globll emulate
  stmfd  sp!, {lr}
  
  bl get_byte
  
  @ we might need this later?
  ldr r1, =opcode
  strb r0, [r1]
  
  ldr r0, =opcode
  ldrb r1, [r0]
  ldr r0, =msg
  bl iprintf
  
  ldr r1, =opcode
  ldrb r0, [r1]
  bl parse_opcode
  
  ldmfd  sp!, {pc}
  bx lr


@ the opcode code
sei:
  ldr r1, =status_reg
  ldrb r0, [r1]
  orr r0, r0, #0b00000010
  strb r0, [r1]
  bx lr

cld:
  ldr r1, =status_reg
  ldrb r0, [r1]
  and r0, r0, #0b00001000
  strb r0, [r1]
  bx lr

.section .rodata
opt_table_funcs:
  .word sei, cld

msg:
  .ascii "opcode: 0x%02x\n\0"

opt_table:
  .byte 0x78, 0xD8
opt_table_end:
