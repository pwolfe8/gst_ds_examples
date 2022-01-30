#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
   
#define MAXLINE 1024

int main(int argc, char *argv[] ) {

    // handle input args
    int PORT;
    int listen_for_return_msg = 0;
    if (argv[1] == NULL) {
        PORT = 6969;
    } else {
        PORT = atoi(argv[1]);
    }
    if (argv[2] != NULL) {
        listen_for_return_msg = atoi(argv[2]);
    }

    // create socket & recv buffer message to send
    int sockfd;
    char buffer[MAXLINE];
    char *hello = (char *) "hello there";
    struct sockaddr_in     my_sock;
   
    // Creating socket file descriptor
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    memset(&my_sock, 0, sizeof(my_sock));
       
    // Filling server information
    my_sock.sin_family = AF_INET;
    my_sock.sin_port = htons(PORT);
    // my_sock.sin_addr.s_addr = INADDR_ANY; // bind to all interfaces (good for listening)
    my_sock.sin_addr.s_addr = inet_addr("127.0.0.1"); // bind to just local host (if you only need to send to an IP)
       
    // send message
    printf("sending \"%s\" to localhost port %d\n", hello, PORT);
    sendto(sockfd, (const char *)hello, strlen(hello),
        MSG_CONFIRM, (const struct sockaddr *) &my_sock, 
            sizeof(my_sock));
    
    /* receive a confirmation msg from server if you choose */
    if (listen_for_return_msg) {
        int n, len;
        n = recvfrom(sockfd, (char *)buffer, MAXLINE, 
                    MSG_WAITALL, (struct sockaddr *) &my_sock,
                    &len);
        buffer[n] = '\0';
        printf("Got return msg: %s\n", buffer);
    }
   
    // close socket & exit success
    close(sockfd);
    return 0;
}
