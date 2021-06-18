#!/bin/bash

#Interlace
     

start(){
	reset
	figlet BOT-ECHO
	echo "Target : $domain ✅"
	sleep 5

}

clean(){
	rm -r $domain
	rm -r ./.tools
	mkdir ./.tools &>/dev/null
	mkdir -p ./.tools/logs/
	#touch ./.tools/logs/my.log
	wget https://raw.githubusercontent.com/fredpalmer/log4bash/master/log4bash.sh -P ./.tools/logs/ &>/dev/null
	git clone https://github.com/swelljoe/slog.git ./.tools/logs/slog &>/dev/null
	. ./.tools/logs/slog/slog.sh
	LOG_PATH=./.tools/logs/my.log
	#source ./.tools/logs/log4bash.sh
	log_warning "cleaning ..";
	log_success "DONE";
	#log_error "something wrong";
	start=`date +%s`
	now="$(date +"%r")" 
}
setup(){

	log_info "Installing tools..";
	log_warning "Dont turn off ur vps..";

	#echo -e "\e[5mInstalling tools.."
	export sub_assest_online='$domain.assetfinder.online'
	export wayback='$domain.assetfi_nder.online.wayback'
	export HEADER="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebkit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36"
	
	git clone https://github.com/nitefood/asn ./.tools/asn-tool  &>/dev/null
	apt-get install whois host -y   &>/dev/null
	apt-get install ipcalc ipcalc ncat aha grepcidr &>/dev/null
	log_success "ASN -DONE";
	git clone https://github.com/maaaaz/webscreenshot.git ./.tools/webscreenshot   &>/dev/null
	pip3 install -r ./.tools/webscreenshot/requirements.txt	&>/dev/null
	apt-get install phantomjs -y &>/dev/null
	log_success "WEBscreenn -DONE";
	#apt install amass &>/dev/null
	log_success "Amass -DONE";
	git clone https://github.com/blechschmidt/massdns.git ./.tools/dns/ &>/dev/null
	#make ./.tools/dns/ &>/dev/null
	cd ./.tools/dns/ ;make &>/dev/null
	cd ../.. &>/dev/null
	#cc  -O3 -std=c11 -DHAVE_EPOLL -DHAVE_SYSINFO -Wall -fstack-protector-strong src/main.c -o bin/massdns 
	log_success "Massdns -DONE";
}
domain-enum(){

	log_warning "Enumerating Subdomains..";
	log_info "will take some time so set back and relax $now ";
	mkdir $domain
	sleep 5
	./assetfinder/assetfinder $domain | ./httprobe/httprobe -prefer-https| tee ./$domain/sub_assest_online  &>/dev/null
	./.tools/asn-tool/asn -n $domain | tee ./$domain/asn_info &>/dev/null
	cat ./$domain/sub_assest_online | sort -u | ./waybackurls/waybackurls | sed 's/........//' | tee ./$domain/wayback  &>/dev/null
	#all AAAA records from domains 
	./.tools/dns/bin/massdns -r ../lists/resolvers.txt -t AAAA ./$domain/sub_assest_online  -w ./$domain/aaa_record &>/dev/null
	log_success "AA records";
	#take screen shots and use them later 
	log_warning "taking screenshots";
	mkdir -p ./.tools/resulte/webscreenshot
	python3 ./.tools/webscreenshot/webscreenshot.py -i ./$domain/sub_assest_online -o ./.tools/resulte/webscreenshot -vv  &>/dev/null # ./webscreenshot/screenshots screensshorts here
	
	cat ./$domain/wayback | grep -v google  | ./httpx/cmd/httpx/httpx -silent | tee ./$domain/wayback.online &>/dev/null
	cat ./$domain/wayback  | grep -v google | ./httpx/cmd/httpx/httpx -json -silent | tee ./$domain/wayback.online-json  &>/dev/null
	log_warning "Running Amass..";
	amass enum -brute -active -d $domain -o ./$domain/$domain-amass-output.txt &>/dev/null
	cat ./$domain/$domain-amass-output.txt | httprobe -p http:81 -p http:3000 -p https:3000 -p http:3001 -p https:3001 -p http:8000 -p http:8080 -p https:8443 -c 50 | tee ./$domain/online-amass-domains.txt &>/dev/null
	log_success "DONE -domain-enum";
	
}
function nuclei(){
	mkdir nuclei_output
	prinf "Template Scanning with Nuclei \n\n"
	prinf "\n\n Running : Nuclei Technologies\n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/technologies -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/technologies.txt; 
	printf "\n\n Running : Nuclei Tokens\n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/exposed-tokens -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/tokens.txt; 
	printf "\n\n Running : Nuclei Exposures\n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/exposures -retries 1 -timeout 3 -c lee -rate-limit tee -o nuclei_output/exposures.txt; 
	printf "\n\n Running : Nuclei CVEs \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/cves -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/cves.txt; 
	printf "\n\n Running : Nuclei Default Creds \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/default-logins -retries 1 -timeout 3 -c 100 -rate-limit IMO -o nuclei_output/default_creds.txt; 
	printf "\n\n Running : Nuclei DNS \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/dns -retries 1 -timeout 3 -c 100 -rate-limit 180 o nuclei_output/dns.txt;
	printf "\n\n Running : Nuclei Panels \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/exposed-panels -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/panels.txt;
	printf "\n\n Running : Nuclei Security Misconfiguration \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/misconfiguration -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/misconfigurations.txt;
	printf "\n\n Running : Nuclei Vulnerabilites \n\n" 
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/vulnerabilities -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/vulnerabilities.txt; 
	printf "\n\n Running : Nuclei fuzzing \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/fuzzing -retries 1 -timeout 3 -c 100 -rate-limit 180 -o nuclei_output/fuzzing.txt; 
	printf "\n\n Running : Nuclei Helper \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/payloads -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/helper_payload.txt; 
	printf "\n\n Running : Nuclei loT \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/tot -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/IoT.txt; 
	printf "\n\n Running : Nuclei miscellaneous \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/miscellaneous -retries 1 -timeout 3 -c 100 -rate-limit 180 -o nuclei_output/miscellaneous.txt;
	printf "\n\n Running : Nuclei network \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/network -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/network.txt; 
	printf "\n\n Running : Nuclei takeovers \n\n"
	cat ./$domain/online-amass-domains.txt | nuclei -silent -H "$HEADER" -t nuclei-templates/takeovers -retries 1 -timeout 3 -c 100 -rate-limit 108 -o nuclei_output/takeovers.txt; 
}


win(){
	#my tricks here
	cat ./$domain/wayback.online | dalfox pipe

}


resulte(){
	end=`date +%s`

	runtime=$((end-start))
}





# we need to add some filters
#starting 
if [[ ! -z $1 ]]; then
    rm -rf $1
	domain=$1
    start
    clean
    setup
    domain-enum
    #amass $domain
    #win
    #resulte

else
        echo -e "Usage: ./bot-echo domain.com"
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31mThis script must be run as root\e[0m" 
   exit 1
fi

#check internet stablility 

wget -q --tries=10 --timeout=20 --spider http://google.com
dt=$(date +%Y%m%d_%H%M%S)
if [[ $? -eq 0 ]]; then
    echo "status = $dt:Online"
else
    echo "$dt:Offline"
    mail -s "Internet connection lost on $(hostname) at $(date)" 
fi

