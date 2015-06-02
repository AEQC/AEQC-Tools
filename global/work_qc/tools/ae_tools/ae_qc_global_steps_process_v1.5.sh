#!/bin/bash
#***************************** TITLE ********************************************************************
# Script Bash3.2 "Stations profil management script"         OVSMG Data Quality Control                 *
# Version 1.5  9 Jan. 2015  AISSAOUI -IPGP Paris             IPOC PROJET                               *
#********************************************************************************************************
echo '***************************************************************************************************'
version_script='Analyse stations management script, Version 1.5,  9 Jan. 2015  AISSAOUI -IPGP Paris      '
echo ' Running '$version_script
echo ' '$(date)
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '                                   *** SYNTAXE ***                                                 '
echo ' ae_qc_global_steps_process_v1.5.sh [dir_work_base] [stations_cfg] [server_name][start_qc_date]    '
echo '                                                          > ae_qc_global_steps_process_v1.5.log    '
echo '***************************************************************************************************'        
echo '________________________________________ID PROCESS_________________________________________________' 
echo '***************************************************************************************************'
pid_script=$$
echo "pid_script="$pid_script
echo '_____________________________________ PATH OF THE AEQC DIRECTORY __________________________________'
echo '***************************************************************************************************' 
dir_work_base=$1
echo "dir_work_base="$dir_work_base
echo '___________________________________PATH OF THE PROFIL FILE STATIONS _______________________________'
echo '***************************************************************************************************' 
stations_cfg=$2
echo "stations_cfg="$stations_cfg
echo '***************************************************************************************************' 
server_name=$3
echo "server_name="$server_name
echo '***************************************************************************************************'          
echo '________________________________________START_QC_DATE_____________________________________________' 
echo '***************************************************************************************************'
start_qc_date=$4
echo "start_qc_date = "$start_qc_date
start_qc_day=$( date +"%j")
echo "start_qc_day="$start_qc_day
start_qc_year=$(date "+%Y")
echo "start_qc_year="$start_qc_year
echo '***************************************************************************************************'
if [  ! -s $dir_work_base/tools/ae_tools/$stations_cfg ]
then
 echo "No configuration $dir_work_base/tools/ae_tools/$stations_cfg found !"
 echo "Exit process..."
 exit
fi
################################################################################
# READ THE STATIONS CONFIGURATION FILE
################################################################################
exec 3<>$dir_work_base/tools/ae_tools/$stations_cfg
while read line_cfg0 <&3
do
 rm -f $dir_work_base/temp/*
 station_name=" "
 ##########################
 source $dir_work_base/tools/ae_tools/read_cfg_file_v1.3.sh
 ###############################################################################
 # CHECK STATION WORK DIRECTORIES 
 ###############################################################################
 error=0
 if [ ! -d $dir_station_work_base ]
 then
  echo " Error $dir_station_work_base doesn't exist !"
  error=1
 fi
 if [ ! -d $dir_station_work_base/bin ] 
 then
  echo "Error $dir_station_work_base/bin  doesn't exist !"
  error=1
 fi
 if [ -d $dir_station_work_base/tools/ae_tools ] 
 then
  cd /$dir_station_work_base/tools/ae_tools 
  rm -f $dir_station_work_base/tools/ae_tools/link_qc_tasks.*
  rm -f $dir_station_work_base/tools/ae_tools/*.log
  rm -f $dir_station_work_base/tools/ae_tools/*.txt
  else 
  echo "Error $dir_station_work_base/tools/ae_tools  doesn't exist !"
  error=1
 fi
 if [ ! -d $dir_station_work_base/logs ] 
 then
  mkdir -p $dir_station_work_base/logs
  error=$?
  echo "$dir_station_work_base/logs doesn't exist !  Created ..."
 fi
 if [ ! -d $dir_station_work_base/tasks ] 
 then
  mkdir -p $dir_station_work_base/tasks
  error=$?
  echo "$dir_station_work_base/tasks  doesn't exist !  Created ..."
 fi
 if [ ! -d $dir_station_work_base/temp ] 
 then
  mkdir -p $dir_station_work_base/temp
  error=$?
  echo "$dir_station_work_base/temp  doesn't exist !  Created ..." 
 fi
 if [ ! -d $dir_station_work_base/reports ] 
 then
  mkdir -p $dir_station_work_base/reports
  error=$?
  echo "$dir_station_work_base/reports  doesn't exist !  Created ..."
 fi
 if [ $error != 0 ]
 then
  echo "Error $error can't create directories, exit !"
  kill $pid_script
 fi 
 if [ $station_status == ENABLE ]
 then
  ###############################################################################
  # PURGE LOGS FILES OF THE STATIONS
  # Call  ae_qc_clean_log.sh
  ###############################################################################
  script="$dir_station_work_base/tools/ae_tools/ae_qc_clean_logs_v1.5.sh"
  if [ ! -s $script ]
  then
   echo "Error $script not found..."
   kill $pid_script
  fi
  logout="$dir_station_work_base/tools/ae_tools/ae_qc_clean_logs_v1.5.log"
  cmd="$dir_station_work_base $back_logs_days_to_keep $start_qc_date"
  cmd="bash $script $cmd >& $logout"
  echo "cmd="$cmd
  eval $cmd
  error=$?
  if [ $error != 0 ]
  then
   echo "Error $error while executing $script ...!"
   kill $pid_script
  fi
  echo '****************************************************************************************************'
  ###############################################################################
  # ANALYSE CHANNEL IN THE LIST
  ###############################################################################
  index_freq=1
  for chan in  $chans_list
  do
   ########
   rate=$( echo "$freqs_list" | awk '{ print $('"$index_freq"') } ' )
   echo "rate="$rate
   ((++index_freq))
   echo "index_freq="$index_freq
   ################# START INVENTORY OF RESIDUAL OVERLAPS ################################################
   if [ $analyse_mode == "M0" ]
   then
    if (( $fixresidual_overlaps > 0 ))
    then
     echo "////************************ START CORRECTION OF RESIDUAL OVERLAPS ***********************"
     day2_b=$start_qc_day
     year2_b=$start_qc_year
     #*********************
     day1_b=$(date -d "$start_qc_date -$end_date days" +%j)
     echo 'day1_b = '$day1_b
     year1_b=$(date -d "$start_qc_date -$end_date days" +%Y)
     echo 'year1_b='$year1_b
     #***********************************************************************************
     echo "*********** START DATE STANDARD FORMAT *************"
     dd2_b=$( calday   $day1_b $year1_b | grep Calendar | awk '{print $4}' )
     echo "dd2_b = "$dd2_b
     mm2_b=$( calday   $day1_b $year1_b | grep Calendar | awk '{print $3}' )
     echo "mm2_b="$mm2_b
     day2_b=$day1_b
     echo "day2_b="$day2_b
     year2_b=$year1_b
     echo "year2_b="$year2_b
     #************************************************************************************
     echo "*********** END DATE STANDARD FORMAT *************"
     day1_b=$(date -d "$mm2_b/$dd2_b/$year2_b -$fixresidual_overlaps days" +%j)
     echo "day1_b="$day1_b
     year1_b=$(date -d "$mm2_b/$dd2_b/$year2_b -$fixresidual_overlaps days" +%Y)
     echo "year1_b="$year1_b 
     #************************************************************************************
     emails_b="NONE"
     station_ip_b="NONE"
     arclink_server_b="NONE" 
     analyse_mode_b="M2"
     start_date_b="$year1_b.$day1_b"
     end_date_b="$year2_b.$day2_b"
     day=$(date "+%j")
     year=$(date "+%Y")
     echo '************************************************************************'
     echo "$network_name/$station_name/$chan : "$day.$year' / '$(date)
     echo '************************************************************************'
     echo "ANALYSE DATA BETWEEN DATES : "$start_date_b" a "$end_date_b" ..."
     echo '************************************************************************'
     # ****************************************************************************
     # I) Call ae_qc_report_v1.65.sh to generate reports                          *                            
     #*****************************************************************************
     script="$dir_station_work_base/tools/ae_tools/ae_qc_report_v1.65.sh"
     if [ ! -s $script ]
     then
      echo "Error $script not found..."
      kill $pid_script
     fi 
     logout="$dir_station_work_base/tools/ae_tools/ae_qc_report_v1.65.log"
     cmd="$station_name $network_name $location_code $analyse_mode_b $start_date_b $end_date_b $server_name " 
     cmd="$cmd $dir_data_base $structure $chan $rate $dir_station_work_base " 
     cmd="$cmd $emails_b $emails_title $start_qc_date $task_list_mode"
     cmd="bash $script $cmd >& $logout"
     echo "cmd="$cmd
     # DEBUG
     #kill $$
     eval $cmd
     error=$?
     if [ $error != 0 ]
     then
      echo "Error $error while executing $script ...!"
      kill $pid_script
     fi
     echo '****************************************************************************************************'
     if [ -s $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt ]
     then
      >$dir_station_work_base/tools/ae_tools/link_qc_tasks.txt_b
      exec 6<>$dir_station_work_base/tools/ae_tools/link_qc_tasks.txt
      while read task <&6
      do 
       overlap=$(cat $task | grep OVERLAP )
       if [ "$overlap" != "" ]
       then
        echo $task >> $dir_station_work_base/tools/ae_tools/link_qc_tasks_b.txt
        mv -f $dir_station_work_base/tools/ae_tools/link_qc_tasks_b.txt  "$dir_station_work_base/tools/ae_tools/link_qc_tasks_b.$chan"
       fi
      done
      exec 6>&- 
     fi #==> if [ -s $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt ]
     echo "////************************ END CORRECTION OF RESIDUAL OVERLAPS ***********************"
     ################# END INVENTORY OF RESIDUAL OVERLAPS ################################################
    fi #==> if (( $fixresidual_overlaps > 0 ))
   fi #==> if [ $analyse_mode == "M0" ]
   day=$(date "+%j")
   year=$(date "+%Y")
   echo '************************************************************************'
   echo "$network_name/$station_name/$chan : "$day.$year' / '$(date)
   echo '************************************************************************'
   echo "ANALYSE DATA BETWEEN DATES : "$start_date" a "$end_date" ..."
   echo '************************************************************************'
   # ****************************************************************************
   # I) Call ae_qc_report_v1.65.sh to generate reports                          *                            
   #*****************************************************************************
   script="$dir_station_work_base/tools/ae_tools/ae_qc_report_v1.65.sh"
   if [ ! -s $script ]
   then
    echo "Error $script not found..."
    kill $pid_script
   fi 
   logout="$dir_station_work_base/tools/ae_tools/ae_qc_report_v1.65.log"
   cmd="$station_name $network_name $location_code $analyse_mode $start_date $end_date $server_name " 
   cmd="$cmd $dir_data_base $structure $chan $rate $dir_station_work_base " 
   cmd="$cmd $emails $emails_title $start_qc_date $task_list_mode"
   cmd="bash $script $cmd >& $logout"
   echo "cmd="$cmd
   # DEBUG
   #kill $$
   eval $cmd
   error=$?
   if [ $error != 0 ]
   then
    echo "Error $error while executing $script ...!"
    kill $pid_script
   fi
   echo '****************************************************************************************************'
   mv -f $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt  "$dir_station_work_base/tools/ae_tools/link_qc_tasks.$chan"
   ########
  done ##=> for chan in  $chans_list
  ##############################################################################
  if [ $auto_retriev_correction == "yes" ]
  then
   #############################################################################
   # AT THIS POINT ALL DATA HAVE BEEN ANALYSED AND EMAILS HAVE BEEN SENT
   #############################################################################
   cat $dir_station_work_base/tools/ae_tools/link_qc_tasks_b.* > $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt
   cat $dir_station_work_base/tools/ae_tools/link_qc_tasks.* >> $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt
   echo "######### TASKS LIST #####################################################"
   cat $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt
   tasks_file=$dir_station_work_base/tools/ae_tools/link_qc_tasks.txt
   echo "tasks_file="$tasks_file
   #DEBUG
   #kill $$
   if [ -s $tasks_file ]
   then
    # ****************************************************************************
    # II) Call ae_qc_retrieve_steps_process_v1.55.sh                              *
    #*****************************************************************************
    script=$dir_station_work_base"/tools/ae_tools/ae_qc_retrieve_steps_process_v1.55.sh"
    logout=$dir_station_work_base"/tools/ae_tools/ae_qc_retrieve_steps_process_v1.55.log"
    cmd="$station_name $network_name $location_code $analyse_mode $start_date $end_date $server_name $dir_data_base "
    cmd="$cmd $structure $list_chans $list_freqs $dir_station_work_base $emails $emails_title  $tasks_file $dir_buffer_base " 
    cmd="$cmd $station_ip $battery_test $start_qc_date $loop_correction $station_srce $battery_volt $bandwidth"
    cmd="$cmd $arclink_server $arclink_user_email $tasks_day_limit"
    ##############################
    if [ $retrieve_mode == "SER" ]
    then
     ### Processus de recuperation et correction pour chaque station en serie
     cmd="bash $script $cmd >& $logout "
     echo "cmd="$cmd
     eval $cmd 
     error=$?
     if [ $error != 0 ]
     then
      echo "Error $error while executing $script ...!"
      kill $pid_script
     fi
    fi
    if [ $retrieve_mode == "PAR" ]
    then
     ### Processus de recuperation et correction pour chaque station en //
     cmd="bash $script $cmd >& $logout &"
     echo "cmd="$cmd
     eval $cmd
     error=$?
     if [ $error != 0 ]
     then
      echo "Error $error while executing $script ...!"
      kill $pid_script
     fi
    fi
   else 
    echo "NOTHING TO DO, TASKS LIST EMPTY !"
   fi #=> if [ -s $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt ]
  fi #--> if [ $auto_retriev_correction == "yes" ]
  ########
 else
  echo "The station is disable..."
 fi #=>  if [ $station_status == ENABLE ]
 ####
done 
exec 3>&-
 
########################################################################################################################
echo '****************************************************************************************************'
echo "END "$name_script"..." 
echo '****************************************************************************************************'
