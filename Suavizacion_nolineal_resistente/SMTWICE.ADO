*! version 1.0.0 30/10/92   STB-11: sed7.2
program define smtwice
   version 3.0
* twice reroughing procedure for
* sm4253eh ado file.
* syntax "smtwice datavar smthvar finsmth"
   capture confirm variable `1'
   capture confirm variable `2'
   capture confirm new variable `3'
   if _rc~=0 {
          display "syntax smtwice datavar smthvar finsmth"
      exit}
   drop timendx
   gen rough=`1'-`2'
   sm4253eh rough smoorou
   gen `3'=`2'+smoorou
   drop smoorou rough `2' 
   gen finrough=`1'-`3'
   label variable `1' "ORIGINAL VALUES" 
   label variable `3' "SMOOTHED VALUES"
   label variable timendx "TIME INDEX"
   graph `1' `3' timendx, xlab ylab c(ls) ti(4253EH,TWICE NON LINEAR SMOOTHER)/*
      */ l2(SEQUENCE VALUES)
end
