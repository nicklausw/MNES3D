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