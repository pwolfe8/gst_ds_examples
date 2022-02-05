// Simple Cpp UDP Client

#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>

#include <iostream>
#include <sstream>

class UdpClient
{
public:
  std::string dest_ip; /**< destination ip address */
  uint16_t dest_port;  /**< destination port number */
  bool verbose;  /**< set on if you want debug prints */

  /**
   * default constructor 
   * sets default destination ip to 127.0.0.1 and port to 6969
   */
  UdpClient() : UdpClient("127.0.0.1", 6969) {}

  /**
   * normal constructor
   * sets default destination ip/port to user specified values
   */
  UdpClient(std::string ip, uint16_t port)
  {
    // default verbose off
    verbose = false;

    dest_ip = ip;
    dest_port = port;

    recv_buff_len = 1024;
    recv_buff = new char[recv_buff_len];

    // initialize socket
    init_socket(dest_ip, dest_port);
  }

  /**
   * destructor 
   */
  ~UdpClient() {}

  /**
   * get destination ip/port string representation
   */
  std::string get_destination_str()
  {
    std::stringstream retstr;
    retstr << dest_ip << ":" << dest_port;
    return retstr.str();
  }

  /**
   * sends data to destination
   */
  void send(char *data)
  {
    // send message
    if (verbose) {
    std::cout << "sending \"" << data << "\" to "
              << get_destination_str() << std::endl;
    }

    sendto(sock_fd, (const char *)data, strlen(data),
           MSG_CONFIRM, (const struct sockaddr *)&dest, sizeof(dest));
  }

  /**
   * sends data, but waits/listens for a return message from destination
   */
  void send_wait_return(char *data)
  {
    int n;
    socklen_t len;

    // send data
    send(data);

    // wait for a return message from the destination
    n = recvfrom(sock_fd, (char *)recv_buff, recv_buff_len,
                 MSG_WAITALL, (struct sockaddr *)&dest, &len);
    recv_buff[n] = '\0';
    if (verbose) {
      std::cout << "Got return msg: " << recv_buff << std::endl;
    }
  }

private:
  int sock_fd;             /**< socket file descriptor */
  char *recv_buff;         /**< receive buffer */
  uint16_t recv_buff_len;  /**< length of receive buffer */
  struct sockaddr_in dest; /**< destination address socket info */

  /**
   * initialize socket 
   */
  void init_socket(std::string ip, uint16_t port)
  {
    // Creating socket file descriptor
    if ((sock_fd = socket(AF_INET, SOCK_DGRAM, 0)) < 0)
    {
      perror("socket creation failed");
      exit(EXIT_FAILURE);
    }

    // zero out struct & populate with our info
    memset(&dest, 0, sizeof(dest));
    dest.sin_family = AF_INET;
    dest.sin_port = htons(port);
    dest.sin_addr.s_addr = inet_addr(ip.c_str());
  }

}; /* end UdpClient class definition */

// /**
//  * main 
//  */
// int main()
// {
//   UdpClient client("127.0.0.1", 8080);
//   client.send((char *)"hello there");

//   UdpClient client2("127.0.0.1", 8081);
//   client2.send_wait_return((char *)"send and wait for return");
// }