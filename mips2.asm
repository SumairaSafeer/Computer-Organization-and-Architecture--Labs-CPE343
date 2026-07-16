.data
    prompt: .asciiz "Enter an alphabetic character: "
    result: .asciiz "\nThe character in opposite case is: "
    invalid: .asciiz "\nInvalid input. Please enter an alphabetic character."

.text
    main:
        # Ask user for input
        li $v0, 4
        la $a0, prompt
        syscall

        # Read user input
        li $v0, 12
        syscall

        # Store input in $t0
        move $t0, $v0
# Check if character is uppercase
        blt $t0, 'A', not_uppercase
        bgt $t0, 'Z', not_uppercase
        # Convert uppercase to lowercase
        addi $t0, $t0, 32
        j display_result

    not_uppercase:
        # Check if character is lowercase
        blt $t0, 'a', invalid_input
        bgt $t0, 'z', invalid_input
        # Convert lowercase to uppercase
        subi $t0, $t0, 32
        j display_result

    invalid_input:
        li $v0, 4
        la $a0, invalid
        syscall
        j exit

    display_result:
        li $v0, 4
        la $a0, result
        syscall

        li $v0, 11
        move $a0, $t0
        syscall

    exit:
        li $v0, 10
        syscall

    
  


