#!/bin/bash
#***************************** TITLE *********************************************************************
# Script Bash3.2  Calcul de date                                                                         *
# Version 1.2    11 Avril 2011        AISSAOUI -IPGP Paris                                               *
#*********************************************************************************************************
# ATTENTION: Cette version de programme ne fonctionne qu'avec une archive miniseed de strucuture SDS     #
#*********************************************************************************************************
#************************* CONFIGURATIONS ****************************************************************
echo '***************************************************************************************************'
version_script='Calcul de date projet IPOC Version 1.2 Version 11/04/2011  AISSAOUI -IPGP Paris          '
echo '               Running '$version_script
echo '               '$(date)
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '_______________________  ETAPE 1 -CONFIGURATION DU PROGRAMME_______________________________________'
echo '---------------------------------------------------------------------------------------------------'
echo '                               *** SYNTAXE ***                                                     '
echo ' ae_qc_calcul_dates_v1.2.sh [analyse_mode] [start_date] [end_date] [dir_work_base] [start_qc_date] ' 
echo '            [pid_parent]                                            > ae_qc_calcul_dates_v1.2.log  ' 
echo '***************************************************************************************************'
echo '________________________________ANALYSE MODE_______________________________________________________'
echo '***************************************************************************************************' 
analyse_mode=$1
echo "Analyse_Mode = "$analyse_mode
echo '***************************************************************************************************'
echo '__________________________________START DATE_______________________________________________________'
echo '***************************************************************************************************' 
start_date=$2
echo "Start_Date = "$start_date
echo '***************************************************************************************************'
echo '__________________________________  END DATE_______________________________________________________'
echo '***************************************************************************************************' 
end_date=$3
echo "End_Date = "$end_date
echo '***************************************************************************************************'           
echo '________________________________________DIR. WORK BASE_____________________________________________' 
echo '***************************************************************************************************'
dir_work_base=$4
echo "Dir_Work_base = "$dir_work_base
echo '***************************************************************************************************'          
echo '________________________________________START_QC_DATE_____________________________________________' 
echo '***************************************************************************************************'
# Cela est necessaire pour mettre tous les rapports, et les fichiers generes (logs, temp, etc..) dans le
# même repertoire dans le cas ou le QC tourne plusieurs jours...
##########################################################################################################
start_qc_date=$5
echo "Start_Qc_Date = "$start_qc_date
echo '***************************************************************************************************'           
echo '________________________________________PID PARENTS________________________________________________' 
echo '***************************************************************************************************'
### NOTE $PPID ne fonctionne pas dans toutes les shell
pid_parent=$6
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
echo ' Utilisation des programmes bin { calday  }' 
echo '***************************************************************************************************'
dir_bin_base=$dir_work_base/bin
echo 'dir_bin_base = '$dir_bin_base
#########################################################################################################
# NOM DU FIHIER LOG 
# Sert  a identifier les differentes parties  dans les fichiers logs...
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
#########################################################################################################
echo '****************************************************************************************************'
echo '________________________________CALCUL DATE DEBUT, FIN NOMBRE DE JOURS ETC..._______________________'
echo '***************************************************************************************************'
# ********************************************************************************************************
# On initialise les variables jours et annee du demarrage du test QC...                                  *
#*********************************************************************************************************
start_qc_day=$(date -d $start_qc_date "+%j")
start_qc_year=$(date -d $start_qc_date "+%Y")
echo 'start_qc_day = '$start_qc_day
echo 'start_qc_year = '$start_qc_year
# ********************************************************************************************************
# Il a 2 modes de fonctionnement:                                                                        *
# MODE 'M0' => On specifie un nombre de jours par rapport a la date actuelle. Le programme calcule lui   *
#             même les dates 1 & 2                                                                       *
# MODE 'M1' => On specifie une date1 (de debut)  et une date2 (de fin) au format yyyy.mm.dd              *
# MODE 'M2' => On specifie une date1 (de debut)  et une date2 (de fin) au format yyyy.ddd                *   
# ********************************************************************************************************
if [  $analyse_mode == "M0" -o  $analyse_mode == "M1" -o $analyse_mode == "M2" ]
then
 echo 'MODE_DATE = '$analyse_mode
 #********************************************************************************************************** 
 #__________________________________ ANALYSE MODE DATE M0 _________________________________________________
 # *********************************************************************************************************
 if [ $analyse_mode == "M0" ]
 then
  #*********************************************************************************************************
  # MODE '0'                                                                                               *
  # Date de debut du jour a analyser calculee a partir du nombre de jour a verifier                        *
  # Annee concernee  a partir du nombre de jour a verifier                                                 *
  #*********************************************************************************************************
  # ********************************************************************************************************
  # On initialise les variables jour et annee actuelle...                                                  *
  #*********************************************************************************************************
  #*********************************************************************************************************
  #old 
  day2=$start_qc_day
  #old
  year2=$start_qc_year
  #*********************************************************************************************************
  #****** ====> C'EST ICI QU'ON MODIFIE L'INTERVAL DE JOURS A ANALYSER...
  ### DEBUG DEBUG
  #days_number=$(( end_date - 2 )) 
  #******************
  days_number=$end_date
  #*****************************************************************************************************
  if  test $days_number -le  2 
  then
   echo "Erreur le nombre de jours a analyser doit-être > 2 ..."
   if [ $pid_parent != NONE ]
   then
    kill $pid_parent
   fi
   kill $pid_script
  fi
  #*****************************************************************************************************
  echo 'days_number = '$days_number
  day1=$(date -d "$start_qc_date -$days_number days" +%j)
  echo 'day1 = '$day1
  year1=$(date -d "$start_qc_date -$days_number days" +%Y)
  echo 'year1 = '$year1
  #*****************************************************************************************************
  #new patch
  day2=$(date -d "$start_qc_date -1 days" +%j)
  echo 'day2 = '$day2
  #new patch 
  year2=$(date -d "$start_qc_date -1 days" +%Y)
  echo 'year2 = '$year2 
  #*****************************************************************************************************
 fi
 #********************************************************************************************************** 
 #__________________________________ ANALYSE MODE DATE M1 _________________________________________________
 # *********************************************************************************************************
 if [ $analyse_mode == "M1" ]
 then 
  # ********************************************************************************************************
  # MODE '1'                                                                                               
  # Date de debut et de fin choisies par l'utilisateur : au format yyyy.mm.dd                                                 
  #*********************************************************************************************************
  yyyy1=$((10#${start_date:0:4}))
  echo "yyyy1 = "$yyyy1
  mm1=$((10#${start_date:5:2}))
  echo "mm1 = "$mm1
  dd1=$((10#${start_date:8:2}))
  echo "dd1 = "$dd1
  #*********************************************************************************************************
  # On initialise la date fin                                                                              
  #*********************************************************************************************************
  yyyy2=$((10#${end_date:0:4}))
  echo "yyyy2 = "$yyyy2
  mm2=$((10#${end_date:5:2}))
  echo "mm2 = "$mm2
  dd2=$((10#${end_date:8:2}))
  echo "dd2 = "$dd2
  #*********************************************************************************************************
  # On calcul les dates de depart/debut:    au format yyyy.ddd
  #********************************************************************************************************* 
  day1=$( date -d "$mm1/$dd1/$yyyy1" +%j )
  echo "day1 = "$day1
  year1=$yyyy1
  echo "year1 = "$year1
  day2=$( date -d "$mm2/$dd2/$yyyy2" +%j )
  echo "day2 = "$day2
  year2=$yyyy2
  echo "year2 = "$year2
 fi
 #********************************************************************************************************** 
 #__________________________________ ANALYSE MODE DATE M2 _________________________________________________
 # *********************************************************************************************************
 if [ $analyse_mode == "M2" ]
 then 
  # ********************************************************************************************************
  # MODE '2'                                                                                               
  # Date de debut et de fin choisies par l'utilisateur : au format yyyy.ddd 
  #*********************************************************************************************************
  yyyy1=$((10#${start_date:0:4}))
  echo "yyyy1 = "$yyyy1
  ddd1=$((10#${start_date:5:3}))
  echo "ddd1 = "$ddd1
  year1=$yyyy1
  day1=$ddd1
  echo 'year1 = '$year1
  echo 'day1 = '$day1
  #*********************************************************************************************************
  # On initialise la date fin                                                                              
  #*********************************************************************************************************
  yyyy2=$((10#${end_date:0:4}))
  echo "yyyy2 = "$yyyy2
  ddd2=$((10#${end_date:5:3}))
  echo "ddd2 = "$ddd2
  year2=$yyyy2
  day2=$ddd2
  echo 'year2 = '$year2
  echo 'day2 = '$day2
 fi
 #*********************************************************************************************************
 # On calcul le nombre de jours et le nombre de secondes de  la periode d'analyse...                                                
 #*********************************************************************************************************
 echo "*********** DATE DEBUT AU FORMAT STANDARD *************"
 dd1=$( $dir_bin_base/calday   $day1 $year1 | grep Calendar | awk '{print $4}' )
 echo "dd1 = "$dd1
 mm1=$( $dir_bin_base/calday   $day1 $year1 | grep Calendar | awk '{print $3}' )
 echo "mm1 = "$mm1
 echo 'year1 = '$year1
 #PATCH MADANI 13 juillet 2011
 #date1_qc=$( date -d "$mm1/$dd1/$year1" +%x )
 date1_qc=$( date -d "$mm1/$dd1/$year1" +%D )
 echo "date1_qc ="$date1_qc
 echo "*********** DATE FIN AU FORMAT STANDARD *************"
 dd2=$( $dir_bin_base/calday   $day2 $year2 | grep Calendar | awk '{print $4}' )
 echo "dd2 = "$dd2
 mm2=$( $dir_bin_base/calday   $day2 $year2 | grep Calendar | awk '{print $3}' )
 echo "mm2 = "$mm2
 echo "year2 = "$year2
 #PATCH MADANI 13 juillet 2011
 #date2_qc=$( date -d "$mm2/$dd2/$year2" +%x )
 date2_qc=$( date -d "$mm2/$dd2/$year2" +%D )
 echo "date2_qc ="$date2_qc
 echo "#######################################################"
 temps1=$( date -d "$mm1/$dd1/$year1" +%s )
 echo "temps1 (s) =  "$temps1
 temps2=$( date -d "$mm2/$dd2/$year2 23:59:59" +%s )
 echo "temps2 (s) =  "$temps2
 temps_secs=$(( temps2 -temps1 ))
 echo "temps_secs = "$temps_secs
 if (( temps_secs > 0 ))
 then
  #### On ajoute un jour parce que le premier jour est inclus dans l'analyse ###############
  days_number=$(( temps_secs/86400 + 1))
  echo "days_number = "$days_number 
  if  test $days_number -le  2 
  then
   echo "Erreur le nombre de jours a analyser doit-être > 2 ..."
   if [ $pid_parent != NONE ]
   then
    kill $pid_parent
   fi
   kill $pid_script
  fi
  #**********************************************************************************************************
  #  On met les valeurs des variables day1, year1, day2, year2, days_number & Temps_secs                    *
  #  dans les fichiers associes  day1.txt, year1.txt etc...                                                 *
  #**********************************************************************************************************
  echo $day1  > $dir_work_base/tools/ae_tools/day1.txt
  echo $year1 > $dir_work_base/tools/ae_tools/year1.txt
  echo $day2 > $dir_work_base/tools/ae_tools/day2.txt
  echo $year2 > $dir_work_base/tools/ae_tools/year2.txt
  echo $date1_qc > $dir_work_base/tools/ae_tools/date1_qc.txt
  echo $date2_qc > $dir_work_base/tools/ae_tools/date2_qc.txt
  echo $temps_secs > $dir_work_base/tools/ae_tools/temps_secs.txt
  echo $days_number > $dir_work_base/tools/ae_tools/days_number.txt
 else
  echo " Attention [end_date] < [start_date] !!!!!"
  if [ $pid_parent != NONE ]
  then
   kill $pid_parent
  fi
  kill $pid_script
 fi
else
 echo " Choix du mode de calcul de date incorrect : choix M0, M1 ou M2 !!!"
 if [ $pid_parent != NONE ]
 then
  kill $pid_parent
 fi
 kill $pid_script
fi
echo '****************************************************************************************************'
echo "FIN du script $name_script de calcul de date...V1.2" 
echo '****************************************************************************************************'






