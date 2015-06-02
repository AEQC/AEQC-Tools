#!/bin/bash
#***************************** TITLE ********************************************************************
# Script Bash3.2 cron_stations_profil_v1.6.sh                 OVSMG  Data Quality Control               *
# Version 1.6  9 January 2015 AISSAOUI -IPGP Paris                                                      *
#********************************************************************************************************
###########################################################################################################
## DEBUG
#f [ "$dir_work_base" == "" ]
#hen
#echo "The system variable AEQC_WORK_DIR doesn't exists, check the file bashrc of the user !"
#kill $$
#exit
#i
echo "dir_work_base="$dir_work_base
cd $dir_work_base/tools/ae_tools
echo "PWD="$PWD
#ls -1 *.cfg  > ./all_cfg_files.txt
#cat ./all_cfg_files.txt
#if [ -s ./all_cfg_files.txt ]
if [ -s ./stations_ovsmg_cron_cfg ]
then 
 exec 8<>$dir_work_base/tools/ae_tools/all_cfg_files.txt
 while read line1 <&8
 do
  echo "#############################################################"
  cfg_file_1=$line1
  echo "cfg_file_1="$cfg_file_1
  echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  cmd_1="bash $dir_work_base/tools/ae_tools/ae_qc_global_steps_process_v1.5.sh $dir_work_base $cfg_file_1 AEQCSRV0  $start_qc_date >& $dir_work_base/tools/ae_tools/$cfg_file_1.log &"
  echo "cmd_1="$cmd_1
  eval $cmd_1
  cmd_ok_1=$?
  echo "cmd_ok_1="$cmd_ok_1
  echo "------------------------------------------------------------------------"
  ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_1" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_1.txt
  cat ./process_1.txt
  echo "________________________________________________________________________"
  read line2  <&8
  cmd_read2_ok=$?
  echo "cmd_read2_ok="$cmd_read2_ok
  if [ $cmd_read2_ok == 0 ]
  then 
   echo "#############################################################"
   cfg_file_2=$line2
   echo "cfg_file_2="$cfg_file_2
   echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
   cmd_2="bash $dir_work_base/tools/ae_tools/ae_qc_global_steps_process_v1.5.sh $dir_work_base $cfg_file_2 AEQCSRV0 $start_qc_date >& $dir_work_base/tools/ae_tools/$cfg_file_2.log &"
   echo "cmd_2="$cmd_2
   eval  $cmd_2
   cmd_ok_2=$?
   echo "cmd_ok_2="$cmd_ok_2
   echo "---------------------------------------------------------------------------"
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_2" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_2.txt
   cat ./process_2.txt
   echo "______________________________________________________________________"
  fi
  ########################
  read line3 <&8
  cmd_read3_ok=$?
  echo "cmd_read3_ok="$cmd_read3_ok
  if [ $cmd_read3_ok == 0 ]
  then
   echo "#############################################################"
   cfg_file_3=$line3
   echo "cfg_file_3="$cfg_file_3
   echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
   cmd_3="bash $dir_work_base/tools/ae_tools/ae_qc_global_steps_process_v1.5.sh $dir_work_base $cfg_file_3 AEQCSRV0 $start_qc_date >& $dir_work_base/tools/ae_tools/$cfg_file_3.log &"
   echo "cmd_3="$cmd_3
   eval  $cmd_3
   cmd_ok_3=$?
   echo "cmd_ok_3="$cmd_ok_3
   echo "---------------------------------------------------------------------------"
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_3" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_3.txt
   cat ./process_3.txt
   echo "______________________________________________________________________"
  fi
  ########################
  read line4 <&8
  cmd_read4_ok=$?
  echo "cmd_read4_ok="$cmd_read4_ok
  if [ $cmd_read4_ok == 0 ]
  then
   echo "#############################################################"
   cfg_file_4=$line4
   echo "cfg_file_4="$cfg_file_4
   echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
   cmd_4="bash $dir_work_base/tools/ae_tools/ae_qc_global_steps_process_v1.5.sh $dir_work_base $cfg_file_4 AEQCSRV0 $start_qc_date  >& $dir_work_base/tools/ae_tools/$cfg_file_4.log &"
   echo "cmd_4="$cmd_4
   eval  $cmd_4
   cmd_ok_4=$?
   echo "cmd_ok_4="$cmd_ok_4
   echo "---------------------------------------------------------------------------"
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_4" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_4.txt
   cat ./process_4.txt
   echo "______________________________________________________________________"
  fi
  ##########################
  read line5 <&8
  cmd_read5_ok=$?
  echo "cmd_read5_ok="$cmd_read5_ok
  if [ $cmd_read5_ok == 0 ]
  then
   echo "#############################################################"
   cfg_file_5=$line5
   echo "cfg_file_5="$cfg_file_5
   echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
   cmd_5="bash $dir_work_base/tools/ae_tools/ae_qc_global_steps_process_v1.5.sh $dir_work_base $cfg_file_5 AEQCSRV0 $start_qc_date >& $dir_work_base/tools/ae_tools/$cfg_file_5.log &"
   echo "cmd_5="$cmd_5
   eval  $cmd_5
   cmd_ok_5=$?
   echo "cmd_ok_5="$cmd_ok_5
   echo "---------------------------------------------------------------------------"
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_5" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_5.txt
   cat ./process_5.txt
   echo "______________________________________________________________________"
  fi
  ##########################
  echo "#######################"
  echo "waiting end of process_1 ___________________________________"
  while [ -s ./process_1.txt ]
  do
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_1" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_1.txt
  done
  echo "########################"
  echo "waiting end of process_2 ___________________________________"
  while [ -s ./process_2.txt ]  
  do
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_2" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_2.txt
  done
  echo "########################"
  echo "waiting end of process_3 ___________________________________"
  while [ -s ./process_3.txt ]
  do
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_3" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_3.txt
  done
  echo "########################"
  echo "waiting end of process_4 ___________________________________"
  while [ -s ./process_4.txt ]
  do
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_4" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_4.txt
  done
  echo "####################"
  while [ -s ./process_5.txt ]
  do
   ps -eaf | grep "ae_qc_global_steps_process_v1.5.sh" | grep "$cfg_file_5" | grep "$dir_work_base" | grep "AEQCSRV" > ./process_5.txt
  done
  echo "####################"
 done
 exec 8>&-
fi
###########################################################################################################################################

