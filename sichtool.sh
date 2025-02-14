#!/bin/bash
echo -e "\nFühre das Skript mit "\$_" ./sicherungstool.sh www.domainname.tld im Terminal aus oder ohne der www-Subdomain mit "\$_" ./sicherungstool.sh domainname.tld, \nwenn die Sicherung zu klein ist.\n"
echo -e "Beispiel 1: \$_ sicherungstool.sh www.domainname.com \nBeispiel 2: \$_ sicheurngstool.sh domainname.com \n\n"

if [ "$#" -ne 1 ]; then
    echo -e "Es wurde noch kein Domainname bei der Ausführung benannt!\n"
    echo -e "Bitte jetzt eingeben:\n"
	read -r domain
    LOG_FILE=sicherungsprotokoll_"$domain".txt
    echo -e "\nEs wird $domain gesichert.\n\n\n"
    starttime=$(date +%s)

    wget --restrict-file-names=windows --limit-rate=2000k --convert-links --random-wait -r -p -E -e robots=off -U mozilla https://"$domain"/ -q --show-progress --progress=bar:force:noscroll 2>&1 | tee "${LOG_FILE}"
    echo -e "\n\n\n" | tee "${LOG_FILE}"
    took=$(($(date +%s)-starttime))
    dauer=$(date -d@"$took" -u +%H:%M:%S)
    echo -e "\t\tHeruntergeladen in $took Sekunden\n\t\tStunden:Minuten:Sekunden\t$dauer\n" | tee "${LOG_FILE}_dauer"
    echo -e "Sicherung der Domain " "$domain" " ist abgeschlossen. Bitte manuell prüfen!"

else
    LOG_FILE=logs_"$1".txt
    echo -e "Es wird " "$1" " gesichert.\n\n\n" | tee "${LOG_FILE}1"
    starttime=$(date +%s)

    wget --restrict-file-names=windows --limit-rate=2000k --convert-links --random-wait -r -p -E -e robots=off -U mozilla https://"$1"/ 2>&1 | tee "${LOG_FILE}2" #-q --show-progress --progress=bar:force:noscroll
    echo -e "\n\n\n" | tee "${LOG_FILE}3"
    took=$(($(date +%s)-starttime))
    dauer=$(date -d@"$took" -u +%H:%M:%S)
    echo -e "\t\tHeruntergeladen in $took Sekunden\n\t\tStunden:Minuten:Sekunden\t$dauer\n" | tee "${LOG_FILE}4"
    echo -e "Sicherung der Domain " "$1" " ist abgeschlossen. Bitte manuell prüfen!" | tee "${LOG_FILE}5"

fi
echo -e "\n\n"
