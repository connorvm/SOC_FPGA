//Authors: Connor Van Meter and Alex Salois
//This C-Program will demonstrate the opcode operations.
//Needs to access the registers using mmap() in Linux.
//Needs to run automatically on boot-up using systemd.


#include <stdio.h>
#include <sys/mman.h>   // mmap functions
#include <unistd.h>     // POSIX API
#include <errno.h>      // error numbers
#include <stdlib.h>     // exit function
#include <stdint.h>     // type definitions
#include <fcntl.h>      // file control
#include <signal.h>     // catch ctrl-c interrupt signal from parent process
#include <stdbool.h>    // boolean types
#define A_ALU_CONTROL_OFFSET 0x0
#define B_ALU_CONTROL_OFFSET 0x1
#define C_ALU_CONTROL_OFFSET 0x6
#define OPCODE_ALU_CONTROL_OFFSET 0x2
#define RL_ALU_CONTROL_OFFSET 0x3
#define RH_ALU_CONTROL_OFFSET 0x4
#define STATUS_ALU_CONTROL_OFFSET 0x5
#define QSYS_LED_CONTROL_0_SPAN 0x00200000
#define QSYS_LED_CONTROL_0_BASE 0xFF200000

// #include <hps_0_arm_a9_0.h> // Platform Designer components addresses

/**********************
* Register offsets
***********************/
/* Remember that each register is offset from each other by 4 bytes;
   this is different from the vhdl view where each register is offset by 1 word
   when we do the addressing on the avalong bus!
   Also note that your offsets might be different depending on how you assigned
   addresses in your qsys wrapper.

   Here we specify the offsets in words rather than bytes because we type cast
   the base address returned by mmap to a uint32_t*. Thus when we increment that
   pointer by 1, the memory address increments by 4 bytes since that's the size
   of the type the pointer points to.
*/

// Define the other register offsets here 

// flag to indicate whetehr or not we've recieved an interrupt signal from the OS
static volatile bool interrupted = false;


// graciously handle interrupt signals from the OS
void interrupt_handler(int sig)
{
    printf("Received interrupt signal. Shutting down...\n");
    interrupted = true;
}


int main()
{
    // open /dev/mem
    int devmem_fd = open("/dev/mem", O_RDWR | O_SYNC);

    // check for errors
    if (devmem_fd < 0)
    {
        // capture the error number
        int err = errno;

        printf("ERROR: couldn't open /dev/mem\n");
        printf("ERRNO: %d\n", err);

        exit(EXIT_FAILURE);
    }

    // map our custom component into virtual memory
    // NOTE: QSYS_LED_CONTROL_0_BASE and QSYS_LED_CONTROL_0_SPAN come from 
    // hps_0_arm_a9_0.h; the names might be different based upon how you 
    // named your component in Platform Designer.
    uint32_t *alu_control_base = (uint32_t *) mmap(NULL, QSYS_LED_CONTROL_0_SPAN,
        PROT_READ | PROT_WRITE,MAP_SHARED, devmem_fd, QSYS_LED_CONTROL_0_BASE);

    // check for errors
    if (alu_control_base == MAP_FAILED)
    {
        // capture the error number
        int err = errno;

        printf("ERROR: mmap() failed\n");
        printf("ERRNO: %d\n", err);

        // cleanup and exit
        close(devmem_fd);
        exit(EXIT_FAILURE);
    }

    // create pointers for each register
    // Define the other register pointers here
    uint32_t *a = alu_control_base + A_ALU_CONTROL_OFFSET;
    uint32_t *b = alu_control_base + B_ALU_CONTROL_OFFSET;
    uint32_t *c = alu_control_base + C_ALU_CONTROL_OFFSET;
    uint32_t *opcode = alu_control_base + OPCODE_ALU_CONTROL_OFFSET;
    uint32_t *rh = alu_control_base + RH_ALU_CONTROL_OFFSET;
    uint32_t *rl = alu_control_base + RL_ALU_CONTROL_OFFSET;
    uint32_t *status = alu_control_base + STATUS_ALU_CONTROL_OFFSET;
	 
	*a = 0xCCCCCCCC;
	*b = 0x11111111;

	*opcode = 1;
    // display each register address and value
    printf("**************************\n");
    printf("   Addresses                Values\n");
    printf("A: 0x%p", a);
    printf("                            %08x\n",*a);
    printf("B: 0x%p", b);
    printf("                            %08x\n",*b);
    printf("C: 0x%p", c);
    printf("                            %08x\n",*c);
    printf("OPCODE: 0x%p", opcode);
    printf("                       %08x\n",*opcode);
    printf("RH: 0x%p", rh);
    printf("                           %08x\n",*rh);
    printf("RL: 0x%p", rl);
    printf("                           %08x\n",*rl);
    printf("STATUS: 0x%p", status);
    printf("                       %08x\n",*status);

    // int count = 20;
    
    // for (int i = 1; i < count; i++)
    // {
    //     printf("Case %d     R0      R1      R2          R4          R3          R4+3        R5\n", i);
    //     printf("IRV:        %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    //     printf("ABW:        %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    //     printf("OFW:        %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    // }
    
    signed initial_a = 0;
    signed initial_b = 0;
    signed initial_RH = 0;
    signed initial_RL = 0;
    signed initial_op = 0;
    signed initial_st = 0;

    //CASE 1: R = A + B,   A = 100 , B = 100
    *a = 100;
    *b = 100;
    *opcode = 1; //add
    printf("Case 1     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status; 

    //CASE 2: R = A + B,   A = 100 , B = 100
    *a = 100;
    *b = 100;
    *opcode = 1; //add
    printf("Case 2     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 3: R = A + B,   A = 0x7FFFFFFF , B = 1
    *a = 0x7FFFFFFF;
    *b = 1;
    *opcode = 1; //add
    printf("Case 3     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status; 

    //CASE 4: R = A - B,   A = 1000 , B = 1000
    *a = 1000;
    *b = 1000;
    *opcode = 2; //subtract
    printf("Case 4     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 5: R = A - B,   A = 1000 , B = 5000
    *a = 1000;
    *b = 5000;
    *opcode = 2; //subtract
    printf("Case 5     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 6: R = A - B,   A = 0x80000000 , B = 1
    *a = 0x80000000;
    *b = 1;
    *opcode = 2; //subtract
    printf("Case 6     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 7: R = A * B,   A = 0x0FFFFFFF , B = 0x0FFFFFFF
    *a = 0x0FFFFFFF;
    *b = 0x0FFFFFFF;
    *opcode = 3; //multiply
    printf("Case 7     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 8: R = A * B,   A = 7000 , B = -500
    *a = 7000;
    *b = -500;
    *opcode = 3; //multiply
    printf("Case 8     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 9: R = A * B,   A = 7000 , B = 0
    *a = 7000;
    *b = 0;
    *opcode = 3; //multiply
    printf("Case 9     R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 10: R = B - 1,   A = 0 , B = 16
    *a = 0;
    *b = 16;
    *opcode = 4; //decrement B
    printf("Case 10    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 11: R = B - 1,   A = 0 , B = 0x80000000
    *a = 0;
    *b = 0x80000000;
    *opcode = 4; //decrement B
    printf("Case 11    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 12: R = B - 1,   A = 0 , B = 0
    *a = 0;
    *b = 16;
    *opcode = 4; //decrement B
    printf("Case 12    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 13: R = A,   A = 5 , B = 0
    *a = 5;
    *b = 0;
    *opcode = 5; //move A
    printf("Case 13    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 14: R = A,   A = 0 , B = 0
    *a = 0;
    *b = 0;
    *opcode = 5; //move A
    printf("Case 14    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 15: R = A,   A = -5 , B = 0
    *a = -5;
    *b = 0;
    *opcode = 5; //move A
    printf("Case 15    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 16: A <-> B,   A = -1 , B = 0
    *a = -1;
    *b = 0;
    *opcode = 6; //swap
    printf("Case 16    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 17: R = A AND B,   A =  , B = 
    *a = ;
    *b = ;
    *opcode = 7; //custom -> AND --- SET THE N FLAG
    printf("Case 17    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 18: R = A AND B,   A = 1 , B = 0
    *a = 1;
    *b = 0;
    *opcode = 7; //custom -> AND --- SET THE Z FLAG
    printf("Case 18    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    //CASE 19: R = A AND B,   A = 0xC0DE  , B = 467
    *a = 0xC0DE;
    *b = 467;
    *c = 1;
    *opcode = 7; //custom -> AND --- enable c
    printf("Case 19    R0      R1      R2          R4          R3          R4+3        R5\n");
    printf("IRV:       %d      %d      %08x        %08x        %08x        %d          %08x\n", initial_a, initial_b, initial_op, initial_RH, initial_RL, initial_st);
    printf("ABW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, initial_op, initial_RH, initial_RL, initial_st);
    printf("OFW:       %d      %d      %08x        %08x        %08x        %d          %08x\n", *a, *b, *opcode, *rh, *rl, *status);
    initial_a = *a;
    initial_b = *b;
    initial_RH = *rh;
    initial_RL = *rl;
    initial_op = *opcode;
    initial_st = *status;

    
    

    /*
    // set the component into software control mode
    //*hs_led_control = 1;
    // clear all of the LEDs
    //*led_reg = 0;
    signal(SIGINT, interrupt_handler); // catch the interrupt signal
    while(!interrupted)
    {
            usleep(0.1*1e6);
        }
    }
    */

    // set the component back into hardware control mode
    //*hs_led_control = 0;

    // unmap our custom component
    int result = munmap(alu_control_base, QSYS_LED_CONTROL_0_SPAN);

    // check for errors
    if (result < 0)
    {
        // capture the error number
        int err = errno;

        printf("ERROR: munmap() failed\n");
        printf("ERRNO: %d\n", err);

        //cleanup and exit
        close(devmem_fd);
        exit(EXIT_FAILURE);
    }

    // close /dev/mem
    close(devmem_fd);

    return 0;
}
