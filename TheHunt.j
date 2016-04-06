;
; Cliff Chandler
; 
; A game written in assembly for the JVM
;
; The objective is to find the monster without dieing
; and shoot an arrow into the room with the monster
;

.class public TheHunt
.super java/lang/Object
  .field private static final rows I = 20
  .field private static final columns I = 20
  .field private static final gridSize I = 400
  
  .field private static final pit I = 1
  .field private static final monster I = 2
  
 ;possible endings - determined by player_state
  .field private static final quit I = -1
  .field private static final deathByPit I = 1
  .field private static final deathByMonster I = 2
  .field private static final deathByAttrition I = 3
  .field private static final victory I = 4
  .field private static player_state I = 0
  
 ;possible values at visited locations
  .field private static final bothWarning I = 21
  .field private static final monsterWarning I = 19
  .field private static final pitWarning I = 17
  .field private static final visited I = 15
  .field private static final player I = 13
  
  .field private static currentPosition I
  .field private static arrowCount I = 1
  
 ;keys to move
  .field private static w I = 119 ; 'w'
  .field private static a I = 97  ; 'a'
  .field private static s I = 115 ; 's'
  .field private static d I = 100 ; 'd'
  
 ;keys to shoot
  .field private static i I = 105 ; 'i'
  .field private static j I = 106 ; 'j'
  .field private static k I = 107 ; 'k'
  .field private static l I = 108 ; 'l'
  

.method public <init>()V
    Code:
       aload_0       
       invokespecial     java/lang/Object/<init>()V
       return
.end method

;MAIN ----------------------------------------------------------
.method public static main([Ljava/lang/String;)V
    .limit stack 4
    .limit locals 4 ;astore_0       istore_1        astore_2        istore_3
                    ;hidden grid    int for loop    StreamReader    key pressed
    
    ;setup at runtime
    invokestatic hmwk4/init()[I
    astore_0
    new             java/io/InputStreamReader
    dup
    getstatic       java/lang/System/in Ljava/io/InputStream;
    invokespecial   java/io/InputStreamReader/<init>(Ljava/io/InputStream;)V
    dup
    astore_2
    invokestatic hmwk4/printIntro()V
    invokevirtual   java/io/InputStreamReader/read()I
    pop
    ;done with setup
    
  gameLoop:
    
    getstatic hmwk4/player_state I
    lookupswitch
        -1 : exit
        1 : killedByPit
        2 : killedByMonster
        3 : deathByAttrition
        4 : victory
        default : continue

  continue:
    aload_0   
    invokestatic hmwk4/printGrid([I)V    
    aload_0
    invokestatic hmwk4/printWarning([I)V
    aload_2    
    invokestatic hmwk4/keyPressed(Ljava/io/InputStreamReader;)I
    aload_0
    invokestatic hmwk4/move(I[I)[I
    astore_0
    goto gameLoop

  victory:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "Having slain the monster, your legacy will be one for the ages."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end

  deathByAttrition:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "Unarmed, it is only a matter of time before the monster finds you."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end

  killedByMonster:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "The monster has killed you."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end
    
  killedByPit:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "You fell into a pit."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end
    
  exit:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "You gave up."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    
  end:
    aload_2     
    invokevirtual   java/io/InputStreamReader/close()V
    return
.end method ;main

;PRINT INTRO -----------------------------------------------------------
.method private static printIntro()V
    .limit stack 2
    .limit locals 1
    
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "\t\t\tINSTRUCTIONS\n"
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "OBJECTIVE: To shoot an arrow into the room containing the monster without entering that room.\n"
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "CONTROLS: Controls will be displayed to the right of the grid. Type the appropiate key and press enter.\n"
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "WAYS TO DIE: Entering a room with a pit, entering the room with the monster, or missing the monster with your arrow (you only get one).\n"
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "HINTS: There will be a hint below the grid each time you move indicating what hazards may be in your immediate vicinity.\n"
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "TROUBLESHOOTING: If you accidentally type an incorrect character, try pressing enter again, and then type the correct key followed by the enter key.\n"
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "Press enter to continue..."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    
    return

.end method ;printIntro

;GET ABOVE --------------------------------------------------------------
;return value above current position
.method private static getAbove([I)I
    .limit stack 3
    .limit locals 2     ;astore_0   istore_1
                        ;grid       index above
    
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/columns I
    isub
    istore_1    ;index
    
    ;check if negative
    iload_1
    iconst_0
    if_icmpge getValue
        iload_1
        getstatic hmwk4/gridSize I
        iadd
        istore_1
    
  getValue:   
    aload_0
    iload_1
    iaload
    ireturn
.end method ;getAbove

;GET BELOW --------------------------------------------------------------
;return value below current position
.method private static getBelow([I)I
    .limit stack 3
    .limit locals 2     ;astore_0   istore_1
                        ;grid       index below
    
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/columns I
    iadd
    istore_1    ;index
    
    ;check if out of bounds
    iload_1
    getstatic hmwk4/gridSize I
    if_icmplt getValue
        iload_1
        getstatic hmwk4/gridSize I
        isub
        istore_1
    
  getValue:
    aload_0
    iload_1
    iaload
    ireturn
.end method ;getBelow

;GET LEFT --------------------------------------------------------------
;return value left of current position
.method private static getLeft([I)I
    .limit stack 2
    .limit locals 2     ;astore_0   istore_1
                        ;grid       index left
    
    getstatic hmwk4/currentPosition I
    iconst_m1
    iadd
    istore_1
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/columns I
    irem
    iconst_0
    if_icmpeq jumpAcross
        goto getValue
  jumpAcross:
    getstatic hmwk4/columns I
    iload_1
    iadd
    istore_1
    
  getValue:
    aload_0
    iload_1
    iaload
    ireturn
.end method ;getLeft

;GET RIGHT --------------------------------------------------------------
;return value right of current position
.method private static getRight([I)I
    .limit stack 2
    .limit locals 2     ;astore_0   istore_1
                        ;grid       index right
    
    getstatic hmwk4/currentPosition I
    iconst_1
    iadd
    istore_1
    iload_1
    getstatic hmwk4/columns I
    irem
    iconst_0
    if_icmpeq moveUp
        goto getValue
  moveUp:
    iload_1
    getstatic hmwk4/columns I
    isub
    istore_1
    
  getValue:
    aload_0
    iload_1
    iaload
    ireturn
.end method ;getRight

;PRINT WARNING
;calls warningCheck to determine appropriate message to display
.method private static printWarning([I)V
    .limit stack 2
    .limit locals 2     ;astore_0   istore_1
                        ;           value from warningCheck
    
    aload_0
    invokestatic hmwk4/warningCheck([I)I
    
    lookupswitch
        0 : safe
        1 : pitNearby
        2 : monsterNearby
        3 : bothNearby
        default : Error
        
  Error:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "Incorrect Value."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end
        
  safe:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "The way seems clear."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end
    
  pitNearby:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "You feel a breeze."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end
    
  monsterNearby:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "You see blood on the walls."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end
    
  bothNearby:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "There is a breeze, and with it, an odor of death."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
  
  end:
    return
.end method ;printWarning

;WARNING CHECK -----------------------------------------------------
;returns 0 if area is safe, 1 if a pit is nearby, 2 if the monster is nearby, and 3 if both are nearby
.method private static warningCheck([I)I
    .limit stack 3
    .limit locals 4     ;astore_0   istore_1        istore_2       istore_3     
                        ;grid       value nearby    pit nearby     monster nearby
    iconst_0
    dup
    istore_2
    istore_3
    
  ;check above
    aload_0
    invokestatic hmwk4/getAbove([I)I
    istore_1
    goto checkForPitAbove
  
  checkForPitAbove:
    iload_1
    iconst_1
    if_icmpne checkForMonsterAbove
        iconst_1
        istore_2
 
  checkForMonsterAbove:
    iload_1
    iconst_2
    if_icmpne checkBelow
        iconst_2
        istore_3
        
  checkBelow:
    aload_0
    invokestatic hmwk4/getBelow([I)I
    istore_1
    goto checkForPitBelow
  
  checkForPitBelow:
    iload_1
    iconst_1
    if_icmpne checkForMonsterBelow
        iconst_1
        istore_2
 
  checkForMonsterBelow:
    iload_1
    iconst_2
    if_icmpne checkLeft
        iconst_2
        istore_3
        
  checkLeft:
    aload_0
    invokestatic hmwk4/getLeft([I)I
    istore_1
    goto checkForPitLeft
  
  checkForPitLeft:
    iload_1
    iconst_1
    if_icmpne checkForMonsterLeft
        iconst_1
        istore_2
 
  checkForMonsterLeft:
    iload_1
    iconst_2
    if_icmpne checkRight
        iconst_2
        istore_3
        
  checkRight:
    aload_0
    invokestatic hmwk4/getRight([I)I
    istore_1
    goto checkForPitRight
  
  checkForPitRight:
    iload_1
    iconst_1
    if_icmpne checkForMonsterRight
        iconst_1
        istore_2
 
  checkForMonsterRight:
    iload_1
    iconst_2
    if_icmpne end
        iconst_2
        istore_3
        
  end:
    iload_2
    iload_3
    iadd
    ireturn
        
.end method ;warningCheck

;MOVEMENT ----------------------------------------------------------
.method private static move(I[I)[I
    .limit stack 4
    .limit locals 2     ;istore_0       astore_1
                        ;key pressed    grid
                        
    iload_0
    lookupswitch
        27 : quit
        105 : shootUp
        106 : shootLeft
        107 : shootDown
        108 : shootRight
        default : continue
        
  continue:    
    ;determine what to display in old spot
    aload_1
    invokestatic hmwk4/warningCheck([I)I
    lookupswitch
        0 : safe
        1 : pitNearby
        2 : monsterNearby
        3 : bothNearby
        default : Error
        
  Error:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc     "Incorrect Value."
    invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
    goto end
        
  ;change position you moved from
  safe:
    aload_1
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/visited I
    iastore         ;change value at players current position to visited value
    goto doneWithOld
    
  pitNearby:
    aload_1
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/pitWarning I
    iastore         ;change value at players current position to pit warning value
    goto doneWithOld
    
  monsterNearby:
    aload_1
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/monsterWarning I
    iastore         ;change value at players current position to monster warning value
    goto doneWithOld
    
  bothNearby:
    aload_1
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/bothWarning I
    iastore         ;change value at players current position to both warning value
    goto doneWithOld
 
  doneWithOld:
  
  ;handle key presses
  
    iload_0
    lookupswitch
        97 : moveLeft
        100 : moveRight
        115 : moveDown
        119 : moveUp
        default : end
        
  quit:
    getstatic hmwk4/quit I
    putstatic hmwk4/player_state I
    goto end
    
  moveRight:
    getstatic hmwk4/currentPosition I
    iconst_1
    iadd
    putstatic hmwk4/currentPosition I
    
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/columns I
    irem
    iconst_0
    if_icmpeq moveUp
        goto checkNewRoom
  ;rightward movement done
  
  moveLeft:    
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/columns I
    irem
    iconst_0
    if_icmpeq jumpAcross
        getstatic hmwk4/currentPosition I
        iconst_m1
        iadd
        putstatic hmwk4/currentPosition I
        goto checkNewRoom
  jumpAcross:
    getstatic hmwk4/currentPosition I
    iconst_m1
    getstatic hmwk4/columns I
    iadd
    iadd
    putstatic hmwk4/currentPosition I
    goto checkNewRoom
  ;leftward movement done  
  
  moveDown:
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/columns I
    iadd
    putstatic hmwk4/currentPosition I
    
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/gridSize I
    if_icmpge over400
        goto checkNewRoom
  over400:
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/gridSize I
    isub
    putstatic hmwk4/currentPosition I
    goto checkNewRoom
  ;downward movement done
  
  moveUp:
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/columns I
    isub
    putstatic hmwk4/currentPosition I
    
    getstatic hmwk4/currentPosition I
    iconst_0
    if_icmplt negative
        goto checkNewRoom
  negative:
    getstatic hmwk4/gridSize I
    getstatic hmwk4/currentPosition I
    iadd
    putstatic hmwk4/currentPosition I
    goto checkNewRoom
  ;upward movement done
  
  shootUp:
    aload_1
    invokestatic hmwk4/getAbove([I)I
    getstatic hmwk4/monster I
    if_icmpeq victory
        goto attrition
        
  shootLeft:
    aload_1
    invokestatic hmwk4/getLeft([I)I
    getstatic hmwk4/monster I
    if_icmpeq victory
        goto attrition
        
  shootDown:
    aload_1
    invokestatic hmwk4/getBelow([I)I
    getstatic hmwk4/monster I
    if_icmpeq victory
        goto attrition
        
  shootRight:
    aload_1
    invokestatic hmwk4/getRight([I)I
    getstatic hmwk4/monster I
    if_icmpeq victory
        goto attrition
        
  victory:
    getstatic hmwk4/victory I
    putstatic hmwk4/player_state I
    goto end
    
  attrition:
    getstatic hmwk4/deathByAttrition I
    putstatic hmwk4/player_state I
    goto end
  
  checkNewRoom:
    aload_1
    getstatic hmwk4/currentPosition I
    iaload
    lookupswitch
        1 : deathByPit
        2 : deathByMonster
        default : end
  deathByPit:
    getstatic hmwk4/deathByPit I
    putstatic hmwk4/player_state I      ;change player state to "killed by pit"
    goto end
  deathByMonster:
    getstatic hmwk4/deathByMonster I
    putstatic hmwk4/player_state I      ;change player state to "killed by monster"
  end:
    aload_1
    getstatic hmwk4/currentPosition I
    getstatic hmwk4/player I
    iastore     ;store player into array at new position
    aload_1
    areturn
.end method

;KEY PRESSED --------------------------------------------------
;get user input
.method private static keyPressed(Ljava/io/InputStreamReader;)I
    .limit stack 3
    .limit locals 2  
         
    aload_0      
    invokevirtual   java/io/InputStreamReader/read()I
    istore_1
    aload_0
    iconst_1
    i2l
    invokevirtual java/io/Reader/skip(J)J
  
    iload_1
    ireturn
.end method

;PRINT GRID --------------------------------------------------
;print the array in the parameters
.method private static printGrid([I)V
    .limit stack 3
    .limit locals 3 ;astore_0   istore_1    istore_3
                    ;parameter  index       value at index
    
    ;print grid
    iconst_0
    istore_1

    ;trying to clear screen
    ;getstatic       java/lang/System/out Ljava/io/PrintStream;
    ;bipush 12
    ;invokevirtual   java/io/PrintStream.print(C)V
    
  loop:
    iload_1
    iconst_0
    if_icmpeq skipTo
    iload_1
    getstatic hmwk4/columns I
    irem
    iconst_0
    if_icmpne skipTo      ;print newline every for each row
        iload_1
        getstatic hmwk4/rows I
        idiv
        lookupswitch
            1 : help_1  ;controls
            3 : help_2  ;to move
            5 : help_3  ;w
            6 : help_4  ;a
            7 : help_5 ;s
            8 : help_6 ;d
            11 : help_7 ;to shoot
            13 : help_8 ;i
            14 : help_9 ;j
            15 : help_10 ;k
            16 : help_11 ;l
            18 : help_12 ;quit
            default : newLine
      help_1:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " CONTROLS"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_2:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " To move:"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_3:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " w - up"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_4:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " a - left"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_5:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " s - down"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_6:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " d - right"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_7:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " To shoot:"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_8:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " i - up"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_9:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " j - left"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_10:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " k - down"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_11:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " l - right"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      help_12:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     " esc - quit"
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        goto skipTo
      newLine:
        getstatic       java/lang/System/out Ljava/io/PrintStream;
        ldc     ""
        invokevirtual   java/io/PrintStream.println(Ljava/lang/String;)V
        
  skipTo:
    iload_1
    getstatic hmwk4/gridSize I          ;checking the loop condition here means the code
    if_icmpge end                       ;above prints a new line when the grid is finished
    
    aload_0
    iload_1
    iaload
    istore_2    ;store value at current index
    
    iload_2
    lookupswitch
        0 : empty
        1 : empty
        2 : empty
        13 : player     ;13 == getstatic hmwk4/player I
        15 : visited    ;15 == getstatic hmwk4/visited I
        17 : warning    ;17 == getstatic hmwk4/pitWarning I
        19 : warning    ;19 == getstatic hmwk4/monsterWarning I
        21 : warning    ;21 == getstatic hmwk4/bothWarning I
        default : increment

  warning:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc " ! "
    invokevirtual   java/io/PrintStream.print(Ljava/lang/String;)V
    goto increment
  empty:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc "[ ]"
    invokevirtual   java/io/PrintStream.print(Ljava/lang/String;)V
    goto increment
  visited:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc " - "
    invokevirtual   java/io/PrintStream.print(Ljava/lang/String;)V
    goto increment
  player:
    getstatic       java/lang/System/out Ljava/io/PrintStream;
    ldc " P "
    invokevirtual   java/io/PrintStream.print(Ljava/lang/String;)V
  increment:
    iinc 1 1
    goto loop
  ;finished printing grid
    
  end:
    return
.end method

;INIT ---------------------------------------------
;create the original (hidden) grid with random pits, the monster, and the player
.method private static init()[I
    .limit stack 4
    .limit locals 5     ;astore_0   istore_1        astore_2        istore_3        istore 4
                        ;grid       milliseconds    random array    various uses    empty or pit
    ;init array
    getstatic hmwk4/gridSize I
    newarray int
    astore_0
    
    ;get current milliseconds from calendar
    invokestatic     java/util/Calendar/getInstance()Ljava/util/Calendar;   
    bipush 14       ;constant representative for milliseconds 
    invokevirtual    java/util/Calendar/get(I)I
    istore_1
    
    ;create random number generator seeded with milliseconds from current time
    new              java/util/Random
    dup           
    iload_1         ;load milliseconds
    i2l           
    invokespecial    java/util/Random/<init>(J)V
    astore_2
    iconst_0      
    istore_3   
    
    ;initialize array with random PITS
  loop:
    iconst_0
    istore 4        
    iload_3       
    getstatic hmwk4/gridSize I
    if_icmpge    finishedInit
    aload_2                                         ;put random array on stack
    invokevirtual   java/util/Random/nextInt()I     ;put random int on stack
    bipush 8
    irem                                            ;put random%8 on stack
    iconst_0
    if_icmpne notPit
      iconst_1
      istore 4
  notPit:
    aload_0
    iload_3
    iload 4     ;default is 0
    iastore
    
    iinc 3 1
    goto loop
  finishedInit:
    ;local variable 3 is available
  
    ;add MONSTER here, can be anywhere, overwrites pit if present
    aload_2         ;get random instance on the stack
    invokevirtual   java/util/Random/nextInt()I
    getstatic hmwk4/gridSize I
    irem
    istore_3
    
    iload_3
    iconst_0
    if_icmpgt   positive_m    ;make sure index is positive
        iconst_m1
        iload_3
        imul
        istore_3
  positive_m:
    aload_0
    iload_3
    iconst_2             ;2 will represent the monster
    iastore
  
  ;add PLAYER location here (array value of player location must be 0)
  addPlayer:
    aload_2         ;get random instance on the stack
    invokevirtual   java/util/Random/nextInt()I
    getstatic hmwk4/gridSize I
    irem
    istore_3
    
    iload_3
    iconst_0
    if_icmpgt   positive_p    ;make sure index is positive
        iconst_m1
        iload_3
        imul
        istore_3
  positive_p:
    ;check if monster is present (just overwrite pits)
    aload_0
    iload_3
    iaload
    iconst_2
    if_icmpeq   addPlayer
    
    ;store player in array
    aload_0
    iload_3
    getstatic hmwk4/player I
    iastore
    ;store index of player position
    iload_3
    putstatic hmwk4/currentPosition I
    
  end:
    aload_0
    areturn

.end method
