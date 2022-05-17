

        mov     lastX,  10                              //set register
        mov     currentX,       firstX                  //set register
        mov     xMax,   -10000                          //set register
        mov     yMax,   -10000                          //set register

//part one solve for -3x^4
outerloop:
        mov     counter,        0                               //zero counter
        mov     currentY,       currentX                        //set current y to be current x
innerloop:
        mul     currentY,       currentY,       currentX        //multiply
        cmp     counter,        2                               //compare to counter
        b.eq    part1b                                          //if equal
        add     counter,        counter,        1               //else add
        bl      innerloop                                       //jump to innerloop
part1b:
        mov     x25,    -3                                      //set register
        mul     currentY,       currentY,       x25             //multiply

//part2 add 267x^2

        mov     x25,    267                                     //load 267
        mul     x26,    currentX,       currentX                //load x^2
        madd    currentY,       x26,    x25,    currentY        //multiply x^2 by 267 and add current y

//part3 add 47x-43
        mov     x25,    47                                      //set register
        mov     x26,    -43                                     //set register
        madd    x25,    x25,    currentX,       x26             //multiply and add
        add     currentY,       currentY,       x25             //add 

//check max values
        cmp     yMax,       currentY                            //compare
        b.gt    displayInfo                                     //if greater than
        mov     xMax,   currentX                                //else set new xMax
        mov     yMax,   currentY                                //set new yMax

//print to console
displayInfo:


        ldr     x0,     =outputStr1                             //load string
        mov     x1,     currentX                                //load value for current x
        bl      printf                                          //print
        ldr     x0,     =outputStr2                             //load string
        mov     x1,     currentY                                //load value for current y
        bl      printf                                          //print
        ldr     x0,     =outputStr3                             //load string
        mov     x1,     xMax                                    //load value for x at current max
        bl      printf                                          //print
        ldr     x0,     =outputStr4                             //load string
        mov     x1,     yMax                                    //load value for y at current max
        bl      printf                                          //print

//outer loop check

        add     currentX,       currentX,       1               //add one to current x
        cmp     lastX,  currentX                                //compare current x to last x
        b.eq    exit                                            //if equal exit
        bl      outerloop                                       //else loop again





exit:                                                   //exit flag
        ldp     x29,    x30,    [sp], 16                //restore fp and link registers
        ret
