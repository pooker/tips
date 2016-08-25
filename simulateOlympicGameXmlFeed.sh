#!/bin/bash

#用于模拟奥运会某场比赛的XML数据源文件，按照时间先后顺序定时推送文件到指定目录
#This scipt will push specified Olympic game XML feed files according to the timestamp of messages.

#USAGE
#./simulateOlympicGameXmlFeed.sh BKM400B15
#"BKM400B15" is the game ID needed to be simulated.

#data source directory
xmlPath="/data_source/"

#transitory directory with a child directory named in game ID
tmpPath="/data_tmp/"${1}"/"
mkdir -m 777 $tmpPath

#destination directory
dealPath="/data_des/"

game=$1
disciplineId=${game:0:2}
eventId=${game:0:6}
phaseId=${game:0:7}

cd $xmlPath
find schedule files
echo "find schedule files" 
for file in `ls -tr | grep ODF_${disciplineId}0000000DT_SCHEDULE`
do
   echo $file
   cp -p $file ${tmpPath}${file}	
done
echo "find schedule files done"

find team files
echo "find participants and teams files" 
for file in `ls -tr | grep ODF_${disciplineId}0000000DT_PARTIC`
do
   echo $file
   cp -p $file ${tmpPath}${file}	
done
echo "find participants and teams files done" 

#find poolstanding files
echo "find poolstanding files" 
for file in `ls -tr | grep ODF_${phaseId}00DT_POOL_STANDING`
do
   echo $file
   cp -p $file ${tmpPath}${file}	
done
echo "find poolstanding files done" 

#find record files
echo "find record files" 
for file in `ls -tr | grep ODF_${disciplineId}0000000DT_RECORD`
do
   echo $file
   cp -p $file ${tmpPath}${file}	
done
echo "find record files done" 

find rank files
echo "find rank files" 
for file in `ls -tr | grep ODF_${eventId}000DT_RANKING`
do
   echo $file
   cp -p $file ${tmpPath}${file}	
done
echo "find rank files done" 

#find submedallist files
echo "find sub medal list files" 
for file in `ls -tr | grep ODF_${eventId}000DT_MEDALLISTS`
do
   echo $file
   cp -p $file ${tmpPath}${file}	
done
echo "find sub medal list files done" 

#find DT_CUMULATIVE_RESULT files
echo "find DT_CUMULATIVE_RESULT files" 
for file in `ls -tr | grep ODF_${phaseId}00DT_CUMULATIVE_RESULT`
do
   echo $file
   cp -p $file ${tmpPath}${file}	
done
echo "find DT_CUMULATIVE_RESULT files done" 

#find dt result live files
echo "find dt result live files" 
for file in `ls -tr | grep ODF_${game}DT_RESULT`
do
   echo $file
   cp -p $file ${tmpPath}${file}	
done
echo "find dt result live files done" 

#basketball and football need PBP data
if [ "${disciplineId}" = "BK" ] || [ "${disciplineId}" = "FB" ]
	then
		echo "find dt play by play live files" 
		for file in `ls -tr | grep ODF_${game}DT_PLAY_BY_PLAY`
		do
	   		echo $file
	    	cp -p $file ${tmpPath}${file}	
		done
		echo "find dt play by play live files done"
fi	 

echo "************** FIND ALL FILES DONE **********"
sleep 5
cd $tmpPath
#file atime is the timestamp
for dealFile in `ls -tr`
do
    echo $dealFile
    cp -p $dealFile ${dealPath}${dealFile}
    rm -rf $dealFile
    cnt=`echo "${dealFile}" | grep 'DT_SCHEDULE\|DT_PARTIC' | wc -l `
    #if [ echo "${dealFile}" | grep -q "DT_SCHEDULE" ] || [ echo "${dealFile}" | grep -q "DT_PARTIC" ]
    if (( $cnt >= 1 ))
	    then 
	       echo "DT_SCHEDULE or DT_PARTIC detected, do not sleep"	
	    else   
        #simulate game message with sleep time
	   		sleep 1 
	fi	    
done
echo "remove dir ${1}"
rm -rf $1
echo "----------------- ALL DONE ------------------"

