#!/bin/bash
echo "Launch the sysop crontab every X seconds ... !"
echo "Temporarly solution for waiting to configure the system crontab of the user sysop"
#### CREATE A LOOP 
while [ 1 != 0 ]
do
/bin/bash /home/sysop/work_qc/tools/ae_tools/kill_cronqc_process.sh
#### ALL STEPS
/bin/bash /home/sysop/work_qc/tools/ae_tools/cron_qc_ae_ovsmg_v2.5.sh /home/sysop/work_qc ALL >& /home/sysop/work_qc/tools/ae_tools/cron_qc_ae_ovsmg_v2.5.log &
#### ONLY STEP MERGE -STEP 4
#/bin/bash /home/sysop/work_qc/tools/ae_tools/cron_qc_ae_ovsmg_v2.5.sh /home/sysop/work_qc 4  >& /home/sysop/work_qc/tools/ae_tools/cron_qc_ae_ovsmg_v2.5.log &
#### ONLY STEP QC + RETRIEVING -STEP 7
#/bin/bash /home/sysop/work_qc/tools/ae_tools/cron_qc_ae_ovsmg_v2.5.sh /home/sysop/work_qc 7  >& /home/sysop/work_qc/tools/ae_tools/cron_qc_ae_ovsmg_v2.5.log &
 dtime=0
 time1=$SECONDS
 ##### EVERY 2 DAYS - 48H
 while (( 10#$dtime < 172800 ))
 do
  time2=$SECONDS
  dtime=$( echo "$time2  - $time1" | bc ) 
 done
done
##########
