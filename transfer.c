#define _POSIX_SOURCE 1 /* POSIX compliant source */
#define _GNU_SOURCE 1 /* POSIX compliant source */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <termios.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <strings.h>

#define BAUDRATE B38400
#define MODEMDEVICE "/dev/ttyUSB0"
#define FALSE 0
#define TRUE 1

volatile int STOP=FALSE; 



int main(int argc, char *argv[]) {
    if(argc != 2) {
        printf("usage: %s <file-to-upload.bin>\n", argv[0]);
        return 0;
    }

    int filefd = open(argv[1], O_RDONLY);
    if(filefd == -1) {
        printf("Unable to open file.\n");
        return 0;
    }

    char page_buffer[512];

    int fd,c, res;
    struct termios oldtio,newtio;
    char buf[255];

    fd = open(MODEMDEVICE, O_RDWR | O_NOCTTY ); 
    if (fd <0) {perror(MODEMDEVICE); exit(-1); }

    tcgetattr(fd,&oldtio); /* save current port settings */

    bzero(&newtio, sizeof(newtio));
    //newtio.c_cflag = BAUDRATE | CRTSCTS | CS8 | CLOCAL | CREAD;
    newtio.c_cflag = BAUDRATE | CS8 | CLOCAL | CREAD;
    newtio.c_iflag = IGNPAR;
    newtio.c_oflag = 0;

    /* set input mode (non-canonical, no echo,...) */
    newtio.c_lflag = 0;

    newtio.c_cc[VTIME]    = 0;   /* inter-character timer unused */
    newtio.c_cc[VMIN]     = 1;   /* blocking read until 5 chars received */

    tcflush(fd, TCIFLUSH);
    tcsetattr(fd,TCSANOW,&newtio);

    enum {
        WAITING_FOR_BOOT,
        BOOTLOADER_CMDLINE,
        WAITING_FOR_CMDLINE
    } STATE = WAITING_FOR_BOOT;

    int rows = 0;
    int erased = 0;

    while (STOP==FALSE) {
        res = read(fd,buf,1);

        //printf("res: %d char: '%c'\n", res, buf[0]);
        if(res != 1) {
            perror("read");
            break;
        }

        switch(STATE) {
        case WAITING_FOR_BOOT: {
            if(buf[0] == '>') {
                //printf("Wait for boot -> Wait for cmdline\n");
                STATE = WAITING_FOR_CMDLINE;
                res = write(fd, "!", 1);
                //printf("write res: %d\n", res);
            }
            break;
        }
        case WAITING_FOR_CMDLINE: {
            if(buf[0] == '?') {
                //printf("Found command-line!\n");
                STATE = BOOTLOADER_CMDLINE;
            }
            break;
        }
        case BOOTLOADER_CMDLINE: {
            // are we on a page boundary?
            if(rows % 8 == 0 && erased == 0) {
                // if so, first erase...
                //printf("Erasing!\n");
                sprintf(page_buffer, "e%08x", 0xbd000000 + rows*0x80);
                puts(page_buffer);
                write(fd,page_buffer,9);
                STATE = WAITING_FOR_CMDLINE;
                erased = 1;
                break;
            }
            erased = 0;
            //printf("Not erasing...\n");

            int ret = read(filefd, buf, 128);
            // at end of file?
            if(ret <= 0) {
                puts("At end of file...");
                STOP = TRUE;
                break;
            }
            // pad out to 128 bytes if necessary
            else if(ret != 128) {
                for(; ret < 128; ret ++) {
                    buf[ret] = 0xff;
                }
                STOP = TRUE;
            }

            sprintf(page_buffer, "o%08x", 0xbd000000 + rows*0x80);
            for(int i = 0; i < 128; i ++) {
                sprintf(page_buffer + 9 + 2*i, "%02x", (uint32_t)((uint8_t *)(buf))[i]);
            }

            puts(page_buffer);
            write(fd, page_buffer, 9 + 256);

            //printf("finished writing command\n");
            // delay for a bit
            //usleep(1000000);

            rows ++;
            //printf("slept\n");

            STATE = WAITING_FOR_CMDLINE;
            break;
        }
        }
        //printf("iteration finished\n");
        if(STOP == TRUE) break;
    }
    //printf("finishing...\n");
    //tcsetattr(fd,TCSANOW,&oldtio);

    close(fd);
    close(filefd);

    printf("terminating...\n");

    return 0;
}

