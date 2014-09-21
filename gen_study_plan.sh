#!/bin/bash
# $1 must be the path to a .run file with the following structure
# i.e. my_study_plan.run :
#	model study_plan.mod; 
#	data <name of the data file>.dat;
#	option solver lpsolve;
#	solve;
#	display x;
#
# At the end the final study plan is saved into the file MyStudyPlan.txt
# in the current folder.
#
ampl $1 > temp.txt
python2.7 GenerateStudyPlan.py > MyStudyPlan.txt
rm temp.txt
