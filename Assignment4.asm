#Christopher Syrnyk
#november 3rd 2021 4:06pm
#first try at assignment 4

        hello:  .asciz  "\n hello \n"
        ran:    .asciz  "\n function %d ran! \n"
        passTest:       .asciz  "\n number passed through: %d\n"

        False = 0                                               //define false
        True = 1                                                //define true

#......................................Structures..............................................................................

        #first structure        
        #define struct coord
        define(coord_base_r,    x19)                            //x19 holds base for struct coord
                int_a = 0                                       //int_a 4 bytes of memory for integer x
                int_b = 4                                       //int_b 4 bytes of memory for integer y
                coord_size = 8                                  //4+4
                coord_alloc = -(16+coord_size)&-16              //amount of space to alloc for structure
                coord_dealloc = - coord_alloc                   //deallocate 
                coord_s = 16


        #second structure
        #define structure size
        define(size_base_r,     x20)                            //x20 holds base for struct size
                int_w = 0                                       //int_w 4 bytes of memory for integer width
                int_l = 4                                       //int_h 4 bytes of memory for integer height
                size_size = 8                                   //4+4
                size_alloc = -(16+size_size)&-16                //amount of space to alloc for size
                size_dealloc = -size_alloc                      //deallocate
                size_s = 16

        #third structure
        #define structure pyramid
        define(pyramid_base_r,  x21)                            //x21 holds base for struct pyramid
                struct_coord_center = 0                         //8 bytes of memory for integer coord centre (int x and y)                      
                struct_size_base = 8                            //4 bytes of memory for integer size base (int w and l)
                int_h = 16                                      //4 bytes of memory for integer height
                int_v = 20                                      //4 bytes of memory for integer volume
                pyramid_size = 24                               //8+8+4+4
                pyramid_alloc = -(16+pyramid_size)&-16          //amount of space to alloc for pyramid
                pyramid_dealloc = - pyramid_alloc               //dealloc               


#......................................Main..................................................................................

        .balign 4                                               //set align
        .global main                                            //make main label global

main:   stp     x29,    x30,    [sp, -16]!                      //alocate space
        mov     x29,    sp                                      //update frame register


exit:
        ldp     x29,    x30,    [sp],   16                      //deallocate space
        ret                                                     //return

#......................................Subroutines..............................................................................

        #function one newPryamid(int width, int length, int height) returns struct pyramid      

newPyramid:


        #function two relocate(struct pyramid *p, int deltaX, int deltaY) void return
     
relocate:
        #allocate space and set FrameRegister = Stack Pointer
        stp     x29,    x30,    [sp,    -16]!                   //allocate space
        mov     x29,    sp                                      //set FrameRegister = Stack Pointer
        #function body  
        #x1 holds *p (pyramid address)
        #x2 holds int length
        #x3 holds int height

        #deallocate space and return to call
        ldp     x29,    x30,    [sp],   16
        ret


        #function three expand (struct pyramid *p, int deltaX, int deltaY) void return

expand:
        #allocate space and set FrameRegister = Stack Pointer
        stp     x29,    x30,    [sp,    -16]!                   //allocate space
        mov     x29,    sp                                      //set FrameRegister = Stack Pointer
        #function body  
        #x1 holds *p (pyramid address)
        #x2 holds int deltaX
        #x3 holds int deltaY

        #deallocate space and return to call
        ldp     x29,    x30,    [sp],   16
        ret


        #function four printPyramid(char *name, struct pyramid *p) void return

printPyramid:
        #allocate space and set FrameRegister = Stack Pointer
        stp     x29,    x30,    [sp,    -16]!                   //allocate space
        mov     x29,    sp                                      //set FrameRegister = Stack Pointer
        #function body  
        #x1 holds *name (name address)
        #x2 holds #p    (pyramid address

        #deallocate space and return to call
        ldp     x29,    x30,    [sp],   16
        ret


        #function five equalSize(struct pyramid *p1, struct pyramid *p2) returns int

equalSize:
        #allocate space and set FrameRegister = Stack Pointer
        stp     x29,    x30,    [sp,    -16]!                   //allocate space
        mov     x29,    sp                                      //set FrameRegister = Stack Pointer
        #function body  
        #x1 holds *p1 (pyramid1 address)
        #x2 holds *p2 (pyramid2 address)

        #deallocate space and return to call
        ldp     x29,    x30,    [sp],   16
        ret
