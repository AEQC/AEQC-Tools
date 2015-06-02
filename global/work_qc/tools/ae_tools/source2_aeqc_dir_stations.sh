###########################################################################################
mkdir -p $station_dir/$dir_name >& /dev/null
result=$?
if [ $result == 1 ]
then
 echo "$station_dir/$dir_name directory is already exists !"
fi
###########################################################################################
if [ $result == 0 ]
then
 echo "$station_dir/$dir_name created !"
fi
###########################################################################################
if [ $result != 0 -o $result != 1 ]
then
 if [ "$arg" == "clean" -a  $dir_name != "tasks" -a $dir_name != "bin" -a $dir_name != "tools" ]
 then
  echo "clean files in the $station_dir/$dir_name/* directory"
  rm -fr $station_dir/$dir_name/*
  result1=$?
  if [ $result1  != 0 ]
  then
   echo "Can't clean files in the $station_dir/$dir_name/* directory"
   echo "Keep anyway the process ..."
  fi
 fi
 if [ $dir_name == bin ]
 then
  echo "Copy binary tools from /home/sysop/work_qc/bin/* to $station_dir/$dir_name/"
  cp -a ../../bin/* $station_dir/$dir_name/
  result1=$?
  if [ $result1  != 0 ]
  then
   echo "Problem while copy /home/sysop/work_qc/bin/* to $station_dir/$dir_name/! "
   echo "Stop the process, check your pwd : $(pwd)"
   kill $$
  fi
 fi #=> if [ $dir_name == bin ]
 if [ $dir_name == tools ]
 then
  echo "Copy bash tools from ./stations_ae_tools/* to  $station_dir/$dir_name/"
  cp -a ./stations_ae_tools/* $station_dir/$dir_name/
  rm -f $station_dir/$dir_name/ae_tools/*.txt >& /dev/null
  rm -f $station_dir/$dir_name/ae_tools/*.log >& /dev/null
  rm -f $station_dir/$dir_name/ae_tools/link_qc_tasks.??? >& /dev/null
  rm -f $station_dir/$dir_name/ae_tools/*~ >& /dev/null
  rm -f $station_dir/$dir_name/ae_tools/emails_list >& /dev/null
  rm -f $station_dir/$dir_name/ae_tools/list_chans >& /dev/null
  result1=$?
  if [ $result1  != 0 ]
  then
   echo "Problem while copy /home/sysop/work_qc/bin/* to $station_dir/$dir_name/"
   echo "Stop the process, check your pwd : $(pwd)"
   kill $$
  fi 
 fi #=> if [ $dir_name == tools ]
fi #=> if [ $result != 0 -o $result != 1 ] 
###########################################################################################
if [ $result != 0 -a $result != 1 ]
then
 echo "Problem for creating $station_dir/$dir_name directory ! "
 echo "Stop the process, check your pwd :  $(pwd) "
 kill $$
fi
###########################################################################################

