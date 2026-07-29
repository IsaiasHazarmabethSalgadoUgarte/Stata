
*! version 3.00 2020/07/15
*! version 1.00 94/11/14
program define warpregpy
  version 16.0
*Authors: Isaias H. Salgado-Ugarte, Makoto Shimizu, Toru Taniuchi
*and V. Mitsui Saito-Quezada
**Colaborators (Python): N.I. Plascencia Díaz, M.M. Salgado-Saito
*First written 94/11/14; Revisions: 95/04/01; 2020/07/15; 2021/10/6
*This program calculates Haerdle WARPing approximation for
*NADARAYA-WATSON regression estimate
*using a Python program which utilizes modified algorithms and
*C programs from Haerdle (1991) "Smoothing Techniques with 
*Implementations in S", Springer-Verlag Series in Statistics, New York.
local varlist "req ex min(2) max(2)"
local if "opt"
local in "opt"
#delimit ;
local options "Bwidth(real 0) Mval(integer 0) Kercod(integer 0) SOrt
       Gen(string) noGraph T1title(string) mSymbol(string) Connect(string) *";
#delimit cr
parse "`*'"
parse "`varlist'", parse(" ")
quietly {
preserve
if "`gen'"~="" {
   tempfile _data
   save `_data'
   }
tempvar yvar xvar
gen `yvar'=`1' `if' `in'
gen `xvar'=`2' `if' `in'
replace `xvar'=. if `yvar'==.
if `xvar'[1]==. {
   di in red "no observations"
   exit
   }
if "`sort'"=="" { 
	sort `xvar'
    }
outfile `xvar' `yvar' using _data2 if `xvar' !=., replace
local hval=`bwidth'
local mva=`mval'
local kco=`kercod'
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
if `kc'>6 {
     di in red "invalid choice of kernel"
     exit
	 } 
keep `hv' `mv' `kc'
drop if _n>1
set obs 1
outfile using _inpval, replace
drop _all
*!warpregf
python script warpregpy.py
!del _data2.raw
!del _inpval.raw 
tempvar num mmval midpoi
import delimited `num' `mmval' `midpoi' using resfile.csv
label var `midpoi'  "Midpoints"
label var `mmval'  "Conditional mean"
!del resfile.csv
if "`graph'" ~= "nograph"  {
   if "`t1title'" ==""{
         local t1title "Nadaraya-Watson regression (WARP)"
         local t1title "`t1title', bw = `hval', M = `mva', Kernel = `kco'"
         }
   if "`msymbol'"=="" { 
   	local msymbol "i" 
	}
   if "`connect'"=="" { 
   	local connect "l" 
	}
   scatter `mmval' `midpoi', `options' t1("`t1title'") /*
                          */ ms(`msymbol') c(`connect')
}

if "`gen'"~="" {
   restore, not
   merge using `_data'
   drop _merge
   parse "`gen'", parse(" ")  
   gen `1'=`mmval'
   gen `2'=`midpoi'
   }

}
end
