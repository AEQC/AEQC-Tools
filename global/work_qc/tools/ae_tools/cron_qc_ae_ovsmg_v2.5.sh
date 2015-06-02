#!/bin/bash
#***************************** TITLE ********************************************************************
# Script Bash3.2 "Crontab management of the data flow" OVSMG  Data Quality Control                      *
# Version 2.55  14 January 2015 AISSAOUI -IPGP Paris                                                    *
#********************************************************************************************************
echo '***************************************************************************************************'
version_script='Crontab management of the data flow, Version 2.55  14 January 2015 AISSAOUI -IPGP Paris  '
echo ' Running '$version_script
echo ' '$(date)
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '                                   *** SYNTAXE ***                                                 '
echo ' cron_qc_ae_ovsm_2.55.sh [dir_work_base][step_to_do][name_local server] >cron_qc_ae_ovsm_v2.55.log '
echo '***************************************************************************************************'        
echo '________________________________________ID PROCESS_________________________________________________' 
echo '***************************************************************************************************'
parent_pid=$$
echo "pid_script="$parent_pid
echo '_____________________________________ PATH OF THE AEQC DIRECTORY __________________________________'
echo '***************************************************************************************************' 
dir_work_base=$1
echo "dir_work_base="$dir_work_base
echo '_____________________________________ PATH OF THE AEQC DIRECTORY __________________________________'
echo '***************************************************************************************************' 
step_to_do=$2
echo "step_to_do="$step_to_do
echo '***************************************************************************************************'
echo '________________________________ CHECK THE VALUE OF THE LOCK FILE _________________________________'
echo '***************************************************************************************************'
lock=$(cat $dir_work_base/tools/ae_tools/lock_cron )
echo "lock_cron="$lock
############ CHECK THE LOCK FILE
if [ $lock  == off ]
then
 rm -f $dir_work_base/tools/ae_tools/stations_ovsmg_cron_cfg
 cat $dir_work_base/tools/ae_tools/*.cfg > $dir_work_base/tools/ae_tools/stations_ovsmg_cron_cfg
 if  [ ! -s $dir_work_base/tools/ae_tools/stations_ovsmg_cron_cfg ]
 then
  echo "There is no *.cfg stations configurations files in $dir_work_base/tools/ae_tools !"
  echo "Exit process !"
  kill $$
 fi
 echo "on" > $dir_work_base/tools/ae_tools/lock_cron
 ################################################################################
 # READ DATE OF THE SCRIPT BEGINNING
 ################################################################################
 start_qc_date=$(date +%D)
 echo "start_qc_date="$start_qc_date
 day=$(date "+%j")
 echo "day="$day
 year=$(date "+%Y")
 echo "year="$year
 ###############################################################################
 # CHECK STATION WORK DIRECTORIES 
 ###############################################################################
 error=0
 dir_log_base=$dir_work_base/logs
 echo "dir_log_base = "$dir_log_base
 if [ ! -d $dir_log_base ] 
 then
  mkdir -p $dir_log_base
  echo "$dir_log_base  doesn't exist !  Created ..."
 fi
 #***************************************************************
 dir_log_daily=$dir_log_base/$day.$year
 echo "dir_log_daily = "$dir_log_daily
 if [ ! -d $dir_log_daily ] 
 then
  mkdir -p $dir_log_daily
  echo "$dir_log_daily doesn't exist !  Created ..."
 fi
 ###################################################################
 if [ $error != 0 ]
 then
  echo "$target_dir, can't create directories..?!"
  kill $pid_script
 fi
 cd $dir_log_daily
################################################################################
#-------------------------------------- STEP  0 --------------------------------
################################################################################
 echo "**************************************************************************"
 echo  $day.$year' / '$(date)
 echo "**************************************************************************"
 echo "# STEP 0: Kill all ae_qc* process + move log files into their directories "
 echo "**************************************************************************"
 process=$( ps -eaf  | grep ae_qc | awk '{print $2}' )
 echo "process = "$process
 echo "killing  $process"
 kill $process
 sleep 10s
 echo "Retry with kill -9 $process to be sure there will no be a problem..."
 kill -9 $( ps -eaf  | grep ae_qc  | awk '{print $2}' )  
 cp -a $dir_work_base/tools/ae_tools/*.log $dir_log_daily
################################################################################
#-------------------------------------- STEP  1 --------------------------------
################################################################################
 echo "**************************************************************************"
 echo  $day.$year' / '$(date)
 echo "**************************************************************************"
 echo "# STEP 1: Purge log files call  ae_qc_clean_log_v1.5.sh                   "
 echo "**************************************************************************"
 # PURGE LOGS FILES 
 # 
 ###############################################################################
 script="$dir_work_base/tools/ae_tools/ae_qc_clean_logs_v1.5.sh"
 if [ ! -s $script ]
 then
  echo "Error $script not found..."
  kill $pid_script
 fi
 back_logs_days_to_keep=3
 logout="$dir_work_base/tools/ae_tools/ae_qc_clean_logs_v1.5.log"
 cmd="$dir_work_base $back_logs_days_to_keep $start_qc_date"
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
 rm -fr $dir_work_base/temp/*
 rm -fr $dir_work_base/*/work_qc/temp/*
 rm -f /home/sysop/timeline_work/timeline/logs/*
 rm -f /home/sysop/timeline_work/timeline/report/*
 rm -f /home/sysop/timeline_work/timeline/temp/*
 echo $(pwd)
 cd  $dir_work_base/tools/ae_tools/
 echo $(pwd)
################################################################################
#-------------------------------------- STEP  2 --------------------------------
################################################################################ 
### DEBUG
if [ $step_to_do  == 2 -o $step_to_do == ALL ]
#if [ a != a ]
then
 echo "**************************************************************************"
 echo  $day.$year' / '$(date)
 echo "**************************************************************************"
 echo "# STEP 2: -Draw Timelines                                                 "
 echo "**************************************************************************"
 export PATH=$PATH:/home/sysop/bin
 export DISPLAY=localhost:10.0
 ##############################################################################
 # READ THE STATIONS CONFIGURATION FILE
 ################################################################################
 exec 3<>$dir_work_base/tools/ae_tools/stations_ovsmg_cron_cfg
 while read line_cfg0 <&3
 do
  rm -f $dir_work_base/temp/*
  station_name=" "
  ##########################
  source $dir_work_base/tools/ae_tools/read_cfg_file_v1.3.sh 
  ##########################
  # *****************************************************************************
  #Call  ae_qc_calcul_dates_v1.2.sh                                             *
  #******************************************************************************
  error=0
  if [  "$prev_year_timeline" == yes -o "$year_timeline" == yes ]
  then
   script="$dir_work_base/tools/ae_tools/ae_qc_calcul_dates_v1.2.sh"
   cmd="bash $script $analyse_mode $start_date $end_date  $dir_work_base $start_qc_date $pid_script"
   echo "cmd="$cmd
   eval $cmd
   error=$?
   echo "error="$error
   if [ $error == 0 ]
   then 
    echo "########################################################################"
    echo "READ DATE VARIABLES                                                     "
    echo "########################################################################"
    year1=$( cat  $dir_work_base/tools/ae_tools/year1.txt )
    echo 'year1='$year1
    year2=$( cat  $dir_work_base/tools/ae_tools/year2.txt )
    echo 'year2='$year2
    if [ "$prev_year_timeline" == yes ]
    then
     if [ $year1 != $year2 ]
     then
      year_cfg=$year1
      source $dir_work_base/tools/ae_tools/source_timelines_making.sh
     fi #=>  if [ $year1 != $year2 ]
    fi #=> if [ "$prev_year_timeline" == yes ] 
    #######################"
    if [ "$year_timeline" == yes ]
    then
     year_cfg=$year2
     source $dir_work_base/tools/ae_tools/source_timelines_making.sh
    fi #=> if [ "$year_timeline" == yes ]
   else #=>  if [ $error != 0 ]
    echo "Error can't draw $station_name timelines, dates calculations problem !"
   fi #=> if [ $error != 0 ]
  fi #=> if [  "$prev_year_timeline" == yes -o "$year_timeline" == yes ]
  ########
 done
 exec 3>&- 
fi #=> if [ $step_to_do  == 2 -o $step_to_do == ALL ]
################################################################################
#-------------------------------------- STEP  3 --------------------------------
################################################################################ 
if [ $step_to_do  == 3 -o $step_to_do == ALL ]
then
 echo "**************************************************************************"
 echo  $day.$year' / '$(date)
 echo "**************************************************************************"
 echo "# STEP 3: -qc data copy dir_buffer_base  => dir_data_base                  "
 echo "                         work_data_server => work_data_server               "
 echo "**************************************************************************"
 ################################################################################
 # READ THE STATIONS CONFIGURATION FILE
 ################################################################################
 exec 3<>$dir_work_base/tools/ae_tools/stations_ovsmg_cron_cfg
 while read line_cfg0 <&3
 do
  rm -f $dir_work_base/temp/*
  station_name=" "
  ##########################
  source $dir_work_base/tools/ae_tools/read_cfg_file_v1.3.sh 
  chmod -R 755 $dir_data_base
  ##########################
  cmd="bash $dir_work_base/tools/ae_tools/ae_qc_ms_copy_v1.6.sh "$station_name" "$network_name" "$location_code"  "$analyse_mode"  "$start_date" "$end_date"  $dir_buffer_base/archive  $dir_data_base "$structure" "'"'" $chans_list "'"'"  "$work_data_server" "$work_data_server" $dir_work_base"
  echo "cmd="$cmd
  eval $cmd
  ########
 done
 exec 3>&- 
fi #=> if [ $step_to_do  == 3 -o $step_to_do == ALL ]
################################################################################
#-------------------------------------- STEP  4 --------------------------------
################################################################################ 
### DEBUG
if [ $step_to_do  == 4  -o $step_to_do == ALL ]
then
 lock_dir_data_base=$(cat $dir_work_base/tools/ae_tools/lock_dir_data_base )
 echo "lock_dir_data_base="$lock_dir_data_base
 if  [ $lock_dir_data_base == off ]
 then
 #####
 echo "**************************************************************************"
 echo  $day.$year' / '$(date)
 echo "*************************************************************************"
 echo "# STEP 4: -qc data copy dir_data_base  => qc_data_dir                    "
 echo "                      work_data_server => qc_data_server                 "
 echo " and if configuredd  merge  dir_data_base +  merge_dir                   "
 echo "*************************************************************************"
 exec 3<>$dir_work_base/tools/ae_tools/stations_ovsmg_cron_cfg
 while read line_cfg0 <&3
 do
  rm -f $dir_work_base/temp/*
  station_name=" "
  ##########################
  source $dir_work_base/tools/ae_tools/read_cfg_file_v1.4.sh
  chmod -R 755 $dir_data_base
  if [ $merge_dir != NONE ]
  then
   chmod -R 755 $merge_dir
   ##########################
   for chan in  $chans_list
   do
    rm -f $dir_work_base/temp/*
    cmd="bash $dir_station_work_base/tools/ae_tools/ae_qc_merge_archive_+GL2WI_v0.9.sh "$station_name" "$network_name" "$location_code"  "$analyse_mode"  "$start_date" "$end_date" $dir_data_base $merge_dir $structure $chan $dir_station_work_base $start_qc_date"
    echo "cmd="$cmd
    echo "merge_dir"=$merge_dir
    eval $cmd
   done
  fi 
  #kill $$
  cmd="bash $dir_work_base/tools/ae_tools/ae_qc_ms_copy_v1.6.sh "$station_name" "$network_name" "$location_code" "$analyse_mode" "$start_date" "$end_date"  $dir_data_base $qc_data_dir  "$structure" "'"'" $chans_list "'"'"  "$work_data_server" "$qc_data_server" $dir_work_base"
  echo "cmd="$cmd
  eval $cmd
  cmd_ok=$?
  echo "cmd_ok="$cmd_ok
  ###### RING BUFFER  WORK_ARCHIVE ###
  #### DISABLE DURING TEST ###
  #if [ $cmd_ok == 0 ]
  #then
  # rm -fr $dir_data_base/$network_name/$station_name/*
  #fi
  ########
 done
 exec 3>&-
 #####
 else #=> if  [ $lock_dir_data_base == off ]
 ####
 echo "Can't do STEP4, $dir_data_base is locked be careful before updating $qc_data_server:$qc_data_dir !!"
 ####
 fi #=> if  [ $lock_dir_data_base == off ]
fi #=> if [ $step_to_do  == 4 -o $step_to_do == ALL ]
#kill $$
################################################################################
#-------------------------------------- STEP  5 --------------------------------
################################################################################ 
if [ $step_to_do  == 5 -o $step_to_do == ALL ]
then 
 rm   -f    lock_dir_data_base
 echo on  > lock_dir_data_base
 echo "**************************************************************************"
 echo  $day.$year' / '$(date)
 echo "**************************************************************************"
 echo "# STEP 5: - raw data copy raw_data_dir => dir_data_base                   "        
 echo "                          raw_data_server => work_data_server             "
 echo "**************************************************************************"
 ###############################################################################
 # READ THE STATIONS CONFIGURATION FILE
 ################################################################################
 exec 3<>$dir_work_base/tools/ae_tools/stations_ovsmg_cron_cfg
 while read line_cfg0 <&3
 do
  rm -f $dir_work_base/temp/*
  station_name=" "
  ##########################
  source $dir_work_base/tools/ae_tools/read_cfg_file_v1.3.sh 
  chmod -R 755 $dir_data_base
  ##########################
  if [ $raw_data_server != NONE ] 
  then
   cmd="bash $dir_work_base/tools/ae_tools/ae_qc_ms_copy_v1.6.sh "$station_name" "$network_name" "$location_code" "$analyse_mode"  "$start_date" "$end_date" $raw_data_dir $dir_data_base "$structure" "'"'" $chans_list "'"'" "$raw_data_server" "$work_data_server"  $dir_work_base"
   echo "cmd="$cmd
   eval $cmd
  else
   echo "No data raw server specified in *.cfg file of $station_name, raw_data_server= $raw_data_server !"
  fi
  ########
 done 
 exec 3>&-
fi #=> if [ $step_to_do  == 5 -o $step_to_do == ALL ]
################################################################################
#-------------------------------------- STEP  5 --------------------------------
################################################################################ 
#DEBUG
if [ $step_to_do  == 6 -o $step_to_do == ALL ]
then
 echo "**************************************************************************"
 echo  $day.$year' / '$(date)
 echo "**************************************************************************"
 echo "# STEP 6: -qc copy data qc_data_dir => dir_data_base                      "           
 echo "                        qc_data_server => work_data_server                "
 echo "**************************************************************************"
 ################################################################################
 # READ THE STATIONS CONFIGURATION FILE
 ################################################################################
 exec 3<>$dir_work_base/tools/ae_tools/stations_ovsmg_cron_cfg
 while read line_cfg0 <&3
 do
  rm -f $dir_work_base/temp/*
  station_name=" "
  ##########################
  source $dir_work_base/tools/ae_tools/read_cfg_file_v1.3.sh
  chmod -R 755 $dir_data_base
  ##########################
  ## PATCH 7/1/2015 to correct residual overlaps of last days out of date
  if [ $analyse_mode == "M0" ]
  then
   if (( $fixresidual_overlaps > 0 ))
   then
    end_date_b=$(( $end_date + $fixresidual_overlaps  ))
    echo "end_date_b = "$end_date_b
   fi
  fi
  cmd="bash $dir_work_base/tools/ae_tools/ae_qc_ms_copy_v1.6.sh "$station_name" "$network_name" "$location_code" "$analyse_mode"   "$start_date" "$end_date_b" $qc_data_dir $dir_data_base "$structure" "'"'" $chans_list "'"'" "$qc_data_server" "$work_data_server"  $dir_work_base"
  echo "cmd="$cmd
  eval $cmd
  ########
  cmd_ok=$?
  chmod -R 755 $dir_data_base
 done 
 exec 3>&- 
 if  [ $cmd_ok == 0 ]
 then
  echo off  > lock_dir_data_base
 fi
fi #=> if [ $step_to_do  == 6 -o $step_to_do == ALL ]
###############################################################################
#echo "DEBUG"
#kill $$
################################################################################
#-------------------------------------- STEP  7 --------------------------------
################################################################################ 
if [ $step_to_do  == 7 -o $step_to_do == ALL ]
then
 echo "**************************************************************************"
 echo  $day.$year' / '$(date)
 echo "**************************************************************************"
 echo "# STEP 7:  Analyse-Reports-Retrieving-Corrections PHASE                   "
 echo "#          on data localised  in the dir_data_base directory              "                      
 echo "**************************************************************************"
 ##################################
 source $dir_work_base/tools/ae_tools/cron_stations_profil_v1.6.sh
 ###############################
fi #=> if [ $step_to_do  == 7 -o $step_to_do == ALL ]
###############################################################################
# DEBUG
kill $$
################################################################################
# MOVE LOGS FILES IN LOGS DIRECTORY...
################################################################################
 cp -a $dir_work_base/tools/ae_tools/*.log $dir_log_daily 
 echo "off" > $dir_work_base/tools/ae_tools/lock_cron
else #=> if [ $lock  == off ]
 echo "$dir_work_base/tools/ae_tools/lock_cron is ON, process is locked ! "
fi #=> if [ $lock  == off ]
echo "**************************************************************************"
echo "END "$0"..." 
echo "**************************************************************************"
