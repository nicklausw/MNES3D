@ needed defines from libctru and stuff

#define VERSION "v0.1 [panda]"

#define GFX_TOP 0
#define GFX_BOTTOM 1

@ the sad truth...
#define NULL 0

@ controller stuff
#define KEY_A        0       @< A
#define KEY_B        1       @< B
#define KEY_SELECT   2       @< Select
#define KEY_START    3       @< Start
#define KEY_DRIGHT   4       @< D-Pad Right
#define KEY_DLEFT    5       @< D-Pad Left
#define KEY_DUP      6       @< D-Pad Up
#define KEY_DDOWN    7       @< D-Pad Down
#define KEY_R        8       @< R
#define KEY_L        9       @< L
#define KEY_X        10      @< X
#define KEY_Y        11      @< Y
#define KEY_ZL       14      @< ZL (New 3DS only)
#define KEY_ZR       15      @< ZR (New 3DS only)
#define KEY_TOUCH    20      @< Touch (Not actually provided by HID)
#define KEY_CSTICK_RIGHT  24 @< C-Stick Right (New 3DS only)
#define KEY_CSTICK_LEFT   25 @< C-Stick Left (New 3DS only)
#define KEY_CSTICK_UP     26 @< C-Stick Up (New 3DS only)
#define KEY_CSTICK_DOWN   27 @< C-Stick Down (New 3DS only)
#define KEY_CPAD_RIGHT  28   @< Circle Pad Right
#define KEY_CPAD_LEFT   29   @< Circle Pad Left
#define KEY_CPAD_UP     30   @< Circle Pad Up
#define KEY_CPAD_DOWN   31   @< Circle Pad Down

@ generic catch-all directions
#define KEY_UP     KEY_DUP    | KEY_CPAD_UP    @< D-Pad Up or Circle Pad Up
#define KEY_DOWN   KEY_DDOWN  | KEY_CPAD_DOWN  @< D-Pad Down or Circle Pad Down
#define KEY_LEFT   KEY_DLEFT  | KEY_CPAD_LEFT  @< D-Pad Left or Circle Pad Left
#define KEY_RIGHT  KEY_DRIGHT | KEY_CPAD_RIGHT @< D-Pad Right or Circle Pad Right