*! version 1.0 13/09/98; version 2.0 29/02/2020
program define bhatgauc1
version 11.0
*Author: Isaias H. Salgado Ugarte
*First written (version 5.0) 13/09/98
*Last review: 13/09/98; 29/02/2020
local varlist "req ex min(2) max(2)"
local if "opt"
local in "opt"
#delimit ;
local options "Gen(string) noGraph T1title(string) MSymbol(string) 
      Connect(string) *";
#delimit cr
parse "`*'"
parse "`varlist'", parse(" ")
quietly {
 tempvar logfreq laglog diflog
 gen `logfreq'=log(`1')
 gen `laglog'=`logfreq'[_n+1]
 gen `diflog'=`laglog'-`logfreq'

         tempvar touse
         gen byte `touse'=0
         replace `touse'=1 `in'
         regress `diflog' `2' if `touse'
         tempvar gauprob sumgaup sumsmfr en gaucom
         local width=`2'[2]-`2'[1]
         local mean=-1*e(b)[1,2]/e(b)[1,1]+`width'/2
         local sd=sqrt(`width'/(-1*e(b)[1,1]))
         }
 local b = e(b)[1,1]
 if `b' > 0 {
    di as res "The slope of selected points is > 0" 
    exit
	}
 else 
 di as text "R-square = " as res %5.4f e(r2) _skip(10) /*
            */as text "Adj R-square = " as res %5.4f e(r2_a)
 di as text "Mean = " as res %5.4f `mean'
 di as text "s.d. = " as res %5.4f `sd'
 quietly {
 gen `gauprob'=`width'*(1/(`sd'*sqrt(2*_pi)))*exp(-.5*((`2'-`mean')/`sd')^2)
 egen `sumgaup'=sum(`gauprob') if `touse'
 
 egen `sumsmfr'=sum(`1') if `touse'
 sort `touse'
 
 gen `en'=`sumsmfr'[_N]/`sumgaup'[_N]
 replace `en'=round(`en',1)
 noisily di as text "component size = " as res `en'
 gen `gaucom'=`en'*`gauprob'
 sort `2'
 }

    if "`graph'" ~= "nograph"  {
       if "`t1title'" ==""{
          local t1title "Gaussian component"
       }
       if "`msymbol'"=="" {
	   local msymbol "oh" 
	   }
       if "`connect'"=="" {
	   local connect "l" 
	   }
       scatter `1' `2', `options' /*
				*/ t1("`t1title'") /*
				*/ ms(`msymbol') c(`connect') /*
				*/|| mspline `gaucom' `2', bands(40) legend(off)
   } 
    if "`gen'"~="" {
       rename `gaucom' `gen'
       }

end
