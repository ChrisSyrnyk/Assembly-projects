        originalHex:    .asciz "(original: %0x, "                               //output string one     
        originalBinary: .asciz  "1111111110000000111111111 | "                //output string two
        reversedHex:    .asciz  "reversed: %x, "                                //output string three
        reversedBinary: .asciz  "11111111100000001111111110000000) \n"            //output string four


        .string  "%s\n"
        .balign 4                                                               //set align
        .global main                                                            //make main label global

main:                                                                           //main flag
        stp     x29,    x30,    [sp,-16]!                                       //save fp register and link register current 

        //define macros
        define(xvalue,  w19)                                                    //define register
        define(t1,      w20)                                                    //define register
        define(t2,      w21)                                                    //define register
        define(yvalue,  w22)                                                    //define register
        define(t3,      w24)                                                    //define register
        define(t4,      w25)                                                    //define register


        mov     xvalue,    0x01FF01FF                                           //load x value

        //x1 = 0x07FC07FC, x2 = 0x7F807F80 x3= 0x01FF01FF
step1:                                                                          //step one flag
        //generate t1
        mov     t1,     0x55555555                                              //load value
        and     t1,     t1,     xvalue                                          //and logical operator
        lsl     t1,     t1,     1                                               //logical shift left 1
        //generate t2
        mov     t2,     0x55555555                                              //load value
        mov     w23,    xvalue                                                  //load x value
        lsr     w23,    w23,    1                                               //logical shift right 1
        and     t2,     t2,     w23                                             //and logical operator
        //t1 or t2
        eor     yvalue, t1,     t2                                              //store in y (t1 | t2)          

step2:
        //generate t1
        mov     w23,    0x33333333                                              //load value
        and     t1,     w23,    w22                                             //and logical operator
        lsl     t1,     t1,     2                                               //logical shift left 2
        //generate t2                           
        lsr     t2,     yvalue, 2                                               //logical shift right 2
        and     t2,     t2,     w23                                             //and logical operator
        //t1 or t2
        eor     yvalue, t1,     t2                                              //store in y (t1 | t2)

step3:
        //generate t1
        mov     w23,    0x0F0F0F0F                                              //load value
        and     t1,     yvalue, w23                                             //and logical operator
        lsl     t1,     t1,     4                                               //logical shift left 4
        //generate t2                                           
        lsr     t2,     yvalue, 4                                               //logical shift right 4
        and     t2,     t2,     w23                                             //and logcial operator
        //t1 or t2
        eor     yvalue, t1,     t2                                              //store in y (t1 | t2)

step4:
     //generate t1
        lsl     t1,     yvalue, 24                                              //logical shift left
        //generate t2           
        mov     w23,    0xFF00                                                  //load value
        and     t2,     yvalue, w23                                             //and logical operator
        lsl     t2,     t2,     8                                               //logical shift left 8
        //generate t3
        lsr     t3,     yvalue, 8                                               //logical shift right 8
        and     t3,     t3,     w23                                             //and logical operator
        //genereate t4
        lsr     w25,    yvalue, 24                                              //logical shift right 24
        //generate y                                    
        eor     w26,    t3,     t4                                              //exclusive or logical operator
        eor     w27,    t2,     w26                                             //exclusive or logical operator
        eor     yvalue, t1,     w27                                             //exclusive or logical operator

        //print
        ldr     x0,     =originalHex                                            //load statement
        mov     x1,     x19                                                     //load value
        bl      printf                                                          //print

        //print
        ldr     x0,     =originalBinary                                         //load statement
        mov     x1,     x19                                                     //load value    
        bl      printf                                                          //print

         //print
        ldr     x0,     =reversedHex                                            //load statement
        mov     x1,     x22                                                     //load value
        bl      printf                                                          //print

        //print
        ldr     x0,     =reversedBinary                                         //load statement
        mov     x1,     x22                                                     //load value
        bl      printf                                                          //print

exit:                                                                           //exit flag
        ldp     x29,    x30,    [sp], 16                                        //restore fp and link registers
        ret
