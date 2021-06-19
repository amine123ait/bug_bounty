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
	echo "set back and relax .."
	#put here all tools u know git clone https.. /opt/ 
	# some tools that I use ^_^ by @dazai
	git clone https://github.com/devanshbatham/ParamSpider.git /opt/ParamSpider &>/dev/null
	pip3 install -r /opt/ParamSpider/requirements.txt  &>/dev/null
	
	#Findomain is the fastest sub-enum tool i know <https://medium.com/@ricardoiramar/subdomain-enumeration-tools-evaluation-57d4ec02d69e>
	wget https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386 /opt/ &>/dev/null
	chmod +x /opt/findomain-linux-i386  &>/dev/null
	GO111MODULE=on ;go get -u -v github.com/lc/gau &>/dev/null
	git clone https://github.com/lc/gau /opt/gau &>/dev/null
	cd /opt/gau/ ; go build . &>/dev/null
	#nuclei-templates
	git clone https://github.com/projectdiscovery/nuclei-templates /opt/nuclei-templates &>/dev/null
	#nuclei source code
	GO111MODULE=on ;go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei  &>/dev/null
	git clone https://github.com/projectdiscovery/nuclei /opt/nuclei &>/dev/null
	cd /opt/nuclei/v2/cmd/nuclei/ ; go build .
	
	#waybackurls
	go get github.com/tomnomnom/waybackurls
	git clone https://github.com/tomnomnom/waybackurls.git /opt/waybackurls ; cd /opt/waybackurls ; go build . &>/dev/null
	git clone https://github.com/projectdiscovery/subfinder.git /opt/subfinder; cd /opt/subfinder/v2/cmd/subfinder/ ; go build. &>/dev/null

}



if [[ $? -eq 0 ]]; then
	figlet bot-echo
	sleep 5
    system-inden
    dependenziz
