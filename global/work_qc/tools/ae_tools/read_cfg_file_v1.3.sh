 #!/bin/bash
 #***************************** TITLE ********************************************************************
 # Script Bash3.2 read_cfg_file_v1.3.sh                 OVSMG  Data Quality Control                      *
 # Version 1.3  8 January 2015 AISSAOUI -IPGP Paris                                                      *
 #********************************************************************************************************
 ############### START READ FIELD OF CONFIGURATION STATIONS FILES ##############
 echo $line_cfg0
 if [[ $line_cfg0 =~ "#_NEW_WORK_STATION_#" ]]
 then
  echo "New station find in this configuration :"
 else
  echo "Configuration file error, found field = " $line_cfg0" but "#_NEW_WORK_STATION_#" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 #######
 read line_cfg1 <&3
 field_type=$(echo $line_cfg1 | awk '{print $2}' )
 if [ $field_type == MAKE_QC ]
 then
  station_status=$(echo $line_cfg1 | awk '{print $1}' )
  echo "station_status="$station_status
  if [ $station_status != DISABLE -a $station_status != ENABLE ]
  then   
   echo "Error in station status ! Options are DISABLE OR ENABLE."
   echo "Disable or enable the QC  procedures on the  data of the station."
   echo "line_cfg1=""$line_cfg1"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg1=""$line_cfg1"
  echo "Configuration file error, found field = "$field_type" but "MAKE_QC" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 #######
 read line_cfg2 <&3
 field_type1=$(echo $line_cfg2 | awk '{print $2}' )
 field_type2=$(echo $line_cfg2 | awk '{print $3}' )
 if [ $field_type1 == STATION -a $field_type2 == "(WORK_STATION_DIR)" ]
 then
  station_name=$(echo $line_cfg2 | awk '{print $1}' )
  echo "station_name="$station_name
 else
  echo "line_cfg2=""$line_cfg2"
  echo "Configuration file error, found field = "$field_type1" but "STATION" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg3 <&3
 field_type=$(echo $line_cfg3 | awk '{print $2}' )
 if [ $field_type == NETWORK ]
 then 
  network_name=$(echo $line_cfg3 | awk '{print $1}' )
  echo "network_name="$network_name
 else
  echo "line_cfg3=""$line_cfg3"
  echo "Configuration file error, found field = "$field_type" but "NETWORK" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg4 <&3
 field_type=$(echo $line_cfg4 | awk '{print $2}' )
 if [ $field_type == LOCATION ]
 then
  location_code=$(echo $line_cfg4 | awk '{print $1}' )
  echo "location_code="$location_code
 else
  echo "line_cfg4=""$line_cfg4"
  echo "Configuration file error, found field = "$field_type" but "LOCATION" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg5 <&3
 field_type=$(echo $line_cfg5 | awk '{print $2}' )
 if [ $field_type == IP_ADDRESS ]
 then
  station_ip=$(echo $line_cfg5 | awk '{print $1}' )
  echo "station_ip="$station_ip
 else
  echo "line_cfg5=""$line_cfg5"
  echo "Configuration file error, found field = "$field_type" but "IP_ADDRESS" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########"
 read line_cfg6 <&3
 field_type=$(echo $line_cfg6 | awk '{print $2}' )
 if [ $field_type == LIMIT_BANDWIDTH ]
 then
  bandwidth=$(echo $line_cfg6 | awk '{print $1}' )
  echo "bandwidth="$bandwidth
 else
  echo "line_cfg6=""$line_cfg6"
  echo "Configuration file error, found field = "$field_type" but "LIMIT_BANDWIDTH" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg7 <&3  
 field_type=$(echo $line_cfg7 | awk '{print $2}' )
 if [ $field_type == SOURCE_DATA ]
 then
  station_srce=$(echo $line_cfg7 | awk '{print $1}' )
  echo "station_srce="$station_srce
  if [ "$station_srce" != BALER44 -a "$station_srce" != SEISCOMPV2 -a "$station_srce" != BALER14 -a "$station_srce" != BALER44_HTTP -a "$station_srce" != RINGBUFFER_NAQS ]
  then
   echo "Error in configuration file, unknow source station mode !"
   echo "Options are BALER14, BALER44, BALER44_HTTP or SEISCOMPV2 (PCFOX) or RINGBUFFER_NAQS "
   echo "line_cfg7=""$line_cfg7"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg7=""$line_cfg7"
  echo "Configuration file error, found field = "$field_type" but "SOURCE_DATA" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg8 <&3
 field_type=$(echo $line_cfg8 | awk '{print $2}' )
 if [ $field_type == ARCLINK_SERVER ]
 then
  arclink_server=$(echo $line_cfg8 | awk '{print $1}' )
  echo "arclink_server="$arclink_server
 else
  echo "line_cfg8=""$line_cfg8"
  echo "Configuration file error, found field = "$field_type" but "ARCLINK_SERVER" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg9 <&3
 field_type=$(echo $line_cfg9 | awk '{print $2}' )
 if [ $field_type == ARCLINK_USER_EMAIL ]
 then
  arclink_user_email=$(echo $line_cfg9 | awk '{print $1}' )
  echo "arclink_user_email="$arclink_user_email
 else
  echo "line_cfg9=""$line_cfg9"
  echo "Configuration file error, found field = "$field_type" but "ARCLINK_USER_EMAIL" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg10 <&3
 field_type=$(echo $line_cfg10 | awk '{print $2}' )
 if [ $field_type == ARCHIVE_DIRECTORY_STRUCTURE ]
 then
  structure=$(echo $line_cfg10 | awk '{print $1}' )
  echo "structure="$structure
  if [ "$structure" != SDS ]
  then
   echo "Error in configuration file, unknow structure!"
   echo "At this time support only SDS structure "
   echo "line_cfg10=""$line_cfg10"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg10=""$line_cfg10"
  echo "Configuration file error, found field = "$field_type" but "ARCHIVE_DIRECTORY_STRUCTURE" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi 
 ########
 read line_cfg11 <&3
 field_type=$(echo $line_cfg11 | awk '{print $2}' )
 if [ $field_type == AUTO_RETRIEVING_CORRECTION ]
 then
  auto_retriev_correction=$(echo $line_cfg11 | awk '{print $1}' )
  echo "auto_retriev_correction="$auto_retriev_correction
  if [ "$auto_retriev_correction" != yes -a "$auto_retriev_correction" != no ]
  then
   echo "Error in configuration file, unknow correction mode !"
   echo "Options are yes or no for retrieving gaps and automatic archive correction "
   echo "line_cfg11=""$line_cfg11"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg11=""$line_cfg11"
  echo "Configuration file error, found field = "$field_type" but "AUTO_RETRIEVING_CORRECTION" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi 
########
 read line_cfg12 <&3
 field_type=$(echo $line_cfg12 | awk '{print $2}' )
 if [ $field_type == TASKS_DAY_LIMIT ]
 then
  tasks_day_limit=$(echo $line_cfg12 | awk '{print $1}' )
  echo "tasks_day_limit="$tasks_day_limit
 else
  echo "line_cfg12=""$line_cfg12"
  echo "Configuration file error, found field = "$field_type" but "TASKS_DAY_LIMIT" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
########
 read line_cfg13 <&3
 field_type=$(echo $line_cfg13 | awk '{print $2}' )
 if [ $field_type == LOOP_CORRECTION ]
 then
  loop_correction=$(echo $line_cfg13 | awk '{print $1}' )
  echo "loop_correction="$loop_correction
  if [ "$loop_correction" != 1 -a "$loop_correction" != 2  -a "$loop_correction" != 3 ]
  then
   echo "Error in configuration file !"
   echo "Options are 1, 2 or 3 for the number of loops correction"
   echo "line_cfg13=""$line_cfg13"
   echo "Exit and stop process..."
   kill $$ 
  fi
 else
  echo "line_cfg13=""$line_cfg13"
  echo "Configuration file error, found field = "$field_type" but "LOOP_CORRECTION" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg14 <&3
 field_type=$(echo $line_cfg14 | awk '{print $2}' )
 if [ $field_type == RETRIEVING_MOD ]
 then
  retrieve_mode=$(echo $line_cfg14 | awk '{print $1}' )
  echo "retrieve_mode="$retrieve_mode
  if [ "$retrieve_mode" != SER -a "$retrieve_mode" != PAR ]
  then
   echo "Error in configuration file, unknow retrieve mode !"
   echo "Options are PAR (paralell) or SER (serial)"
   echo "line_cfg14=""$line_cfg14"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg14=""$line_cfg14"
  echo "Configuration file error, found field = "$field_type" but "RETRIEVING_MOD" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg15 <&3
 field_type=$(echo $line_cfg15 | awk '{print $2}' )
 if [ $field_type ==  TASKS_LIST_MODE ]
 then
  task_list_mode=$(echo $line_cfg15 | awk '{print $1}' )
  echo "task_list_mode="$task_list_mode
  if [ "$task_list_mode" != KEEP -a "$task_list_mode" != RESET ]
  then
   echo "Error in configuration file, unknow task list mode !"
   echo "Options are KEEP or RESET "
   echo "line_cfg15=""$line_cfg15"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg15=""$line_cfg15"
  echo "Configuration file error, found field = "$field_type" but "TASKS_LIST_MODE" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg16 <&3
 field_type=$(echo $line_cfg16 | awk '{print $2}' )
 if [ $field_type ==  TEST_BATTERY ]
 then
  battery_test=$(echo $line_cfg16 | awk '{print $1}' )
  echo "battery_test="$battery_test
  if [ "$battery_test" != yes -a "$battery_test" != no ]
  then
   echo "Error in configuration file, unknow battery test mode !"
   echo "Options are yes or no for testing battery voltage "
   echo "line_cfg16=""$line_cfg16"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg16=""$line_cfg16"
  echo "Configuration file error, found field = "$field_type" but "TEST_BATTERY" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg17 <&3
 field_type=$(echo $line_cfg17 | awk '{print $2}' )
 if [ $field_type == VOLT ]
 then
  battery_volt=$(echo $line_cfg17 | awk '{print $1}' )
  echo "battery volt="$battery_volt
 else
  echo "line_cfg17=""$line_cfg17"
  echo "Configuration file error, found field = "$field_type" but "VOLT" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg18 <&3
 field_type=$(echo $line_cfg18 | awk '{print $2}' )
 if [ $field_type == MODE_DATE ]
 then
  analyse_mode=$(echo $line_cfg18 | awk '{print $1}' )
  echo "analyse_Mode="$analyse_mode
  if [ "$analyse_mode" != M0 -a "$analyse_mode" != M1  -a "$analyse_mode" != M2 ]
  then
   echo "Error in configuration file, unknow analyse date mode !"
   echo "Options are M0,M1 or M2"
   echo "line_cfg18=""$line_cfg18"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg18=""$line_cfg18"
  echo "Configuration file error, found field = "$field_type" but "MODE_DATE" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg19 <&3
 field_type=$(echo $line_cfg19 | awk '{print $2}' )
 if [ $field_type ==  START_DATE ]
 then
  start_date=$(echo $line_cfg19 | awk '{print $1}' )
  echo "start_date="$start_date
 else
  echo "line_cfg18=""$line_cfg18"
  echo "Configuration file error, found field = "$field_type" but "START_DATE" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########"
 read line_cfg20 <&3
 field_type=$(echo $line_cfg20 | awk '{print $2}' )
 if [ $field_type ==  END_DATE ]
 then
  end_date=$(echo $line_cfg20 | awk '{print $1}' )
  echo "end_date="$end_date
 else
  echo "line_cfg20=""$line_cfg20"
  echo "Configuration file error, found field = "$field_type" but "END_DATE" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg21 <&3
 field_type=$(echo $line_cfg21 | awk '{print $2}' )
 if [ $field_type ==  CHANNELS ]
 then
  list_chans=$(echo $line_cfg21 | awk '{print $1}' )
  echo "list_chan="$list_chans
  echo $list_chans > $dir_work_base/tools/ae_tools/list_chans.$station_name 
  champ=$( sed "s/_/ /g" $dir_work_base/tools/ae_tools/list_chans.$station_name  )
  chans_list=$champ
  echo "chans_list="$chans_list
  echo $(pwd)
  #kill $$
 else
  echo "line_cfg21=""$line_cfg21"
  echo "Configuration file error, found field = "$field_type" but "CHANNELS" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg22 <&3
 field_type=$(echo $line_cfg22 | awk '{print $2}' )
 if [ $field_type ==  RATES ]
 then
  list_freqs=$(echo $line_cfg22 | awk '{print $1}' )
  echo "list_freqs="$list_freqs
  echo $list_freqs > $dir_work_base/tools/ae_tools/list_freqs.$station_name
  champ=$( sed "s/_/ /g" $dir_work_base/tools/ae_tools/list_freqs.$station_name  )
  freqs_list=$champ
  echo "freqs_list="$freqs_list
 else
  echo "line_cfg22=""$line_cfg22"
  echo "Configuration file error, found field = "$field_type" but "RATES" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg23 <&3
 field_type=$(echo $line_cfg23 | awk '{print $2}' )
 if [ $field_type ==  EMAILS ]
 then
  emails=$(echo $line_cfg23 | awk '{print $1}' )
  echo "emails=""$emails"
 else
  echo "line_cfg23=""$line_cfg23"
  echo "Configuration file error, found field = "$field_type" but "EMAILS" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg24 <&3
 field_type1=$(echo $line_cfg24 | awk '{print $2}' )
 field_type2=$(echo $line_cfg24 | awk '{print $3}' )
 if [ $field_type1 ==  EMAILS_TITLE  -a $field_type2 ==  -NO_SPACE! ]
 then
  emails_title=$(echo $line_cfg24 | awk '{print $1}' )
  echo "emails_title="$emails_title
 else
  echo "line_cfg24=""$line_cfg24"
  echo "Configuration file error, found field = "$field_type1" but "EMAILS_TITLE" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg25 <&3
 field_type=$(echo $line_cfg25 | awk '{print $2}' )
 if [ $field_type ==  WORK_STATION_DIR ] 
 then
  dir_station_work_base=$(echo $line_cfg25 | awk '{print $1}' )
  echo "dir_station_work_base="$dir_station_work_base
 else
  echo "line_cfg25=""$line_cfg25"
  echo "Configuration file error, found field = "$field_type" but "WORK_STATION_DIR" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg26 <&3
 field_type=$(echo $line_cfg26 | awk '{print $2}' )
 if [ $field_type ==   WORK_ARCHIVE_DIR ] 
 then
  dir_data_base=$(echo $line_cfg26 | awk '{print $1}' )
  echo "dir_data_base="$dir_data_base
 else
  echo "line_cfg26""$line_cfg26"
  echo "Configuration file error, found field = "$field_type" but "WORK_ARCHIVE_DIR" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg27 <&3
 field_type=$(echo $line_cfg27 | awk '{print $2}' )
 if [ $field_type == WORK_BUFFER_DIR ] 
 then
  dir_buffer_base=$(echo $line_cfg27 | awk '{print $1}' )
  echo "dir_buffer_base="$dir_buffer_base
 else
  echo "line_cfg27""$line_cfg27"
  echo "Configuration file error, found field = "$field_type" but "WORK_BUFFER_DIR" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg28 <&3
 field_type=$(echo $line_cfg28 | awk '{print $2}' )
 if [ $field_type == WORK_TIMELINE_DIR ] 
 then
  dir_timeline_base=$(echo $line_cfg28 | awk '{print $1}' )
  echo "dir_timeline_base="$dir_timeline_base
 else
  echo "line_cfg28""$line_cfg28"
  echo "Configuration file error, found field = "$field_type" but "WORK_TIMELINE_DIR" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg29 <&3
 field_type=$(echo $line_cfg29 | awk '{print $2}' )
 if [ $field_type == CREATE_YEAR_TIMELINE ] 
 then
  year_timeline=$(echo $line_cfg29 | awk '{print $1}' )
  echo "year_timeline="$year_timeline
  if [ "$year_timeline" != yes -a "$year_timeline" != no ]
  then
   echo "Error in configuration file !"
   echo "Options are yes or no for creating year timeline "
   echo "line_cfg29=""$line_cfg29"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg29""$line_cfg29"
  echo "Configuration file error, found field = "$field_type" but "CREATE_YEAR_TIMELINE" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg30 <&3
 field_type=$(echo $line_cfg30 | awk '{print $2}' )
 if [ $field_type == CREATE_PREV_YEAR_TIMELINE ]
 then 
  prev_year_timeline=$(echo $line_cfg30 | awk '{print $1}' )
  echo "prev_year_timeline="$prev_year_timeline
  if [ "$prev_year_timeline" != yes -a "$prev_year_timeline" != no ]
  then
   echo "Error in configuration file !"
   echo "Options are yes or no for creating timeline for the previous year "
   echo "line_cfg30=""$line_cfg30"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg30""$line_cfg30"
  echo "Configuration file error, found field = "$field_type" but "CREATE_PREV_YEAR_TIMELINE" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 #########
 read line_cfg31 <&3
 field_type=$(echo $line_cfg31 | awk '{print $2}' )
 if [ $field_type == DISPLAY_FORMAT ]
 then 
  display_format=$(echo $line_cfg31 | awk '{print $1}' )
  echo "display_format="$display_format 
 else
  echo "line_cfg31""$line_cfg31"
  echo "Configuration file error, found field = "$field_type" but "DISPLAY_FORMA" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
########
 read line_cfg32 <&3
 field_type=$(echo $line_cfg32 | awk '{print $2}' )
 if [ $field_type == WORK_DATA_SERVER ]
 then 
  work_data_server=$(echo $line_cfg32 | awk '{print $1}' )
  echo "work_data_server="$work_data_server
  string=${work_data_server##*@}
  echo "string="$string
  if [ "$string" != "localhost" ]
  then
   echo "Error in configuration file !"
   echo "work directories of the QC scripts must be in local server"
   echo "line_cfg32=""$line_cfg32"
   echo "Exit and stop process..."
   kill $$
  fi
 else
  echo "line_cfg32""$line_cfg32"
  echo "Configuration file error, found field = "$field_type" but "WORK_DATA_SERVER" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg33 <&3
 field_type=$(echo $line_cfg33 | awk '{print $2}' )
 if [ $field_type == RAW_DATA_DIR ]
 then 
  raw_data_dir=$(echo $line_cfg33 | awk '{print $1}' )
  echo "raw_data_dir="$raw_data_dir
 else
  echo "line_cfg33""$line_cfg33"
  echo "Configuration file error, found field = "$field_type" but "RAW_DATA_DIR" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 #######
 read line_cfg34 <&3
 field_type=$(echo $line_cfg34 | awk '{print $2}' )
 if [ $field_type == RAW_DATA_SERVER ]
 then 
  raw_data_server=$(echo $line_cfg34 | awk '{print $1}' )
  echo "raw_data_server="$raw_data_server
 else
  echo "line_cfg34""$line_cfg34"
  echo "Configuration file error, found field = "$field_type" but "RAW_DATA_SERVER" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg35 <&3
 field_type=$(echo $line_cfg35 | awk '{print $2}' )
 if [ $field_type == QC_DATA_DIR ]
 then 
  qc_data_dir=$(echo $line_cfg35 | awk '{print $1}' )
  echo "qc_data_dir="$qc_data_dir
 else
  echo "line_cfg35""$line_cfg35"
  echo "Configuration file error, found field = "$field_type" but "QC_DATA_DIR" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg36 <&3
 field_type=$(echo $line_cfg36 | awk '{print $2}' )
 if [ $field_type == QC_DATA_SERVER ]
 then
  qc_data_server=$(echo $line_cfg36 | awk '{print $1}' )
  echo "qc_data_server="$qc_data_server
 else
  echo "line_cfg36""$line_cfg36"
  echo "Configuration file error, found field = "$field_type" but "QC_DATA_SERVER" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ########
 read line_cfg37 <&3
 field_type=$(echo $line_cfg37 | awk '{print $2}' )
 if [ $field_type == BACK_LOGS_DAYS_TO_KEEP ]
 then
  back_logs_days_to_keep=$(echo $line_cfg37 | awk '{print $1}' )
  echo "back_logs_days_to_keep="$back_logs_days_to_keep
 else
  echo "line_cfg37""$line_cfg37"
  echo "Configuration file error, found field = "$field_type" but "BACK_LOGS_DAYS_TO_KEEP" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 #######
 read line_cfg38 <&3
 field_type=$(echo $line_cfg38 | awk '{print $2}' )
 if [ $field_type == MERGE_DIR ]
 then
  merge_dir=$(echo $line_cfg38 | awk '{print $1}' )
  echo "merge_dir="$merge_dir
 else 
  echo "line_cfg38""$line_cfg38"
  echo "Configuration file error, found field = "$field_type" but "MERGE_DIR" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 #######
 read line_cfg38 <&3
 field_type=$(echo $line_cfg38 | awk '{print $2}' )
 if [ $field_type == FIXRESIDUAL_OVERLAPS ]
 then
  fixresidual_overlaps=$(echo $line_cfg38 | awk '{print $1}' )
  echo "fixresidual_overlaps="$fixresidual_overlaps
  re='^[0-9]+$'
  if ! [[ $fixresidual_overlaps =~ $re ]] 
  then
   echo "error: Not a number" >&2; exit 1
  fi
 else 
  echo "line_cfg38""$line_cfg38"
  echo "Configuration file error, found field = "$field_type" but "FIXRESIDUAL_OVERLAPS" is expected at this ligne !!"
  echo "Exit and stop process..."
  kill $$
 fi
 ############### END READ FIELD OF CONFIGURATION STATIONS FILES ################
