#!/bin/bash

#tput is used here for fomating the text
NC=`tput sgr0`
bold=`tput bold`
underline=`tput smul`
remove_underline=`tput rmul`

clear

cmd=(dialog --colors --keep-tite --title "\Zb\Z1CHATTING APPLICATION" --menu "What do you want to be:" 22 76 16)

options=(1 "THE SERVER"
         2 "THE CLIENT"
         3 "EXIT")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices
do
case $choice in
    1)
    beServer()
    {
	progressBar()
	{
		#progress bar start
		i=0
		(while [ $((i <= 100)) '=' 1 ]
		do
	    echo $i
	    sleep 1
	    i=$((i + 10))
		done) | zenity --progress --title="CHATTING APPLICATION" --width=700 height=400 --text='connecting...' --time-remaining --auto-close
		#progress end
	}

	progressBar
	xterm -e gcc server.c -o server -pthread &   # compiling server.c program in baground terminal(xterm)
	echo ""
	clear
	echo -e "                                              \033[35m***********************************************"
	echo -e "                                              \033[32m|             CHATTING APPLICATION            |"
	echo -e "                                              \033[35m***********************************************\e[0m"
	echo ""
	echo -e "                                                            \033[31m***SERVER SIDE***${NC}" #echo -e is used for colouring the text
	echo ""
	echo ""

	./server     # executing the object of server.c
    }
    beServer
    ;;
    2)  
	gainingAcess()
	{
	password=$( zenity --password --title="CHATTING APPLICATION" --width=400 )
	clear
	asciPassword="100101118"  
	length=${#password[0]}
	for (( i=0; i<$length; i++ ))
	do
	a1="${password:$i:1}"
	A1=$(printf '%d\n' "'$a1")
	arg="$arg$A1"
	done
	beClient()
	{
		# here we are storing the ip address value in the variable
		ipaddress=$( zenity --entry --title="CHATTING APPLICATION" --text="Enter the ip address of the Server" --entry-text="127.0.0.1" --width=400 --height=100 )
        clear
        progressBar()
        {
		#progress bar start
		i=0
		(while [ $((i <= 100)) '=' 1 ]
		do
	    echo $i
	    sleep 1
	    i=$((i + 10))
		done) | zenity --progress --title="CHATTING APPLICATION" --width=700 height=400 --text='connecting...' --time-remaining --auto-close
		#progress end
		clear
	}

	progressBar
	clear
	xterm -e gcc client.c -o client -pthread &    # compiling client.c program in baground terminal(xterm)
	clear
	echo ""
	echo -e "                                              \033[35m***********************************************"
	echo -e "                                              \033[32m|             CHATTING APPLICATION            |"
	echo -e "                                              \033[35m***********************************************\e[0m"
	echo ""
	echo ""
	echo -e "                                                             \e[93m***CLIENT SIDE***${NC}"
	echo ""
	
	echo ""

	./client $ipaddress # executing the object of server.c and passing the ipaddress variable value as a argument
	}
	if [[ "$arg" == "$asciPassword" ]]; then
		echo ""
		echo -e " \033[32mAcess Granted.${NC}"
		echo ""
		beClient
		echo ""
		echo ""
	else
		echo ""
	echo -e "\033[31mAcess Denied.${NC}"
		echo ''
		echo ""
	fi
	}

	gainingAcess
	
    ;;
    3)
    echo "Thank you for using our App."
    ;;
esac
done
