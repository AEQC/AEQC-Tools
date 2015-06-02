#!/bin/bash
#***************************** TITLE ********************************************************************
# Script Bash3.2  Script to Generate annual QC graphics                                                 *
# Version 1.1  14 January 2015 AISSAOUI -IPGP Paris                                                     *
#********************************************************************************************************
eval_disp=1
echo "eval_disp="$eval_disp
echo "year_cfg="$year_cfg
#####
if [ $display_format == 1 ]
then
 cmd="python2.6 $dir_work_base/tools/ae_tools/ae_qc_ms_view_v1.1.1.py verbose1 test_freq $year_cfg $network_name 1 $station_name 6 HHE HHN HHZ HNE HNN HNZ 100 100 100 100 100 100  $qc_data_dir $dir_timeline_base/temp $dir_timeline_base/timeline $dir_timeline_base/report 9 '  ' HHE HHN HHZ HNE HNN HNZ '  '  '  '  >& $dir_timeline_base/logs/ae_qc_ms_view_v1.1.1.$station_name.log "
 echo "cmd="$cmd
 eval $cmd
 eval_disp=0
fi 
####
if [ $display_format == 2 ]
then
 cmd="python2.6 $dir_work_base/tools/ae_tools/ae_qc_ms_view_v1.1.1.py verbose1 test_freq $year_cfg $network_name 1 $station_name 6 HH1 HH2 HHZ HN1 HN2 HNZ 100 100 100 100 100 100  $qc_data_dir $dir_timeline_base/temp $dir_timeline_base/timeline $dir_timeline_base/report 9 '  ' HH1 HH2 HHZ HN1 HN2 HNZ '  '  '  '  >& $dir_timeline_base/logs/ae_qc_ms_view_v1.1.1.$station_name.log "
 echo "cmd="$cmd
 eval $cmd
 eval_disp=0
fi
####
if [ $display_format == 3 ]
then
 cmd="python2.6 $dir_work_base/tools/ae_tools/ae_qc_ms_view_v1.1.1.py verbose1 test_freq $year_cfg $network_name 1 $station_name 3 HHE HHN HHZ 100 100 100   $qc_data_dir  $dir_timeline_base/temp $dir_timeline_base/timeline $dir_timeline_base/report 6 '  ' HHE HHN HHZ '  '  '  '  >& $dir_timeline_base/logs/ae_qc_ms_view_v1.1.1.$station_name.log "
 echo "cmd="$cmd
 eval $cmd
 eval_disp=0
fi 
####
if [ $display_format == 4 ]
then
 cmd="python2.6 $dir_work_base/tools/ae_tools/ae_qc_ms_view_v1.1.1.py verbose1 test_freq $year_cfg $network_name 1 $station_name 3 HNE HNN HNZ 120 120 120  $qc_data_dir $dir_timeline_base/temp $dir_timeline_base/timeline $dir_timeline_base/report 6 '  ' HNE HNN HNZ '  '  '  '  >& $dir_timeline_base/logs/ae_qc_ms_view_v1.1.1.$station_name.log "
 echo "cmd="$cmd
 eval $cmd
 eval_disp=0
fi
echo "eval_disp="$eval_disp
if [ $eval_disp ==  1 ]
then
 echo "Error can't draw $station_name timelines, display format $display_format is not accepted !"
fi
####

