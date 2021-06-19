#!/bin/bash

system-inden() {
	apt-get update -y 
	apt-get upgrade -y

}
dependenziz(){
	wget -c https://dl.google.com/go/go1.16.5.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
	echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile
	source ~/.profile
}
tools(){
	figlet tools 
	#put here all tools u know git clone https.. /opt/ 
}



if [[ $? -eq 0 ]]; then
	figlet bot-echo
	sleep 5
    system-inden
    dependenziz
