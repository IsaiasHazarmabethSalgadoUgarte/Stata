*! version 1.10 93/04/12; 26/03/2020                 STB-18: sg23
program define gaussgen1
 version 11.0
 capture confirm existence `1'
 capture confirm number `2' `3' `4'
 capture confirm new variable `5'
 if _rc~=0 {
    di "syntax: gaussgen midpoivar meanval sdval freqval comgaufre" 
    exit
	}
 quietly {
 tempvar midpo mean sd freqval width gauprob gaucom
 gen `midpo'=`1'
 gen `mean'=`2'
 gen `sd'=`3'
 gen `freqval'=`4' 
 gen `width'= `midpo'[2]-`midpo'[1]
 gen `gauprob'=`width'*(1/(`sd'*sqrt(2*_pi)))*exp(-.5*((`midpo'-`mean')/`sd')^2)
 gen `gaucom'=`freqval'*`gauprob'
 }
 rename `gaucom' `5'
end
