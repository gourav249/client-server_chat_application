#include"stdio.h"  
#include"stdlib.h"  
#include"sys/types.h"  
#include"sys/socket.h"  
#include"string.h"  
#include"netinet/in.h"
#include"netdb.h"
#include"pthread.h"

#define PORT 4444 
#define BUF_SIZE 2000 
  
void * receiveMessage(void * socket) 
{
   int sockfd, ret;
   char buffer[BUF_SIZE]; 
   sockfd = (int) socket;
   memset(buffer, 0, BUF_SIZE);  
   for (;;) {
      ret = recvfrom(sockfd, buffer, BUF_SIZE, 0, NULL, NULL);  
      if (ret < 0) {
          system(" zenity --error --title='ERROR' --text='Error receiving data!' ");     
      } else {
           printf("\n                                                                                                              \e[92mSERVER:\e[0m");
           fputs(buffer, stdout);
           printf("\e[39m\n");
      }  
   }
}

int main(int argc, char**argv) 
{  
   struct sockaddr_in addr, cl_addr;  
   int sockfd, ret;  
   char buffer[BUF_SIZE]; 
   char * serverAddr;
   pthread_t rThread;

   if (argc < 2) {
      printf("usage: client < ip address >\n");
      exit(1);  
   }

   serverAddr = argv[1]; 
   
   sockfd = socket(AF_INET, SOCK_STREAM, 0);  
   if (sockfd < 0) { 
     system(" zenity --error --title='ERROR' --text='Error creating socket!' ");  
      exit(1);  
   }
   system(" zenity --notification --text='Socket created...' ");   

   memset(&addr, 0, sizeof(addr));  
   addr.sin_family = AF_INET;  
   addr.sin_addr.s_addr = inet_addr(serverAddr);
   addr.sin_port = PORT;     

   ret = connect(sockfd, (struct sockaddr *) &addr, sizeof(addr));  
   if (ret < 0) {
        system(" zenity --error --title='ERROR' --text='Error connecting to the server!' ");  
        exit(1);  
   }
   system(" zenity --notification --text='Connected to the server...' ");  

   memset(buffer, 0, BUF_SIZE);
   system(" zenity --info --title='Connecttion Established' --text='Enjoy your conversation.' --width=300 --height=200 ");
   printf("\n");

   //creating a new thread for receiving messages from the server
   ret = pthread_create(&rThread, NULL, receiveMessage, (void *) sockfd);
   if (ret) {
      printf("ERROR: Return Code from pthread_create() is %d\n", ret);
      exit(1);
   }

   while (fgets(buffer, BUF_SIZE, stdin) != NULL) {
      ret = sendto(sockfd, buffer, BUF_SIZE, 0, (struct sockaddr *) &addr, sizeof(addr));  
      if (ret < 0) {
          printf("Error sending data!\n\t-%s", buffer);  
      }
   }

   close(sockfd);
   pthread_exit(NULL);
   
   return 0;    
}
