*! sm4253eh version 2.0.0 29/10/92   STB-11 sed7.2
program define sm4253eh
   version 3.0
   * running-medians of span 4, 2, 5, 3 and hanning 
   * compound smoother
   * syntax "sm4253eh datavar smthvar"
   capture confirm variable `1'
   capture confirm new variable `2'
   if _rc~=0 {
       display "syntax sm4253eh datavar smthvar" 
       exit}
   * first, running-medians of span 4
   quietly {
   generate hvsum=`1'[_n-2]+`1'[_n-1]+`1'+`1'[_n+1]
   generate hvmax=max(`1'[_n-2],`1'[_n-1],`1',`1'[_n+1])
   generate hvmin=min(`1'[_n-2],`1'[_n-1],`1',`1'[_n+1])
   generate hvalue=(hvsum-hvmax-hvmin)/2
   generate `2'=cond(_n==1,`1',(hvalue))
   replace `2'=(`1'[_n-1]+`1')/2 if _n==2
   replace `2'=(`1'[_n-1]+`1')/2 if _n==_N
   replace `2'=`1'[_N] if _n==_N+1
     drop hvsum hvmin hvmax hvalue
   
   * now, running-medians of span 2
   generate tempo=`2'
   replace `2'=(tempo+tempo[_n+1])/2
   replace `2'=`1' if _n==1 | _n==_N
   generate tempoa=`2'
   drop tempo

   * running-medians of span 5 smoother
   * new algoritm
    generate count=_n^0+2
    generate tempo5=`2'
    generate index5=_n+1
    while count<_N-1 {
       summ tempo5 if _n<6, detail
       replace `2'=_result(10) if _n==count
       replace tempo5=tempo5[index5]
       replace count=count+1}
    drop tempo5 count index5

   * median of 3 on secuence extremes (on tempoa that is a
   * copy of `2' after 42
    generate hvsum=tempoa[_n-1]+tempoa+tempoa[_n+1]
    generate hvmax=max(tempoa[_n-1],tempoa,tempoa[_n+1])
    generate hvmin=min(tempoa[_n-1],tempoa,tempoa[_n+1])
    generate hvalue=hvsum-hvmax-hvmin
    replace `2'=hvalue[2] if _n==2
    replace `2'=hvalue[_N-1] if _n==_N-1
    replace `2'=tempoa[1] if _n==1
    replace `2'=tempoa[_N] if _n==_N
    generate tempob=`2'
    drop tempoa hvsum hvmin hvmax hvalue

    
   * running-medians of span 3 smoother
   generate hvsum=tempob[_n-1]+tempob+tempob[_n+1]
   generate hvmax=max(tempob[_n-1],tempob,tempob[_n+1])
   generate hvmin=min(tempob[_n-1],tempob,tempob[_n+1])
   generate hvalue=hvsum-hvmax-hvmin
   replace `2'=cond(_n==1|_n==_N,tempob,(hvalue))
   drop tempob hvsum hvmin hvmax hvalue
  
   * endpoint adjusting
   generate yxtpol1=3*`2'[_n-2]-(2*`2'[_n-1])
   generate yxtpol2=3*`2'[_n-1]-(2*`2'[_n-2])
   generate lowyxtp=yxtpol1[4]
   generate hiyxtp=yxtpol2[_N]
   generate lowsum=lowyxtp+`2'[1]+`2'[2]
   generate lowmin=min(lowyxtp,`2'[1],`2'[2])
   generate lowmax=max(lowyxtp,`2'[1],`2'[2])
   generate lowend=lowsum-lowmin-lowmax 
   generate hisum=hiyxtp+`2'[_N]+`2'[_N-1]
   generate himin=min(hiyxtp,`2'[_N],`2'[_N-1])
   generate himax=max(hiyxtp,`2'[_N],`2'[_N-1])
   generate hiend=hisum-himin-himax  
   replace `2'=lowend if _n==1
   replace `2'=hiend if _n==_N
   drop yxtpol1 yxtpol2 lowyxtp hiyxtp lowsum lowmin lowmax lowend /*
   */ hisum  himin himax hiend

   * hanning
   generate tempoc=`2'
   replace `2'=cond(_n==1|_n==_N,tempoc,((tempoc[_n-1]/4)+/*
               */(tempoc/2)+(tempoc[_n+1]/4)))
   drop tempoc tempo 
   label variable `2' "4253eh resistant smooth"
   generate timendx=_n
  }
   
end
