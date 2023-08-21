#!/bin/bash

cd /home/goldfish/MITM/logs/keystrokes
#get all log files in directory
array=($(ls ./*.log))

if [ ${#array[@]} = 0 ] 
then
        exit 1
fi

#loop through log files
for i in "${array[@]}"
do
        cd /home/goldfish/datacollection
        #get the time of the attack, and make datacollection file
        NAME=${i##*/}
        touch attacker@${NAME%.*}

        cd /home/goldfish/MITM/logs/session_streams
        #copy beginning session stream info into datacollection file for this attack
        sudo zcat $NAME.gz | head -9 >> /home/goldfish/datacollection/attacker@${NAME%.*}

        cd /home/goldfish/MITM/logs/keystrokes
        echo "=============AttackerCommandsExecuted===============" >> /home/goldfish/datacollection/attacker@${NAME%.*}

        #copy all parsed data lines from keystrokes log into the data collection file for this attack
        cat $i | grep Parsed | cut -d']' -f2 >> /home/goldfish/datacollection/attacker@${NAME%.*}

        cd /home/goldfish/MITM/logs/keystrokes
        #cp keystroke log file into file with out .log extension
        cp $i ${i%.*}
        #remove original log file, so that next time script is run, it won't collect the data again.
        rm $i
done
