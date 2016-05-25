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


get_word:
  stmfd  sp!, {lr}
  
  bl get_byte
  mov r1, r0
  bl get_byte
  lsl r0, #8
  orr r0, r1
  
  ldmfd  sp!, {lr}
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
  
  instr 0x78, sei
  instr 0xd8, cld
  instr 0x20, jsr
  instr 0xad, lda_16_addr
  instr 0xa9, lda_8_imm
  instr 0xa2, ldx_8_imm
  instr 0x9d, sta_ind_x
  instr 0xd0, bne_x
  instr 0xe8, inx
  instr 0x8e, stx_nzp
  instr 0x8d, sta_nzp
  instr 0x9a, txs
  instr 0x10, bpl
  instr 0x60, rts
  
  bl unknown_opcode
  mov r0, #1
  ldmfd  sp!, {lr}
  bx lr


@ the opcode code
sei:
  ldr r1, =status_reg
  ldrb r0, [r1]
  orr r0, r0, #0b00000010
  strb r0, [r1]
  end_instr

cld:
  ldr r1, =status_reg
  ldrb r0, [r1]
  and r0, r0, #0b00001000
  strb r0, [r1]
  end_instr

jsr:
  ldr r0, =offset
  ldr r0, [r0]
  ldr r1, =temp_space
  str r0, [r1]
  
  bl get_word
  
  sub r0, r0, #0xC000
  add r0, r0, #0x10
  ldr r1, =offset
  str r0, [r1]
  
  end_instr
  
lda_16_addr:
  bl get_word
  
  @ probably 2002
  ldr r1, =0x2002
  cmp r0, r1
  bne .not_2002
  
  @ clear negative bit
  ldr r1, =status_reg
  ldrb r0, [r1]
  and r0, r0, #~(1 << 7)
  strb r0, [r1]
  
 .not_2002:
  
  end_instr
  
lda_8_imm:
  bl get_byte
  ldr r1, =reg_x
  strb r0, [r1]
  
  end_instr

ldx_8_imm:
  bl get_byte
  ldr r1, =reg_a
  strb r0, [r1]
  
  end_instr

sta_ind_x:
  bl get_byte
  bl get_byte
  end_instr

stx_nzp:
  bl get_byte
  bl get_byte
  end_instr

sta_nzp:
  bl get_byte
  bl get_byte
  end_instr

inx:
  ldr r1, =reg_x
  ldrb r0, [r1]
  add r0, r0, #1
  cmp r0, #0xFF+1
  bne .no_zero
  
  ldr r1, =status_reg
  ldrb r0, [r1]
  set_byte r0, 1
  strb r0, [r1]
  
  ldr r1, =reg_x
  mov r0, #0
  
 .no_zero:
  strb r0, [r1]
  
  end_instr

txs:
  @ the stack? who cares...
  end_instr

bne_x:
  bl get_byte
  
  ldr r2, =status_reg
  ldr r2, [r2]
  tst r2, #(1<<1)
  beq .no_jump
  
  @ broken
  ldr r2, =offset
  ldr r1, [r2]
  sub r1, r1, r0
  str r1, [r2]
  
 .no_jump:
  end_instr
  
bpl:
  @ automatic redirect
  bl get_byte
  
  end_instr
  
rts:
  ldr r0, =temp_space
  ldr r0, [r0]
  add r0, r0, #2
  ldr r1, =offset
  str r0, [r1]
  
  end_instr


.section .rodata

msg:
  .ascii "opcode: 0x%04x\n\0"
