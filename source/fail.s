  .arch armv6k
  .fpu vfp
  .arm
  .align  2

  @ global label macro
  .macro globll name
    .global \name
    .type \name,%function
    \name:
  .endm


globll romfs_failed
  ldr r0, =romfs_failure_message
  bl iprintf
  b failed_inf
  
globll invalid_header
  ldr r0, =header_failure_message
  bl iprintf
  b failed_inf

globll failed_inf
   b failed_inf
