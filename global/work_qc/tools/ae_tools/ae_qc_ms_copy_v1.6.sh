#!/bin/bash
#***************************** TITLE *******************************************
# Script Bash3.2  Optimised miniseed files mover IPOC                          *
# Version 1.6   12 Jan.  2015  AISSAOUI -IPGP Paris                            *
#*******************************************************************************
echo '***************************************************************************************************'
version_script=' Optimised miniseed files mover Version 1.1 12 Jan. 2015  AISSAOUI -IPGP Paris           '
echo '               Running '$version_script
echo '               '$(date)
echo '***************************************************************************************************'
echo ''
cmd_syntax_0="  SYNTAX  (Note the source server is the localhost machine)                          "
cmd_syntax_1="ae_qc_ms_copy_v1.3.sh [stations] [networks] [locations] [analyse_mode] [start_date] "
cmd_syntax_2=" ...[end_date] [source_data_base] [target_data_base] [structure]...                  "              
cmd_syntax_3="[channels] [source_server] [target_server] [dir_work_base] > ae_qc_ms_copy_v1.1.log "  
if [ "$1" == "-h" -o "$1" == "--help" -o "$1" == "help" ]
then
 echo -e "$cmd_syntax_0 \n $cmd_syntax_1 \n $cmd_syntax_2 \n $cmd_syntax_3"
 kill $$
fi
echo '*************************************************************************'          
echo '________________________________________ID PROCESS_______________________' 
echo '*************************************************************************'
pid_script=$$
echo "pid_script = "$pid_script
prog_dir=$(pwd)
echo "prog_dir = "$prog_dir
echo '*************************************************************************'
echo '_______________________________STEP 1  ANALYSE LINE COMMAND______________'
echo '-------------------------------------------------------------------------'
echo '*************************************************************************'
echo ''
echo '*************************************************************************'
echo '______________________________STATIONS___________________________________'
echo '*************************************************************************'
stations_filter=$1
echo "stations_filter = "$stations_filter
echo '*************************************************************************'
echo '________________________________NETWORKS_________________________________'
echo '*************************************************************************'                                                                     
networks_filter=$2
echo 'networks_filter = '$networks_filter
echo '*************************************************************************'
echo '________________________________LOCATION CODE____________________________'
echo '*************************************************************************'                                                                     
locations_filter=$3
echo 'locations_filter = '$locations_filter
echo '*************************************************************************'
echo '________________________________ANALYSE MODE_____________________________'
echo '*************************************************************************' 
analyse_mode=$4
echo "analyse_Mode = "$analyse_mode
echo '*************************************************************************'
echo '__________________________________START DATE_____________________________'
echo '*************************************************************************' 
start_date=$5
echo "Start_Date = "$start_date
echo '*************************************************************************'
echo '__________________________________END DATE_______________________________'
echo '*************************************************************************' 
end_date=$6
echo "End_Date = "$end_date
echo '*************************************************************************'
echo '____________________________SOURCE DATA DIRECTORY________________________'
echo '*************************************************************************' 
source_data_base=$7
echo "source_data_base = "$source_data_base
echo '**************************************************************************'
echo '____________________________TARGET DATA DIRECTORY________________________'
echo '*************************************************************************' 
target_data_base=$8
echo "target_data_base = "$target_data_base
echo '*************************************************************************'
echo '___________________________________STRUCTURE_____________________________'
echo '*************************************************************************' 
structure=$9
echo "structure = "$structure
echo '*************************************************************************'          
echo '_____________________________________CHANNELS FILTER_____________________' 
echo '*************************************************************************'
## to be compatible with the Bourne shell
shift
channels_filter=$9
echo "channels_filter = "$channels_filter
echo '*************************************************************************'          
echo '_____________________________________SOURCE_SERVER______________________________' 
echo '*************************************************************************'
shift
source_server=$9
echo "server = "$source_server
echo '*************************************************************************'          
echo '_____________________________________TARGET_SERVER_______________________' 
echo '*************************************************************************'
shift
target_server=$9
echo "target_server = "$target_server
echo '*************************************************************************'          
echo '________________________________________DIR_WORK_BASE____________________' 
echo '*************************************************************************'
## to be compatible with the Bourne shell
shift
dir_work_base=$9
echo "dir_work_base= "$dir_work_base
################################################################################
temp_dir=$dir_work_base/temp
echo 'temp_dir = '$temp_dir
dir_bin_base=$dir_work_base/bin
echo 'dir_bin_base = '$dir_bin_base
################################################################################
error=0
if [ ! -d $dir_bin_base ]
then 
 error=1
 echo "$dir_bin_base doesn't exist !.."
fi
################################################################################
if [ ! -d $temp_dir ]
then 
 mkdir -p $temp_dir
 error=$?
 echo "directory '$temp_dir' created..."
else
 echo "directory '$temp_dir' already exists..." 
 rm -f $temp_dir/*
fi
echo "go under $temp_dir/..."
################################################################################
if [ $error != 0 ]
then
 echo "directories problems !..."
 kill $pid_script
fi
################################################################################
cd $temp_dir        
################################################################################
# ******************************************************************************
# Init start date program              
#*******************************************************************************
################################################################################
start_qc_date=$(date +%D)
echo "start_qc_date = "$start_qc_date
start_qc_day=$(date -d $start_qc_date "+%j")
start_qc_year=$(date -d $start_qc_date "+%Y")
echo 'start_qc_day = '$start_qc_day
echo 'start_qc_year = '$start_qc_year
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
command="$analyse_mode $start_date $end_date  $dir_work_base " 
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
d1=$( $dir_bin_base/calday   $day1 $year1 | grep Calendar | awk '{print $4}' )
echo "d1 = "$d1
m1=$( $dir_bin_base/calday   $day1 $year1 | grep Calendar | awk '{print $3}' )
echo  "m1 = "$m1
t1=$( date -d "$year1/$m1/$d1 00:00:00" +%s )
echo "t1 (s) =  "$t1
#*******************************************************************************
echo "*********** CALCUL date start and date end epoch seconds *************"
d2=$( $dir_bin_base/calday  $day2 $year2 | grep Calendar | awk '{print $4}' )
echo "d2 = "$d2
m2=$( $dir_bin_base/calday  $day2 $year2 | grep Calendar | awk '{print $3}' )
echo  "m2 = "$m2
t2=$( date -d "$year2/$m2/$d2 00:00:00" +%s )
echo "t2 (s) =  "$t2
#*******************************************************************************
timing=$(( 10#$t2 -10#$t1 ))
echo "timing = "$timing
################################################################################
echo '**************************************************************************'
echo "START (MM/JJ/AAAA) = "$date1_qc
#************************************************************
echo "END (MM/JJ/AAAA) = "$date2_qc
#************************************************************
echo "days_number = "$days_number 
#************************************************************ 
echo 'networks_filter = '$networks_filter
echo 'locations_filter = '$locations_filter
echo 'stations_filter = '$stations_filter
echo 'channels_filter = '$channels_filter
echo '*************************************************************************'
cd $temp_dir 
echo "On se met sur le repertoire ...$(pwd)"
################################################################################
target_data_base_parent=$(dirname $target_data_base)
echo "target_data_base_parent = "$target_data_base_parent
remote_dir=$(basename $target_data_base)
echo "remote_dir = "$remote_dir
######################
cmd="ssh $target_server find $target_data_base_parent  -name $remote_dir -type d -print  | grep $target_data_base"
echo "cmd = "$cmd
######################
test_target_dir=$( ssh "$target_server" find "$target_data_base_parent"  -name "$remote_dir" -type d -print  | grep "$target_data_base" )
echo "test_target_dir = "$test_target_dir
#kill $$
if [  "$target_data_base" != "$test_target_dir" ]
then 
 echo "$target_server:$target_data_base directory problem...?!"
 kill $pid_script
fi
################################################################################
rm -f $dir_work_base/tools/ae_tools/list_globale.txt
rm -f $dir_work_base/tools/ae_tools/list_ms_files.txt
> $dir_work_base/tools/ae_tools/list_ms_files.txt
################################################################################
for network in $networks_filter
do
 #DEBUG
 #echo 'network = '$network
 for station in $stations_filter
 do 
  #DEBUG
  #echo 'station = '$station
  for channel in $channels_filter
  do
   #DEBUG
   #echo 'channel = '$channel
   for location in $locations_filter
   do       
    #DEBUG
    #echo 'location = '$location
    if [ "$location" = NO_LOC ]
    then
     location=""
    fi
    ##############################################################################################
    # PATCH MADANI 15/01/2015 
    # pattern_match_1="$network.$station.$location.$channel.D.$year1.*"
    pattern_match_1="$network.$station.$location.$channel.D.$year1.???"
    echo "pattern_match_1 = "$pattern_match_1
    #find $source_data_base/ -maxdepth 5 -type f -name "$pattern_match_1" >> list_ms_files.txt
    if [[ "$source_server" =~ "$HOSTNAME" ]]
    then
     echo "find "$source_data_base/" -maxdepth 5 -type f -name "$pattern_match_1" -print  >> $dir_work_base/tools/ae_tools/list_ms_files.txt"
     find "$source_data_base/" -maxdepth 5 -type f -name "$pattern_match_1" -print  >> $dir_work_base/tools/ae_tools/list_ms_files.txt
    else
     if [[ "$source_server" =~ "localhost" ]]
     then
      echo "find "$source_data_base/" -maxdepth 5 -type f -name "$pattern_match_1" -print  >> $dir_work_base/tools/ae_tools/list_ms_files.txt"
      find "$source_data_base/" -maxdepth 5 -type f -name "$pattern_match_1" -print  >> $dir_work_base/tools/ae_tools/list_ms_files.txt
     else
      echo "ssh $source_server "find $source_data_base/ -maxdepth 5 -type f -name "$pattern_match_1" -print"  >> $dir_work_base/tools/ae_tools/list_ms_files.txt"
      ssh $source_server "find $source_data_base/ -maxdepth 5 -type f -name "$pattern_match_1" -print"  >> $dir_work_base/tools/ae_tools/list_ms_files.txt
     fi
    fi
    ##############################################################################################
    if [ $year1 != $year2 ]
    then
     # PATCH MADANI 12/01/2015
     #pattern_match_2="$network.$station.$location.$channel.D.$year2.*"
     pattern_match_2="$network.$station.$location.$channel.D.$year2.???"
     echo "pattern_match_2 = "$pattern_match_2
     if [[ "$source_server" =~ "$HOSTNAME" ]]
     then
      echo "find "$source_data_base/" -maxdepth 5 -type f -name "$pattern_match_2" -print >> $dir_work_base/tools/ae_tools/list_ms_files.txt"
      find "$source_data_base/" -maxdepth 5 -type f -name "$pattern_match_2" -print >> $dir_work_base/tools/ae_tools/list_ms_files.txt
     else
      if [[ "$source_server" =~ "localhost" ]]
      then
       echo "find "$source_data_base/" -maxdepth 5 -type f -name "$pattern_match_2" -print >> $dir_work_base/tools/ae_tools/list_ms_files.txt"
       find "$source_data_base/" -maxdepth 5 -type f -name "$pattern_match_2" -print >> $dir_work_base/tools/ae_tools/list_ms_files.txt
      else 
       echo "$source_server "find $source_data_base/ -maxdepth 5 -type f -name "$pattern_match_2" -print" >> $dir_work_base/tools/ae_tools/list_ms_files.txt"
       ssh $source_server "find $source_data_base/ -maxdepth 5 -type f -name "$pattern_match_2" -print" >> $dir_work_base/tools/ae_tools/list_ms_files.txt
      fi
     fi
    fi
    #########################################################################
   done #=> for location in $locations_filter
   ##########################################################################
  done #=> for channel in $channels_filter
  ###########################################################################
 done #=> for station in $stations_filter
 ############################################################################
done #=> for network in $networks_filter
#############################################################################
#DEBUG
#ls -l $dir_work_base/tools/ae_tools/list_ms_files.txt 
cat $dir_work_base/tools/ae_tools/list_ms_files.txt     
nbr_ms_files=$(cat $dir_work_base/tools/ae_tools/list_ms_files.txt | wc -l )
echo "nbr_ms_files = "$nbr_ms_files
#DEBUG
#kill $pid_script
echo "*****************************************************************************"
###############################################################################
nbr_files_find=0
counter_line=1
>  $dir_work_base/tools/ae_tools/list_globale.txt
while (( 10#$nbr_ms_files >  (10#$counter_line-1) ))
do 
 echo "________________________________________________________________________"
 #DEBUG
 #echo "counter_line = "$counter_line
 line=$( awk "NR==$counter_line{print;exit}" $dir_work_base/tools/ae_tools/list_ms_files.txt )
 echo "line = "$line
 ###############################################################################
 name_file=$(basename $line)
 #DEBUG
 #echo "name_file = "$name_file
 ###############################################################################
 echo $name_file > $dir_work_base/tools/ae_tools/name_file.txt  # repertoire courant
 champ=$( sed "s/\./ /g" $dir_work_base/tools/ae_tools/name_file.txt )
 names_field=$champ
 #DEBUG
 #echo "names_field ="$names_field
 if [ "$location" = ""  ]
 then
  day_pos=$( echo   "$names_field" | awk '{print $6}' )
  #DEBUG
  echo "day_pos = "$day_pos
  year_pos=$( echo   "$names_field" | awk '{print $5}' )
  #DEBUG
  echo "year_pos = "$year_pos
  chan_pos=$( echo   "$names_field" | awk '{print $3}' )
  #DEBUG
  #echo "chan_pos = "$chan_pos
  station_pos=$( echo   "$names_field" | awk '{print $2}' )
  #DEBUG
  #echo "station_pos = "$station_pos
  net_pos=$( echo   "$names_field" | awk '{print $1}' )
  #DEBUG
  #echo "net_pos = "$net_pos
  #DEBUG
  #kill $pid_script
 else
  day_pos=$( echo   "$names_field" | awk '{print $7}' )
  #DEBUG
  echo "day_pos = "$day_pos
  year_pos=$( echo   "$names_field" | awk '{print $6}' )
  #DEBUG
  echo "year_pos = "$year_pos
  chan_pos=$( echo   "$names_field" | awk '{print $4}' )
  #DEBUG
  #echo "chan_pos = "$chan_pos
  station_pos=$( echo   "$names_field" | awk '{print $2}' )
  #DEBUG
  #echo "station_pos = "$station_pos
  net_pos=$( echo   "$names_field" | awk '{print $1}' )
  #DEBUG
  #echo "net_pos = "$net_pos   
  #DEBUG
  #kill $pid_script      
 fi
 ###############################################################################
 echo "            ---------------------------"
 ###############################################################################
 #DEBUG
 #echo "*********** DATE DEBUT AU FORMAT STANDARD *************"
 d=$( $dir_bin_base/calday   $day_pos $year_pos | grep Calendar | awk '{print $4}' )
 #DEBUG
 echo "d = "$d
 m=$( $dir_bin_base/calday   $day_pos $year_pos | grep Calendar | awk '{print $3}' )
 #DEBUG
 echo  "m = "$m
 t=$( date -d "$year_pos/$m/$d 00:00:00" +%s )
 #DEBUG
 #echo "t (s) =  "$t
 delta_t1=$(( 10#$t - 10#$t1  ))
 delta_t2=$(( 10#$t2 - 10#$t ))
 #DEBUG
 #echo "delta_t1 (s) = "$delta_t1
 #echo "delta_t2 (s) = "$delta_t2
 if (( delta_t1 >= 0 ))
 then
  if (( delta_t2 >= 0 ))
  then
   nbr_files_find=$((10#$nbr_files_find+1))
   #DEBUG
   #echo "nbr_files_find = "$nbr_files_find
   echo "name_file = "$name_file" selected..."
   ##########################################################################
   #DEBUG
   #echo "line = "$line
   line2=${line#"$source_data_base/"}
   line2="$line2"
   echo "line2 = "$line2
   flag=1
   if [ "$source_server" == "$target_server" ]
   then
    #DEBUG
    #echo "line = "$line
    echo "cas 1"
    echo $line2 >> $dir_work_base/tools/ae_tools/list_globale.txt
    flag=0
   else
    # if [[ "$source_server" =~ "$HOSTNAME" ]]
    #MODIF DU 5 juillet  MADANI
    if [[ "$source_server" =~ "localhost" ]]
    then
     #DEBUG
     #echo "line = "$line
     echo "cas 2"
     echo $line2 >> $dir_work_base/tools/ae_tools/list_globale.txt
     flag=0
    else
     #if [[ "$target_server" =~ "$HOSTNAME" ]]
     #MODIF DU 5 Juillet MADANI
     if [[ "$target_server" =~ "localhost" ]]
     then 
      #DEBUG
      #echo "line = "$line
      echo "cas 3"
      echo $line2  >> $dir_work_base/tools/ae_tools/list_globale.txt
      flag=0
     fi
    fi
   fi
   if [ $flag == 1 ]
   then
    echo "Problem on servers name check $source_server & $target_server...!"
    kill $pid_script
   fi
   # echo "DEBUG..."
   # kill $$
   ##########################################################################
  fi #=> if (( delta_t2 >= 0 ))
 fi #=>if (( delta_t2 >= 0 )) 
 counter_line=$((10#$counter_line + 1))
done 
cat $dir_work_base/tools/ae_tools/list_globale.txt
#echo "DEBUG "
#kill $$
##########################################################################
error=0
echo  $source_server
echo  $target_server
echo  $(hostname)
if [ "$source_server" == "$target_server" ]
then
 echo "cas 1"
 echo " target_data_base = " $target_data_base
 cmd=" -Irva --files-from=$dir_work_base/tools/ae_tools/list_globale.txt $source_data_base $target_data_base"
 echo "rsync $cmd"
 rsync $cmd
 error=$?
else
 # if [[ "$source_server" =~ "$HOSTNAME" ]]
 #MODIF DU 5 juillet  MADANI
 if [[ "$source_server" =~ "localhost" ]]
 then
  echo "cas 2"
  cmd=" -Irva  --files-from=$dir_work_base/tools/ae_tools/list_globale.txt $source_data_base $target_server:$target_data_base"
  echo "rsync $cmd"
  rsync $cmd
  error=$?
 else
  #if [[ "$target_server" =~ "$HOSTNAME" ]]
  #MODIF DU 5 Juillet MADANI
  if [[ "$target_server" =~ "localhost" ]]
  then
   echo "cas 3"
   cmd=" -Irva --files-from=$dir_work_base/tools/ae_tools/list_globale.txt $source_server:$source_data_base $target_data_base"
   echo "rsync $cmd"
   rsync $cmd
   error=$?
  fi
 fi
fi
if [ $error != 0 ]
then
 echo "Problem on rsync command error = "$error
 kill $pid_script
fi
echo "################################################################################"
echo "counter_line = "$counter_line
echo "nbr_files_find = "$nbr_files_find
echo '*************************************************************************'
echo "FIN du script $0..." 
echo '*************************************************************************'





  

 





