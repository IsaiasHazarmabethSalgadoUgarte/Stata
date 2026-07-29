*! version 2.00 94/11/11; 2020/07/15
program define warpdenpy
  version 16.0
*First writen: 94/08/01; Last revised 95/03/10
*Authors: Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi
*Updated version by: Isaias H. Salgado-Ugarte & V. Mitsui 
*Saito-Quezada
*This program calculates Haerdle-Scott warping density estimation
*(step function) using a Python script which utilizes modified 
* algorithms from:
* Haerdle, W. (1991) "Smoothing Techniques with Implementations in S", 
* Springer-Verlag Series in Statistics, New York
* Scott (1992) "Multivariate Density Estimation. Theory, Practice, 
* and Visualization, John Wiley & Sons, New York.
* Salgado-Ugarte, I.H. 2002. Suavización no paramétrica para análisis 
* de datos. DGAPA & FES Zaragoza, UNAM. Mexico

local varlist "req ex min(1) max(1)"
local if "opt"
local in "opt"
#delimit ;
local options "Bwidth(real 0) Mval(integer 0) Kercode(integer 0) STep 
        noSort NUModes MOdes NUAMOdes NPoints AMOdes Gen(string) noGraph 
		T1title(string) mSymbol(string) Connect(string) *";
#delimit cr
parse "`*'"
parse "`varlist'", parse(" ")
quietly {
preserve
if "`gen'"~="" {
   tempfile _data
   save `_data'
   }

tempvar xvar
gen `xvar'=`1' `if' `in'
drop if `xvar'==.
if `xvar'[1]==. {
   di in red "no observations"
   exit
   }
keep `xvar'
if "`nosort'"=="" { 
	sort `xvar'
	}
outfile `xvar' using _data2, replace
local hval=`bwidth'
local mva=`mval'
local kco=`kercode'
tempvar hv mv kc
gen `hv'=`hval'
gen `mv'=`mva'
gen `kc'=`kco'
if `hv'==0 {
     di in red "you must provide the bandwidth"
     exit
	 }
if `mv'==0 {
     di in red "you must provide the number of shifted histograms"
     exit
	 }
if `kc'==0 {
     di in red "you must provide the kernel code"
     exit
	 }
if `kc'>7 {
     di in red "invalid choice of kernel"
     exit
	 } 
keep `hv' `mv' `kc'
drop if _n>1
set obs 1
outfile using _inpval, replace
drop _all
*!warpingc
python script warping.py
!del _data2.raw
!del _inpval.raw
tempvar num midpoi densi inter lowcut
*infile `densi' `midpoi' using resfile.
import delimited `num' `densi' `midpoi' using resfile.csv
!del resfile.csv
if "`graph'" ~= "nograph"  {
   if "`t1title'" ==""{
      if "`step'"~="" {
         local t1title "WARPing density (step version)"
         local t1title "`t1title', bw = `hval', M = `mva', Ker = `kco'"
         }
      else {
         local t1title "WARPing density (polygon version)"
         local t1title "`t1title', bw = `hval', M = `mva', Ker = `kco'"
         }           
      }
   if "`msymbol'"=="" { 
   	local msymbol "i" 
	}
   if "`connect'"=="" { 
      if "`step'"~="" {
	  	local connect "J" 
		}
      else {
	  	local connect "l" 
		}
   }
   if "`step'"~="" {
     gen `inter'=`midpoi'[2]-`midpoi'[1]
     gen `lowcut'=`midpoi'-(`inter'/2)
     label variable `densi' "Density"
     label variable `lowcut' "Lower cutoff"
     scatter `densi' `lowcut',  `options' /*
				*/ t1("`t1title'") /*
				*/ ms(`msymbol') c(`connect') 
   }
   else {
      label variable `densi' "Density"
      label variable `midpoi' "Midpoints"
      scatter `densi' `midpoi', `options' /*
				*/ t1("`t1title'") /*
				*/ ms(`msymbol') c(`connect') 
   }

    if "`numodes'"!="" { /* modified */
       tempvar difvar inmo sumo
       gen `difvar'=`densi'[_n+1] - `densi'[_n]
       gen `inmo' = 0
       replace `inmo'=1 if `difvar'[_n]>=0 & `difvar'[_n+1] < 0
       gen `sumo' = sum(`inmo')
       local numo= `sumo'[_N]
       noi di as text _newline " Number of modes = " as res `numo'
   }
   if "`modes'"!="" { /* modified */
      tempvar modes
      gen `modes'=.
      replace `modes'=`midpoi' if `inmo'[_n-1]==1
      sort `modes'
      local i = 1
      noi di as text _newline _dup(75) "_"
      local title " Modes in WARPing density estimation"
      noi di as text "`title'" as text", bw = " as res `hval' as text ", M = " as res `mva' as text ", Ker = " as res `kco'
      noi di as text _dup(75) "-"
   while `i'<`numo'+1 {
      noi di as text " Mode ( " %4.0f as res `i' as text " ) = " %12.4f as res `modes'[`i']
      local i = `i'+1
   }
   noi di as text _dup(75) "_"
   sort `midpoi'
   }   
 
     if "`nuamodes'"~="" {
   tempvar difvar inamo suamo index
   gen `difvar'=`densi'[_n+1] - `densi'[_n]
   gen `inamo' = 0
   replace `inamo'=1 if `difvar'[_n]<=0 & `difvar'[_n+1] > 0
   gen `index'=_n if `densi'!=.           /* modified */
   replace `inamo'=0 if `index'==1      /* modified */
   replace `inamo'=0 if `index'==_N-1   /* modified */
   gen `suamo' = sum(`inamo')
   local nuamo= `suamo'[_N]
   noi di as text _newline " Number of antimodes = " as res `nuamo'
   }
   
   if "`amodes'"~="" {
   tempvar amodes
   gen `amodes'=.
   replace `amodes'=`midpoi' if `inamo'[_n-1]==1 
   sort `amodes'
   local i = 1
   noi di as text _newline _dup(75) "_"
   local title " Antimodes in WARPing density estimation"
   noi di as text "`title'" as text ", bw = " as res `hval' as text ", M = " as res `mva' as text ", Ker = " as res `kco'
   noi di as text _dup(75) "-"
   while `i'<`nuamo'+1 {
      noi di as text " Antimode ( " %4.0f as res `i' as text " ) = " %12.4f as res `amodes'[`i']
      local i = `i'+1
      }
   noi di as text _dup(75) "_"
   sort `midpoi'
   }

   if "`npoints'"!="" { /* modified */
   summ `midpoi'
   local np = r(N) /* modified */
   noi di _newline " Number of estimated points = " `np'
   }
   
if "`gen'"~="" {
   restore, not
   merge using `_data'
   drop _merge
   parse "`gen'", parse(" ")  
   gen `1'=`densi'
   gen `2'=`midpoi'
   }
 }
}
end
