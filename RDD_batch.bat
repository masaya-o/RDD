@echo off
title Batch file to execute RDD replication assignment.

cd "C:\Users\omasa\Documents\GitHub\RDD\input"
"C:\Program Files\Stata16\StataSE-64.exe" /e do "rdd.do"


cd "C:\Users\omasa\Documents\GitHub\RDD\writing"
"C:\Program Files\R\R-4.0.3\bin\i386\Rscript.exe" "RDDexec.R"

pause