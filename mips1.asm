
###############################################################################
# USER TEXT SEGMENT
#
# MARS start to execute at label main in the user .text segment.
###############################################################################

.globl main
.text
main:
       
	li $s0, 0x7fffffff  
       	addi $s1, $s0, 1
	
	lw $s0, 0($zero)
	teqi $zero, 0

todo_3:
  	
  	lw $s0, 0xffff0000	
        sw $s1, 0xffff0000
	
	
infinite_loop: 
	
	addi $s0, $s0, 1
	j infinite_loop


###############################################################################
# KERNEL DATA SEGMENT
###############################################################################

		.kdata
		
UNHANDLED_EXCEPTION:	.asciiz "===>      Unhandled exception       <===\n\n"
UNHANDLED_INTERRUPT: 	.asciiz "===>      Unhandled interrupt       <===\n\n"
OVERFLOW_EXCEPTION: 	.asciiz "===>      Arithmetic overflow       <===\n\n" 
TRAP_EXCEPTION: 	.asciiz "===>         Trap exception         <===\n\n"
BAD_ADDRESS_EXCEPTION: 	.asciiz "===>   Bad data address exception   <===\n\n"
		
###############################################################################

 .ktext 0x80000180  
   
__kernel_entry_point:
	
	mfc0 $k0, $13   
	andi $k1, $k0, 0x00007c  
	
	# Shift two bits to the right to get the exception code. 
	srl  $k1, $k1, 2
	beqz $k1, __interrupt
	
__exception:

	# Branch on value of the the exception code in $k1. 
	beq $k1, 12, __overflow_exception
	
todo_2:	
__unhandled_exception: 
    	
	li $v0, 4
	la $a0, UNHANDLED_EXCEPTION
	syscall
        j __resume_from_exception
	
__overflow_exception:

  	#  Use the MARS built-in system call 4 (print string) to print error messsage.
	li $v0, 4
	la $a0, OVERFLOW_EXCEPTION
	syscall
        j __resume_from_exception
 	
 __bad_address_exception:

	li $v0, 4
	la $a0, BAD_ADDRESS_EXCEPTION
	syscall
        j __resume_from_exception	
 
__trap_exception: 

	li $v0, 4
	la $a0, TRAP_EXCEPTION
	syscall
        j __resume_from_exception

__interrupt: 

    	andi $k1, $k0, 0x00000100
    	srl  $k1, $k1, 8
    	beq  $k1, 1, __keyboard_interrupt

__unhandled_interrupt: 
   
	li $v0, 4
	la $a0, UNHANDLED_INTERRUPT
	syscall
 	j __resume

__keyboard_interrupt:     	
	
	# Get ASCII value of pressed key from the memory mapped receiver data register. 

todo_4:
	
	j __resume
	

__resume_from_exception: 
	
        mfc0 $k0, $14
        
        
todo_1:
        
        addi $k0, $k0, 4 # TODO: Uncomment this instruction      
        mtc0 $k0, $14
        
__resume:
       
	eret # Look at the value of $14 in Coprocessor 0 before single stepping.

