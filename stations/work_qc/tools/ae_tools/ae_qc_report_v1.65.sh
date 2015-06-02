#!/bin/bash
#***************************** TITLE *********************************************************************
# Script Bash3.2,  Quality Control  of miniseed data IPOC Project                                        *     
# Version 1.65  10 Dec 2012 AISSAOUI -IPGP Paris                                                         *
#*********************************************************************************************************
# WARNING: ONLY WORK AT THIS TIME  WITH SDS ARCHIVE STRUCTURES    #
#*********************************************************************************************************
#************************* CONFIGURATIONS ****************************************************************
echo '***************************************************************************************************'
version_script='Quality Control IPOC Data script  Version 1.65  Dec Mars 2012 AISSAOUI -IPGP Paris       '
echo '               Running '$version_script
echo '               '$(date)
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '_______________________  STEP 1 PROGRAM CONFIGURATION _____________________________________________'
echo '---------------------------------------------------------------------------------------------------'
echo '                               *** SYNTAXE ***                                                     '
echo ' ae_qc_report_v1.65.sh [station] [network] [location_code ] [analyse_mode] [start_date] [end_date] '
echo ' [server_name] [dir_datase] [structure ][channel_to_analyse][rate][dir_work_base] [email_adresse ] '
echo '                          [email_title] [start_qc_date] [task_list_mode]  > ae_qc_report_v1.65.log '  
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '______________________________STATION NAMES________________________________________________________'
echo '***************************************************************************************************'
station_name=$1
echo "Nom de la station = "$station_name
echo '***************************************************************************************************'
echo '________________________________NETWORK NAMES______________________________________________________'
echo '***************************************************************************************************'
network_name=$2
echo 'Network_Name = '$network_name
echo '***************************************************************************************************'
echo '________________________________LOCATION CODE______________________________________________________'
echo '***************************************************************************************************'
location_code=$3
echo 'Location_code = '$location_code
echo '***************************************************************************************************'
echo '________________________________ANALYSE MODE_______________________________________________________'
echo '***************************************************************************************************' 
analyse_mode=$4
echo "Analyse_Mode = "$analyse_mode
echo '***************************************************************************************************'
echo '__________________________________START DATE_______________________________________________________'
echo '***************************************************************************************************' 
start_date=$5
echo "Start_Date = "$start_date
echo '***************************************************************************************************'
echo '__________________________________END DATE_______________________________________________________'
echo '***************************************************************************************************' 
end_date=$6
echo "End_Date = "$end_date
echo '***************************************************************************************************'
echo '___________________________________SERVER NAME______________________________________________________'
echo '***************************************************************************************************' 
# ===> JUST FOR INFORMATION ...
server_name=$7
echo "Server_Name = "$server_name
echo '***************************************************************************************************'
echo '____________________________DATA DIRECTORIES_______________________________________________________'
echo '***************************************************************************************************' 
dir_data_base=$8
echo "dir_data_base = "$dir_data_base
echo '***************************************************************************************************'
echo '___________________________________STRUCTURE_______________________________________________________'
echo '***************************************************************************************************' 
structure=$9
echo "structure = "$structure
echo '***************************************************************************************************'          
echo '_____________________________________CHANNEL TO CHECK______________________________________________' 
echo '***************************************************************************************************'
## to be compatible with the Bourne shell
shift
channel_to_analyse=$9
echo "Channel_to_Analyse = "$channel_to_analyse
#rate_select=${channel_to_analyse:0:1}
#case $rate_select in
# H) rate=100 ;;
# B) rate=20 ;;
# L) rate=1 ;;
# E) rate=100 ;;
#esac
echo '***************************************************************************************************'          
echo '_____________________________________CHANNEL RATE__________________________________________________' 
echo '***************************************************************************************************'
## to be compatible with the Bourne shell
shift
rate=$9
echo ###########################
echo "rate = "$rate
echo ###########################
echo '***************************************************************************************************'          
echo '________________________________________DIR. WORK BASE_____________________________________________' 
echo '***************************************************************************************************'
## to be compatible with the Bourne shell
shift
dir_work_base=$9
echo "Dir_Work_base = "$dir_work_base
echo '***************************************************************************************************'
echo '______________________________TITLE  & EMAILS  ADDRESS LIST TO SEND REPORTS QC_____________________'
echo '***************************************************************************************************'
echo '  --- POSTFIX/SENDMAIL HAVE TO BE CONFIGURED ON YOUR SYSTEM !! ----'
## to be compatible with the Bourne shell
shift
emails_list=$9
echo "emails_list=""$emails_list"
#if [[ $emails_list =~ "+" ]]
#then
# echo "Send with mutiple destination address !"
#else
# echo "Send with a sender and receiver !"
# echo "emails_list="$emails_list
# echo $emails_list > emails_list
# champ=$( sed "s/,/ /g" emails_list )
# emails=$champ
# echo "emails=""$emails"
#fi
###############
# ==> Titre du message 
shift
emails_title=$9
echo "Email_Title = "$emails_title
echo '***************************************************************************************************'          
echo '________________________________________START_QC_DATE_____________________________________________' 
echo '***************************************************************************************************'
shift
start_qc_date=$9
echo "Start_Qc_Date = "$start_qc_date
echo '***************************************************************************************************'          
echo '________________________________________TASK_LIST_MODE_____________________________________________' 
echo '***************************************************************************************************'
## VALUES  AUTHORIZED RESET OR KEEP
##########################################################################################################
shift
task_list_mode=$9
echo "Task_List_Mode = "$task_list_mode
echo '***************************************************************************************************'          
echo '________________________________________ID PROCESS_________________________________________________' 
echo '***************************************************************************************************'
#echo $$ > pid_file
#pid_script=$(cat pid_file)
pid_script=$$
echo "pid_script = "$pid_script
echo '***************************************************************************************************'
echo '_____________________________________________BIN PATHS_____________________________________________'
echo '---------------------------------------------------------------------------------------------------'
## YOU HAVE TO INSTALL THE PASSCAL SOFTWARE LIBRARY -MINISEED TOOLS
echo '***************************************************************************************************'
dir_bin_base=$dir_work_base/bin
echo 'dir_bin_base = '$dir_bin_base
#########################################################################################################
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
echo '***************************************************************************************************'
echo '_____________________VERSIONS QMERGE & CHECK_FILE TOOLS____________________________________________'
echo '***************************************************************************************************'
export LEAPSECONDS=$dir_work_base/tools/leapseconds  #?? ==> DOESN'T WORK IN A CRONTAB CALL !!
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
echo '****************************************************************************************************'
echo '________________________________DATE CALCULATIONS: START, END, NUMBER OF DAY _____________________'
echo '------------------- JULDAY & CALDAY PROGRAMS ARE USED FROM PASSCAL SOFTWARE ----------------------'
echo '****************************************************************************************************'
  # ********************************************************************************************************
  # Init the beginning date of the QC process *
  #*********************************************************************************************************
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
  echo "###################################################################################################################"
  echo '*********************####### AFTER CALCULATION, RETRIEVE THE DATE VARIABLES ....################*******************'
  echo "###################################################################################################################"
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
  ##########################################################################
echo '***************************************************************************************************'
echo '__________________________________LOGS DIRECTORIES_________________________________________________'
echo '***************************************************************************************************'
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
###########################################################
if [ $error != 0 ]
then
 echo "Can't create directories !..."
 kill $pid_script
fi
###########################################################
rm -f $dir_logs_daily/*
####################################################################
echo '****************************************************************************************************'
echo '********************************** TEMP DIRECTORIES ************************************************'
echo '****************************************************************************************************'
#############################################################
dir_temp_daily=$dir_work_base/temp
##########################################
echo 'dir_temp_daily = '$dir_temp_daily
##########################################
error=0
if [ ! -d $dir_temp_daily ]
then 
 mkdir -p $dir_temp_daily
 error=$?
 echo 'Directory '$dir_temp_daily' created...'
else
 echo 'Directory '$dir_temp_daily' already exists...' 
fi
##############################################
echo 'Move to the  Directory temp/...'
##############################################
if [ $error != 0 ]
then
 echo "Can't create directories !..."
 kill $pid_script
fi
##############################################
cd $dir_temp_daily          
rm -f *
##############################################                                                                                     
echo '***************************************************************************************************'
echo '*************************************  REPORTS  DIRECTORIES ***************************************'
echo '***************************************************************************************************'
##################################################################
dir_reports_base=$dir_work_base/reports      
dir_reports_daily=$dir_reports_base/$start_qc_day'.'$start_qc_year
##################################################################
echo 'dir_reports_base = '$dir_reports_base
echo 'dir_reports_daily = '$dir_reports_daily 
##############################################
error=0
if [ ! -d $dir_reports_daily ]
then
 mkdir -p $dir_reports_daily 
 error=$?
 echo 'Directory '$dir_reports_daily' created...'
else
 echo 'Directory '$dir_reports_daily' already exists...' 
fi
###################################################
dir_reports_daily=$dir_reports_daily/$network_name
echo 'dir_reports_daily = '$dir_reports_daily 
###################################################
if [ ! -d $dir_reports_daily ]
then
 mkdir -p $dir_reports_daily
 error=$? 
 echo 'Directory '$dir_reports_daily' created...'
else
 echo 'Directory '$dir_reports_daily' already exists...' 
fi
###################################################
dir_reports_daily=$dir_reports_daily/$station_name
echo 'dir_reports_daily = '$dir_reports_daily 
###################################################
if [ ! -d $dir_reports_daily ]
then
 mkdir -p $dir_reports_daily 
 error=$?
 echo 'Directory '$dir_reports_daily' created...'
else
 echo 'Directory '$dir_reports_daily' already exists...' 
fi
###################################################
dir_reports_daily=$dir_reports_daily/$channel_to_analyse.D
echo 'dir_reports_daily = '$dir_reports_daily 
###################################################
if [ ! -d $dir_reports_daily ]
then
 mkdir -p $dir_reports_daily 
 error=$?
 echo 'Directory '$dir_reports_daily' created...'
else
 echo 'Directory '$dir_reports_daily' already exists...' 
fi
###################################################
dir_reports_daily=$dir_reports_daily/$year1.$day1'_'$year2.$day2
echo 'dir_reports_daily = '$dir_reports_daily 
###################################################
if [ ! -d $dir_reports_daily ]
then
 mkdir -p $dir_reports_daily 
 error=$?
 echo 'Directory '$dir_reports_daily' created...'
else
 echo 'Directory '$dir_reports_daily' already exists...' 
fi
###########################################################
if [ $error != 0 ]
then
 echo "Can't create directories !..."
 kill $pid_script
fi
###########################################################
##############################################
rm -f $dir_reports_daily/*
##############################################
echo '***************************************************************************************************'
echo '********************************* TASKS BASE DIRECTORIES (SDS) ************************************'
echo '***************************************************************************************************'
dir_tasks_base=$dir_work_base/tasks
echo "dir_tasks_base = "$dir_tasks_base
echo '****************************************************************************************************'
echo '_______________________STEP 2 CREATE AND WRITE HEADER REPORT FILES_______________________________'
echo '****************************************************************************************************'
echo "START (MM/DD/AAAA) = "$date1_qc
#************************************************************
echo  "END (MM/DD/AAAA) = "$date2_qc
#************************************************************
echo "days_number = "$days_number 
#************************************************************
serveur=$server_name
reseau=$network_name
if [ $location_code == NO_LOC ]
then
 location=""
else
 location=$location_code
fi
station=$station_name
canal=$channel_to_analyse
##################################
echo 'serveur = '$serveur 
echo 'reseau = '$reseau
echo 'location = '$location
echo 'station = '$station 
echo 'canal = '$canal
echo 'rate = '$rate
echo '***************************************************************************************************'
echo '__________________________________BASE NAME REPORTS FILES__________________________________________'
echo '***************************************************************************************************'
suffix_file_report_summary='qc_report_summary'
echo 'suffix_file_report_summary = '$suffix_file_report_summary
suffix_file_tasks_list='qc_tasks_list'
echo 'suffix_file_tasks_list = '$suffix_file_tasks_list        
echo '***************************************************************************************************' 
##################################
files_suffix=$reseau'.'$station'.'$location'.'$canal'.D.'
echo 'files_suffix = '$files_suffix
##################################
dir_data_station=$dir_data_base'/'$year1'/'$reseau'/'$station_name'/'$canal'.D/'
echo 'dir_data_station = '$dir_data_station
#*********************************************************************************************************
#_______________________________________FILE_REPORT_SUMMARY HEADER REPORT________________________________#
#*********************************************************************************************************
file_report_summary=$dir_reports_daily'/'$suffix_file_report_summary'.D'
echo 'file_report_summary='$file_report_summary
>$file_report_summary
###
file_report_summary_header=$dir_reports_daily'/'$suffix_file_report_summary'.header.D'
echo 'file_report_summary_header='$file_report_summary_header
>$file_report_summary_header
###
file_report_summary_body=$dir_reports_daily'/'$suffix_file_report_summary'.body.D'
echo 'file_report_summary_body='$file_report_summary_body
>$file_report_summary_body
###
file_report_summary_end=$dir_reports_daily'/'$suffix_file_report_summary'.end.D'
echo 'file_report_summary_end='$file_report_summary_end
>$file_report_summary_end
echo '***************************************************************************************' >> $file_report_summary_header
echo $version_script >> $file_report_summary_header
echo "   Script : $name_script" >> $file_report_summary_header
echo " Log File : $dir_logs_daily/$name_script_log" >> $file_report_summary_header
echo 'OPEN-'`date`   >> $file_report_summary_header
echo $file_report_summary >> $file_report_summary_header
echo 'The number of days= '$days_number >>$file_report_summary_header 
echo 'START DATE (MM/DD/AAAA) = '$date1_qc' '$day1'.'$year1 >>$file_report_summary_header 
echo 'END DATE (MM/DD/AAAA) = '$date2_qc' '$day2'.'$year2 >>$file_report_summary_header   
echo 'command check_file: '$version_check_file'  ***' >> $file_report_summary_header
echo 'command qmerge    : '$version_qmerge'  ***' >> $file_report_summary_header
echo '  -----------------------------------------------------------------------------------  ' >>$file_report_summary_header 
echo 'Serveur ='$serveur >> $file_report_summary_header
echo 'STATION: '$station '*Files: '$dir_data_station >>$file_report_summary_header
echo '_______________________________________________________________________________________' >> $file_report_summary_header
#*********************************************************************************************************
#_______________________________________FILE_REPORT_TASKS_LIST HEADER REPORT_____________________________#
#*********************************************************************************************************
file_report_tasks_list=$dir_reports_daily'/'$suffix_file_tasks_list'.D'
echo 'file_report_tasks_list = '$file_report_tasks_list
> $file_report_tasks_list  
echo '***************************************************************************************' >>$file_report_tasks_list
echo $version_script >> $file_report_tasks_list
echo "   Script : $name_script" >>  $file_report_tasks_list
echo " Log File : $dir_logs_daily/$name_script_log" >>  $file_report_tasks_list
echo 'OPEN-'`date` >> $file_report_tasks_list
echo $file_report_tasks_list >>$file_report_tasks_list
echo 'The number of days= '$days_number >>$file_report_tasks_list
echo 'START DATE (MM/JJ/AAAA) = '$date1_qc' '$day1'.'$year1 >>$file_report_tasks_list
echo 'END DATE (MM/JJ/AAAA) = '$date2_qc' '$day2'.'$year2 >>$file_report_tasks_list
echo 'command check_file: '$version_check_file'  ***' >>$file_report_tasks_list
echo 'command qmerge    : '$version_qmerge'  ***' >>$file_report_tasks_list
echo '  -----------------------------------------------------------------------------------  ' >>$file_report_tasks_list
echo 'Serveur = '$serveur >>$file_report_tasks_list
echo 'Station = '$station '*Files: '$dir_data_station  >>$file_report_tasks_list
echo '_______________________________________________________________________________________' >>$file_report_tasks_list
echo '***************************************************************************************************'
echo '___________________________STEP 3 RECURSIVE LOOP  TO ANALYSE FILES_______________________________'
echo '***************************************************************************************************'
#*********************************************************************************************************
#************************************** LOOP VARIABLES      *********************************************
#*********************************************************************************************************
total_time_gap=0
total_time_overlap=0
total_time_period=$temps_secs 
echo "////////////////////////////////////////////////////////////////////////"
echo "total_time_period (s) = "$total_time_period
echo "////////////////////////////////////////////////////////////////////////"
old_flag_days=0
gap_rate=0
compteur_Files_gaps_overs=0
compteur_Files_corrupted=0
compteur_Files_error_config=0
compteur_Files_absents=0
compteur_Files=0
compteur_jour1=0
echo "days_number = "$days_number
###########################################
while [ $compteur_jour1 != $days_number ]
do
 compteur_problems=0
 ####################################################################
 echo "compteur_jour1 = "$compteur_jour1
 day_file1=$( date -d "$date1_qc +$compteur_jour1 days" "+%j" )
 echo "day_file1 ="$day_file1
 date_file1=$( date -d "$date1_qc +$compteur_jour1 days" "+%D" )
 echo "date_file1="$date_file1
 ddd1=$( date -d "$date1_qc +$compteur_jour1 days" +%d )
 echo "ddd1 ="$ddd1
 mmm1=$( date -d "$date1_qc +$compteur_jour1 days" +%m )
 echo "mmm1 ="$mmm1
 year_file1=$( date -d "$date1_qc +$compteur_jour1 days" +%Y )
 echo "year_file1 ="$year_file1
 ####################################################################
 compteur_jour2=$(( compteur_jour1 + 1 ))
 echo "compteur_jour2 = "$compteur_jour2
 day_file2=$( date -d "$date1_qc +$compteur_jour2 days" +%j )
 echo "day_file2 ="$day_file2
 date_file2=$( date -d "$date1_qc +$compteur_jour2 days" "+%D" )
 echo "date_file2="$date_file2
 year_file2=$( date -d "$date1_qc +$compteur_jour2 days" +%Y )
 echo "year_file2 ="$year_file2
 ####################################################################
 file_name1=$reseau'.'$station'.'$location'.'$canal'.D.'$year_file1'.'$day_file1
 echo 'file_name1 = '$file_name1
 dir_data_station1=$dir_data_base'/'$year_file1'/'$reseau'/'$station_name'/'$canal'.D/'
 echo 'dir_data_station1 = '$dir_data_station1
 dir_data_station11=$dir_data_base'/'$year_file1'/'$reseau'/'$station_name
 #///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 file_name2=$reseau'.'$station'.'$location'.'$canal'.D.'$year_file2'.'$day_file2
 echo 'file_name2 = '$file_name2
 dir_data_station2=$dir_data_base'/'$year_file2'/'$reseau'/'$station_name'/'$canal'.D/'
 echo 'dir_data_station2 = '$dir_data_station2
 dir_data_station22=$dir_data_base'/'$year_file2'/'$reseau'/'$station_name
 ####################################################################
 error_flag=0
 echo "error_flag="$error_flag
 if [ ! -d $dir_data_station11 ]
 then
  echo "$dir_data_station11 doesn't exist !" 
  echo "There is no data available for the request while or there is a"
  echo "copy problem. Check the associated ae_qc_global_steps_process_v1.42.log file..."
  echo "$dir_data_station11 doesn't exist !"  >> $file_report_summary_body
  echo "There is no data available for the request while or there is a" >> $file_report_summary_body
  echo "copy problem. Check the associated ae_qc_global_steps_process_v1.42.log file..." >> $file_report_summary_body
  error_flag=1
  echo "error_flag="$error_flag  
 fi #=> if [ ! -d $dir_data_station11 ]
 ###########################################################
 if [ ! -d $dir_data_station22 -a  $error_flag == 0 ]
 then
  echo "$dir_data_station22 doesn't exist !" 
  echo "There is no data available for the request while or there is a"
  echo "copy problem. Check the associated ae_qc_global_steps_process_v1.42.log file..."
  echo "$dir_data_station22 doesn't exist !"  >> $file_report_summary_body
  echo "There is no data available for the request while or there is a" >> $file_report_summary_body
  echo "copy problem. Check the associated ae_qc_global_steps_process_v1.42.log file..." >> $file_report_summary_body
  echo "error_flag="$error_flag
 fi #=> if [ ! -d $dir_data_station22 -a  $error_flag != 0 ]
 ##########################################################
 if [ $error_flag == 1 ]
 then
  if [ "$emails" != NONE ]
  then
   cat $file_report_summary_header $file_report_summary_end  $file_report_summary_body >  $file_report_summary
   echo 'CLOSE-'`date` >>$file_report_summary
   echo '******************************************************************************************' >>$file_report_summary
   rm -f $file_report_summary_header
   rm -f $file_report_summary_body
   rm -f $file_report_summary_end
   title_fix=$emails_title-$serveur-$reseau-$station-$canal
   echo "title_fix = "$title_fix
   if [[ $emails_list =~ "+" ]]
   then
    echo "Send with mutiple destination address !"
    echo "emails_list="$emails_list
    echo $emails_list > emails_list
    champ=$( sed "s/+/ /g" emails_list )
    emails=$champ
    echo "emails=""$emails"
    cmd="mail  -s "$title_fix" $emails  < $file_report_summary "
    echo "cmd="$cmd
    eval $cmd
    cmd_ok=$?
    echo "cmd_ok="$?
   else
    echo "Send with a sender and receiver !"
    echo "emails_list="$emails_list
    echo $emails_list > emails_list
    champ=$( sed "s/,/ /g" emails_list )
    emails=$champ
    echo "emails=""$emails"
    cmd="mail  -s "$title_fix" -r $emails  < $file_report_summary "
    echo "cmd="$cmd
    eval $cmd
    cmd_ok=$?
    echo "cmd_ok="$?
   fi #=> if [[ $emails_list =~ "+" ]]  
  fi #=> if [ "$emails" != NONE ] 
  exit
 fi #=> if [ $error_flag == 1 ]
 ###########################################################
 echo "** file_name1 = "$file_name1
 echo "** file_name2 = "$file_name2
 ###
 file_name3=$dir_data_station1$file_name1
 file_name4=$dir_data_station2$file_name2
 ###
 echo "** file_name3 = "$file_name3
 echo "** file_name4 = "$file_name4
 echo "------------------------------------------------------"
 ###
 file_name3_short=$canal'.D/'$file_name1
 file_name4_short=$canal'.D/'$file_name2
 #**********************************************************************************************************
 qmerge1_correct_output1=$station'.'$reseau'.'$canal'.'$location'_rate='$rate
 qmerge1_correct_output2=$year_file1'.'$day_file1  
 file3_status="#_CHECK=_"
 rm -f error_file 
 rm -f error_file2
 echo "DEBUG qmerge1_correct_output1 = "$qmerge1_correct_output1
 echo "DEBUG qmerge1_correct_output2 = "$qmerge1_correct_output2
 #**********************************************************************************************************
 echo "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
 echo "file_name3 = "$file_name3
 echo "Temps = "$SECONDS"s"
 echo "------------------------------------------------------"
 if [ -s $file_name3 ]
 then
  compteur_Files=$(( 10#$compteur_Files + 1 ))
  echo "compteur_Files = "$compteur_Files 
  echo $qmerge1_correct_output2" = Qmerge1 normal output2..."
  rm -f temp_file
  $dir_bin_base/dataselect -Q D -o  temp_file  $file_name3
  ($dir_bin_base/qmerge -b 512 -a -u -v  temp_file > file_to_check_1 ) >& error_file2
  #************************************************************************
  cat error_file2
  echo "////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
  champ=$(sed  's/ /_/g' error_file2 )
  echo $champ > error_file
  champ=$(sed  's/ /_/g' error_file )
  echo $champ > error_file
  echo "-->"$champ 
  echo "////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
  #************************************************************************
  echo $qmerge1_correct_output1" = Qmerge1 normal output1..."
  #************************************************************************
  champ2=$(grep Error error_file)
  champ2=$champ2$(grep decode_error error_file)
  champ2=$champ2$(grep invalid_ck error_file)
  champ2=$champ2$(grep Unknown_data_format error_file)
  champ2=$champ2$(grep corrupt error_file)
  champ2=$champ2$(grep Data_integrity error_file)
  echo "////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
  echo "Errors detected = "$champ2
  #************************************************************************
  if (( ${#champ2} > 2 )) 
  then 
   echo "File integrity or/and block size/compression seem NOT  OK..."
   file3_status_1="Data-Integrity!"
   compteur_Files_corrupted=$((10#$compteur_Files_corrupted + 1 ))
   echo "compteur_Files_corrupted = "$compteur_Files_corrupted
   rm -f  file_to_check_1
  else
   echo "File integrity and block size/compression seem OK..."
   file3_status_1="OK"
  fi
  #************************************************************************ 
  if [[ $champ =~ $qmerge1_correct_output1 ]] 
  then
   file3_status_2="OK"
   echo "Station name, channel and frequency of file seem  OK..."
  else
   file3_status_2="Chan!Name!Rate!"
   echo "Station name, channel or/and frequency of file seem  NOT OK..."
   rm -f  file_to_check_1
  fi
  #************************************************************************
  if [[ $champ =~ $qmerge1_correct_output2 ]] 
  then 
   file3_status_3="OK"
   echo "File date seems OK..."
  else
   file3_status_3="Date!"
   echo "File date seems  NOT OK..."
  fi
  #************************************************************************
  echo "file3_status_1 = "$file3_status_1
  echo "file3_status_2 = "$file3_status_2
  echo "file3_status_3 = "$file3_status_3
  #************************************************************************
  if [ $file3_status_2 != "OK" -o  $file3_status_3 != "OK" ] 
  then
   compteur_Files_error_config=$((10#$compteur_Files_error_config +1 ))
   echo "compteur_Files_error_config = "$compteur_Files_error_config   
  fi
  #************************************************************************
  if [ $file3_status_1 == "OK" ]
  then
   if [ $file3_status_2 == "OK" -a $file3_status_3 == "OK" ] 
   then
    file3_status=$file3_status"FILE_OK."
   else
    if [ $file3_status_2 != "OK" ]  
    then
     file3_status=$file3_status$file3_status_2
    fi
    if [ $file3_status_3 != "OK" ]
    then
     file3_status=$file3_status$file3_status_3
    fi   
   fi #--> if [ $file3_status_2 == "OK" -a $file3_status_3 == "OK " ]
  else  #-->  [ $file3_status_1 == "OK" ]
   file3_status=$file3_status$file3_status_1
   if [ $file3_status_2 != "OK" ]  
   then
    file3_status=$file3_status$file3_status_2
   fi
   if [ $file3_status_3 != "OK" ]
   then
    file3_status=$file3_status$file3_status_3
   fi     
  fi  #-->  if [ $file3_status_1 == "OK" ]
  #************************************************************************
  echo "Temps = "$SECONDS"s"
  echo "file3_status ="$file3_status
 else #---> if [ -s $file_name3 ]
  echo $file_name3
  echo "Temps = "$SECONDS"s"
  file3_status=$file3_status"NO_FILE_!"
  echo "file3_status = "$file3_status
  type_prob="GAP"
  echo "type_prob = "$type_prob
  ####################################################################
  compteur_Files_absents=$(( 10#$compteur_Files_absents + 1 ))
  echo "compteurs_Files_absents = "$compteur_Files_absents  
  #-------------------------------------------------------------------
  compteur_problems=$((10#$compteur_problems + 1))
  echo "compteur_problems = "$compteur_problems
  #-------------------------------------------------------------------
  total_time_gap=$((10#$total_time_gap + 86400)) 
  gap_rate=$(echo "scale=2; ($total_time_gap/$total_time_period)*100" | bc )
  echo "total_time_gap (s) = "$total_time_gap
  echo "gap_rate (%) = "$gap_rate
 fi #---> if [  -s $file_name3 ]
 #########################################################################
 #########################################################################
 if [ $file3_status != "#_CHECK=_FILE_OK." -a  $file3_status != "#_CHECK=_Date!" ]
 then
   yy=$year_file1
   echo $yy
   dd=$ddd1
   echo $dd
   mm=$mmm1
   echo $mm
  #####################################################################
  if [[  $file3_status =~ "Chan!Name!Rate!"  ]]
  then
   type_prob="CHAN_NAME_RATE"
   problems_info="__!CHAN_NAME_RATE=_"$yy"-"$mm"-"$dd"_00:00:00_to_"$yy"-"$mm"-"$dd"_23:59:59=86400s"  
  fi
  echo "type_prob = "$type_prob
  #############################################################################
  # IF THERE IS THE BOTH PROBLEMS  CHAN_NAME_RATE & INTEGRITY ONLY THE INTEGRITY PROBLEM WILL BE REFERENCED
  #############################################################################
  if [[  $file3_status =~ "Data-Integrity!"  ]]
  then
   type_prob="INTEGRITY"
   problems_info="__!INTEGRITY=_"$yy"-"$mm"-"$dd"_00:00:00_to_"$yy"-"$mm"-"$dd"_23:59:59=86400s"  
  fi
  #################################
  if [[  $file3_status =~ "NO_FILE_!"  ]]
  then
   type_prob="GAP"
   problems_info="__!GAP=_"$yy"-"$mm"-"$dd"_00:00:00_to_"$yy"-"$mm"-"$dd"_23:59:59=86400s"    
  fi
  #*****************************************************************************************
  if [ $type_prob == "INTEGRITY" -o $type_prob == "GAP"  -o $type_prob == "CHAN_NAME_RATE" ]
  then
   #######################################################################################
   echo "problems_info = "$problems_info
   ## CREATE THE NAME OF THE TASK
   base_name_task=$yy.$mm.$dd"_00:00:00_to_"$yy.$mm.$dd"_23:59:59.task"
   echo "base_name_task = "$base_name_task
   #######################################################################################################
   ## CHECK IN THE  TASKS STRUCTURE IF THIS TASK ISN'T ALREADY REFERENCED
   doublon=$( grep "$problems_info" $file_report_tasks_list)
   if  ((${#doublon} <2 ))
   then
    #######################################################################################
    ## IF NEEDEED, THE TASK LIST IS CREATED
    #######################################################################################
    error=0
    #***********************************************
    name_task=$dir_tasks_base/$year_file1
    if [ ! -d $name_task ]
    then
     mkdir -p $name_task
     error=$?
    fi
    #***********************************************
    name_task=$dir_tasks_base/$year_file1/$reseau
    if [ ! -d $name_task ]
    then
     mkdir -p $name_task
     error=$?
    fi
    #***********************************************
    name_task=$dir_tasks_base/$year_file1/$reseau/$station
    if [ ! -d $name_task ]
    then
     mkdir -p $name_task
     error=$?
    fi
    #***********************************************
    name_task=$dir_tasks_base/$year_file1/$reseau/$station/$canal.D
    if [ ! -d $name_task ]
    then
     mkdir -p $name_task
     error=$?
    fi
    #***********************************************
    if [ $error != 0 ]
    then
     echo "Can't create directories !..."
     kill $pid_script
    fi
    #***********************************************
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >>$file_report_tasks_list 
    name_task=$name_task/$base_name_task
    echo "$problems_info" >>$file_report_tasks_list 
    echo $name_task >>$file_report_tasks_list
    task_flag=0
    echo "task_flag="$task_flag
    #***********************************************
    if [ $task_list_mode  == RESET ]
    then
     rm -f $name_task
     echo "Task created -old is deleted if exists."
     echo "Task created -old is deleted if exists." >>$file_report_tasks_list
     > $name_task
     task_flag=1
     echo "task_flag="$task_flag
    fi
    #***********************************************
    if [ $task_list_mode  == KEEP ]
    then
     if [ -s $name_task ]
     then
      echo "Task already exits."
      echo "Task already exits." >>$file_report_tasks_list
      echo "`date` $name_script LAST_LOG AISSAOUI IPGP PARIS 2011 " >> $name_task
     else
      rm -f $name_task
      > $name_task
      echo "Task created."      
      task_flag=1
      echo "task_flag="$task_flag
     fi
    fi
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" 
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >>$file_report_tasks_list 
    if [ $task_flag == 1 ]
    then
     #***** START FILLING THE TASK FIELDS *****
     echo  "`date`  $name_script OPEN" >>$name_task
     echo  "$version_script" >>$name_task
     echo  "$reseau  NETWORK"      >>$name_task
     echo  "$location_code LOCATION"    >>$name_task
     echo  "$station STATION"      >>$name_task
     echo  "$canal   CANAL"        >>$name_task
     echo  "$serveur SERVER"       >>$name_task
     echo  "$dir_data_station DIR_DATA_STATION" >>$name_task
     echo  "$year_file1     YEAR_FILE1" >>$name_task
     echo  "$year_file2     YEAR_FILE2" >>$name_task
     echo  "$type_prob PROB_TYPE" >>$name_task
     ##### 
     echo  "$yy  START_YEAR"  >>$name_task
     echo  "$mm START_MONTH" >>$name_task   
     echo  "$dd   START_DAY"   >>$name_task
     echo  "00  START_HOUR"  >>$name_task
     echo  "00   START_MIN"   >>$name_task
     echo  "00   START_SEC"   >>$name_task  
     ##### 
     echo  "$yy  END_YEAR"    >>$name_task
     echo  "$mm END_MONTH"   >>$name_task 
     echo  "$dd   END_DAY"     >>$name_task
     echo  "23  END_HOUR"    >>$name_task
     echo  "59   END_MIN"     >>$name_task
     echo  "59   END_SEC"     >>$name_task
     #####
     echo  "$file_name1 NAME_FILE1"  >>$name_task
     echo  "$file_name3 LINK_FILE1"  >>$name_task
     echo  "$file3_status FILE1_STATUS" >>$name_task
     echo  "UNKNOW NAME_FILE2"      >>$name_task
     echo  "UNKNOW LINK_FILE2" >>$name_task
     echo  "UNKNOW FILE2_STATUS" >>$name_task
     echo  "$date_file1 DATE_FILE1" >>$name_task
     echo  "$date_file2 DATE_FILE2" >>$name_task
     echo  "**** DETAILS_LOGS ***">>$name_task
     echo "------------------------------------------------------"
     echo "***** THE CREATION OF THE TASK IS FINISHED  *****"
     echo "_____________________________________________________"
    fi #--> [ $task_flag == 1 ]
   fi #--> if  ((${#doublon} <2 ))   
  fi #--> if [ $type_prob == "INTEGRITY" -o $type_prob == "GAP"  -o $type_prob == "CHAN_NAME_RATE" ]
 fi  #--> if [ $file3_status != "#_CHECK=_FILE_OK." -a  $file3_status != "#_CHECK=_Date!" ]
 echo "------------------------------------------------------"
 echo "Temps = "$SECONDS"s"
 echo $file_name3
 echo "file3_status ="$file3_status
 echo "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
 #**********************************************************************************************************
 qmerge2_correct_output1=$station'.'$reseau'.'$canal'.'$location'_rate='$rate
 qmerge2_correct_output2=$year_file2'.'$day_file2 
 file4_status="#_CHECK=_"
 ###
 rm -f error_file 
 rm -f error_file2
 ###
 echo "DEBUG qmerge2_correct_output1 = "$qmerge2_correct_output1
 echo "DEBUG qmerge2_correct_output2 = "$qmerge2_correct_output2
 #**********************************************************************************************************
 echo "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
 echo $file_name4
 echo "Temps = "$SECONDS"s"
 echo "------------------------------------------------------"
 if [ -s $file_name4 ]
 then
  echo $qmerge2_correct_output2" = Qmerge2 normal output2..."
  rm -f temp_file
  $dir_bin_base/dataselect -Q D -o  temp_file  $file_name4
  ($dir_bin_base/qmerge -b 512 -a -u -v  temp_file > file_to_check_2) >& error_file2
  #************************************************************************
  cat error_file2
  echo "////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
  champ=$(sed  's/ /_/g' error_file2 )
  echo $champ > error_file
  champ=$(sed  's/ /_/g' error_file )
  echo $champ > error_file
  echo "-->"$champ 
  echo "////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
  #************************************************************************
  echo $qmerge2_correct_output1" = Qmerge2 normal output1..."
  #************************************************************************
  champ2=$(grep Error error_file)
  champ2=$champ2$(grep decode_error error_file)
  champ2=$champ2$(grep invalid_ck error_file)
  champ2=$champ2$(grep Unknown_data_format error_file)
  champ2=$champ2$(grep corrupt error_file)
  champ2=$champ2$(grep Data_integrity error_file)
  echo "////////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"
  echo "Errors detected = "$champ2
  #************************************************************************
  if (( ${#champ2} > 2 )) 
  then 
   echo "File Integrity and block size/compression seem NOT OK..."
   file4_status_1="Data-Integrity!"
   rm -f file_to_check_2
  else
   echo "File Integrity and block size/compression seem OK..."
   file4_status_1="OK"
  fi
  #************************************************************************ 
  if [[ $champ =~ $qmerge2_correct_output1 ]] 
  then
   file4_status_2="OK"
   echo "Station name, channel and frequency of file seem  OK..."
  else
   file4_status_2="Chan!Name!Rate!"
   echo "Station name, channel and frequency of file seem  NOT OK..."
   rm -f file_to_check_2
  fi
  #************************************************************************
  if [[ $champ =~ $qmerge2_correct_output2 ]] 
  then 
   file4_status_3="OK"
   echo "File date seems OK..."
  else
   file4_status_3="Date!"
   echo "File date seems  NOT OK..."
  fi
  #************************************************************************
  echo "file4_status_1 = "$file4_status_1
  echo "file4_status_2 = "$file4_status_2
  echo "file4_status_3 = "$file4_status_3
  #************************************************************************
  if [ $file4_status_1 == "OK" ]
  then
   if [ $file4_status_2 == "OK" -a $file4_status_3 == "OK" ] 
   then
    file4_status=$file4_status"FILE_OK."
   else
    if [ $file4_status_2 != "OK" ]  
    then
     file4_status=$file4_status$file4_status_2
    fi
    if [ $file4_status_3 != "OK" ]
    then
     file4_status=$file4_status$file4_status_3
    fi   
   fi #--> if [ $file4_status_2 == "OK" -a $file4_status_3 == "OK " ]
  else  #-->  [ $file4_status_1 == "OK" ]
   file4_status=$file4_status$file4_status_1
   if [ $file4_status_2 != "OK" ]  
   then
    file4_status=$file4_status$file4_status_2
   fi
   if [ $file4_status_3 != "OK" ]
   then
    file4_status=$file4_status$file4_status_3
   fi   
  fi  #-->  if [ $file4_status_1 == "OK" ]
  #************************************************************************
 else #-->if [ -s $file_name4 ]
  file4_status=$file4_status"NO_FILE_!"
 fi #--> if [ -s $file_name4 ]
 echo "------------------------------------------------------"
 echo "Temps = "$SECONDS"s"
 echo $file_name4
 echo "file4_status ="$file4_status
 echo "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
 ###########################################################################################################"
 file_to_check=$files_suffix'.'$year_file1'.'$day_file1'..'$year_file2'.'$day_file2   
 echo "DEBUG file_to_check = "$file_to_check
 rm -f $file_to_check
 if [ -s file_to_check_1 ]
 then
  if [ -s file_to_check_2 ]
  then
   ($dir_bin_base/qmerge -b 512 -a -u -v file_to_check_1 file_to_check_2 > $file_to_check) >& error_file2
   echo "error_file2:"
   cat error_file2
  else #--> if [ -s file_to_check_2 ]
   mv -f  file_to_check_1  $file_to_check 
  fi #--> if [ -s file_to_check_2 ]
 #************************************************************************************************
 else #-->[ -s file_to_check_1 ]
 #************************************************************************************************
  if [ -s file_to_check_2 ]
  then
   mv -f  file_to_check_2  $file_to_check
  else
   echo "file_to_check1 and file_to_check2 don't exist !"
  fi 
 fi #-->[ -s file_to_check_1 ]
 ###############################################################################
 echo "DEBUG"
 #kill $$
 rm -f file_to_check_1
 rm -f file_to_check_2
 rm -f file_result_output
 rm -f problem_display_file
 ###
 ## TO AVOID EMPTY FILE
 echo ' ' > file_result_output
 ###############################################################################
 if [ -s $file_to_check ]
 then
  echo "####################################################"
  echo 'FILE_TO_CHECK='$file_to_check 
  $dir_bin_base/check_file  $file_to_check > file_result_output
  #**********************************
  problem_status="#_CHECKING_OK"
  #**********************************
  rm -f problem_display_file 
  > problem_display_file
  ###################### ANALYSE THE OUTPUT OF THE TEXT FILE:  file_result_output ############
  while read line1
  do 
   line=$line1 
   champ=$(echo $line | grep "Time-gap:")
   if  ((${#champ} > 1))
   then
    compteur_problems=$((10#$compteur_problems + 1))
    echo "compteur_problems = "$compteur_problems
    ###################################################
    problem_status="#_CHECKING_NOT_OK"
    ###################################################
    echo "-------------------------------------------------------"
    ####################################################################################################
    # FOR  DEBUGGING...
    # champ="Time-gap: 2009/03/12 05:29:38.6800 instead of 2009/03/12 01:44:34.6799 in stream HMBCX HHE"  
    # champ="Time-gap: 2009/03/12 01:44:34.6799 instead of 2009/03/12 05:29:38.6800 in stream HMBCX HHE"
    ####################################################################################################
    echo "------------------------------------------------------"
    echo $champ
    echo "------------------------------------------------------"
    #*****************************************
    year22=$((10#${champ:10:4}))
    month22=$((10#${champ:15:2}))
    day22=$((10#${champ:18:2}))
    #-------------------------------------------
    hour22=$((10#${champ:21:2}))
    min22=$((10#${champ:24:2})) 
    sec22=$((10#${champ:27:2}))
    #*****************************************
    year11=$((10#${champ:46:4}))
    month11=$((10#${champ:51:2}))
    day11=$((10#${champ:54:2}))
    #-------------------------------------------
    hour11=$((10#${champ:57:2}))
    min11=$((10#${champ:60:2}))
    sec11=$((10#${champ:63:2}))
    ####################################################################################################
    echo "DEBUG : y2="$year22"|m2="$month22"|d2="$day22"|h2="$hour22"|mi2="$min22"|s2="$sec22
    echo "DEBUG : y1="$year11"|m1="$month11"|d1="$day11"|h1="$hour11"|mi1="$min11"|s1="$sec11
    ####################################################################################################
    t1=$( date -d "$year11/$month11/$day11 $hour11:$min11:$sec11" +%s )
    echo "t1 (s) =  "$t1
    t2=$( date -d "$year22/$month22/$day22 $hour22:$min22:$sec22" +%s )
    echo "t2 (s) =  "$t2
    timing=$(( 10#$t2 -10#$t1 ))
    echo "timing = "$timing
    ####################################################################################################
    if (( timing < 0 ))
    then
     type_prob="OVERLAP"
    fi
    if (( timing > 0 ))
    then
     type_prob="GAP"
    fi
    if [ $timing == 0 ]
    then
     timing=1
     type_prob="GAP"
     echo "timing="$timing
    fi
    #######################################################################################################
    ## CREATE AND FORMAT INFORMATION STRINGS WHICH WILL BE DISPLAY/WRITE IN THE DIFFERENT FILES
    problem_display[$compteur_problems]="__!"$type_prob"="
    problem_display[$compteur_problems]=${problem_display[$compteur_problems]}$year11"-"$month11"-"$day11"_" 
    problem_display[$compteur_problems]=${problem_display[$compteur_problems]}$hour11":"$min11":"$sec11"_to_"
    problem_display[$compteur_problems]=${problem_display[$compteur_problems]}$year22"-"$month22"-"$day22" "     
    problem_display[$compteur_problems]=${problem_display[$compteur_problems]}$hour22":"$min22":"$sec22
    problem_display[$compteur_problems]=${problem_display[$compteur_problems]}"="$timing"s"
    echo -e "problem_display="${problem_display[$compteur_problems]}
    echo -e  ${problem_display[$compteur_problems]} >> problem_display_file
    ####
    echo "------------------------------------------------------"
    problem_details[$compteur_problems]=$year11"."$month11"."$day11"_"
    problem_details[$compteur_problems]=${problem_details[$compteur_problems]}$hour11":"$min11":"$sec11"_to_"
    problem_details[$compteur_problems]=${problem_details[$compteur_problems]}$year22"."$month22"."$day22"_" 
    problem_details[$compteur_problems]=${problem_details[$compteur_problems]}$hour22":"$min22":"$sec22".task"
    echo "problem_details = "${problem_details[$compteur_problems]}
    problem_type[$compteur_problems]=$type_prob
    echo "problem_type = "${problem_type[$compteur_problems]} 
    lost_data[$compteur_problems]=$timing
    echo "lost_data (s) = "${lost_data[$compteur_problems]} 
    #######################################################################################################
    ## CHECK IN THE  TASKS STRUCTURE IF THIS TASK ISN'T ALREADY REFERENCED
    chainx=${problem_display[$compteur_problems]}
    doublon=$( grep "$chainx" $file_report_tasks_list)
    ###############################################################################################
    ## IF NEEDEED, THE TASK LIST IS CREATED
    ##############################################################################################
    if  ((${#doublon} < 2))
    then 
     #######################################################################################################
     compteur_Files_gaps_overs=$(( 10#$compteur_Files_gaps_overs + 1 ))
     echo "compteur_Files_gaps_overs = "$compteur_Files_gaps_overs 
     ##################### COMPLETE GAP TIME VALUE  ####################
     if [ $type_prob == "GAP" ]
     then
      total_time_gap=$((10#$total_time_gap + 10#$timing))
      gap_rate=$(echo "scale=2; ($total_time_gap/$total_time_period)*100" | bc )
      echo "total_time_gap (s) = "$total_time_gap
      echo "gap_rate (%) = "$gap_rate
     fi #--> if [ $type_prob == "GAP" ]
     ##################### COMPLETE OVERLAP TIME VALUE  #################
     if [ $type_prob == "OVERLAP" ]
     then
      total_time_overlap=$(( 10#$total_time_overlap + 10#$timing ))
      echo "total_time_overlap (s) = "$total_time_overlap
     fi #--> if [ $type_prob == "OVERLAP" ]
     #######################################################################################################
     error=0
     #***********************************************
     name_task=$dir_tasks_base/$year_file1
     if [ ! -d $name_task ]
     then
      mkdir -p $name_task
      error=$?
     fi
     #***********************************************
     name_task=$dir_tasks_base/$year_file1/$reseau
     if [ ! -d $name_task ]
     then
      mkdir -p $name_task
      error=$?
     fi
     #***********************************************
     name_task=$dir_tasks_base/$year_file1/$reseau/$station
     if [ ! -d $name_task ]
     then
      mkdir -p $name_task
      error=$?
     fi
     #***********************************************
     name_task=$dir_tasks_base/$year_file1/$reseau/$station/$canal.D
     if [ ! -d $name_task ]
     then
      mkdir -p $name_task
      error=$?
     fi
     #***********************************************
     if [ $error != 0 ]
     then
      echo "Can't create directories !..."
      kill $pid_script
     fi
     #***********************************************
     echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
     echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >>$file_report_tasks_list 
     name_task=$name_task/${problem_details[$compteur_problems]}
     echo "${problem_display[$compteur_problems]}" >>$file_report_tasks_list 
     echo  $name_task >>$file_report_tasks_list
     task_flag=0
     echo "task_flag="$task_flag
     #***********************************************
     if [ $task_list_mode  == RESET ]
     then
      rm -f $name_task
      echo "Task created -old is deleted if exists."
      echo "Task created -old is deleted if exists." >>$file_report_tasks_list
      > $name_task
      task_flag=1
      echo "task_flag="$task_flag
     fi
     #***********************************************
     if [ $task_list_mode  == KEEP ]
     then
      if [ -s $name_task ]
      then
       echo "Task already exits."
       echo "`date` $name_script LAST_LOG AISSAOUI IPGP PARIS 2011 " >> $name_task
      else
       rm -f $name_task
       > $name_task
       echo "Task created."      
       task_flag=1
       echo "task_flag="$task_flag
      fi
     fi
     echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
     echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >>$file_report_tasks_list 
     if [ $task_flag == 1 ]
     then
      #***** START FILLING THE TASK FIELDS *****
      echo  "`date`  $name_script OPEN" >>$name_task
      echo  "$version_script" >>$name_task
      echo  "$reseau  NETWORK"      >>$name_task
      echo  "$station STATION"      >>$name_task
      echo  "$location_code LOCATION"    >>$name_task
      echo  "$canal   CANAL"        >>$name_task
      echo  "$serveur SERVER"       >>$name_task
      echo  "$dir_data_station DIR_DATA_STATION" >>$name_task
      echo  "$year_file1     YEAR_FILE1" >>$name_task
      echo  "$year_file2     YEAR_FILE2" >>$name_task
      echo  "$type_prob PROB_TYPE" >>$name_task
      ##### 
      echo  "$year11  START_YEAR"  >>$name_task
      echo  "$month11 START_MONTH" >>$name_task   
      echo  "$day11   START_DAY"   >>$name_task
      echo  "$hour11  START_HOUR"  >>$name_task
      echo  "$min11   START_MIN"   >>$name_task
      echo  "$sec11   START_SEC"   >>$name_task 
      ##### 
      echo  "$year22  END_YEAR"    >>$name_task
      echo  "$month22 END_MONTH"   >>$name_task 
      echo  "$day22   END_DAY"     >>$name_task
      echo  "$hour22  END_HOUR"    >>$name_task
      echo  "$min22   END_MIN"     >>$name_task
      echo  "$sec22   END_SEC"     >>$name_task
      ##### 
      echo  "$file_name1 NAME_FILE1"  >>$name_task
      echo  "$file_name3 LINK_FILE1"  >>$name_task
      echo  "$file3_status FILE1_STATUS" >>$name_task
      echo  "$file_name2 NAME_FILE2" >>$name_task
      echo  "$file_name4 LINK_FILE2" >>$name_task
      echo  "$file4_status FILE2_STATUS" >>$name_task
      echo  "$date_file1 DATE_FILE1" >>$name_task
      echo  "$date_file2 DATE_FILE2" >>$name_task
      echo  "**** DETAILS_LOGS ***">>$name_task
      echo "------------------------------------------------------"
      echo "***** THE CREATION OF THE TASK IS FINISHED  *****"
      echo "_____________________________________________________"
     fi #-->  [ $task_flag == 1 ]
    fi #--> if  ((${#doublon} < 2))
   fi #-->  if  ((${#champ} > 1))
  done < file_result_output #-->  while read line1
 fi #--> if [ -s $file_to_check ]
 ####################################################################################
 ##### DISPLAY THE RESULT OF ANALYSE
 echo "------------------------------------------------------"
 cat file_result_output
 ####################################################################################
 ################# CASE 1 --> THE BOTH FILES DON'T EXIST ############################
 if [ $file3_status == "#_CHECK=_NO_FILE_!" -a   $file4_status == "#_CHECK=_NO_FILE_!"  ]
 then
  rm -f problem_display_file  
  > problem_display_file
  problem_status="!_NO_FILE_TO_CHECK_!"  
 fi
 ###################################################################################
 ####################################### CASE 2  ###################################
 if [ $file3_status == "#_CHECK=_NO_FILE_!" ]
 then
  #####
  if [[  $file4_status =~ "Data-Integrity!"  ]]
  then
   rm -f problem_display_file  
   > problem_display_file
   problem_status="!_NOT_DONE_!"  
  fi  
  if [[  $file4_status =~ "Chan!Name!Rate!"  ]]
  then
   rm -f problem_display_file  
   > problem_display_file
   problem_status="!_NOT_DONE_!"  
  fi  
 fi
 ####################################################################################
 ####################################### CAS 3  #####################################
 if [[  $file3_status =~ "Data-Integrity!"  ]]
 then
  ####
  if [ $file4_status == "#_CHECK=_NO_FILE_!" ]
  then
   rm -f problem_display_file  
   > problem_display_file
   problem_status="!_NOT_DONE_!"  
  fi
  if [[  $file4_status =~ "Data-Integrity!"  ]]
  then
   rm -f problem_display_file  
   > problem_display_file
   problem_status="!_NOT_DONE_!" 
  fi
  if [[  $file4_status =~ "Chan!Name!Rate!"  ]]
  then
   rm -f problem_display_file  
   > problem_display_file
   problem_status="!_NOT_DONE_!"  
  fi
 fi
 ######################################################################################
 ####################################### CAS 4  #######################################
 if [[  $file3_status =~ "Chan!Name!Rate!"  ]]
 then
  #####
  if [ $file4_status == "#_CHECK=_NO_FILE_!" ]
  then
   rm -f problem_display_file  
   > problem_display_file
   problem_status="!_NOT_DONE_!"   
  fi
  if [[  $file4_status =~ "Data-Integrity!"  ]]
  then
    rm -f problem_display_file  
   > problem_display_file
   problem_status="!_NOT_DONE_!"  
  fi
  if [[  $file4_status =~ "Chan!Name!Rate!"  ]]
  then
   rm -f problem_display_file  
   > problem_display_file
   problem_status="!_NOT_DONE_!"  
  fi  
 fi
 ##### 
 echo "problem_status="$problem_status 
 echo $problem_status >> problem_display_file
 cat problem_display_file
 ##################################################################################################################################
 ############## WRITE RESULT OF THE ANALYSE IN THE FILES REPORT
 if [ "$problem_status" != "#_CHECKING_OK" -o  "$file3_status" != "#_CHECK=_FILE_OK." -o  "$file4_status" != "#_CHECK=_FILE_OK." ]
 then
  #########################################################################################
  files_names_summary=$file_name3_short'_______'$file_name4_short
  files_status_summary=$file3_status'_______'$file4_status
  echo "   "$files_names_summary >>$file_report_summary_body
  echo "   "$files_status_summary >>$file_report_summary_body
  cat   problem_display_file >>$file_report_summary_body
  echo '      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          ' >>$file_report_summary_body
 fi
 ###########################################
 #****** INCREMENT THE DAY COUNTER
 compteur_jour1=$((10#$compteur_jour1 +1 ))
 ###########################################
 echo '****************************************************************************************************'
done #--> while [ $compteur_jour1 != $days_number ] ;
##########
echo '****************************************************************************************************'
echo '________________________STEP 4 CLOSE AND COMPLETE REPORT FILES_____________________________________'
echo '****************************************************************************************************'
####
echo ' Total Files.............: = '$station'/'$canal'.D = '$compteur_Files' ***' >>$file_report_summary_end
echo ' Missed Files............: = '$station'/'$canal'.D = '$compteur_Files_absents '***' >>$file_report_summary_end
echo ' Corrupeted Files........: = '$station'/'$canal'.D = '$compteur_Files_corrupted' ***' >>$file_report_summary_end
echo ' Files with config error.: = '$station'/'$canal'.D = '$compteur_Files_error_config' ***' >>$file_report_summary_end
echo ' Total Gaps/Overlaps.....: = '$station'/'$canal'.D = '$compteur_Files_gaps_overs'  ***'>>$file_report_summary_end
echo ' Total Time GAP(s).......: = '$station'/'$canal'.D = '$total_time_gap'    ***'>>$file_report_summary_end
echo ' GAP(%)..................: = '$station'/'$canal'.D = '$gap_rate'    ***'>>$file_report_summary_end
echo ' Total Time Overlap(s)...: = '$station'/'$canal'.D = '$total_time_overlap'    ***'>>$file_report_summary_end
echo '      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~          ' >>$file_report_summary_end
####
echo '*********************************************' >>$file_report_tasks_list
echo ' Total Files.............: = '$station'/'$canal'.D = '$compteur_Files' ***' >>$file_report_tasks_list
echo ' Missed Files............: = '$station'/'$canal'.D = '$compteur_Files_absents '***' >>$file_report_tasks_list
echo ' Corrupeted Files........: = '$station'/'$canal'.D = '$compteur_Files_corrupted' ***' >>$file_report_tasks_list
echo ' Files with config error.: = '$station'/'$canal'.D = '$compteur_Files_error_config' ***' >>$file_report_tasks_list
echo ' Total Gaps/Overlaps.....: = '$station'/'$canal'.D = '$compteur_Files_gaps_overs'  ***'>>$file_report_tasks_list
echo ' Total Time GAP(s).......: = '$station'/'$canal'.D = '$total_time_gap'    ***'>>$file_report_tasks_list
echo ' GAP(%)..................: = '$station'/'$canal'.D = '$gap_rate'    ***'>>$file_report_tasks_list
echo ' Total Time Overlap(s)...: = '$station'/'$canal'.D = '$total_time_overlap'    ***'>>$file_report_tasks_list
echo '*********************************************'  >>$file_report_tasks_list
echo 'CLOSE-'`date` >>$file_report_tasks_list
echo '******************************************************************************************' >>$file_report_tasks_list  
####
##############################################################################
#### MAKE THE  LINK PATH  TO THE FILE WHERE ARE PUT THE  TASKS OF THIS ANALYSE
rm -f $dir_script/link_qc_tasks.txt
echo $file_report_tasks_list > $dir_script/link_qc_tasks.txt
####
echo '****************************************************************************************************'
echo '______STEP 5 SEND THE REPORTS AND COPY THE LOG FILES _______'
echo '****************************************************************************************************'
if [ "$emails" != NONE ]
then
 cat $file_report_summary_header $file_report_summary_end  $file_report_summary_body >  $file_report_summary
 echo 'CLOSE-'`date` >>$file_report_summary
 echo '******************************************************************************************' >>$file_report_summary
 rm -f $file_report_summary_header
 rm -f $file_report_summary_body
 rm -f $file_report_summary_end
 title_fix=$emails_title-$serveur-$reseau-$station-$canal
 echo "title_fix = "$title_fix
 echo "emails_list="$emails_list
 n=1
 str=$(echo ${emails_list:${#emails_list} - $n})
 echo "str="$str
 # echo "DEBUG"
 # if [ "$str"  == "+" ]
 # then
 #  echo "OK"
 # else
 # echo "NO"
 #fi
 #kill $$
 if [ "$str"  == "+" ]
 then
  echo "Send with mutiple destination address !"
  echo "emails_list="$emails_list
  echo $emails_list > emails_list
  champ=$( sed "s/+/ /g" emails_list )
  emails=$champ
  echo "emails=""$emails"
  cmd="mail  -s "$title_fix" $emails  < $file_report_summary "
  echo "cmd="$cmd
  eval $cmd
  cmd_ok=$?
  echo "cmd_ok="$?
 else
  echo "Send with a sender and receiver !"
  echo "emails_list="$emails_list
  echo $emails_list > emails_list
  champ=$( sed "s/,/ /g" emails_list )
  emails=$champ
  echo "emails=""$emails"
  cmd="mail  -s "$title_fix" -r $emails  < $file_report_summary "
  echo "cmd="$cmd
  eval $cmd
  cmd_ok=$?
  echo "cmd_ok="$?
 fi
fi 
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





  

 





