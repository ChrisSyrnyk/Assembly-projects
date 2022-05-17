#Christopher Syrnyk
#November 23 2021
#assigbment 5 assemby file
#contains functions for main() as well as global variables in a5Main.c

#strings
        displayNumber:  .asciz  "\n number: %d \n"
        pushError:      .asciz  "\n error: stack full \n"
        popError:       .asciz  "\n error: stack empty \n"
        ungetchError:   .asciz  "\n ungetch: too many characters \n"


#global variables
        MAXOP = 20      //define MAXOP
        NUMBER = 0      //define NUMBER
        TOOBIG = 9      //define TOOBIG
        MAXVAL = 100    //define MAXVAL
        BUFSIZE = 100   //define BUFSIZE
        sp = 0          //int sp
        bufp = 0        //int bufp

#arrays
        #int val[MAXVAL];
        val_x = MAXVAL                                  //number of elements in array
        val_type = 4                                    //int size = 4bytes
        val_size = val_x * val_type
        val_alloc = -(16+val_size)&-16
        val_dealloc = -val_alloc

        #char buf[BUFSIZE];
        buf_x = BUFSIZE                                 //number of elements in array
        buf_type = 1                                    //char size = 1byte 
        buf_size = buf_x * buf_type
        buf_alloc = -(16+buf_size)&-16
        buf_dealloc = -buf_alloc

#functions


#main

        .balign 4                                               //set align
        .global main                                            //make main label global

main:   stp     x29,    x30,    [sp, -16]!                    //alocate space
        mov     x29,    sp                                      //update frame register

        mov     x2,     5                                       //pass integer through
        bl      push                                           //function call

        bl      pop

        bl      clear

        bl      getop

        bl      getch

        bl      ungetch

exit:
        ldp     x29,    x30,    [sp],   16                 //deallocate space
        ret                                                     //return



push:  stp     x29,    x30,    [sp,    -16]!                   //allocate space for function
        mov     x29,    sp                                      //update frame register
        #str     x19,    [x29,  x19_save]                       
        mov     x20,    x2                                      //store int passed through

        #function body
        cmp     sp,     MAXVAL
        b.ge    pushElse
        //return val[sp++] = f;
        bl      pushExit
pushElse:
        ldr     x0,     =pushError
        bl      printf
        //clear();
        //return 0

        ldr     x0,     =displayNumber
        mov     x1,     sp
        bl      printf

        ldr     x0,     =displayNumber
        mov     x1,     MAXVAL
        bl      printf

pushExit:
        #ldr     x19,    [x29,   x19_save]                      
        ldp     x29,    x30,    [sp],   16                      //dealloc
        ret

pop:    stp     x29,    x30,    [sp,    -16]!
        mov     x29,    sp

        #function body
        cmp     sp,     0
        b.le popElse
        //return val[--sp];
        bl      popExit
popElse:
        ldr     x0,     =popError
        bl      printf
        //clear();
        //return 0;
        //exit pop
popExit:
        ldp     x29,    x30,    [sp],   16
        ret

clear:
        stp     x29,    x30,    [sp,    -16]!
        mov     x29,    sp
        //sp = 0
        ldp     x29,    x30,    [sp],   16
        ret
//----------------------------------------------------------------
getop:
        stp     x29,    x30,    [sp,    -16]!
        mov     x29,    sp
        //function body
        //create int i and int c
        //set c = getch()
        //while c == ' ' || c == '\t' || c == '\n'
        //if (c<'0' || c > '9'){return c}


        //exit
getopExit:
        ldp     x29,    x30,    [sp],   16
        ret
//-----------------------------------------------------------------

getch:
        stp     x29,    x30,    [sp,    -16]!
        mov     x29,    sp
        //function body
        //return bufp > 0 ? buf[--bufp] : getchar();
        ldp     x29,    x30,    [sp],   16
        ret
ungetch:
        stp     x29,    x30,    [sp,    -16]!
        mov     x29,    sp
        //function body
        mov     x2,     bufp
        cmp     x2,     BUFSIZE
        b.le    ungetchElse
        ldr     x0,     ungetchError
        bl      printf
        bl      ungetchExit
ungetchElse:
        //buf[bufp++] = c;
ungetchExit:
        ldp     x29,    x30,    [sp],   16
        ret
