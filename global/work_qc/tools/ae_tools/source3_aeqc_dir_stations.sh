#########################################################################
if [ ! -d $dir_name ]
then
 echo "$dir_name doesn't exist !"
 mkdir -p $dir_name >& /dev/null
 result=$?
 if [ $result != 0 ]
 then
  echo "Problem for creating $dir_name directory, stop the process !"
  kill $$
 else
  echo "$dir_name created !"
 fi
else
 echo "$dir_name already exist..."
fi 
#########################################################################
