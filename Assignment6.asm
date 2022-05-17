#Christopher Syrnyk
#december 6th
#open file input.bin and read values sequentially. Perform taylor series of arctan(input) for
#each value in input.bin

//macros for command line arguments
define(i_r, w26)
define(argc_r, w27)
define(argv_r, x28)


.text
        threshold:      .double 0r1.0e-13                       //threshold value 1*10^-13
        //filename_str:   .asciz "input.bin"
        filename_str:   .string "%s"
        success:        .asciz " \n file read \n"
        error:          .asciz  "\n Error, file does not exist \n"
        table_header:   .asciz "\n| Input value | Output value |"
        table_l:        .asciz  "\n|"
        input_fp:       .asciz "% 12.10f|"
        output_fp:      .asciz "% 12.10f| "
        input_fp_neg:   .asciz "%12.10f|"
        output_fp_neg:  .asciz "%12.10f| "
        fmt2:           .asciz    "\n The number read was:  %s \n" //f for floating point s for string
        n1:             .asciz "\nfloating point number is: %s\n"
        nl:             .asciz "\n"
        ran:            .asciz "\n ran \n"
        input_error:    .asciz "\n Error, no input file was entered \n"

.balign 4                                                       //set alignment
.global main                                                    //make main global

// Local Variables for opening a storing file in memmory                        
fd_o = 16
bytes_read_o = 20
value_o = 24


main:
        stp     x29,    x30,    [sp, -32]!                      //alloc scace for main 
        mov     x29,    sp                                      //set frame register

//...........................get file name from command line....................................
        mov     argc_r, w0                                      // copy argc
        mov     argv_r, x1                                      //copy argv
        mov     i_r,    0                                       //i= 0    
        adrp    x0,     filename_str                            //format specifier
        add     x0,     x0,     :lo12:filename_str              //set up 1st arg
        add     i_r,    i_r,    1                               //increment

        //check if filename entered

        ldr     x1,     [argv_r, i_r, SXTW 3]                   //load argument
        cmp     x1,     0                                       //compare to zero (see if user gave input
        b.gt    open_file                                       //contine to open file if greater than 0
        ldr     x0,     =input_error                            //else display input error
        bl      printf
        b       exit_main
  
open_file:
        //open file
        mov     w0,     -100                                    //mov   AT_FDCD = -100 into w0
        ldr     x1,     [argv_r, i_r, SXTW 3]
        mov     w2,     0                                       //read only
        mov     w3,     0666                                    //permissions

        mov     x8,     56                                      //openat system call
        svc     0                                               //openat(-100, filename_str, 0, 0666)

        str     w0,     [x29,   fd_o]                           //store the handle
        cmp     w0,     -1
        b.gt    print_table_header                                      //if successfull, jump to read value

        // print error message
        ldr     x0,     =error                                  //load error message
        bl      printf                                          //print to console
        mov     x0,     -1                                      //return value
        b exit_main                                             //exit to main  

print_table_header:
        //print table header                                    
        ldr     x0,     =table_header                           //load header string
        bl      printf                                          //print header

read_value:
        //add a blank line for readability
        ldr     x0,     =nl                                     //load blank line                                       
        bl      printf                                          //print to console
top:                                                            //top of loop (outer loop reads file 8 bytes at a time) 
        //setup for a read
        ldr     w0,     [x29,   fd_o]                           //w0 = fd
        add     x1,     x29,    value_o                         //address of value on the stack
        mov     w2,     8                                       //size of read (8 bytes)
        mov     x8,     63                                      //63 =  system call
        svc     0                                               //read at
        str     w0,     [x29, bytes_read_o]                     //store the bytes read
checkValue:
        cmp     x0,     0                                       //look for end of file. if value is <=0 exit
        b.le    exit_main                                       //jump to exit flag
        ldr     d8,     [x29, value_o]                          //store input from file in d8
        b       math                                            //jump to flag math
continue:
        b       top                                             //start next read       
math:
        //start values          
        fmov    d10,    1.0                                     //start at 1 (x^1) from x-x^3/3........
        fmov    d11,    xzr                                     //holds current term
        fmov    d13,    xzr                                     //holds of all terms
        mov     w23,    0                                       //counter keeps track of exponent 
        mov     w24,    w23                                     //second exponent tracker
        mov     w20,    0                                       //counter for round (round 0 = x in x - x^3/3 + x^5/5......)
        //assign register to threshold
        fmov    d12,    xzr                                     //zero d12
        adrp    x0,     threshold                               //get address of threshold
        add     x0,     x0,     :lo12: threshold                //
        ldr     d12,    [x0]                                    //store value of threshold in d12
loop_top:
        fmov    d11,    d8                                      //set d11 = input from file
calc_numerator:
        cmp     w24,    0                                       //compare w24 to 0. if there is no exponent jump to divide
        b.le    divide                                          //jump to divide flag
        sub     w24,    w24,    1                               //remove one fom exponent counter       
        fmul    d11,    d11,    d8                              //multiply by self
        b       calc_numerator                                  //loop till exponent gone
divide:
        fcmp    d11,    d8                                      //if d11 equal to input value dont divide jump to sum 
        b.eq    sum                                             //if d11 = d8 jump to sum
        fdiv    d11,    d11,    d10                             //divide by denomenator
sum:
        //calc modulo of d13/2 if = 0 sub if not add
        //R = N - ((N/D) * D)
        mov     w21,    2                                       //denomenator = 2
        sdiv    w22,    w20,    w21                             //divide counter in w22 by 2
        msub    w22,    w22,    w21,    w20                     //multiply by 2 and subtract from numerator (counter)
        cmp     w22,    0                                       //if zero number is even else odd
        b.eq    add_var                                         //if even jump to add_var else continue
sub_var:
        fsub    d13,    d13,    d11                             //subtract
        b       loop_check                                      //jump to loop check
add_var:
        fadd    d13,    d13,    d11                             //add
        b       loop_check                                      //jump to loop check
loop_check:
        //determine if value of term is negative or positive
        fmov    d6,     xzr                                     //zero register
        fcmp    d11,    d6                                      //compare value to zero
        b.ge    positive_term                                   //if >= 0 value positive else negative. jump to falg if positive else continue
        fmov    d6,     -1.0                                    //set to negative 1.0
        fmul    d7,     d11,    d6                              //flip value
negative_term:
        fcmp    d7,     d12                                     //compare to d12 (threshold)
        b.lt    display_num                                     //if less than threshold end loop and jump to display num
        b       continue_loop                                   //else continue loop
positive_term:                                                  //for positive terms
        fcmp    d11,    d12                                     //compare to d12(threshold)
        b.lt    display_num                                     //if less than theshold end loop and jump to displau num
continue_loop:
        add     w23,    w23,    2                               //add two to exponent counter
        mov     w24,    w23                                     //reset temp exponent counter
        add     w20,    w20,    1                               //number of rounds counter (used to determine add or subtract)
        fmov    d7,     2.0                                     //set d7 = 2
        fadd    d10,    d10,    d7                              //add two to denomenator
        b       loop_top                                        //back to top of loop
display_num:
        //for table alignment
        fmov    d7,     xzr                                     //zero register
        fcmp    d8,     d7                                      //compare value to zero
        b.lt    print_neg                                       //if negative continue to print negative
        ldr     x0,     =table_l                                //load string for table left
        bl      printf                                          //print
        ldr     x0,     =input_fp                               //load string for positive input (offset 1 space for missing neg sign)
        fmov    d0,     d8                                      //set value of input
        bl      printf                                          //print
        ldr     x0,     =output_fp                              //load string for positive output
        fmov    d0,     d13                                     //load value
        bl      printf                                          //print
        b continue                                              //continue loop (next value from file)
print_neg:
        ldr     x0,     =table_l                                //load string table left
        bl      printf                                          //print
        ldr     x0,     =input_fp_neg                           //load string for negative input
        fmov    d0,     d8                                      //load input value
        bl      printf                                          //print
        ldr     x0,     =output_fp_neg                          //load string for negative output
        fmov    d0,     d13                                     //load value
        bl      printf                                          //print
        b continue                                              //continue loop(next value from file)
exit_main:                                                      //exit flag
        ldr     x0,     =nl                                     //load blank line
        bl      printf                                          //print blank line for increased readability
        mov     x0,     xzr                                     //return value = zero
        // close the file
        ldr     w0,     [x29,   fd_o]                           //file handle
        mov     x8,     57                                      //system call 
        svc     0                                               //close
        ldp     x29,    x30,    [sp], 32                        //dealloc space for main
        ret    
