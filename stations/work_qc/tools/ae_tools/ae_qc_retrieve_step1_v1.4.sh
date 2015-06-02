#!/bin/bash
#***************************** TITLE *********************************************************************
# Script Bash3.2  Recuperation BALER  STEP1                                                              *
# Version v1.4    12 Avril 2011  AISSAOUI -IPGP PARIS                                                    *
#*********************************************************************************************************
# ATTENTION: Cette version de programme ne fonctionne qu'avec une archive miniseed de strucuture SDS et  #
#*********************************************************************************************************
#************************* CONFIGURATIONS ****************************************************************
echo '***************************************************************************************************'
version_script='Data Retrieve and correction from Baler STEP1 script 12/04/2011   -AISSAOUI IPGP Paris   '
echo '               Running '$version_script
echo '               '$(date)
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '_______________________  ETAPE 1 -CONFIGURATION DU PROGRAMME_______________________________________'
echo '---------------------------------------------------------------------------------------------------'
echo '                               *** SYNTAXE ***                                                     '
echo 'ae_qc_retrieve_step1_v1.4 [tasks_file][ip_station][dir_work_base][correction_buffer_base][network] '
echo '          [station][canal][pid_parent] > ae_qc_retrieve_step1_v1.4.log   '
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '__________________________________TASKS FILE_______________________________________________________'
echo '***************************************************************************************************'
tasks_file=$1
echo "Tasks_file = "$tasks_file 
echo '***************************************************************************************************'          
echo '________________________________________DIR. WORK BASE_____________________________________________' 
echo '***************************************************************************************************'
dir_work_base=$2
echo "Dir_Work_base = "$dir_work_base
echo '***************************************************************************************************'          
echo '________________________________________CORRECTION BUFFER__________________________________________' 
echo '***************************************************************************************************'
correction_buffer_base=$3
echo "correction_buffer_base = "$correction_buffer_base
echo '***************************************************************************************************'
echo '________________________________NETWORK NAMES______________________________________________________'
echo '***************************************************************************************************'                                                                     
network=$4
echo 'Network_Name = '$network
echo '***************************************************************************************************'
echo '___________________________________ STATION NAME___________________________________________________'
echo '***************************************************************************************************'
station=$5
echo "station_name = "$station
echo '***************************************************************************************************'
echo '___________________________________ CHAN NAME___________________________________________________'
echo '***************************************************************************************************'
canal=$6
echo "Canal = "$canal
echo '***************************************************************************************************'
echo '***************************************************************************************************'          
echo '________________________________________START_QC_DATE_____________________________________________' 
echo '***************************************************************************************************'
# Cela est necessaire pour mettre tous les rapports, et les fichiers generes (logs, temp, etc..) dans le
# même repertoire dans le cas ou le QC tourne plusieurs jours...
##########################################################################################################
start_qc_date=$7
echo "Start_Qc_Date = "$start_qc_date
echo '***************************************************************************************************'           
echo '________________________________________PID PARENTS________________________________________________' 
echo '***************************************************************************************************'
pid_parent=$8
echo "Pid_parent = "$pid_parent
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
echo "dir_script = "$dir_script # NOTE BUG SANS GRAVITE chemin s'affiche avec une double barre // au debut !??
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
 mkdir -p $dir_buffer_archive
 error=$?
fi 
if [ ! -d $dir_buffer_work ]
then
 mkdir -p  $dir_buffer_work
 error=$?
fi 
if [ $error == 1 ]
then
 echo "Can't create directories !..."
 if [ $pid_parent != NONE ]
 then
  kill $pid_parent
 fi
 kill $pid_script
fi

##########################################################################
########### RECUPERATION DES TACHES DANS LE FICHIER TASKSLIST EN COURS ...
tasks_file_work=$tasks_file.cpy
grep "\.task" $tasks_file > $tasks_file_work
echo "tasks_file_work = "$tasks_file_work
cat $tasks_file_work

#########################################################################
### ON EFFACE LES FICHIERS DE L'ARCHIVE > correction_buffer/work ########

exec 4<>$tasks_file_work
while read line <&4
do

 line1=$line
 echo "##############################################################################"
 echo "### ON EFFACE LES FICHIERS DE L'ARCHIVE > correction_buffer/work      ########"
 echo $line1 
 echo "##############################################################################"
 details_tasks_file=$line1
 echo "`date` $name_script LAST_LOG, AISSAOUI IPGP PARIS 2011" >> $details_tasks_file

 champ=$(grep "NETWORK" $details_tasks_file)
 echo "Champ ="$champ

 network=$( echo $champ | awk '{print $1}' )
 echo "Network = "$network

 echo "-----------------------------------------------------------------------------"

 champ=$(grep "STATION" $details_tasks_file)
 echo "Champ ="$champ

 station=$( echo $champ | awk '{print $1}' )
 echo "Station = "$station

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

 champ=$(grep "CANAL" $details_tasks_file)
 echo "Champ ="$champ

 canal=$( echo $champ | awk '{print $1}' )
 echo "Canal = "$canal

 echo "-----------------------------------------------------------------------------"

 dir1_buffer_archive=$dir_buffer_archive/$year_file1/$network/$station/$canal.D
 dir1_buffer_work=$dir_buffer_work/$year_file1/$network/$station/$canal.D
 if [ -d $dir1_buffer_archive ]
 then
  rm -f  $dir1_buffer_archive/*
 fi
 if [ -d $dir1_buffer_work ]
 then
  #mv -f  "$dir1_buffer_work/*.dat" $dir2_buffer_work/
  rm -f  $dir1_buffer_work/*
 fi

 dir2_buffer_archive=$dir_buffer_archive/$year_file2/$network/$station/$canal.D
 dir2_buffer_work=$dir_buffer_work/$year_file2/$network/$station/$canal.D
 if [ -d $dir2_buffer_archive ]
 then
  rm -f  $dir2_buffer_archive/*
 fi
 if [ -d $dir2_buffer_work ]
 then
  ##########################################################################
  #test_dat=$( ls -t1 "$dir2_buffer_work/*.dat" | tail -n 1 )
  #echo "Test_dat ="$test_dat
  #kill $$
  #kill $pid_parent
  #if [ -s "$test_dat" ]
  #then
  # echo "##########################################################################################"
  #echo "############## CONCATENATIONS DES DONNEES RECUPEREES VERS L'ARCHIVE mixed_data_archive   #"
   # Ces fichiers dans $correction_buffer_base => correction_buffer/work/.../station 
  # echo "##############  Version en developpement #################################################"
  # mixed_data_archive_dir="$dir_buffer_work/$year_file1/$network/$station/"
  # echo "mixed_data_archive_dir = "$mixed_data_archive_dir 
  # mixed_data_archive="$mixed_data_archive_dir/mixed_data_archive"
  # echo "mixed_data_archive = "$mixed_data_archive
  # cat $dir2_buffer_work/*.dat > $mixed_data_archive
  #fi
  rm -f  $dir2_buffer_work/*
 fi 
done
exec 4>&-

##########################################################################
### ON RECOPIE LES FICHIERS DE L'ARCHIVE > correction_buffer/work ########
exec 4<>$tasks_file_work
while read line <&4
do

 line1=$line
 echo "##############################################################################"
 echo "### ON RECOPIE LES FICHIERS DE L'ARCHIVE > correction_buffer/work      ########"
 echo $line1 
 echo "##############################################################################"
 details_tasks_file=$line1
 echo "`date` $name_script LAST_LOG, AISSAOUI IPGP PARIS 2011" >> $details_tasks_file

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

 champ=$(grep "CANAL" $details_tasks_file)
 echo "Champ ="$champ

 canal=$( echo $champ | awk '{print $1}' )
 echo "Canal = "$canal

 echo "-----------------------------------------------------------------------------"

 champ=$(grep "DIR_DATA_STATION" $details_tasks_file)
 echo "Champ ="$champ

 dir_data_station=$( echo $champ | awk '{print $1}' )
 echo "Dir_data_station = "$dir_data_station

 dir_station=$( $dir_bin_base/dirname  "$dir_data_station" )

 echo "_____________________________________________________________________________"
 echo "Dir_station = "$dir_station
 echo "_____________________________________________________________________________"
 
 echo "-----------------------------------------------------------------------------"

 champ=$(grep "FILE1_STATUS" $details_tasks_file)
 echo "Champ ="$champ

 file1_status=$( echo $champ | awk '{print $1}' )
 echo "FILE1_STATUS = "$file1_status

 echo "-----------------------------------------------------------------------------"

 champ=$(grep "LINK_FILE1" $details_tasks_file)
 echo "Champ ="$champ

 link_file1=$( echo $champ | awk '{print $1}' )
 echo "LINK_FILE1 = "$link_file1

 echo "-----------------------------------------------------------------------------"

 champ=$(grep "NAME_FILE1" $details_tasks_file)
 echo "Champ ="$champ
 name_file1=$( echo $champ | awk '{print $1}' )
 echo "FILE1 = "$name_file1

 echo "-----------------------------------------------------------------------------"

 champ=$(grep "FILE2_STATUS" $details_tasks_file)
 echo "Champ ="$champ

 file2_status=$( echo $champ | awk '{print $1}' )
 echo "FILE2_STATUS = "$file2_status

 echo "-----------------------------------------------------------------------------"

 champ=$(grep "LINK_FILE2" $details_tasks_file)
 echo "Champ ="$champ

 link_file2=$( echo $champ | awk '{print $1}' )
 echo "LINK_FILE2 = "$link_file2

 echo "-----------------------------------------------------------------------------"
 
 champ=$(grep "NAME_FILE2" $details_tasks_file)
 echo "Champ ="$champ

 name_file2=$( echo $champ | awk '{print $1}' )
 echo "FILE2 = "$name_file2

 ########################################################################################
 ############## CREATION D'UN  BUFFER ARCHIVE DE TRAVAIL QUI CONTIENDRA LES FICHIERS ####
 ############## INTERMEDIAIRES DE CORRECTIONS ###########################################
 dir_buffer_archive=$correction_buffer_base/archive
 error=0
 ###################################################
 dir1_buffer_archive=$dir_buffer_archive/$year_file1
 if [ ! -d $dir1_buffer_archive ]
 then
  mkdir -p $dir1_buffer_archive
  error=$?
 fi
 dir2_buffer_archive=$dir_buffer_archive/$year_file2
 if [ ! -d $dir2_buffer_archive ]
 then
  mkdir -p $dir2_buffer_archive
  error=$?
 fi
 dir1_buffer_archive=$dir1_buffer_archive/$network
 if [ ! -d $dir1_buffer_archive ]
 then
  mkdir -p $dir1_buffer_archive
  error=$?
 fi
 dir2_buffer_archive=$dir2_buffer_archive/$network
 if [ ! -d $dir2_buffer_archive ]
 then
  mkdir -p $dir2_buffer_archive
  error=$?
 fi
 dir1_buffer_archive=$dir1_buffer_archive/$station
 if [ ! -d $dir1_buffer_archive ]
 then
  mkdir -p $dir1_buffer_archive
  error=$?
 fi
 dir2_buffer_archive=$dir2_buffer_archive/$station
 if [ ! -d $dir2_buffer_archive ]
 then
  mkdir -p $dir2_buffer_archive
  error=$?
 fi
 dir1_buffer_canal=$dir1_buffer_archive/$canal.D
 if [ ! -d $dir1_buffer_canal ]
 then
  mkdir -p $dir1_buffer_canal
  error=$?
 fi
 dir2_buffer_canal=$dir2_buffer_archive/$canal.D
 if [ ! -d $dir2_buffer_canal ]
 then
  mkdir -p $dir2_buffer_canal
  error=$?
 fi
 ###########################################################
 if [ $error == 1 ]
 then
  echo "Can't create directories !..."
  if [ $pid_parent != NONE ]
  then
   kill $pid_parent
  fi
  kill $pid_script
 fi
 ###########################################################
 echo "dir1_buffer_canal = "$dir1_buffer_canal
 echo "dir2_buffer_canal = "$dir2_buffer_canal
 ###################################################################################################
 #################### COPIE DES FICHIERS ###########################################################
 echo "_____________________________________________________________________________________________"
 echo "***** Transfert des fichiers de l'archive principale vers le repertoire de travail work *****"
 if [ $file1_status != "#_CHECK=_NO_FILE_!" ]
 then
  if [ ! -s $dir1_buffer_canal/$name_file1 ]
  then
   echo "copy $link_file1 to $dir1_buffer_canal..."
   rsync -Itv $link_file1 $dir1_buffer_canal
  else
   echo "$link_file1 already copied in $dir1_buffer_canal..."
  fi
 fi 
 if [ $file2_status != "#_CHECK=_NO_FILE_!" -a  $file2_status != "UNKNOW" ]
 then
  if [ ! -s $dir2_buffer_canal/$name_file2 ]
  then
   echo "copy $link_file2 to $dir2_buffer_canal..."
   rsync -Itv $link_file2 $dir2_buffer_canal
  else
   echo "$link_file2 already copied in $dir2_buffer_canal..."
  fi
 fi
 ###################################################################################################
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
 cp $tasks_file_work $dir_logs_daily
fi
name_script_log=$dir_script/$name_script_log
if [ -f $name_script_log ]
then
 cp $name_script_log $dir_logs_daily
 cp $tasks_file_work $dir_logs_daily
fi
##########################################################################################################
echo '****************************************************************************************************'
echo "FIN du script $name_script..." 
echo '****************************************************************************************************'




