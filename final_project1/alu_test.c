//Authors: Connor Van Meter and Alex Salois
//This C-Program will demonstarte the opcode operations.
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
#define QSYS_LED_CONTROL_0_SPAN 16
#define QSYS_LED_CONTROL_0_BASE 0x00000000

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
int signal_a;
int signal_b;
int signal_c;
int signal_opcode;

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
    
    // display each register address and value
    printf("**************************\n");
    printf("register addresses\n");
    printf("**************************\n");
    printf("hs_led_control address: 0x%p\n", *a);
     // Print the other register addresses here
   
    printf("**************************\n");
    printf("register values\n");
    printf("**************************\n");
    printf("hs_led_control: 0x%08x\n", *b);


    printf("**************************\n");
    printf("register values\n");
    printf("**************************\n");
    printf("hs_led_control: 0x%08x\n", *c);


    printf("**************************\n");
    printf("register values\n");
    printf("**************************\n");
    printf("hs_led_control: 0x%08x\n", *opcode);
    // Print the other register values here

    
    // set the component into software control mode
    //*hs_led_control = 1;

    // clear all of the LEDs
    //*led_reg = 0;

    /* run a pattern on the LEDS until we are interrupted with a SIGINT signal.
        The pattern "fills" the LEDS from right to left, i.e.
        00011000
        00111100
        01111110
        11111111
        01111110
        00111100
        00011000
        ... repeat
        where 0 indicates off and 1 indicates on. This pattern repeats.
        Sleep for 0.1 seconds between each pattern-step with usleep(0.1*1e6)

        Extra credit will be given to the most concise (in number of lines)
        pattern logic implementation.
       */
    signal(SIGINT, interrupt_handler); // catch the interrupt signal
    while(!interrupted)
    {
        for(int i=0; i<7; i++){
            switch (i)
            {
            case 0:
                signal_a = 0x18;
                break;

            case 1:
                signal_a = 0x3C;
                break;

            case 2:
                signal_a = 0x7E;
                break;

            case 3:
                signal_a = 0xFF;
                break;

            case 4:
                signal_a = 0x7E;
                break;

            case 5:
                signal_a = 0x3C;
                break;

            case 6:
                signal_a = 0x18;
                break;

            default:
                break;
            }
            usleep(0.1*1e6);
        }
    }

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
