#!/bin/bash
#***************************** TITLE *********************************************************************
# Script Bash3.2  Script RINBUFFER-NAQS STEP2                                                            *
# Version v1.5   14 Jan. 2013 AISSAOUI -IPGP  Paris                                                      *
#*********************************************************************************************************
#************************* CONFIGURATIONS ****************************************************************
echo '***************************************************************************************************'
version_script='  Script RINBUFFER-NAQS STEP2 Version v1.5  14 Jan 2015 AISSAOUI -IPGP Paris             '
echo '               Running '$version_script
echo '               '$(date)
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '_______________________  ETAPE 1 -CONFIGURATION DU PROGRAMME_______________________________________'
echo '---------------------------------------------------------------------------------------------------'
echo '                               *** SYNTAXE ***                                                     '
echo ' ae_qc_nasqs_ovsmg_ringbuffer_step2_v1.5.sh [tasks_file][ip_station][dir_work_base] ... '
echo '   ... [correction_buffer_base] [network] [station][canal][pid_parent] '
echo ' > ae_qc_nasqs_ovsmg_ringbuffer_step2_v1.5.log   '
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '__________________________________TASKS FILE_______________________________________________________'
echo '***************************************************************************************************'
tasks_file=$1
echo "Tasks_file = "$tasks_file 
echo '***************************************************************************************************'
echo '_________________________________IP STATION________________________________________________________'
echo '***************************************************************************************************'
station_ip=$2
echo "Station IP = "$station_ip
echo '***************************************************************************************************'          
echo '________________________________________DIR. WORK BASE_____________________________________________' 
echo '***************************************************************************************************'
dir_work_base=$3
echo "Dir_Work_base = "$dir_work_base
echo '***************************************************************************************************'          
echo '________________________________________CORRECTION BUFFER__________________________________________' 
echo '***************************************************************************************************'
correction_buffer_base=$4
echo "correction_buffer_base = "$correction_buffer_base
echo '***************************************************************************************************'
echo '________________________________NETWORK NAMES______________________________________________________'
echo '***************************************************************************************************'
network=$5
echo 'Network_Name = '$network
echo '***************************************************************************************************'
echo '___________________________________ STATION NAME___________________________________________________'
echo '***************************************************************************************************'
station=$6
echo "station_name = "$station
echo '***************************************************************************************************'
echo '___________________________________ CHAN NAME ____________________________________________________'
echo '***************************************************************************************************'
canal=$7
echo "Canal = "$canal
echo '***************************************************************************************************'          
echo '________________________________________START_QC_DATE_____________________________________________' 
echo '***************************************************************************************************'
start_qc_date=$8
echo "Start_Qc_Date="$start_qc_date
echo '***************************************************************************************************'           
echo '________________________________________PID PARENTS________________________________________________' 
echo '***************************************************************************************************'
pid_parent=$9
echo "Pid_parent="$pid_parent
echo '***************************************************************************************************'           
echo '________________________________________ARCLINK_SERVER_____________________________________________' 
echo '***************************************************************************************************'
shift
arclink_server=$9
echo "arclink_server="$arclink_server
echo '***************************************************************************************************'           
echo '________________________________________ARCLINK_USER_EMAIL_________________________________________' 
echo '***************************************************************************************************'
shift
arclink_user_email=$9
echo "arclink_user_email="$arclink_user_email
echo '***************************************************************************************************'           
echo '_________________________________________TASKS_DAY_LIMIT___________________________________________' 
echo '***************************************************************************************************'
shift
tasks_day_limit=$9
echo "tasks_day_limit="$tasks_day_limit
echo '***************************************************************************************************'          
echo '________________________________________ID PROCESS_________________________________________________' 
echo '***************************************************************************************************'
pid_script=$$
echo "pid_script = "$pid_script
echo '***************************************************************************************************'
echo '_____________________________________________BIN PATHS_____________________________________________'
echo '---------------------------------------------------------------------------------------------------'
echo ' Les packages seiscomp & passcal softwares doivent être installes !! '
echo ' Utilisation des programmes bin { julday / calday / qmerge /check_file }' 
echo '***************************************************************************************************'
dir_bin_base=$dir_work_base/bin
echo 'dir_bin_base = '$dir_bin_base
#########################################################################################################
# NOM DU FIHIER LOG 
# Cette information est transmise dans le resume du rapport qc a l'utilisateur....
# Sert  a identifier les differentes parties dans les fichiers logs...
name_script=$0
echo "##############################################"
echo "name_script = "$name_script" ##########"
echo "##############################################"
dir_script=$(pwd)
echo "dir_script = "$dir_script # NOTE BUG SANS GRAVITE chemin affiche avec une double barre // au debut !??
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
export LEAPSECONDS=$dir_work_base/tools/leapseconds  #?? ==> Ne fonctionne pas dans un appel crontab !!
echo '----- Extraction de la version des programmes { check_file / qmerge } ---------'
$dir_bin_base/check_file > file_result_output
version_check_file=$(grep "check_file" file_result_output )
version_check_file=${version_check_file:13:20}
echo "version_check_file = "$version_check_file  20
rm -f file_result_output
$dir_bin_base/qmerge -h > file_result_output
version_qmerge=$( grep "version" file_result_output )
version_qmerge=${version_qmerge:7:26}
echo "version_qmerge = "$version_qmerge
rm -f file_result_output
echo '****************************************************************************************************'
echo '________________________________CALCUL DATE DEBUT, FIN NOMBRE DE JOURS ETC..._______________________'
echo '-------------------UTILISATION DES PROGRAMMES JULDAY & CALDAY PASSCAL SOFTWARE----------------------'
echo '****************************************************************************************************'
# ********************************************************************************************************
# On initialise les variables jours et annee du demarrage du test QC...                                  *
#*********************************************************************************************************
start_qc_day=$(date -d $start_qc_date "+%j")
start_qc_year=$(date -d $start_qc_date "+%Y")
echo 'start_qc_day = '$start_qc_day
echo 'start_qc_year = '$start_qc_year
##########################################################################
########### CREATION ARBORESCENCE SDS correction_buffer/work #############
dir_buffer_archive=$correction_buffer_base/archive
dir_buffer_work=$correction_buffer_base/work
##########################################################################
error=0
if [ ! -d $dir_buffer_archive ]
then
 echo "ATTENTION le repertoire dir_buffer_archive = "$dir_buffer_archive" n'existe pas !?"
 error=1
fi
if [ -d $dir_buffer_work ]
then
 cd $dir_buffer_work
else
 error=1
 echo "ATTENTION le repertoire dir_buffer_work = "$dir_buffer_work" n'existe pas !?"
fi 
echo "error = "$error
if [ $error != 0 ]
then
 echo "Can't create directories !..."
 if [ $pid_parent != NONE ]
 then
  kill $pid_parent
 fi
 kill $pid_script
fi
###################################################################################################
########### RECUPERATION DU FICHIER CONTENANT L'INDEX DES CORRECTIONS A FAIRE #####################
### PATCH 03/08/2012
# $tasks_file.cpy ## ATTENTION FICHIER CREE PAR ae_qc_retrieve_step1_v1.4.sh 
tac $tasks_file.cpy > ./tasks_file_temp
cp -a ./tasks_file_temp $tasks_file.cpy
tasks_file_work=$tasks_file.cpy
cat $tasks_file_work
###################################################################################################
########################## RECUPERATION ET CORRECTION DES FICHIERS ###############################
exec 4<> $tasks_file_work
while read line <&4
do 
 echo "##############################################################################"
 echo $line 
 echo "##############################################################################"
 details_tasks_file=$line
 echo "`date` $name_script LAST_LOG" >> $details_tasks_file
 ########################################################################
 # RECUPERATION DES INFORMATIONS CONCERNANT LA CORRECTION A EFFECTUER
 ########################################################################
 champ=$(grep "NETWORK" $details_tasks_file)
 echo "Champ ="$champ
 network=$( echo $champ | awk '{print $1}' )
 echo "Network = "$network
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "LOCATION" $details_tasks_file)
 echo "Champ ="$champ
 location=$( echo $champ | awk '{print $1}' )
 echo "Location = "$location
 #########################################
 if [ $location == NO_LOC ]
 then
  location=""
  echo "Location = "$location
 fi
 #########################################
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "STATION" $details_tasks_file)
 echo "Champ ="$champ
 station=$( echo $champ | awk '{print $1}' )
 echo "Station = "$station
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "CANAL" $details_tasks_file)
 echo "Champ ="$champ
 canal=$( echo $champ | awk '{print $1}' )
 echo "Canal = "$canal
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "YEAR_FILE1" $details_tasks_file)
 echo "Champ ="$champ
 year_file1=$( echo $champ | awk '{print $1}' )
 echo "year_file1 = "$year_file1
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "YEAR_FILE2" $details_tasks_file)
 echo "Champ ="$champ
 year_file2=$( echo $champ | awk '{print $1}' )
 echo "year_file2 = "$year_file2
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "SERVER" $details_tasks_file)
 echo "Champ ="$champ
 server=$( echo $champ | awk '{print $1}' )
 echo "Server = "$server
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "DIR_DATA_STATION" $details_tasks_file)
 echo "Champ ="$champ
 dir_data_station=$( echo $champ | awk '{print $1}' )
 echo "Dir_data_station = "$dir_data_station
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "PROB_TYPE" $details_tasks_file)
 echo "Champ ="$champ
 prob_type=$( echo $champ | awk '{print $1}' )
 echo "prob_type = "$prob_type
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "START_YEAR" $details_tasks_file)
 echo "Champ ="$champ
 start_year=$( echo $champ | awk '{print $1}' )
 echo "START_YEAR = "$start_year
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "START_MONTH" $details_tasks_file)
 echo "Champ ="$champ
 start_month=$( echo $champ | awk '{print $1}' )
 echo "START_MONTH = "$start_month
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "START_DAY" $details_tasks_file)
 echo "Champ ="$champ
 start_day=$( echo $champ | awk '{print $1}' )
 echo "START_DAY = "$start_day
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "START_HOUR" $details_tasks_file)
 echo "Champ ="$champ
 start_hour=$( echo $champ | awk '{print $1}' )
 echo "START_HOUR = "$start_hour
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "START_MIN" $details_tasks_file) 
 echo "Champ ="$champ
 start_min=$( echo $champ | awk '{print $1}' )
 echo "START_MIN = "$start_min
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "START_SEC" $details_tasks_file)
 echo "Champ ="$champ
 start_sec=$( echo $champ | awk '{print $1}' )
 echo "START_SEC = "$start_sec
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "END_YEAR" $details_tasks_file)
 echo "Champ ="$champ
 end_year=$( echo $champ | awk '{print $1}' )
 echo "END_YEAR = "$end_year
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "END_MONTH" $details_tasks_file)
 echo "Champ ="$champ
 end_month=$( echo $champ | awk '{print $1}' )
 echo "END_MONTH = "$end_month
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "END_DAY" $details_tasks_file)
 echo "Champ ="$champ
 end_day=$( echo $champ | awk '{print $1}' )
 echo "END_DAY = "$end_day
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "END_HOUR" $details_tasks_file)
 echo "Champ ="$champ
 end_hour=$( echo $champ | awk '{print $1}' )
 echo "END_HOUR = "$end_hour
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "END_MIN" $details_tasks_file)
 echo "Champ ="$champ
 end_min=$( echo $champ | awk '{print $1}' )
 echo "END_MIN = "$end_min
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "END_SEC" $details_tasks_file)
 echo "Champ ="$champ
 end_sec=$( echo $champ | awk '{print $1}' )
 echo "END_SEC = "$end_sec
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "NAME_FILE1" $details_tasks_file)
 echo "Champ ="$champ
 name_file1=$( echo $champ | awk '{print $1}' )
 echo "FILE1 = "$name_file1
 len=$((10#${#name_file1}-8))
 suffix_file1=${name_file1:len:8}
 echo "suffix_file1 = "$suffix_file1
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "LINK_FILE1" $details_tasks_file)
 echo "Champ ="$champ
 link_file1=$( echo $champ | awk '{print $1}' )
 echo "LINK_FILE1 = "$link_file1
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "FILE1_STATUS" $details_tasks_file)
 echo "Champ ="$champ
 file1_status=$( echo $champ | awk '{print $1}' )
 echo "FILE1_STATUS = "$file1_status
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "NAME_FILE2" $details_tasks_file)
 echo "Champ ="$champ
 name_file2=$( echo $champ | awk '{print $1}' )
 echo "FILE2 = "$name_file2
 len=$((10#${#name_file2}-8))
 suffix_file2=${name_file2:len:8}
 echo "suffix_file2 = "$suffix_file2
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "LINK_FILE2" $details_tasks_file)
 echo "Champ ="$champ
 link_file2=$( echo $champ | awk '{print $1}' )
 echo "LINK_FILE2 = "$link_file2
 echo "-----------------------------------------------------------------------------"
 champ=$(grep "FILE2_STATUS" $details_tasks_file)
 echo "Champ ="$champ
 file2_status=$( echo $champ | awk '{print $1}' )
 echo "FILE2_STATUS = "$file2_status
 echo "-----------------------------------------------------------------------"
 champ=$(grep "DATE_FILE1" $details_tasks_file)
 echo "Champ ="$champ
 date_file1=$( echo $champ | awk '{print $1}' )
 echo "DATE_FILE1 = "$date_file1
 echo "-----------------------------------------------------------------------"
 champ=$(grep "DATE_FILE2" $details_tasks_file)
 echo "Champ ="$champ
 date_file2=$( echo $champ | awk '{print $1}' )
 echo "DATE_FILE2 = "$date_file2
 ########################################################################################
 ############## ARBORESCENCE NORMALEMENT DEJA CREE PAR ae_qc_retrieve_step1_v1.4.sh ###########
 dir_buffer_archive=$correction_buffer_base/archive
 #-----------------------
 dir1_buffer_archive=$dir_buffer_archive/$year_file1
 dir2_buffer_archive=$dir_buffer_archive/$year_file2
 #-----------------------
 dir1_buffer_archive=$dir1_buffer_archive/$network
 dir2_buffer_archive=$dir2_buffer_archive/$network
 #-----------------------
 dir1_buffer_archive=$dir1_buffer_archive/$station
 dir2_buffer_archive=$dir2_buffer_archive/$station
 #-----------------------
 dir1_buffer_canal=$dir1_buffer_archive/$canal.D
 dir2_buffer_canal=$dir2_buffer_archive/$canal.D
 ###########################################################
 echo "dir1_buffer_canal = "$dir1_buffer_canal
 echo "dir2_buffer_canal = "$dir2_buffer_canal
 ########################################################################################
 ############## CREATION D'UN  BUFFER WORK DE TRAVAIL QUI CONTIENDRA LES FICHIERS #######
 ############## INTERMEDIAIRES DE CORRECTIONS ###########################################
 dir_buffer_work=$correction_buffer_base/work
 error=0
 #######################################################
 dir1_buffer_work=$dir_buffer_work/$year_file1
 if [ ! -d $dir1_buffer_work ]
 then
  mkdir -p $dir1_buffer_work
  error=$?
 fi
 dir2_buffer_work=$dir_buffer_work/$year_file2
 if [ ! -d $dir2_buffer_work ]
 then
  mkdir -p $dir2_buffer_work
  error=$?
 fi
 dir1_buffer_work=$dir1_buffer_work/$network
 if [ ! -d $dir1_buffer_work ]
 then
  mkdir -p $dir1_buffer_work
  error=$?
 fi
 dir2_buffer_work=$dir2_buffer_work/$network
 if [ ! -d $dir2_buffer_work ]
 then
  mkdir -p $dir2_buffer_work
  error=$?
 fi
 dir1_buffer_work=$dir1_buffer_work/$station
 if [ ! -d $dir1_buffer_work ]
 then
  mkdir -p $dir1_buffer_work
  error=$?
 fi
 dir2_buffer_work=$dir2_buffer_work/$station
 if [ ! -d $dir2_buffer_work ]
 then
  mkdir -p $dir2_buffer_work
  error=$?
 fi
 dir1_buffer_work=$dir1_buffer_work/$canal.D
 if [ ! -d $dir1_buffer_work ]
 then
  mkdir -p $dir1_buffer_work
  error=$?
 fi
 dir2_buffer_work=$dir2_buffer_work/$canal.D
 if [ ! -d $dir2_buffer_work ]
 then
  mkdir -p $dir2_buffer_work
  error=$?
 fi
 ###########################################################
 if [ $error != 0 ]
 then
  echo "Can't create directories !..."
  if [ $pid_parent != NONE ]
  then
   kill $pid_parent
  fi
  kill $pid_script
 fi
 ###########################################################
 cd $dir1_buffer_work
 echo "Work directory="$(pwd)
 ###############################################################################
 start_day1=$( date -d "$date_file1" +%s )
 start_day2=$( date -d "$date_file2" +%s )
 echo "start_day1="$start_day1
 echo "start_day2="$start_day2
 #########################################################
 echo "________________________________________________________________________"
 echo "#################### GET INFORMATIONS OF LOCAL FILE 1#########################"
 echo "##############################################################################"
 echo "pass_to_next_compression=""$pass_to_next_compression"
 if [ $start_day != "$previous_start_day" ]
 then
  pass_to_next_compression=0
 fi
 echo "pass_to_next_compression=""$pass_to_next_compression"
 if [ "$pass_to_next_compression" == 0 ] 
 then
 ##########
 pass_to_next_compression=1
 echo "pass_to_next_compression=""$pass_to_next_compression" 
 if [ -s $dir1_buffer_canal/$name_file1 ]
 then
  cp  $dir1_buffer_canal/$name_file1 $name_file1
  echo "#################### GET LOCAL SIZE_BLOCK-ENCODING-QUALITY_FLAG FILE1"
  $dir_bin_base/msview -p $name_file1 |  head -n 14 > output_ms_view.txt  
  echo "*********output_ms_view.txt local file1*************"
  cat output_ms_view.txt
  echo "****************************************"
  local_file1_block_size=$(cat output_ms_view.txt | grep record | awk '{print $3}' )
  echo "local_file1_block_size="$local_file1_block_size
  local_file1_steim=$(cat output_ms_view.txt |  grep encoding | awk '{print $3}' )
  echo "local_file1_steim=STEIM "$local_file1_steim
  local_file1_quality_flag=$(cat output_ms_view.txt| grep $network | awk '{print $3}' )
  echo "local_file1_quality_flag="$local_file1_quality_flag    
  echo "######################################################################"
  echo "#BEFORE TREATMENT PUT LOCAL FILE1 WITH CORRECT FILES FORMAT IF NEEDED "
  echo "######################################################################"
  echo "conversion local file1 to D quality flag."
  $dir_bin_base/dataselect -Q D -o file_temp  $name_file1
  if [ $local_file1_block_size  != 512 -o $local_file1_steim != 2 ]
  then
   echo "conversion local file1 to 512 block size and to STEIM 2 encoding."  
   $dir_bin_base/qmerge  -b 512 file_temp > file_temp2 
   $dir_bin_base/msrepack -E 11 -o file_temp22 file_temp2 >& /dev/null 
   $dir_bin_base/qmerge  -b 512 file_temp22 > file_temp
  fi
  mv  file_temp $name_file1
  ls -l $name_file1
  cp  $name_file1 $dir1_buffer_canal/$name_file1
 fi #=>if [ -s $dir1_buffer_canal/$name_file1 ]
 ####################################################################################
 echo "________________________________________________________________________"
 echo "#################### GET INFORMATIONS OF LOCAL FILE2 #########################"
 echo "##############################################################################"
 if [ $file2_status != "UNKNOW" -a  $file2_status != "NO_FILE_!" ]
 then
  if [ -s $dir2_buffer_canal/$name_file2 ]
  then
   cp  $dir2_buffer_canal/$name_file2 $name_file2
   echo "#################### GET LOCAL SIZE_BLOCK-ENCODING-QUALITY_FLAG FILE2"
   $dir_bin_base/msview -p $name_file2 |  head -n 14 > output_ms_view.txt 
   echo "*********output_ms_view.txt local file2*************"
   cat output_ms_view.txt
   echo "****************************************"
   local_file2_block_size=$(cat output_ms_view.txt | grep record | awk '{print $3}' )
   echo "local_file2_block_size="$local_file2_block_size
   local_file2_steim=$(cat output_ms_view.txt | grep encoding | awk '{print $3}' )
   echo "local_file2_steim=STEIM "$local_file2_steim
   local_file2_quality_flag=$(cat output_ms_view.txt| grep $network | awk '{print $3}' )
   echo "local_file2_quality_flag="$local_file2_quality_flag 
   echo "####################################################################"
   echo "#BEFORE TREATMENT PUT LOCAL FILE2 WITH CORRECT FILES FORMAT IF NEEDED"
   echo "#####################################################################"
   echo "conversion local file2 to D quality flag."
   $dir_bin_base/dataselect -Q D -o file_temp  $name_file2
   if [ $local_file2_block_size != 512 -o $local_file2_steim != 2 ]
   then
    echo "conversion local file2 to 512 block size and to STEIM 2 encoding."
    $dir_bin_base/qmerge -b 512 file_temp > file_temp2
    $dir_bin_base/msrepack -E 11  -o file_temp22 file_temp2 >& /dev/null      
    $dir_bin_base/qmerge  -b 512 file_temp22 > file_temp
   fi
   mv -f file_temp  $name_file2
   cp  $name_file2 $dir2_buffer_canal/$name_file2 
  fi #=> if [ -s $dir2_buffer_canal/$name_file2 ]
 fi #=> if [ $file2_status != "UNKNOW" ... ]
 ###
 fi #=> if [ $pass_to_next_compression == 0 ]
 ##################################################################################################
 ################################# CORRECTIONS DES  OVERLAPS ######################################
 echo "pass_to_next_overlap=""$pass_to_next_overlap"
 if [ $start_day != "$previous_start_day" ]
 then
  pass_to_next_overlap=0
 fi
 echo "pass_to_next_overlap=""$pass_to_next_overlap"
 if [ $prob_type == "OVERLAP" -a "$pass_to_next_overlap" == 0 ] 
 then
  pass_to_next_overlap=1
  echo "pass_to_next_overlap="$pass_to_next_overlap
  ##################################################################################################
  ########################################" CAS 1 ##################################################
  if [  $file1_status ==  "#_CHECK=_FILE_OK." -o  $file1_status == "#_CHECK=_Date!" ]
  then
   if [  $file2_status ==  "#_CHECK=_FILE_OK." -o  $file2_status == "#_CHECK=_Date!" ] 
   then
    echo "############################# CORRECTION DES OVERLAPS SEULEMENT #####################"
    echo "### CAS DE FIGURE 1 ==> FILE1 & FILE2 PRESENTS #######################################" 
    echo "### CAS DE FIGURE STANDARD OVERLAP APRES AVOIR MERGER LES DEUX FICHIERS CONSECUTIF MINISEED ######"
    output_qmerge=$name_file1'_'$name_file2
    echo "_____________________________________________________________________________" 
    echo "CORRECTION DES OVERLAPS SEULEMENT... "
    echo $dir1_buffer_canal/$name_file1
    echo $dir2_buffer_canal/$name_file2
    echo $output_qmerge
    rm -f $output_qmerge
    echo "_____________________________________________________________________________" 
    #########################################################################
    rm -f $station* #!!!!
    rm -f test1
    rm -f test2
    rm -f test3
    $dir_bin_base/qmerge -b 512 $dir1_buffer_canal/$name_file1 > test1
    $dir_bin_base/qmerge -b 512 $dir1_buffer_canal/$name_file2 > test2
    $dir_bin_base/qmerge -b 512  test1 test2 > test3
    $dir_bin_base/sdrsplit -c -C -G 1 test3
    ## MODIF DU 7 MARS 2012
    #$dir_bin_base/sdrsplit -c -C -G 1 $dir1_buffer_canal/$name_file1 
    #$dir_bin_base/sdrsplit -c -C -G 1 $dir2_buffer_canal/$name_file2
    echo "############# DEBUG ###########################"
    ls -l $station*
    echo "line="$line
    #if [ $line = "/home/sysop/PATCX/work_qc/tasks/2009/CX/PATCX/LLZ.D/2009.11.29_0:1:9_to_2009.11.28_23:52:34.task" ]
    #then
    # echo "DEBUG .."
    # kill $$
    #fi
    $dir_bin_base/qmerge -b 512 $station* > $output_qmerge
    #-> modif du 13/04/2011
    #$dir_bin_base/qmerge -b 512  $station*$suffix_file1* $station*$suffix_file2* > $output_qmerge
    rm -f $station* #!!!!
    ###########################################################################
    ###########################################################################
    #$dir_bin_base/sdrsplit -c -D $output_qmerge 
    if [ -s $output_qmerge ]
    then
     rm -f $name_file1
     rm -f $name_file2
     echo "DEBUG"
     $dir_bin_base/dataselect -Q D -Pr -Ps -A ./%n.%s.%l.%c.D.%Y.%j $output_qmerge
     #echo "DEBUG"
     #kill $$
     rm -f $output_qmerge
     echo "_____________________________________________________________________________" 
     #ls -l $station*$suffix_file1*
     ls -l $dir1_buffer_canal/$name_file1
     #ls -l $station*$suffix_file2*
     ls -l $dir2_buffer_canal/$name_file2
     echo "_____________________________________________________________________________" 
     #echo "fichiers crees sdrsplit :"
     #file1_data=$( echo  `ls  $station*$suffix_file1*` | awk '{print $1}' )
     #echo "file1_data = "$file1_data
     #mv -f $file1_data $name_file1
     #file2_data=$( echo  `ls  $station*$suffix_file2*` | awk '{print $1}' )
     #echo "file2_data = "$file2_data
     #mv -f $file2_data $name_file2
     echo "copies des fichiers corriges vers work buffer ..."
     rsync -ctv $name_file1 $dir1_buffer_canal/$name_file1
     rsync -ctv $name_file2 $dir2_buffer_canal/$name_file2
    fi
   fi
   ###############################################################################################
   #######################################" CAS 2 ################################################
   if [ $file2_status != "#_CHECK=_FILE_OK." -a  $file2_status != "#_CHECK=_Date!" -a   $file2_status != "UNKNOW" ]
   then
    echo "############################# CORRECTION DES OVERLAPS SEULEMENT #####################"
    echo "### CAS DE FIGURE 2 ==> FILE1 PRESENT & FILE2 ABSENT OU NOT OK ####"
    echo "### CAS DE FIGURE STANDARD OVERLAP  AVEC UN SEUL FICHIER ######"
    output_qmerge=$name_file1".tmp"
    echo "_____________________________________________________________________________" 
    echo "FILE2 n'existe pas correction de FILE1..."
    echo "CORRECTION DES OVERLAPS SEULEMENT... "
    echo $dir1_buffer_canal/$name_file1
    echo $output_qmerge
    rm -f $output_qmerge
    echo "_____________________________________________________________________________" 
    #########################################################################
    rm -f $station* #!!!!
    $dir_bin_base/sdrsplit -c -C  -G 1 $dir1_buffer_canal/$name_file1 
    echo "############# DEBUG ###########################"
    ls -l $station*
    $dir_bin_base/qmerge -b 512 $station* > $output_qmerge
    if [ -s $output_qmerge ]
    then
     mv -f $output_qmerge $name_file1
     rm -f $station* #!!!!
     ###########################################################################
     ###########################################################################
     echo "_____________________________________________________________________________" 
     ls -l $name_file1
     ls -l $dir1_buffer_canal/$name_file1
     echo "_____________________________________________________________________________"
     echo "copies des fichiers corriges vers work buffer ..."
     rsync -ctv $name_file1 $dir1_buffer_canal/$name_file1 
    fi ##=> if [ -s $output_qmerge ]
   fi ##=> if [ $file2_status != "#_CHECK=_FILE_OK." -a  $file2_status != "#_CHECK=_Date!" -a   $file2_status != "UNKNOW" ] 
  fi ##=> if [  $file1_status ==  "#_CHECK=_FILE_OK." -o  $file1_status == "#_CHECK=_Date!" ]
  ################################################################################################
  #######################################" CAS 3  ################################################
  if [  $file2_status ==  "#_CHECK=_FILE_OK." -o  $file2_status == "#_CHECK=_Date!" ]
  then
   if [ $file1_status != "#_CHECK=_FILE_OK." -a  $file1_status != "#_CHECK=_Date!"  ]
   then
    echo "############################# CORRECTION DES OVERLAPS SEULEMENT #####################"
    echo "### CAS DE FIGURE 3 ==> FILE1 ABSENT OU NOT OK & FILE2 PRESENT ################################"
    echo "### CAS DE FIGURE STANDARD OVERLAP  AVEC UN SEUL FICHIER ######"
    output_qmerge=$name_file2".tmp"
    echo "_____________________________________________________________________________" 
    echo "FILE1 n'existe pas correction de FILE2..."
    echo "CORRECTION DES OVERLAPS SEULEMENT... "
    echo $dir2_buffer_canal/$name_file2
    echo $output_qmerge
    rm -f $output_qmerge
    echo "_____________________________________________________________________________"  
    #######################################################################
    rm -f $station* #!!!!
    $dir_bin_base/sdrsplit -c -C  -G 1 $dir2_buffer_canal/$name_file2 
    echo "############# DEBUG ###########################"
    ls -l $station*
    $dir_bin_base/qmerge -b 512 $station* > $output_qmerge
    if [ -s $output_qmerge ] 
    then
     mv -f $output_qmerge $name_file2
     rm -f $station* #!!!!
     ###########################################################################
     ###########################################################################
     echo "_____________________________________________________________________________" 
     ls -l $name_file2
     ls -l $dir2_buffer_canal/$name_file2
     echo "_____________________________________________________________________________" 
     echo "copies des fichiers corriges vers work buffer ..."
     rsync -ctv $name_file2 $dir2_buffer_canal/$name_file2
    fi ##=> if [ -s $output_qmerge ]
   fi
  fi ##=>if [  $file2_status ==  "#_CHECK=_FILE_OK." -o  $file2_status == "#_CHECK=_Date!" ]
 #***************************************************************************************
 else #==>if [ $prob_type == "OVERLAP" -a $pass_to_next_overlap == 0 ] 
  ################################# CORRECTIONS DES  GAPS ####################
  echo "############################# CORRECTION DES GAPS ####################"
  echo "######################### ON VERIFIE QUE LE GAP N'A PAS DEJA ETE RECUPERE ###"
  name_tasks_file=$( "$dir_bin_base/basename" $details_tasks_file )
  echo "name_tasks_file = "$name_tasks_file
  len=$((10#${#name_tasks_file} -5))
  echo "len = "$len
  suffix_name=${name_tasks_file:0:len}
  echo "suffix_name = "$suffix_name
  gap_data_task=$suffix_name.dat
  echo "gap_data_task = "$gap_data_task 
  gap_retrieved=0 
  rm -f $gap_data_task 
  #####################################################################"
  ####### OPTIMISATION DE LA RECUPERATION !
  #####################################################################"
  pass_to_next_gap=0
  if [ $start_day != "$previous_start_day" ]
  then
   all_day_data1_flag=0
   all_day_data1_flag=0
  fi
  if [ $start_day == $end_day ]
  then
   if [ "$all_day_data1_flag" == 1 ]
   then
    echo " Deja present dans la derniere recuperation !"
    pass_to_next_gap=1
   fi
  else  
   if [ "$all_day_data1_flag" == 1 -a "$all_day_data2_flag" == 1 ]
   then 
    echo " Deja present dans la derniere recuperation !"
    pass_to_next_gap=1
   fi
  fi
  echo "all_day_data1_flag="$all_day_data1_flag
  echo "all_day_data2_flag="$all_day_data2_flag
  echo "pass_to_next_gap=""$pass_to_next_gap"
  ####################################
  if [  "$pass_to_next_gap" == 0 ]
  then
   echo $name_tasks_file > file_temp
   champ=$( sed "s/_/ /g" file_temp )
   rm -f file_temp 
   gap_day=$( echo $champ | awk '{ print $1 }' ) 
   #gap_day=${name_tasks_file:0:10}
   echo "gap_day="$gap_day
   nbr_gaps=$(cat $tasks_file_work | grep $gap_day | wc -l )
   echo "nbr_gaps="$nbr_gaps 
   ############################################################################## 
   echo "############  AJUSTEMENT DU GAP POUR LA RECUPERATION ##################"
   echo "_______________________________________________________________________"
   echo "GET DATA 1 mn ago "
   champ1="$start_year/$start_month/$start_day $start_hour:$start_min:$start_sec"
   echo "champ1 = "$champ1
   date1=$( date -d "$champ1 1 minute ago " +" %Y %m %d %H %M %S ")
   echo "date1 = "$date1
   yy1=$( echo $date1 | awk '{print $1}' )
   mm1=$( echo $date1 | awk '{print $2}' )
   dd1=$( echo $date1 | awk '{print $3}' )
   hh1=$( echo $date1 | awk '{print $4}' )
   min1=$( echo $date1 | awk '{print $5}' )
   sec1=$( echo $date1 | awk '{print $6}' )
   echo "new start date = $yy1/$mm1/$dd1 $hh1:$min1:$sec1"
   ##########################
   echo "GET DATA 59 mn after "
   champ2="$end_year/$end_month/$end_day $end_hour:$end_min:$end_sec"
   echo "champ2 = "$champ2
   date2=$( date -d "$champ2  59 minute " +" %Y %m %d %H %M %S ")
   echo "date2 = "$date2
   yy2=$( echo $date2 | awk '{print $1}' )
   mm2=$( echo $date2 | awk '{print $2}' )
   dd2=$( echo $date2 | awk '{print $3}' )
   hh2=$( echo $date2 | awk '{print $4}' )
   min2=$( echo $date2 | awk '{print $5}' )
   sec2=$( echo $date2 | awk '{print $6}' )
   echo "new end date = $yy2/$mm2/$dd2 $hh2:$min2:$sec2"
   #####################################################################################
   echo "############  DETAILS GAP POUR LA RECUPERATION ########################"
   echo "_____________________________________________________________________________"
   if (( ${#mm1} < 2 ))
   then
    mm1=0$mm1
   else
    mm1=$mm1
   fi
   if (( ${#dd1} < 2 ))
   then
    dd1=0$dd1
   else
    dd1=$dd1
   fi
   if (( ${#hh1} < 2 ))
   then
    hh1=0$hh1
   else
    hh1=$hh1
   fi
   if (( ${#min1} < 2 ))
   then
    min1=0$min1
   else
    min1=$min1
   fi
   if (( ${#sec1} < 2 ))
   then
    sec1=0$sec1
   else
    sec1=$sec1
   fi
   echo "Start date = $yy1/$mm1/$dd1 $hh1:$min1:$sec1"
   data_start=$( date -d "$yy1/$mm1/$dd1 $hh1:$min1:$sec1" +%s )
   if (( ${#mm2} < 2 ))
   then
    mm2=0$mm2
   else
    mm2=$mm2
   fi
   if (( ${#dd2} < 2 ))
   then
    dd2=0$dd2
   else
    dd2=$dd2
   fi
   if (( ${#hh2} < 2 ))
   then
    hh2=0$hh2
   else
    hh2=$hh2
   fi
   if (( ${#min2} < 2 ))
   then
    min2=0$min2
   else
    min2=$min2
   fi
   if (( ${#sec2} < 2 ))
   then
    sec2=0$sec2
   else
    sec2=$sec2
   fi
   echo "End date = $yy2/$mm2/$dd2 $hh2:$min2:$sec2"
   data_end=$( date -d "$yy2/$mm2/$dd2 $hh2:$min2:$sec2" +%s )
   echo "Data_start (A)= "$data_start
   echo "Data_end (C)= "$data_end
   #############################
   gap_retrieved=0
   #############################
   echo "_______________________________________________________________________" 
   if [ $station_ip != "NO_IP" -o $arclink_server != "NO_IP"  ]
   then
     ##################################################################
     echo "nbr_gaps="$nbr_gaps
     echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
     if (( nbr_gaps > 10#$tasks_day_limit ))
     then
      echo "nbr_gaps > tasks_day_limit, most easy to retrieve all days in 2 requests !"
      all_day_data1_flag=1
      if [ $file2_status != "UNKNOW" -a  $file2_status != "NO_FILE_!" ]
      then 
       all_day_data2_flag=1
      else
       all_day_data2_flag=0
      fi 
     else
      all_day_data1_flag=0
      all_day_data2_flag=0
     fi #=> if (( nbr_gaps > tasks_day_limit )) 
     echo "all_day_data1_flag="$all_day_data1_flag
     echo "all_day_data2_flag="$all_day_data2_flag
     ##############################################################
    if [ $station_ip != "NO_IP" ]
    then
     echo "suffix_file1 = "$suffix_file1
     echo "suffix_file2 = "$suffix_file2
     echo "***********************************************************************"
     echo " RECUPERATION DES DONNEES SUR LE RINBUFFER DU NAQS ********************"
     echo "***********************************************************************"
     rm -fr ./aeqc_dir
     mkdir -p  ./aeqc_dir
     #rm -f ./aeqc_dir/$yy1/$network/$station/$canal.D/*$suffix_file
     #rm -f ./aeqc_dir/$yy2/$network/$station/$canal.D/*$suffix_file2     
     ########################################
     if [ $all_day_data1_flag == 1 ]
     then
      cmd2="$dir_bin_base/nmxptool -H $station_ip -D 28002 -C "$network.$station.$canal.$location" -u mseed_arch -p nmxptool -s $suffix_file1 -t 1d  -ms -o ./aeqc_dir" > /dev/null
     else
      cmd2="$dir_bin_base/nmxptool -H $station_ip -D 28002 -C "$network.$station.$canal.$location" -u mseed_arch -p nmxptool -s  $yy1/$mm1/$dd1,$hh1:$min1:$sec1 -e $yy2/$mm2/$dd2,$hh2:$min2:$sec2 -ms -o ./aeqc_dir" > /dev/null
     fi
     echo "cmd2="$cmd2
     if [ $all_day_data2_flag == 1 ]
     then
      cmd3="$dir_bin_base/nmxptool -H $station_ip -D 28002 -C "$network.$station.$canal.$location" -u mseed_arch -p nmxptool -s $suffix_file2 -t 1d  -ms -o ./aeqc_dir" > /dev/null
     else
      cmd3="EMPTY" 
     fi
     echo "cmd3="$cmd3 
     ########################################
     eval $cmd2
     cmd2_ok=$?
     if [ "$cmd3" != EMPTY ]
     then
      eval $cmd3
      cmd3_ok=$?
     else
      cmd3_ok=0
     fi 
     echo "cmd2_ok="$cmd2_ok" / cmd3_ok="$cmd3_ok
     if [  $cmd2_ok != 0 -o $cmd3_ok != 0 ]
     then
      echo "Probleme pendant la connexion au serveur $station_ip, verifier les clés SSH  !"
      #DEBUG
      #echo "Arrêt du processus !"
      #kill $pid_parent
      #kill $pid_script
     else
      echo "naqs server $station_ip reachable !"
     fi
     ########################################################################### 
     ############### ANALYSE DE LA TENTATIVE DE RECUPERATION ###################
     echo "all_day_data1_flag="$all_day_data1_flag
     echo "all_day_data2_flag="$all_day_data2_flag
     if [ $all_day_data1_flag == 1 ]
     then 
      echo "DEBUG= ./aeqc_dir/$yy1/$network/$station/$canal.D/$name_file1"
      if [ ! -s ./aeqc_dir/$yy1/$network/$station/$canal.D/$name_file1 ]
      #if [ ! -s ./aeqc_dir/$name_file1 ]
      then
       echo "Aucun fichier $name_file1 extrait du ringbuffer sur $station_ip !"
      fi
     fi
     echo "DEBUG= ./aeqc_dir/$yy2/$network/$station/$canal.D/$name_file2"
     if [ $all_day_data2_flag == 1 ]
     then
      if [ !  -s ./aeqc_dir/$yy2/$network/$station/$canal.D/$name_file2 ]
      #if [ !  -s ./aeqc_dir/$name_file2 ]
      then
       echo "Aucun fichier $name_file2 extrait du ringbuffer sur $station_ip !"
      fi 
     fi
     ###############################
     #echo "DEBUG"
     #kill $$    
     ###############################
     rm -f ./tampon
     rm -f ./extracted_data
     rm -f ./tampon1
     ###############################
     cat ./aeqc_dir/$yy1/$network/$station/$canal.D/$network.$station* > ./tampon1
     cat ./aeqc_dir/$yy2/$network/$station/$canal.D/$network.$station* >> ./tampon1
     if [ -s ./tampon1 ]
     then
      $dir_bin_base/qmerge -L $location ./tampon1 > ./tampon
     fi
     if [ -s ./tampon ]
     then 
      $dir_bin_base/qmerge -b 512  ./tampon > ./extracted_data
      ls -l ./extracted_data  
     fi
     #echo "DEBUG"
     #kill $$
     #############################################################################
     arclink_request=0
     echo "arclink_request="$arclink_request
     #############################################################################
     if [  -s ./extracted_data ]
     then 
      #############################################################################
      #################### CAS 1 DONNEES  DISPONIBLES SUR LE RINGBUFFER NAQS ###########
      gap_retrieved=1
      echo "conversion to D quality flag."
      $dir_bin_base/dataselect -Q D -o file_temp  ./extracted_data
      ls -l file_temp
      echo "conversion to 512 block size and to STEIM 2 encoding."
      $dir_bin_base/qmerge  -b 512 file_temp > file_temp2
      ls -l file_temp2
      $dir_bin_base/msrepack  -E 11 -o file_temp22 file_temp2 >& /dev/null
      ls -l file_temp22
      $dir_bin_base/qmerge -b 512 file_temp22 > file_temp
      mv -f file_temp  $gap_data_task
      $dir_bin_base/check_file  $gap_data_task > file_temp
      gap_flag=$( cat file_temp | grep "Time-gap" )
      if  ((${#gap_flag} > 1))
      then 
       arclink_request=1
      else
       arclink_request=0
      fi
     else
     ##########################################################################
      #################### CAS 2 DONNEES NON DISPONIBLES SUR LE RINGBUFFER #####
      gap_retrieved=0
      echo "Aucun fichier extrait du ringbuffer sur $station_ip !" 
      arclink_request=1
     fi
    fi  #=> if [ $station_ip != "NO_IP" ]
    #######################################    
    echo "arclink_request="$arclink_request
    echo "gap_retrieved ="$gap_retrieved
    ######################################
    #echo "DEBUG"
    #arclink_request=1
    #kill $$
    #################################
    if [ $arclink_server != "NO_IP" -a $arclink_request == 1 ]
    then
     # DEBUG
     #if [ $arclink_request == 1 -o $gap_retrieved == 0 ]
     #then
      echo "Write arclink request file aeqc.req"
      rm -f ./aeqc.req
      if [ $all_day_data1_flag == 1 ]
      then
       echo "$start_year,$start_month,$start_day,00,00,00 $start_year,$start_month,$start_day,23,59,59 $network $station $canal $location" > aeqc.req
      else
       echo  "$yy1,$mm1,$dd1,$hh1,$min1,$sec1 $yy2,$mm2,$dd2,$hh2,$min2,$sec2  $network $station $canal $location" > aeqc.req
      fi
      if [ $all_day_data2_flag == 1 -a  $start_month != $end_month -a $start_day != $end_day ]
      then
       echo  "$end_year,$end_month,$end_day,00,00,00 $end_year,$end_month,$end_day,23,59,59 $network $station $canal $location " >> aeqc.req
      fi
      ls -l aeqc.req
      cat aeqc.req
      rm -f ./arclink.mseed
      cmd0="$dir_bin_base/arclink_fetch -a $arclink_server -v -t 25 -x 1 -u $arclink_user_email -o ./arclink.mseed ./aeqc.req  > ./arclink_fetch.log"
      echo "cmd0="$cmd0
      ###########################
      #echo "DEBUG"
      #kill $$
      ###########################
      eval $cmd0
      cmd0_ok=$?
      echo "cmd0_ok="$cmd0_ok
      error=$( cat ./arclink_fetch.log | grep "Errno" )
      error1=$( cat ./arclink_fetch.log | grep "error" )
      error2=$( cat ./arclink_fetch.log | grep "No route" )
      error3=$( cat ./arclink_fetch.log | grep "no downloadable volumes found" )
      echo "error"$error
      echo "error1="$error1
      echo "error2="$error2
      echo "error3="$error3
      ################
      #echo "DEBUG"
      #kill $$
      ###############
      if [ $cmd0_ok != 0 -o "$error" != "" -o "$error1" != "" -o "$error2" != "" -o  "$error3" != "" ]
      then
       if [ "$error3" != "" ]
       then
        echo "server arclink  $arclink_server reachable..."
        echo  "no data available for this while !"
       else
        echo "arclink connexion problem to $arclink_server  !"
       fi
      else
       echo "server arclink  $arclink_server reachable..."
       if [ -s ./arclink.mseed ]
       then
        echo "________________________________________________________________________"
        echo "#################### GET INFORMATIONS OF ARCLINK DATA  ##################"
        echo "#########################################################################"
        $dir_bin_base/msview -p ./arclink.mseed |  head -n 14 > output_ms_view.txt  
        echo "*********output_ms_view.txt local file1*************"
        cat output_ms_view.txt
        echo "****************************************"
        local_file1_block_size=$(cat output_ms_view.txt | grep record | awk '{print $3}' )
        echo "local_file1_block_size="$local_file1_block_size
        local_file1_steim=$(cat output_ms_view.txt |  grep encoding | awk '{print $3}' )
        echo "local_file1_steim=STEIM "$local_file1_steim
        local_file1_quality_flag=$(cat output_ms_view.txt| grep $network | awk '{print $3}' )
        echo "local_file1_quality_flag="$local_file1_quality_flag    
        echo "######################################################################"
        echo "#BEFORE TREATMENT PUT LOCAL FILE1 WITH CORRECT FILES FORMAT IF NEEDED "
        echo "######################################################################"
        echo "conversion to D quality flag."
        $dir_bin_base/dataselect -Q D -o file_temp  ./arclink.mseed 
        if [ $local_file1_block_size  != 512 -o $local_file1_steim != 2  ]
        then
         echo "conversion to 512 block size and to STEIM 2 encoding."  
         $dir_bin_base/qmerge -b 512 file_temp > file_temp2 
         $dir_bin_base/msrepack  -E 11 -o file_temp22 file_temp2 >& /dev/null  
         $dir_bin_base/qmerge -b 512 file_temp22 > file_temp
        fi 
        mv -f file_temp  ./arclink-modif.mseed
        ls -l ./arclink-modif.mseed
        ###########################
        echo "DEBUG1"
        #kill $$
        ###########################
        if [ -s ./arclink-modif.mseed ]
        then
         echo "DEBUG2"
         if [ -s $gap_data_task ]
         then
          echo "DEBUG3"
          echo "merge arclink data and naqs data $gap_data_task"
          qmerge -b 512 ./arclink-modif.mseed $gap_data_task > file_temp
          mv file_temp  $gap_data_task
          ls -l $gap_data_task
          gap_retrieved=1
          echo "gap_retrieved ="$gap_retrieved
         else
          echo "DEBUG4"
          mv ./arclink-modif.mseed $gap_data_task
          gap_retrieved=1
          echo "gap_retrieved ="$gap_retrieved
         fi
        fi #=> if [ -s ./arclink-modif.mseed ]
       else
        echo "DEBUG5"
        gap_retrieved=0
        echo "gap_retrieved ="$gap_retrieved
        echo "arclink retrieved data file: empty or no exists !"
       fi #=> if [ -s ./arclink.mseed ]
      fi #=> if [ $cmd0_ok != 0 -o "$error" != "" -o "$error1" != "" -o "$error2" != "" -o $error3 != "" ]
     #fi #=> if [ $arclink_request == 1 -o $gap_retrieved == 0 ]
    fi #=> if [ $arclink_server != "NO_IP" ]     
    ##############
    #echo "DEBUG"
    #kill $$
    ##############################################################################
    ################################# CORRECTIONS DES  GAPS   ####################
    if [ $gap_retrieved == 1 ]
    then
     echo "############# FIN RECUPERATION DONNEE RECUPEREE = $gap_data_task #####"
     #############################################################################
     ### MODIFICATION DU 30 JANVIER 2013
     rm -f *.tmp
     ########################################" CAS 1 #############################
     if [  $file1_status ==  "#_CHECK=_FILE_OK." -o  $file1_status == "#_CHECK=_Date!" ]
     then
      if [ $file2_status == "#_CHECK=_FILE_OK." -o  $file2_status == "#_CHECK=_Date!"  ]
      then
       echo "############################# CORRECTION DES GAPS ###################"
       echo "### CAS DE FIGURE 1 ==> FILE1 & FILE2 PRESENTS ######################"
       output_qmerge=$name_file1'_'$name_file2
       echo "_____________________________________________________________________________" 
       echo $dir1_buffer_canal/$name_file1
       echo $gap_data_task
       echo $dir2_buffer_canal/$name_file2
       echo $output_qmerge
       rm -f $output_qmerge
       echo "_____________________________________________________________________________" 
       ###################################################################################
       rm -f $station* #!!!!
       $dir_bin_base/qmerge  -b 512 $dir1_buffer_canal/$name_file1 > test1
       cp -f  test1 $dir1_buffer_canal/$name_file1
       rm -f test1
       $dir_bin_base/qmerge  -b 512 $dir2_buffer_canal/$name_file2 > test1
       cp -f  test1 $dir2_buffer_canal/$name_file2
       rm -f test1
       $dir_bin_base/qmerge  -b 512 $gap_data_task > test1
       cp -f  test1  $gap_data_task
       rm -f test1
       $dir_bin_base/qmerge  -b 512 $dir1_buffer_canal/$name_file1 $gap_data_task $dir2_buffer_canal/$name_file2 > $output_qmerge
       $dir_bin_base/sdrsplit -c -D $output_qmerge
       if [ -s $output_qmerge ]
       then
        rm -f $output_qmerge
        ###########################################################################
        ###########################################################################
        echo "_____________________________________________________________________________" 
        ls -l $station*$suffix_file1*
        ls -l $dir1_buffer_canal/$name_file1
        ls -l $station*$suffix_file2*
        ls -l $dir2_buffer_canal/$name_file2
        echo "_____________________________________________________________________________" 
        echo "fichiers crees sdrsplit :"
        file1_data=$( echo  `ls  $station*$suffix_file1*` | awk '{print $1}' )
        echo "file1_data = "$file1_data
        file2_data=$( echo  `ls  $station*$suffix_file2*` | awk '{print $1}' )
        echo "file2_data = "$file2_data
        mv -f $file1_data $name_file1
        mv -f $file2_data $name_file2
        echo "copies des fichiers corriges vers work buffer ..."
        rsync -ctv $name_file1 $dir1_buffer_canal/$name_file1
        rsync -ctv $name_file2 $dir2_buffer_canal/$name_file2
        echo "_____________________________________________________________________________" 
       fi ##=> if [ -s $output_qmerge ]
      fi ##=> if [ $file2_status == "#_CHECK=_FILE_OK." -o  $file2_status == "#_CHECK=_Date!"  ]
      ###############################################################################################################
      ########################################" CAS 2 ###############################################################
      if [ $file2_status != "#_CHECK=_FILE_OK." -a  $file2_status != "#_CHECK=_Date!" -a   $file2_status != "UNKNOW" ]
      then   
       echo "############################# CORRECTION DES GAPS ###################################"
       echo "### CAS DE FIGURE 2 ==> FILE1 PRESENT & FILE2 ABSENT OU NOT OK ####" 
       output_qmerge=$name_file1".tmp"
       echo "_____________________________________________________________________________" 
       echo $dir1_buffer_canal/$name_file1
       echo $gap_data_task
       echo $output_qmerge
       rm -f $output_qmerge
       echo "_____________________________________________________________________________" 
       ##########################################################################
       rm -f $station* #!!!
       $dir_bin_base/qmerge  -b 512 $dir1_buffer_canal/$name_file1 > test1
       cp -f  test1 $dir1_buffer_canal/$name_file1
       rm -f test1
       $dir_bin_base/qmerge  -b 512 $gap_data_task > test1
       cp -f  test1  $gap_data_task
       rm -f test1
       $dir_bin_base/qmerge  -b 512 $dir1_buffer_canal/$name_file1 $gap_data_task  > $output_qmerge
       if [ -s $output_qmerge ]
       then
        mv -f $output_qmerge $name_file1
        ###########################################################################
        ###########################################################################
        echo "_____________________________________________________________________________" 
        ls -l $name_file1
        ls -l $dir1_buffer_canal/$name_file1
        echo "_____________________________________________________________________________" 
        echo "copies des fichiers corriges vers work buffer ..."
        rsync -ctv $name_file1 $dir1_buffer_canal/$name_file1
       fi ##=> if [ -s $output_qmerge ]
      fi ##=> if [ $file2_status != "#_CHECK=_FILE_OK." -a  $file2_status != "#_CHECK=_Date!" -a   $file2_status != "UNKNOW" ]
     fi ##=> if [  $file1_status ==  "#_CHECK=_FILE_OK." -o  $file1_status == "#_CHECK=_Date!" ]
     ###############################################################################################################
     ########################################" CAS 3 ###############################################################
     if [  $file2_status ==  "#_CHECK=_FILE_OK." -o  $file2_status == "#_CHECK=_Date!" ]
     then
      if [ $file1_status != "#_CHECK=_FILE_OK." -a  $file1_status != "#_CHECK=_Date!" ]
      then
       echo "############################# CORRECTION DES GAPS ############################"
       echo "### CAS DE FIGURE 3 ==> FILE1 ABSENT OU NOT OK & FILE2 PRESENT #########################"
       output_qmerge=$name_file2".tmp"
       echo "_____________________________________________________________________________" 
       echo $dir2_buffer_canal/$name_file2
       echo $gap_data_task
       echo $output_qmerge
       rm -f $output_qmerge
       echo "_____________________________________________________________________________" 
       ##########################################################################
       rm -f $station* #!!!
       $dir_bin_base/qmerge  -b 512 $dir2_buffer_canal/$name_file2 > test1
       cp -f  test1 $dir2_buffer_canal/$name_file2
       rm -f test1
       $dir_bin_base/qmerge  -b 512 $gap_data_task > test1
       cp -f  test1  $gap_data_task
       rm -f test1
       $dir_bin_base/qmerge  -b 512 $dir2_buffer_canal/$name_file2 $gap_data_task  > $output_qmerge
       if [ -s $output_qmerge ]
       then
        mv -f $output_qmerge $name_file2
        ###########################################################################
        ###########################################################################
        echo "_____________________________________________________________________________" 
        ls -l $name_file2
        ls -l $dir2_buffer_canal/$name_file2
        echo "_____________________________________________________________________________" 
        echo "copies des fichiers corriges vers work buffer ..."
        rsync -ctv $name_file2 $dir2_buffer_canal/$name_file2
       fi ##=> if [ -s $output_qmerge ]
      fi ##=> if [ $file1_status != "#_CHECK=_FILE_OK." -a  $file1_status != "#_CHECK=_Date!" ]
     fi ##=> if [  $file2_status ==  "#_CHECK=_FILE_OK." -o  $file2_status == "#_CHECK=_Date!" ]
     ##################################################################################################################
     ########################################" CAS 4 ##################################################################
     if [ $file1_status != "#_CHECK=_FILE_OK." -a  $file1_status != "#_CHECK=_Date!"   -a  $file2_status == "UNKNOW" ] 
     then 
      echo "############################# CORRECTION DES GAPS ############################"
      echo "### CAS DE FIGURE 4 ==> FILE1 ABSENT OU NOT OK  & FILE2 UNKNOW ###############"
      output_qmerge=$name_file1".tmp"
      echo "_____________________________________________________________________________" 
      echo $dir1_buffer_canal/$name_file1
      echo $gap_data_task
      echo $output_qmerge
      rm -f $output_qmerge
      echo "_____________________________________________________________________________" 
      ##########################################################################
      rm -f $station*  #!!!
      $dir_bin_base/qmerge  -b 512  $gap_data_task  > $output_qmerge
      if [ -s $output_qmerge ]
      then
       mv -f $output_qmerge $name_file1
       ###########################################################################
       ###########################################################################
       echo "_____________________________________________________________________________" 
       ls -l $name_file1
       ls -l $dir1_buffer_canal/$name_file1
       echo "_____________________________________________________________________________" 
       echo "copies des fichiers corriges vers work buffer ..."
       ##DEBUG
       #kill $pid_script
       #kill $pid_parent
       rsync -ctv $name_file1 $dir1_buffer_canal/$name_file1
      fi ##=> if [ -s $output_qmerge ]
     fi ##=> if [ $file1_status != "#_CHECK=_FILE_OK." -a  $file1_status != "#_CHECK=_Date!"   -a  $file2_status == "UNKNOW" ]
    ###############################################################################################################################
    fi # --> if [ $gap_retrieved == 1 ]
    #####################################
   fi #--> if [ $station_ip != "NO_IP" -o arclink_server != "NO_IP" ]
   ######################################   
  fi #--> if [  $pass_to_next_gap == 0 ]
  #####################################  
 fi # -->if [ $prob_type == "OVERLAP" ] 
 #####################################
 previous_start_day=$start_day
 echo "previous_start_day="$previous_start_day
 #############
 #echo "DEBUG"
 #kill $$
 ############
done
exec 4>&-
###################################################################
#   ARCHIVER LE FICHIER LOG ...                                   #
#  Les repertoires ayant deja ete crees par ae_qc_report_v1.4.sh  #
###################################################################
echo '***************************************************************************************************'
echo '__________________________________LOGS DIRECTORIES_________________________________________________'
echo '***************************************************************************************************'
champ=$( "$dir_bin_base/dirname" $tasks_file )
year1_day1_to_year2_day2=$( "$dir_bin_base/basename" $champ )
echo "year1_day1_to_year2_day2 = "$year1_day1_to_year2_day2
champ=$( "$dir_bin_base/dirname" $champ )
echo $champ
champ=$( "$dir_bin_base/dirname" $champ )
echo $champ
champ=$( "$dir_bin_base/dirname" $champ )
echo $champ
champ=$( "$dir_bin_base/dirname" $champ )
echo $champ
day_year_tasks_file=$( "$dir_bin_base/basename" $champ )
echo "day_year_tasks_file ="$day_year_tasks_file
#########################################################################
dir_logs_base=$dir_work_base/logs
dir_logs_daily=$dir_logs_base/$day_year_tasks_file
dir_logs_daily=$dir_logs_daily/$network
dir_logs_daily=$dir_logs_daily/$station
dir_logs_daily=$dir_logs_daily/$canal.D
dir_logs_daily=$dir_logs_daily/$year1_day1_to_year2_day2
###################################################################
#   POUR FINALISER LE PROGRAMME  ET POUR UN MEILLEUR DEBBUGAGE    #
# LA PARTIE DE CODE QUI VA ARCHIVER LE FICHIER LOG ...            #
###################################################################
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
##########################################################################################################
echo '****************************************************************************************************'
echo "FIN du script $name_script..." 
echo '****************************************************************************************************'

