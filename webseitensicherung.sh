#!/bin/bash
echo -e "\nFühre das Skript mit Terminal: ./webseitensicherung.sh www.domainname.tld im Terminal aus oder ohne der www-Subdomain mit Terminal: ./webseitensicherung.sh domainname.tld, \nwenn die Sicherung zu klein ist.\n"
echo -e "Beispiel 1: \$_ ./webseitensicherung.sh www.domainname.com \nBeispiel 2: \$_ ./webseitensicherung.sh domainname.com \n\n"

if [ "$#" -ne 1 ]; then
    echo -e "Es wurde noch kein Domainname bei der Ausführung benannt!\n"
    echo -e "Bitte den Domainnamen jetzt eingeben:\n"
	read -r domain
    
    NAME="$domain"
    starttime=$(date +%s)
    time=$(date -d@"$starttime" -u +%H%M%S_%Y%m%d)
    LOG="${NAME}-${time}-UTC"
    mkdir -p ./"${LOG}"
    echo -e "\nEs wird gesichert: https://$domain\n\n"

    wget --restrict-file-names=windows --limit-rate=2000k --convert-links --random-wait -r -p -E -e robots=off -U mozilla https://"$domain"/ -P "./${LOG}/Sicherung-${time}-UTC" 2>&1 | tee "./${LOG}/Downloadlog_${LOG}.txt" 
    
    echo -e "\n"
    took=$(($(date +%s)-starttime))
    dauer=$(date -d@"$took" -u +%H-%M-%S)
    echo -e "\t\tHeruntergeladen in $took Sekunden\n\t\tStunden:Minuten:Sekunden\t$dauer" | tee "./${LOG}/Ausführungsdauer-in-StundenMinutenSekunden_${dauer}.txt"
    echo -e "\nSicherung der Domain https://${NAME} ist abgeschlossen. Bitte manuell prüfen!\n"
else
    NAME="$1"
    starttime=$(date +%s)
    time=$(date -d@"$starttime" -u +%H%M%S_%Y%m%d)
    LOG="${NAME}-${time}-UTC"
    mkdir -p ./"${LOG}"
    echo -e "Es wird gesichert: https://"$1"\n\n"

    wget --restrict-file-names=windows --limit-rate=2000k --convert-links --random-wait -r -p -E -e robots=off -U mozilla https://"$1"/ -P "./${LOG}/Sicherung-${time}-UTC" 2>&1 | tee "./${LOG}/Downloadlog_${LOG}.txt" 
    
    echo -e "\n"
    took=$(($(date +%s)-starttime))
    dauer=$(date -d@"$took" -u +%H-%M-%S)
    echo -e "\t\tHeruntergeladen in $took Sekunden\n\t\tStunden:Minuten:Sekunden\t$dauer" | tee "./${LOG}/Ausführungsdauer-in-StundenMinutenSekunden_${dauer}.txt"
    echo -e "\nSicherung der Domain https://${NAME} ist abgeschlossen. Bitte manuell prüfen!\n"
fi
