####################################################################################
mkdir -p $station_dir/$dir_name >& /dev/null
result=$?
if [ $result != 0 ]
then
 echo "Problem for creating $station_dir/$dir_name directory, stop the process !"
 kill $$
else
 echo "$station_dir/$dir_name created !"
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
  result1=$?
  if [ $result1  != 0 ]
  then
   echo "Problem while copy /home/sysop/work_qc/bin/* to $station_dir/$dir_name/"
   echo "Stop the process, check your pwd : $(pwd)"
   kill $$
  fi
 fi #=> if [ $dir_name == tools ]
fi #=> if [ $result != 0 ]
####################################################################################
