*! version 2.00 14/06/99
program define fordwal
   version 6.0
*First written 16/09/98; Revised 26/10/01
*Author: Salgado-Ugarte I.H.
*This program estimates the Linfinite parameter of the von
*Bertalanffy growth function by means of the Ford-Walford method
*Ford(1933); Walford (1946) using mean length at age values.
*This new version is updated for Stata 6.0

   #delimit ;
   syntax varlist(min=1 max=1) [if] [in]
   , [noGraph T1title(string) L1lab(string) Symbol(string) Connect(string) *];

   #delimit cr
   tokenize `varlist'

   quietly {
preserve

tempvar msize
gen `msize' = `1' `if' `in'

local nurows=_N+2
set obs `nurows'
tempvar lagmsi lmsize llagm llagest b
gen lagmsi=`msize'[_n+1]
gen lmsize= `msize'[_n-1]
gen llagm= lagmsi[_n-1]
replace lmsize=0 if _n==1
regress llagm lmsize
predict `llagest'
local b=_b[lmsize]
 if `b'>=1 {
    noi di in red "The slope of the line of the observed points is >=1" 
    exit}
 else 
replace `llagest'=_b[_cons]/(1-_b[lmsize]) if _n==_N
replace lmsize=_b[_cons]/(1-_b[lmsize]) if _n==_N

local linf=lmsize[_N]
local kval=log(_b[lmsize])*-1

noi di _newline "Estimation of L_inf and K values by the Ford-Walford Method"
noi di _dup(60) "-"
noi di "Intercept = " %8.4f _b[_cons] _skip(10) "Slope        = " %8.4f _b[lmsize]
noi di _newline "R-square  = " %8.4f _result(7) _skip(10) "Adj R-square = " %8.4f _result(8) 
noi di _newline "L_inf.    = " %8.4f lmsize[_N] _skip(10) "K            = " %8.4f `kval'
noi di _dup(60) "-"

    if "`graph'" ~= "nograph"  {
       local lilab=string(round(`linf',.0001),"%9.4f")
       local kvlab=string(round(`kval',.0001),"%9.4f")
       if "`t1title'" ==""{
          local t1title "Ford-Walford graph"
          local t1title "`t1title',  L_inf = `lilab',  K = `kvlab'"
           }
       if "`symbol'"=="" { local symbol "O.." }
       if "`connect'"=="" { local connect ".ll" }
       if "`l1lab'"=="" {local l1lab "Size at age t + 1" }
       label var lmsize "Size at age t"
       graph llagm `llagest' lmsize lmsize, `options' /*
				*/ t1("`t1title'") /*
				*/ s(`symbol') c(`connect') /*
                                */ l1("`l1lab'")
       } 
}
end
  