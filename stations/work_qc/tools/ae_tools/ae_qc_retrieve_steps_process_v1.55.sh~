#!/bin/bash
#***************************** TITLE ********************************************************************
# Script Bash3.2  Auto Correction Data, sources manager ...  IPOC PROJET                                *
# Version v1.55   10 Dec 2012     AISSAOUI -IPGP PARIS                                                  *
#********************************************************************************************************
#********************************************************************************************************
echo '***************************************************************************************************'
version_script='Auto Correction Data, source manager  Version v1.55  10 Dec 2012    AISSAOUI -IPGP PARIS'
echo ' Running '$version_script
echo ' '$(date)
echo '***************************************************************************************************'
echo '***************************************************************************************************'
echo '_______________________  ETAPE 1 -CONFIGURATION DU PROGRAMME_______________________________________'
echo '---------------------------------------------------------------------------------------------------'
echo '                                     *** SYNTAXE ***                                               '
echo ' ae_qc_retrieve_steps_process_v1.55.sh [station_name] [network] [location] [analyse_mode] [start_date] '
echo ' [end_date] [server_name] [dir_data_base] [structure] [chans_list] [dir_station_work_base]         ' 
echo ' [email_address][email_title] [ tasks_file ] [ dir_buffer_base ] [station_ip] battery_test]        '                            
echo ' [start_qc_date] [loop_correction] [station_srce] [battery_volt] [bandwidth]                                  '
echo '                                                           > ae_qc_retrieve_steps_process_v1.55.log '  
echo '***************************************************************************************************'
echo ''
echo '***************************************************************************************************'
echo '___________________________________ STATION NAME___________________________________________________'
echo '***************************************************************************************************'
station_name=$1
echo "station_name = "$station_name
echo '***************************************************************************************************'
echo '________________________________NETWORK NAMES______________________________________________________'
echo '***************************************************************************************************'    
network_name=$2
echo "Network_Name="$network_name
echo '***************************************************************************************************'
echo '________________________________LOCATION CODE______________________________________________________'
echo '***************************************************************************************************'                           
location_code=$3
echo "Location_code="$location_code
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
echo "Dir_Data_Base = "$dir_data_base
echo '***************************************************************************************************'
echo '___________________________________STRUCTURE_______________________________________________________'
echo '***************************************************************************************************' 
structure=$9
echo "structure = "$structure
echo '***************************************************************************************************'          
echo '_____________________________________CHANS LIST TO CHECK___________________________________________' 
echo '***************************************************************************************************'
shift
list_chans=$9
echo "list_chans = "$list_chans
echo $list_chans > list_chans.$station_name 
champ=$( sed "s/_/ /g" list_chans.$station_name )
chans_list=$champ
echo "chans_list ="$chans_list
echo '***************************************************************************************************'          
echo '_____________________________________CHANNEL RATE__________________________________________________' 
echo '***************************************************************************************************'
## to be compatible with the Bourne shell
shift
list_freqs=$9
echo "list_freqs="$list_freqs
echo $list_freqs > list_freqs.$station_name
champ=$( sed "s/_/ /g" list_freqs.$station_name  )
freqs_list=$champ
echo "freqs_list="$freqs_list
echo '***************************************************************************************************'          
echo '________________________________________DIR. WORK BASE_____________________________________________' 
echo '***************************************************************************************************'
shift
dir_station_work_base=$9
echo "dir_station_work_base = "$dir_station_work_base
echo '***************************************************************************************************'
echo '______________________________TITLE  & EMAILS  ADDRESS LIST TO SEND REPORTS QC_____________________'
echo '***************************************************************************************************'
echo '  --- !! ATTENTION VOTRE CONFIGURATION POSTFIX/SENDMAIL DOIT ETRE BIEN CONFIGURER !! ----'
# ==> Emails des destinataires du bilan QC ci-dessus...
shift
emails=$9
echo "Emails = "$emails
# ==> Titre du message 
shift
emails_title=$9
echo "Email_Title = "$emails_title
echo '***************************************************************************************************'
echo '__________________________________TASKS FILE_______________________________________________________'
echo '***************************************************************************************************'
shift
tasks_file=$9
echo "Tasks_file = "$tasks_file
echo '***************************************************************************************************'          
echo '________________________________________CORRECTION BUFFER__________________________________________' 
echo '***************************************************************************************************'
shift
dir_buffer_base=$9
echo "dir_buffer_base = "$dir_buffer_base
echo '***************************************************************************************************'          
echo '_________________________________________ STATION_IP _____________________________________________' 
echo '***************************************************************************************************'
shift
station_ip=$9
echo "Station_ip = "$station_ip
echo '***************************************************************************************************'          
echo '________________________________________ BATTERY_TEST ____________________________________________' 
echo '***************************************************************************************************'
shift
battery_test=$9
echo "Battery_test = "$battery_test
echo '***************************************************************************************************'          
echo '________________________________________START_QC_DATE_____________________________________________' 
echo '***************************************************************************************************'
# Cela est necessaire pour mettre tous les rapports, et les fichiers generes (logs, temp, etc..) dans le
# même repertoire dans le cas ou le QC tourne plusieurs jours...
##########################################################################################################
shift
start_qc_date=$9
echo "Start_Qc_Date = "$start_qc_date
echo '***************************************************************************************************'          
echo '________________________________________ LOOP_CORRECTION __________________________________________' 
echo '***************************************************************************************************'
shift
loop_correction=$9
echo "Loop_correction = "$loop_correction
echo '***************************************************************************************************'          
echo '________________________________________ STATION DATA SOURCE_______________________________________' 
echo '***************************************************************************************************'
shift
station_srce=$9
echo "Station_srce = "$station_srce
echo '***************************************************************************************************'          
echo '___________________________________________ BATTERY VOLT___________________________________________' 
echo '***************************************************************************************************'
shift
battery_volt=$9
echo "Battery_volt = "$battery_volt
echo '***************************************************************************************************'          
echo '________________________________________ BANDWIDTH LIMIT _________________________________________' 
echo '***************************************************************************************************'
shift
bandwidth=$9
echo "Bandwidth = "$bandwidth
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
dir_bin_base=$dir_station_work_base/bin
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
echo '***************************************************************************************************'
################################ BOUCLE *************
compteur=0 
while (( compteur < loop_correction ))  
do

 compteur=$(( compteur + 1 ))
 echo '***************************************************************************************************'
 echo "TRAITEMENT DES LISTES DE TACHES RECURSIVEMENT:"
 echo "compteur = "$compteur
################################ BOUCLE *************
 exec 5<>$tasks_file
 while read line <&5
 do
  line1=$line
  file_report_dir=$line1
  echo "file_report_dir = "$file_report_dir
  ### RECHERCHE DU CANAL CORRESPONDANT #############
  for chan in  $chans_list
  do
   chan_test=$( echo $file_report_dir | grep "$chan" )
   chan_test=" "$chan_test
   echo " chan = "$chan" / chan_test = "$chan_test
   if [[  $chan_test =~ "$chan.D" ]]  
   then 
    canal=$chan
    echo "Canal correspondant a la task_list = "$canal
   fi 
  done #==> for chan in  $chans_list
  ##############################################
  if [ "$canal" == "" ]
  then 
   kill $pid_script
  fi
  #############################################
  echo "***************************************************************************************************"
  day=$(date "+%j")
  year=$(date "+%Y")
  echo '****************************************************************************************************'
  echo "$network_name/$station_name/$chan en cours de traitement...  "$day.$year' / '$(date)
  echo '****************************************************************************************************'  
  echo "TRAITEMENT DES DONNEES  SUR LA PERIODE : "$start_date" a "$end_date" ..."
  echo '****************************************************************************************************'


  #********************************************************************************************************
  # I) Appel du script bash ae_retrieve_step1_v1.4.sh pour copier et preparer les donnees avant correction...*
  #********************************************************************************************************
   script="$dir_station_work_base/tools/ae_tools/ae_qc_retrieve_step1_v1.4.sh"
   if [ ! -s $script ]
   then
     echo "Error $script not found..."
     kill $pid_script
   fi 
   logout="$dir_station_work_base/tools/ae_tools/ae_qc_retrieve_step1_v1.4.log"
   echo "file_report_dir = "$file_report_dir
   command="$file_report_dir $dir_station_work_base $dir_buffer_base $network_name $station_name $canal "
   command="$command $start_qc_date $pid_script "
   echo "PREPARATION DU BUFFER CORRECTION ..."
   #DEBBUGAGE
   echo "COMMANDE SHELL = "
   echo "/bin/bash $script $command >& $logout"
   /bin/bash  $script $command >& $logout
   error=$?
   if [ $error != 0 ]
   then
    echo "Error $error while executing $script ...!"
    kill $pid_script
   fi
   echo '****************************************************************************************************'
 #######
   flag=1
 #* *******************************************************************************************************
 # II) Appel du script bash pour recuperer et corriger les donnees a partir la source...   *
 #*********************************************************************************************************
   if [ $station_srce == BALER14 ]
   then
    script="$dir_station_work_base/tools/ae_tools/ae_qc_baler14_step2_v1.75.sh"
    if [ ! -s $script ]
    then
     echo "Error $script not found..."
     kill $pid_script
    fi 
    logout="$dir_station_work_base/tools/ae_tools/ae_qc_baler14_step2_v1.75.log"  
    echo "file_report_dir = "$file_report_dir
    command="$file_report_dir  $station_ip $dir_station_work_base $dir_buffer_base $network_name  "
    command="$command $station_name $canal $start_qc_date $pid_script  $battery_test $battery_volt "
    echo "RECUPERATION ET CORRECTION DES FICHIERS..."
    #DEBBUGAGE
    echo "COMMANDE SHELL = "
    echo "/bin/bash $script $command >& $logout"
    /bin/bash $script $command >& $logout
    error=$?
    if [ $error != 0 ]
    then
     echo "Error $error while executing $script ...!"
     kill $pid_script
    fi
   echo '****************************************************************************************************'
   flag=0
  fi
  ###########################################################################"
  if [ $station_srce == SEISCOMP ]
  then
   script="$dir_station_work_base/tools/ae_tools/ae_qc_seiscomp_rsync_step2_v1.7.sh"
   if [ ! -s $script ]
   then
    echo "Error $script not found..."
    kill $pid_script
   fi 
   logout="$dir_station_work_base/tools/ae_tools/ae_qc_seiscomp_rsync_step2_v1.7.log"  
   echo "file_report_dir = "$file_report_dir
   command="$file_report_dir  $station_ip $dir_station_work_base $dir_buffer_base $network_name  "
   command="$command $station_name $canal $start_qc_date $pid_script  $battery_test $battery_volt $bandwidth"
   echo "RECUPERATION ET CORRECTION DES FICHIERS..."
   #DEBBUGAGE
   echo "COMMANDE SHELL = "
   echo "/bin/bash $script $command >& $logout"
   /bin/bash $script $command >& $logout
   error=$?
   if [ $error != 0 ]
   then
    echo "Error $error while executing $script ...!"
    kill $pid_script
   fi
   echo '****************************************************************************************************'
   flag=0
  fi
  ###########################################################################
  if [ $station_srce == SEISCOMPV2 ]
  then
   script="$dir_station_work_base/tools/ae_tools/ae_qc_seiscomp_step2_v1.95.sh"
   if [ ! -s $script ]
   then
    echo "Error $script not found..."
    kill $pid_script
   fi 
   logout="$dir_station_work_base/tools/ae_tools/ae_qc_seiscomp_step2_v1.95.log"  
   echo "file_report_dir = "$file_report_dir
   command="$file_report_dir  $station_ip $dir_station_work_base $dir_buffer_base $network_name  "
   command="$command $station_name $canal $start_qc_date $pid_script  $battery_test $battery_volt $bandwidth"
   echo "RECUPERATION ET CORRECTION DES FICHIERS..."
   #DEBBUGAGE
   echo "COMMANDE SHELL = "
   echo "/bin/bash $script $command >& $logout"
   /bin/bash $script $command >& $logout
   error=$?
   if [ $error != 0 ]
   then
    echo "Error $error while executing $script ...!"
    kill $pid_script
   fi
   echo '****************************************************************************************************'
   flag=0
  fi
  ###########################################################################"
  if [ $station_srce == BALER44 ]
  then
   script="$dir_station_work_base/tools/ae_tools/ae_qc_baler44_step2_v1.7.sh"
   if [ ! -s $script ]
   then
    echo "Error $script not found..."
    kill $pid_script
   fi 
   logout="$dir_station_work_base/tools/ae_tools/ae_qc_baler44_step2_v1.7.log"  
   echo "file_report_dir = "$file_report_dir
   command="$file_report_dir  $station_ip $dir_station_work_base $dir_buffer_base $network_name $station_name "
   command="$command $canal $start_qc_date $pid_script $battery_test $battery_volt $bandwidth"
   echo "RECUPERATION ET CORRECTION DES FICHIERS..."
   #DEBBUGAGE
   echo "COMMANDE SHELL = "
   echo "/bin/bash $script $command >& $logout"
   /bin/bash $script $command >& $logout
   error=$?
   if [ $error != 0 ]
   then
    echo "Error $error while executing $script ...!"
    kill $pid_script
   fi
   echo '****************************************************************************************************'
   flag=0
  fi
  ###########################################################################"
  if [ $station_srce == RINGBUFFER_NAQS ]
  then
   script="$dir_station_work_base/tools/ae_tools/ae_qc_nasqs_ovsmg_ringbuffer_step2_v1.5.sh"
   if [ ! -s $script ]
   then
    echo "Error $script not found..."
    kill $pid_script
   fi
   logout="$dir_station_work_base/tools/ae_tools/ae_qc_nasqs_ovsm_ringbuffer_step2_v1.5.log"
   echo "file_report_dir = "$file_report_dir
   command="$file_report_dir  $station_ip $dir_station_work_base $dir_buffer_base $network_name $station_name "
   command="$command $canal $start_qc_date $pid_script $arclink_server $arclink_user_email $tasks_day_limit"
   echo "RECUPERATION ET CORRECTION DES FICHIERS..."
   #DEBBUGAGE
   echo "COMMANDE SHELL = "
   echo "/bin/bash $script $command >& $logout"
   /bin/bash $script $command >& $logout
   error=$?
   if [ $error != 0 ]
   then
    echo "Error $error while executing $script ...!"
    kill $pid_script
   fi
   echo '****************************************************************************************************'
   flag=0
  fi
  ###########################################################################"
  if [ $station_srce == BALER44_HTTP ]
  then
   script="$dir_station_work_base/tools/ae_tools/ae_qc_baler44_step2_http_v1.75.sh"
   if [ ! -s $script ]
   then
    echo "Error $script not found..."
    kill $pid_script
   fi
   logout="$dir_station_work_base/tools/ae_tools/ae_qc_baler44_step2_http_v1.75.log"
   echo "file_report_dir = "$file_report_dir
   command="$file_report_dir  $station_ip $dir_station_work_base $dir_buffer_base $network_name $station_name "
   command="$command $canal $start_qc_date $pid_script $battery_test $battery_volt $bandwidth"
   echo "RECUPERATION ET CORRECTION DES FICHIERS..."
   #DEBBUGAGE
   echo "COMMANDE SHELL = "
   echo "/bin/bash $script $command >& $logout"
   /bin/bash $script $command >& $logout
   error=$?
   if [ $error != 0 ]
   then
    echo "Error $error while executing $script ...!"
    kill $pid_script
   fi
   echo '****************************************************************************************************'
   flag=0
  fi
  ########
  if [ $flag == 0 ]
  then
   echo "######################## MISE A JOUR DES FICHIERS CORRIGES DANS L'ARCHIVE ############################"
   # ###### REPRISE DES VALEURS YEAR_1  ET YEAR_2 CALCULEES  PAR LE SCRIPT $work_dir/tools/ae_tools/ae_qc_calcul_dates.sh ####
   year1=$( cat  $dir_station_work_base/tools/ae_tools/year1.txt )
   echo 'year1 = '$year1
   year2=$( cat  $dir_station_work_base/tools/ae_tools/year2.txt )
   echo 'year2 = '$year2
   rsync -rctv $dir_buffer_base/archive/$year1/$network_name/$station_name/$canal.D $dir_data_base/$year1/$network_name/$station_name/
   rsync -rctv $dir_buffer_base/archive/$year2/$network_name/$station_name/$canal.D $dir_data_base/$year2/$network_name/$station_name/
  fi
 ###################################################################################################################################
 # BUG CORRECT 23/04/2011
 #done  < $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt  #while read line-->boucle pour les listes de tâches....
 #done  < $tasks_file #while read line-->boucle pour les listes de tâches...
 done
 exec 5>&-
 ###################################################################################################################################
 if (( compteur < loop_correction ))
 then
  ################## ANALYSE DES CANAUX BROADBAND & ACCELERO.##########################
  # ETATS INTERMEDIAIRES DES FICHIERS APRES CORRECTION.....
  #####################################################################################
  rm -f $dir_station_work_base/tools/ae_tools/link_qc_tasks.*
  #####################################################################################
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
   ########
   day=$(date "+%j")
   year=$(date "+%Y")
   echo '****************************************************************************************************'
   echo "$network_name/$station_name/$chan en cours de traitement...  "$day.$year' / '$(date)
   echo '****************************************************************************************************'  
   echo "TRAITEMENT DES DONNEES  SUR LA PERIODE : "$start_date" a "$end_date" ..."
   echo '****************************************************************************************************'
   # ********************************************************************************************************
   # III) Appel du script bash ae_qc_report_v1.65.sh pour analyser et creer les rapports pour la correction  *
   # ETAT INTERMEDIAIRE DES DONNES -PAS D'ENVOI D'EMAILS !!                                                 *
   #*********************************************************************************************************
   #*********************************************************************************************************
   script="$dir_station_work_base/tools/ae_tools/ae_qc_report_v1.65.sh"
   if [ ! -s $script ]
   then
    echo "Error $script not found..."
    kill $pid_script
   fi 
   logout="$dir_station_work_base/tools/ae_tools/ae_qc_report_v1.65.log"
   command="$station_name $network_name $location_code $analyse_mode $start_date $end_date $server_name" 
   command="$command $dir_data_base $structure $chan $rate $dir_station_work_base" 
   command=$command" NONE NONE $start_qc_date"
   #DEBBUGAGE
   #command=$command" $emails $emails_title $start_qc_date"
   echo "COMMANDE SHELL = "
   echo "/bin/bash $script $command >& $logout"
   /bin/bash $script $command >& $logout
   error=$?
   if [ $error != 0 ]
   then
    echo "Error $error while executing $script ...!"
    kill $pid_script
   fi
   echo '****************************************************************************************************'
   mv -f $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt  "$dir_station_work_base/tools/ae_tools/link_qc_tasks.$chan"   
  done ##=> for chan in  $chans_list
  #### A PARTIR DE CE POINT NORMALEMENT POUR UNE STATION DONNEE, TOUS LES CANAUX DEMANDES ONT ETE RE-ANALYSES 
  cat $dir_station_work_base/tools/ae_tools/link_qc_tasks.* > $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt
  cat $dir_station_work_base/tools/ae_tools/link_qc_tasks.txt
  tasks_file=$dir_station_work_base/tools/ae_tools/link_qc_tasks.txt
 fi
done #==> while (( compteur < loop_correction )) 

###################################################################
#   ARCHIVER LE FICHIER LOG ...     (DERNIER CANAL)               #
#  Les repertoires ayant deja ete crees par ae_qc_report_v1.62.sh  #
###################################################################
echo '***************************************************************************************************'
echo '__________________________________LOGS DIRECTORIES_________________________________________________'
echo '***************************************************************************************************'
echo "###################################################################################################"
echo "*********************####### RECUPERATIONS DES VARIABLES DATES CALCULEES ....################******"
echo "####################################################################################################"
day1=$( cat $dir_station_work_base/tools/ae_tools/day1.txt)
echo 'day1 = '$day1
year1=$( cat  $dir_station_work_base/tools/ae_tools/year1.txt )
echo 'year1 = '$year1
day2=$( cat  $dir_station_work_base/tools/ae_tools/day2.txt )
echo 'day2 = '$day2
year2=$( cat  $dir_station_work_base/tools/ae_tools/year2.txt )
echo 'year2 = '$year2
year1_day1_to_year2_day2=$year1.$day1'_'$year2.$day2
echo "year1_day1_to_year2_day2 ="$year1_day1_to_year2_day2
####################################################
dir_logs_base="$dir_station_work_base/logs/$start_qc_day.$start_qc_year"
dir_logs_daily="$dir_logs_base/$network_name/$station_name/$chan.D/$year1_day1_to_year2_day2/"
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
