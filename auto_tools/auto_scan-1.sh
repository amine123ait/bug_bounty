#!/bin/bash
HEADER="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_0) AppleWebkit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36"
target=$1 
bash subzzZ -d $target
cd scans/$target-$(date +%Y-%m-%d)
printf "\n\nALIVE with buzzZ => $(wc -l alive.txt)\n\n"
echo -e "» \e(36mAmass \e[0m is in progress"
cat alive.txt 1 | cut -d"/" -f3 | sort -u xargs -P 500 -n 1 -I@ sh -c "amass enum -d '@' -config Amass_Config.ini -silent | tee -a amass-subs.txt"
cat amass-subs.txt | sort -u | httpx -silent -H "$HEADER" | anew alive.txt
printf "\n\nFinal Alive Amass + SubzzZ => $(wc -l alive.txt)\n\n"
rm -rf amass-* 
#############
echo -e "» \e[36mNuclei \elem is in progress" 
	echo -n "Updating Nuclei Templates.."
	nuclei -update-templates
	echo "::::::::Scanning begins::::::::"
	mkdir -p nuclei-output 
printf "######################################################################\n"

prinf "Template Scanning with Nuclei \n\n" 
start=`date +%s`
prinf "\n\n Running : Nuclei Technologies\n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t technologies -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/technologies.txt; 
printf "\n\n Running : Nuclei Tokens\n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t exposed-tokens -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/tokens.txt; 
printf "\n\n Running : Nuclei Exposures\n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t exposures -retries 1 -timeout 3 -c lee -rate-limit tee -o nuclei_output/exposures.txt; 
printf "\n\n Running : Nuclei CVEs \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t cves -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/cves.txt; 
printf "\n\n Running : Nuclei Default Creds \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t default-logins -retries 1 -timeout 3 -c 100 -rate-limit IMO -o nuclei_output/default_creds.txt; 
printf "\n\n Running : Nuclei DNS \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t dns -retries 1 -timeout 3 -c 100 -rate-limit 180 o nuclei_output/dns.txt;
printf "\n\n Running : Nuclei Panels \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t exposed-panels -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/panels.txt;
printf "\n\n Running : Nuclei Security Misconfiguration \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t misconfiguration -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/misconfigurations.txt;
printf "\n\n Running : Nuclei Vulnerabilites \n\n" 
cat alive.txt | nuclei -silent -H "$HEADER" -t vulnerabilities -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/vulnerabilities.txt; 
printf "\n\n Running : Nuclei fuzzing \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t fuzzing -retries 1 -timeout 3 -c 100 -rate-limit 180 -o nuclei_output/fuzzing.txt; 
printf "\n\n Running : Nuclei Helper \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t payloads -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/helper_payload.txt; 
printf "\n\n Running : Nuclei loT \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t tot -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/IoT.txt; 
printf "\n\n Running : Nuclei miscellaneous \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t miscellaneous -retries 1 -timeout 3 -c 100 -rate-limit 180 -o nuclei_output/miscellaneous.txt;
printf "\n\n Running : Nuclei network \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t network -retries 1 -timeout 3 -c 100 -rate-limit 100 -o nuclei_output/network.txt; 
printf "\n\n Running : Nuclei takeovers \n\n"
cat alive.txt | nuclei -silent -H "$HEADER" -t takeovers -retries 1 -timeout 3 -c 100 -rate-limit 108 -o nuclei_output/takeovers.txt; 

printf "########################done:))################################~by Dheera"








