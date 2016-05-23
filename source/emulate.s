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
  
  @cmp r0, #0x78 ; beq sei
  @cmp r0, #0xd8 ; beq cld
  @cmp r0, #0x20 ; beq jsr
  
  @b unknown_opcode
  ldmfd  sp!, {lr}
  bx lr


@ the opcode code
sei:
  ldr r1, =status_reg
  ldrb r0, [r1]
  orr r0, r0, #0b00000010
  strb r0, [r1]
  ldmfd  sp!, {lr}
  bx lr

cld:
  ldr r1, =status_reg
  ldrb r0, [r1]
  and r0, r0, #0b00001000
  strb r0, [r1]
  ldmfd  sp!, {lr}
  bx lr

jsr:
  bl get_byte
  mov r1, r0
  bl get_byte
  lsl r0, #8
  orr r0, r1
  
  sub r0, r0, #0xC000
  add r0, r0, #0x10
  ldr r1, =offset
  str r0, [r1]
  
  mov r1, r0
  ldr r0, =msg
  bl iprintf
  
  ldmfd  sp!, {lr}
  bx lr
  
.section .rodata
opt_table_funcs:
  .word sei, cld, jsr

msg:
  .ascii "opcode: 0x%04x\n\0"

opt_table:
  .byte 0x78, 0xD8, 0x20, 0x00
opt_table_end:
