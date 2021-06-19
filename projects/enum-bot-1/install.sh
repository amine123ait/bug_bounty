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
	git clone https://github.com/nitefood/asn /opt/asn  &>/dev/null
	apt-get install whois host -y   &>/dev/null
	apt-get install ipcalc ipcalc ncat aha grepcidr &>/dev/null
	log_success "ASN -DONE";
	git clone https://github.com/maaaaz/webscreenshot.git /opt/webscreenshot   &>/dev/null
	pip3 install -r /opt/webscreenshot/requirements.txt	&>/dev/null
	apt-get install phantomjs -y &>/dev/null
	log_success "WEBscreenshot -DONE";
	apt install amass &>/dev/null
	log_success "Amass -DONE";
	git clone https://github.com/blechschmidt/massdns.git /opt/massdns &>/dev/null
	cd /opt/massdns/ ;make &>/dev/null
	log_success "Massdns -DONE";
	# some tools that I use ^_^
	git clone https://github.com/devanshbatham/ParamSpider.git /opt/ParamSpider &>/dev/null
	pip3 install -r /opt/ParamSpider/requirements.txt  &>/dev/null
	log_success "ParamSpider -DONE";
	#Findomain is the fastest sub-enum tool i know <https://medium.com/@ricardoiramar/subdomain-enumeration-tools-evaluation-57d4ec02d69e>
	wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386 /opt/ &>/dev/null
	chmod +x /opt/findomain-linux-i386  &>/dev/null
	log_success "Findomain -DONE";
	GO111MODULE=on go get -u -v github.com/lc/gau &>/dev/null
	git clone https://github.com/lc/gau /opt/gau &>/dev/null
	cd /opt/gau/ ; go build . &>/dev/null
	log_success "gau -DONE";
}



if [[ $? -eq 0 ]]; then
	figlet bot-echo
	sleep 5
    system-inden
    dependenziz
