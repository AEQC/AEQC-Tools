#!/bin/bash
#***************************** TITLE *******************************************
# Script Bash3.2,  Quality Control  of miniseed data OVSG                         
# Version 0.9  20 Juin 2012 AISSAOUI -IPGP Paris                                
#*******************************************************************************
# WARNING: ONLY WORK AT THIS TIME  WITH SDS ARCHIVE STRUCTURES    #
#*******************************************************************************
#************************* CONFIGURATIONS **************************************
echo '***************************************************************************************************'
version_script='Quality Control  of miniseed data OVSG, Version 0.9  20 Juin 2012 AISSAOUI -IPGP Paris   '
echo '               Running '$version_script
echo '               '$(date)
echo '***************************************************************************************************'
echo '_______________________  STEP 1 PROGRAM CONFIGURATION _____________________________________________'
echo '---------------------------------------------------------------------------------------------------'
echo '                               *** SYNTAXE ***                                                     '
echo ' ae_qc_merge_archive_v0.9.sh [station] [network] [location_code ] [analyse_mode] [start_date]      '
echo ' [end_date] [server_name] [dir_datase_1] [dir_datase_2] [structure ][channel_to_analyse]           '
echo ' [dir_work_base] [start_qc_date]   > ae_qc_merge_archive_v0.9.log  '  
echo ' WARNING ONLY WORK WITH 512 DATA BLOCK SIZE AND D QUALITY FLAG            '
echo '**************************************************************************'
echo ''
echo '**************************************************************************'
echo '______________________________STATION NAMES_______________________________'
echo '**************************************************************************'
station_name=$1
echo "Nom de la station = "$station_name
echo '**************************************************************************'
echo '________________________________NETWORK NAMES_____________________________'
echo '*******************************************************************************'                                                                  
network_name=$2
echo 'Network_Name = '$network_name
echo '**************************************************************************'
echo '________________________________LOCATION CODE_____________________________'
echo '*******************************************************************************'                                                                     
location_code=$3
echo 'Location_code = '$location_code
echo '**************************************************************************'
echo '________________________________ANALYSE MODE______________________________'
echo '**************************************************************************' 
analyse_mode=$4
echo "Analyse_Mode = "$analyse_mode
echo '**************************************************************************'
echo '__________________________________START DATE______________________________'
echo '**************************************************************************' 
start_date=$5
echo "Start_Date = "$start_date
echo '**************************************************************************'
echo '__________________________________END DATE________________________________'
echo '**************************************************************************' 
end_date=$6
echo "End_Date = "$end_date
echo '**************************************************************************'
echo '___________________________________SERVER NAME____________________________'
echo '**************************************************************************' 
# ===> JUST FOR INFORMATION ...
server_name=$7
echo "Server_Name = "$server_name
echo '**************************************************************************'
echo '____________________________DATA DIRECTORIES______________________________'
echo '**************************************************************************' 
dir_data_base_1=$8
echo "dir_data_base_1="$dir_data_base_1
dir_data_base_2=$9
echo "dir_data_base_2="$dir_data_base_2
echo '**************************************************************************'
echo '___________________________________STRUCTURE______________________________'
echo '**************************************************************************' 
shift
structure=$9
echo "structure = "$structure
echo '**************************************************************************'          
echo '_____________________________________CHANNELS TO CHECK____________________' 
echo '**************************************************************************'
## to be compatible with the Bourne shell
shift
channel_to_analyse=$9
echo "Channel_to_Analyse = "$channel_to_analyse
echo '**************************************************************************'          
echo '________________________________________DIR. WORK BASE____________________' 
echo '**************************************************************************'
## to be compatible with the Bourne shell
shift
dir_work_base=$9
echo "Dir_Work_base = "$dir_work_base
echo '**************************************************************************'          
echo '________________________________________START_QC_DATE_____________________' 
echo '**************************************************************************'
shift
start_qc_date=$9
echo "Start_Qc_Date = "$start_qc_date
echo '**************************************************************************'          
echo '________________________________________ID PROCESS________________________' 
echo '**************************************************************************'
pid_script=$$
echo "pid_script = "$pid_script
echo '**************************************************************************'
echo '_____________________________________________BIN PATHS____________________'
echo '--------------------------------------------------------------------------'
## YOU HAVE TO INSTALL THE PASSCAL SOFTWARE LIBRARY -MINISEED TOOLS
echo '**************************************************************************'
dir_bin_base=$dir_work_base/bin
echo 'dir_bin_base = '$dir_bin_base
################################################################################
# CATCH  THE BASH NAME  PROGRAM TO IDENTIFY THE LOG FILE NAME
name_script=$0
echo "##############################################"
echo "name_script = "$name_script" ##########"
echo "##############################################"
dir_script=$(pwd)
echo "dir_script = "$dir_script 
base_name_script=$($dir_bin_base/basename $name_script)
if [ $name_script == $base_name_script ]
then
 name_script=$dir_script/$base_name_script
fi
echo "name_script = "$name_script
len_name_script=${#base_name_script}
echo "len_name_script = "$len_name_script
len_name_script_log=$((10#$len_name_script-3))
echo "len_name_script_log = "$len_name_script_log
base_name_script_log=${base_name_script:0:len_name_script_log}
name_script_log=$base_name_script_log.log
echo "##############################################"
echo "name_script_log = "$name_script_log" ##########"
echo "##############################################"
echo '**************************************************************************'
echo '_____________________VERSIONS QMERGE & CHECK_FILE TOOLS___________________'
echo '**************************************************************************'
export LEAPSECONDS=$dir_work_base/tools/leapseconds  
#?? ==> DOESN'T WORK IN A CRONTAB CALL !!
echo '----- Version extraction { check_file / qmerge } ---------'
$dir_bin_base/check_file > file_result_output
version_check_file=$(grep "check_file" file_result_output )
version_check_file=${version_check_file:13:20}
echo "version_check_file = "$version_check_file
rm -f file_result_output
$dir_bin_base/qmerge -h > file_result_output
version_qmerge=$( grep "version" file_result_output )
version_qmerge=${version_qmerge:7:26}
echo "version_qmerge = "$version_qmerge
rm -f file_result_output
echo '**************************************************************************'
echo '________________DATE CALCULATIONS: START, END, NUMBER OF DAY ____________'
echo '-------- JULDAY & CALDAY PROGRAMS ARE USED FROM PASSCAL SOFTWARE --------'
echo '**************************************************************************'
# ******************************************************************************
# Init the beginning date of the QC process *
#*******************************************************************************
start_qc_day=$(date -d $start_qc_date "+%j")
start_qc_year=$(date -d $start_qc_date "+%Y")
echo 'start_qc_day = '$start_qc_day
echo 'start_qc_year = '$start_qc_year
# ********************************************************************************************************
# I) CALL bash ae_qc_calcul_dates_v1.2.sh *
#*********************************************************************************************************
script="$dir_work_base/tools/ae_tools/ae_qc_calcul_dates_v1.2.sh"
if [ ! -s $script ]
then
 echo "Error $script not found..."
 kill $pid_script
fi 
command="$analyse_mode $start_date $end_date  $dir_work_base $start_qc_date $pid_script"
echo "COMMANDE SHELL = "
echo "/bin/bash $script $command "
/bin/bash $script $command
error=$?
if [ $error != 0 ]
then
 echo "Error $error while executing $script ...!"
 kill $pid_script
fi
echo "##########################################################################"
echo '*********####### AFTER CALCULATION, RETRIEVE THE DATE VARIABLES ....######'
echo "##########################################################################"
day1=$( cat $dir_work_base/tools/ae_tools/day1.txt)
echo 'day1 = '$day1
year1=$( cat  $dir_work_base/tools/ae_tools/year1.txt )
echo 'year1 = '$year1
day2=$( cat  $dir_work_base/tools/ae_tools/day2.txt )
echo 'day2 = '$day2
year2=$( cat  $dir_work_base/tools/ae_tools/year2.txt )
echo 'year2 = '$year2
date1_qc=$( cat  $dir_work_base/tools/ae_tools/date1_qc.txt )
echo 'date1_qc = '$date1_qc
date2_qc=$( cat  $dir_work_base/tools/ae_tools/date2_qc.txt )
echo 'date2_qc = '$date2_qc
temps_secs=$( cat  $dir_work_base/tools/ae_tools/temps_secs.txt )
echo 'Temps_secs = '$temps_secs
days_number=$( cat  $dir_work_base/tools/ae_tools/days_number.txt )
echo 'days_number = '$days_number
################################################################################
echo '*************************************************************************'
echo '__________________________________LOGS DIRECTORIES_______________________'
echo '*************************************************************************'
#############################################################
dir_logs_base=$dir_work_base/logs      
dir_logs_daily=$dir_logs_base/$start_qc_day'.'$start_qc_year
#############################################################
echo 'dir_logs_base = '$dir_logs_base
echo 'dir_logs_daily = '$dir_logs_daily
##########################################
error=0
if [ ! -d $dir_logs_daily ]
then
 mkdir -p $dir_logs_daily
 error=$? 
 echo 'Directory '$dir_logs_daily' created...'
else
 echo 'Directory '$dir_logs_daily' already exists...' 
fi
##########################################
dir_logs_daily=$dir_logs_daily/$network_name
echo 'dir_logs_daily = '$dir_logs_daily
##########################################
if [ ! -d $dir_logs_daily ]
then
 mkdir -p $dir_logs_daily
 error=$? 
 echo 'Directory '$dir_logs_daily' created...'
else
 echo 'Directory '$dir_logs_daily' already exists...' 
fi
##########################################
dir_logs_daily=$dir_logs_daily/$station_name
echo 'dir_logs_daily = '$dir_logs_daily
##########################################
if [ ! -d $dir_logs_daily ]
  then
   mkdir -p $dir_logs_daily 
   error=$?
   echo 'Directory '$dir_logs_daily' created...'
  else
   echo 'Directory '$dir_logs_daily' already exists...' 
fi
##########################################
dir_logs_daily=$dir_logs_daily/$channel_to_analyse.D
echo 'dir_logs_daily = '$dir_logs_daily
##########################################
if [ ! -d $dir_logs_daily ]
  then
   mkdir -p $dir_logs_daily 
   error=$?
   echo 'Directory '$dir_logs_daily' created...'
  else
   echo 'Directory '$dir_logs_daily' already exists...' 
fi
##########################################
dir_logs_daily=$dir_logs_daily/$year1.$day1'_'$year2.$day2
echo 'dir_logs_daily = '$dir_logs_daily
##########################################
if [ ! -d $dir_logs_daily ]
  then
   mkdir -p $dir_logs_daily 
   error=$?
   echo 'Directory '$dir_logs_daily' created...'
  else
   echo 'Directory '$dir_logs_daily' already exists...' 
fi
if [ $error != 0 ]
then
 echo "Can't create directories !..."
 kill $pid_script
fi
rm -f $dir_logs_daily/*
echo '**************************************************************************'
echo '********************************** TEMP DIRECTORIES **********************'
echo '**************************************************************************'
dir_temp_daily=$dir_work_base/temp
echo 'dir_temp_daily = '$dir_temp_daily
error=0
if [ ! -d $dir_temp_daily ]
then 
 mkdir -p $dir_temp_daily
 error=$?
 echo 'Directory '$dir_temp_daily' created...'
else
 echo 'Directory '$dir_temp_daily' already exists...' 
fi
echo 'Move to the  Directory temp/...'
if [ $error != 0 ]
then
 echo "Can't create directories !..."
 kill $pid_script
fi
cd $dir_temp_daily          
rm -f *
#*************************************
echo "START (MM/DD/AAAA) = "$date1_qc
echo  "END (MM/DD/AAAA) = "$date2_qc
echo "days_number = "$days_number 
#*************************************
serveur=$server_name
reseau=$network_name
if [ $location_code == NO_LOC ]
then
 location_code=""
else
 location=$location_code
fi
station=$station_name
canal=$channel_to_analyse
echo '**************************************************************************'
echo 'serveur = '$serveur 
echo 'reseau = '$reseau
echo 'location = '$location
echo 'station = '$station 
echo 'canal = '$canal 
dir_data_station_1=$dir_data_base_1'/'$year1'/'$reseau'/'$station_name'/'$canal'.D/'
echo 'dir_data_station_1 = '$dir_data_station_1
dir_data_station_2=$dir_data_base_2'/'$year1'/'$reseau'/'$station_name'/'$canal'.D/'
echo 'dir_data_station_2 = '$dir_data_station_2
echo '**************************************************************************'
echo '___________________________STEP 3 RECURSIVE LOOP  TO MERGE FILES__________'
echo '**************************************************************************'
#************************************** LOOP VARIABLES      ********************
#*******************************************************************************
compteur_jour1=0
echo "days_number = "$days_number
while [ $compteur_jour1 != $days_number ]
do
 compteur_problems=0
 ####################################################################
 echo "compteur_jour1 = "$compteur_jour1
 day_file1=$( date -d "$date1_qc + $compteur_jour1 days" "+%j" )
 echo "day_file1 ="$day_file1
 date_file1=$( date -d "$date1_qc + $compteur_jour1 days" "+%D" )
 echo "date_file1="$date_file1
 ddd1=$( date -d "$date1_qc +$compteur_jour1 days" +%d )
 echo "ddd1 ="$ddd1
 mmm1=$( date -d "$date1_qc +$compteur_jour1 days" +%m )
 echo "mmm1 ="$mmm1
 year_file1=$( date -d "$date1_qc +$compteur_jour1 days" +%Y )
 echo "year_file1 ="$year_file1
 ####################################################################
 file_name1=$reseau'.'$station'.'$location'.'$canal'.D.'$year_file1'.'$day_file1
 echo 'file_name1 = '$file_name1
 ####################################################################
 file_name2=$reseau'.'$station'.'$location'.'$canal'.D.'$year_file1'.'$day_file1
 echo 'file_name2 = '$file_name2
 ####################################################################
 file_name3=$dir_data_station_1$file_name1
 file_name4=$dir_data_station_2$file_name2
 echo "** file_name3 = "$file_name3
 echo "** file_name4 = "$file_name4
 file3=0
 if [ -s $file_name3 ]
 then
  file3=1
  echo "#################### GET LOCAL SIZE_BLOCK-ENCODING-QUALITY_FLAG $file_name3"
  $dir_bin_base/msview -p $file_name3|  head -n 14 > output_ms_view.txt  
  echo "*********output_ms_view.txt local $file_name3*************"
  cat output_ms_view.txt
  echo "****************************************"
  local_file1_block_size=$(cat output_ms_view.txt | grep record | awk '{print $3}' )
  echo "local_file1_block_size="$local_file1_block_size
  local_file1_steim=$(cat output_ms_view.txt |  grep encoding | awk '{print $3}' )
  echo "local_file1_steim=STEIM "$local_file1_steim
  local_file1_quality_flag=$(cat output_ms_view.txt| grep $reseau| awk '{print $3}' )
  echo "local_file1_quality_flag="$local_file1_quality_flag    
  echo "conversion local file1 to D quality flag."
  $dir_bin_base/dataselect -Q D -o file_temp  $file_name3
  mv -f file_temp  $file_name3
  if [ $local_file1_block_size  != 512 ]
  then
   echo "conversion local $file_name3 to 512 block size."   
   $dir_bin_base/msrepack -R 512 -o file_temp $file_name3 >& /dev/null
   $dir_bin_base/qmerge -b 512 file_temp > file_temp2
   mv -f file_temp2 $file_name3
  fi
  if [ $local_file1_steim != 2 ] 
  then
   echo "conversion local $file_name3 to STEIM 2 encoding."
   $dir_bin_base/msrepack -E 11 -o file_temp $file_name3 >& /dev/null
   $dir_bin_base/qmerge -b 512 file_temp > file_temp2
   mv -f file_temp2  $file_name3
  fi
 fi #=> if [ -s $file_name3 ]
 ####################################################################
 file4=0
 if [ -s $file_name4 ]
 then
  file4=1
  echo "#################### GET LOCAL SIZE_BLOCK-ENCODING-QUALITY_FLAG $file_name4 "
  $dir_bin_base/msview -p $file_name4 |  head -n 14 > output_ms_view.txt  
  echo "*********output_ms_view.txt local $file_name4 *************"
  cat output_ms_view.txt
  echo "****************************************"
  local_file1_block_size=$(cat output_ms_view.txt | grep record | awk '{print $3}' )
  echo "local_file1_block_size="$local_file1_block_size
  local_file1_steim=$(cat output_ms_view.txt |  grep encoding | awk '{print $3}' )
  echo "local_file1_steim=STEIM "$local_file1_steim
  local_file1_quality_flag=$(cat output_ms_view.txt| grep $reseau | awk '{print $3}' )
  echo "local_file1_quality_flag="$local_file1_quality_flag    
  echo "conversion local file1 to D quality flag."
  $dir_bin_base/dataselect -Q D -o file_temp  $file_name4 
  mv -f file_temp $file_name4 
  if [ $local_file1_block_size  != 512 ]
  then
   echo "conversion local file1 to 512 block size."   
   $dir_bin_base/msrepack -R 512 -o file_temp $file_name4  >& /dev/null
   $dir_bin_base/qmerge -b 512 file_temp > file_temp2
   mv -f file_temp2 $file_name4 
  fi
  if [ $local_file1_steim != 2 ] 
  then
   echo "conversion local file1 to STEIM 2 encoding."
   $dir_bin_base/msrepack -E 11 -o file_temp $file_name4  >& /dev/null
   $dir_bin_base/qmerge -b 512 file_temp > file_temp2
   mv -f file_temp2  $file_name4 
  fi
 fi  #=> fi #=> if [ -s $file_name4 ]
 ####################################################################
 if [ $file3 == 1 -a $file4 == 1 ]
 then
  echo "$file_name3 present !"
  echo "$file_name4 present !"
  $dir_bin_base/qmerge  -b 512 $file_name3 >  ./test1
  $dir_bin_base/qmerge  -b 512 $file_name4  > ./test2
  $dir_bin_base/qmerge  -b 512 ./test1 ./test2 > ./test3 
  #cp -a test3 $file_name3
  #cp -a test3 $file_name4
 fi
 ####################################################################
 if [ $file3 == 1 -a $file4 == 0 ]
 then
   echo "$file_name3 present !"
   echo "$file_name4 absent  !"
   #cp -a $file_name3 $file_name4
 fi
 ####################################################################
 if [ $file3 == 0 -a $file4 == 1 ]
 then
   echo "$file_name3 absent  !"
   echo "$file_name4 present !"
   #cp -a  $file_name4 $file_name3
 fi
 ####################################################################
 if [ $file3 == 0 -a $file4 == 0 ]
 then
  echo "No files to merge !!"
 fi
 ###########################################
 #****** INCREMENT THE DAY COUNTER
 compteur_jour1=$((10#$compteur_jour1 +1 ))
 ###########################################
 echo '****************************************************************************************************'
done #--> while [ $compteur_jour1 != $days_number ] ;
#######
echo 'dir_logs_daily = '$dir_logs_daily
if [ -f $name_script_log ]
then
 cp $name_script_log $dir_logs_daily
fi
name_script_log=$dir_script/$name_script_log
if [ -f $name_script_log ]
then
 cp $name_script_log $dir_logs_daily
fi
echo '****************************************************************************************************'
echo "END  "$name_script" ..." 
echo '****************************************************************************************************'





  

 





