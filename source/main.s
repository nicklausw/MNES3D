  .arch armv6k
  .fpu vfp
  .arm
  .align  2
  
  #include "defines.h"

  .text

  .global  main
main:
  stmfd  sp!, {r4, lr}
  
  bl  gfxInitDefault
  
  @ set pc to $c000
  ldr r1, =pc_emu
  ldr r0, =0xc000
  str r0, [r1]
  
  @ set offset to 0x10
  ldr r1, =offset
  mov r0, #0x10
  str r0, [r1]
  
  
  movs r0, #GFX_BOTTOM
  movs r1, #NULL
  bl consoleInit
  
  @ let the world know we're okay
  ldr r0, =begin_msg
  bl iprintf
  
  @ now to load that rom!
  @ nesasm.nes.
  movs r0, #NULL
  bl romfsMount
  cmp r0, #0
  bne romfs_failed
  
  ldr r0, =romfs_success
  bl iprintf
  
  ldr r0, =rom_name
  ldr r1, =open_type
  bl fopen
  
  mov r3, r0
  mov r2, #1
  ldr r0, =rom_data
  ldr r1, =(8192*3)+16
  bl fread
  bl fclose
  
  ldr r0, =rom_load_success
  bl iprintf
  
  
  @ make sure is a nes file
  ldr r0, =rom_data
  ldr r1, =nes_header
  mov r4, #0
  
 .check_header:
  ldrb r2, [r0]
  ldrb r3, [r1]
  
  cmp r2, r3
  bne invalid_header
  
  add r0, r0, #1
  add r1, r1, #1
  add r4, r4, #1
  
  cmp r4, #3
  bne .check_header
  
loop: @ do {
  @ wait for vblank
  mov  r1, #1
  mov  r0, #2
  bl  gspWaitForEvent
  
  @ emulate, what else?
  bl emulate
  
  @ get input
  bl  hidScanInput
  
  @ leave if home pressed
  bl  hidKeysDown
  tst  r0, #8
  bne  done
  
  
  @ flush/swap framebuffers
  bl  gfxFlushBuffers
  bl  gfxSwapBuffers
  
  @ } while (aptMainLoop())
  bl  aptMainLoop
  cmp  r0, #0
  bne  loop
  
done:
  bl  gfxExit
  
  @ the program should never come
  @ here, unless home button pressed?
  @ this is equal to "return 0"
  mov  r0, #0
  ldmfd  sp!, {r4, pc}
