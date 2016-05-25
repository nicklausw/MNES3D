  @ macro for easy variable declaration
  .macro variable name size
    .global \name
    .type \name, %object
    .size \name, \size
    \name:
      .space \size
  .endm

  @ global label macro
  .macro globll name
    .global \name
    .type \name,%function
    \name:
  .endm
  
  @ emulation macros
  .macro set_byte reg, byte_arg
    orr \reg, \reg, #1 << \byte_arg
  .endm
  
  .macro clear_byte reg, byte_arg
    and \reg, \reg, #~(1 << \byte_arg)
  .endm
  
  .macro end_instr
    mov r0, #0
    ldmfd  sp!, {lr}
    bx lr
  .endm
  
  .macro instr byte_name, instr_name
    cmp r0, #\byte_name ; beq \instr_name
  .endm
  