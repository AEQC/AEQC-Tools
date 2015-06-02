#!/bin/bash
#***************************** TITLE *********************************************************************
# Script Bash3.2,  Clean the logs files in the directory station/work_qc/logs                            *     
# Version 1.5  13 Jan. 2015 AISSAOUI -IPGP Paris                                                         *
#*********************************************************************************************************
echo '***************************************************************************************************'
version_script='Logs files cleaner   Version 1.5  13 Jan.  2015 AISSAOUI -IPGP Paris                     '
echo '               Running '$version_script
echo '               '$(date)
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '_______________________  STEP 1 PROGRAM CONFIGURATION _____________________________________________'
echo '---------------------------------------------------------------------------------------------------'
echo '                               *** SYNTAXE ***                                                     '
echo ' ae_qc_clean_logs_v1.5.sh [dir_work_base] [back_logs_days_to_keep]   > ae_qc_clean_logs_v1.5.log   '  
echo '***************************************************************************************************'
echo '***************************************************************************************************'          
echo '________________________________________DIR. WORK BASE_____________________________________________' 
echo '***************************************************************************************************'
dir_work_base=$1
echo "dir_work_base = "$dir_work_base
echo '***************************************************************************************************'
echo '__________________________________END DATE_______________________________________________________'
echo '**************************************************************************************************'
back_logs_days_to_keep=$2
echo "back_logs_days_to_keep="$back_logs_days_to_keep
echo '***************************************************************************************************'          
echo '________________________________________START_QC_DATE_____________________________________________' 
echo '***************************************************************************************************'
# Cela est necessaire pour mettre tous les rapports, et les fichiers generes (logs, temp, etc..) dans le
# même repertoire dans le cas ou le QC tourne plusieurs jours...
##########################################################################################################
start_qc_date=$3
echo "start_qc_date = "$start_qc_date
pid_script=$$
echo "pid_script="$pid_script
##############################################################################
# ******************************************************************************
# I)Call script bash ae_qc_calcul_dates_v1.2.sh                                *
#*******************************************************************************
script="$dir_work_base/tools/ae_tools/ae_qc_calcul_dates_v1.2.sh"
if [ ! -s $script ]
then
 echo "Error $script not found..."
 kill $pid_script
fi
# no need log file for this call subroutine...
command="M0 NONE $back_logs_days_to_keep  $dir_work_base "
command=$command" $start_qc_date $pid_script"
#DEBBUGAGE
echo "COMMANDE SHELL = "
echo "/bin/bash $script $command "
/bin/bash $script $command
error=$?
if [ $error != 0 ]
then
 echo "Error $error while executing $script ...!"
 kill $pid_script
fi
echo "#########################################################################"
echo "##################### ...RETRIEVE DATE VARIABLES ...#####################"
echo "#########################################################################"
day1=$( cat $dir_work_base/tools/ae_tools/day1.txt)
echo 'day1 = '$day1
year1=$( cat  $dir_work_base/tools/ae_tools/year1.txt )
echo 'year1 = '$year1
day2=$( cat  $dir_work_base/tools/ae_tools/day2.txt )
echo 'day2 = '$day2
################################################################################
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
echo "*********** CALCUL date start and date end epoch seconds *************"
d1=$( calday   $day1 $year1 | grep Calendar | awk '{print $4}' )
echo "d1 = "$d1
m1=$( calday   $day1 $year1 | grep Calendar | awk '{print $3}' )
echo  "m1 = "$m1
t1=$( date -d "$year1/$m1/$d1 00:00:00" +%s )
echo "t1 (s) =  "$t1
#*******************************************************************************
echo "*********** CALCUL date start and date end epoch seconds *************"
d2=$( calday  $day2 $year2 | grep Calendar | awk '{print $4}' )
echo "d2 = "$d2
m2=$( calday  $day2 $year2 | grep Calendar | awk '{print $3}' )
echo  "m2 = "$m2
t2=$( date -d "$year2/$m2/$d2 00:00:00" +%s )
echo "t2 (s) =  "$t2
#*******************************************************************************
timing=$(( 10#$t2 -10#$t1 ))
echo "timing = "$timing
##############################################################################
ls -t1  $dir_work_base/logs > $dir_work_base/logs/list_logs_dir.txt
cat $dir_work_base/logs/list_logs_dir.txt
nbr_logs_dir=$(cat $dir_work_base/logs/list_logs_dir.txt | wc -l )
echo "nbr_logs_dir = "$nbr_logs_dir
echo "###############################################################################"
counter_line=1
>  $dir_work_base/logs/list_logs_dir_to_delete.txt
###############################################################################
while (( 10#$nbr_logs_dir >  (10#$counter_line-1) ))
do
 echo "________________________________________________________________________"
 line=$( awk "NR==$counter_line{print;exit}" $dir_work_base/logs/list_logs_dir.txt )
 echo "line = "$line
 name_dir=$dir_work_base/logs/$line
 echo "name_dir="$name_dir
 champ=$( echo $line | sed "s/\./ /g" )
 echo "champ="$champ
 day_pos=$( echo $champ | awk '{print $1}' )
 echo "day_pos="$day_pos
 year_pos=$( echo $champ | awk '{print $2}' )
 echo "year_pos="$year_pos
 d=$( calday   $day_pos $year_pos | grep Calendar | awk '{print $4}' )
 echo "d = "$d
 m=$( calday   $day_pos $year_pos | grep Calendar | awk '{print $3}' )
 echo  "m = "$m
 t=$( date -d "$year_pos/$m/$d 00:00:00" +%s )
 echo "t="$t
 if [ "$t" != ""  ]
 then
  flag_delete=1
  delta_t1=$(( 10#$t - 10#$t1  ))
  #delta_t2=$(( 10#$t2 - 10#$t ))
  echo "delta_t1=t1-t="$delta_t1
  if (( delta_t1 > 0 ))
  then
   #if (( delta_t2 > 0 ))
   #then
    (( nbr_dir_find_find ++ ))
    echo "nbr_files_find = "$nbr_files_find
    echo "name_dir = "$name_dir" not to delete..."
    ############################################
    flag_delete=0
   #fi
  fi
  echo "flag_delete="$flag_delete
  if [ $flag_delete == 1 ]
  then
   echo "name_dir = "$name_dir" selected to be deleted ..."
   rm -fr $name_dir
  fi
 else
  echo "skip, it's not a logs dir !"
 fi 
 (( counter_line ++ ))
done
##########################################################################################################
echo '****************************************************************************************************'
echo "END  $0 ..."
echo '****************************************************************************************************'

