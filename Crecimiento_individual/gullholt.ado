*! version 2.00 14/06/99
program define gullholt
   version 6.0
*First written 09/11/98
*Author: Salgado-Ugarte I.H.
*This program estimates the Linfinite parameter of the von
*Bertalanffy growth function by means of the Gulland-Holt method
*Gulland y Holt (1959) according to Sparre et al. (1989)
*This new version is updated for Stata 6.0

   #delimit ;
   syntax varlist(min=2 max=2) [if] [in]
   , [noGraph Gen(string) T1title(string) Symbol(string) 
     Connect(string) *];

   #delimit cr
   tokenize `varlist'

quietly {
preserve

tempvar msize agev
gen `msize' = `1' `if' `in'
gen `agev' = `2' `if' `in'

local nurows=_N+2
set obs `nurows'
tempvar lagmsi lmsize llagm yest b lagage deltat
gen lagmsi=`msize'[_n+1]
gen lmsize= `msize'[_n-1]
gen llagm= lagmsi[_n-1]
replace lmsize=0 if _n==1
gen lagage=`agev'[_n-1]
gen deltat=`agev'-lagage
gen deltas=llagm-lmsize

tempvar equis yev
gen ye=deltas/deltat
gen equis=(llagm+lmsize)/2

regress ye equis

local b=_b[equis]
 if `b'>=0 {
    noi di in red "The slope of the line of the observed points is >=0" 
    exit}
 else 

predict `yest'

replace equis=_b[_cons]/_b[equis]*-1 if _n==_N

replace `yest'=0 if _n==_N


local linf=_b[_cons]/_b[equis]*-1
local kval=(_b[equis])*-1

noi di _newline "Estimation of L_inf and K values by the Gulland-Holt Method"
noi di _dup(60) "-"
noi di "Intercept = " %8.4f _b[_cons] _skip(10) "Slope        = " %8.4f _b[equis]
noi di _newline "R-square  = " %8.4f _result(7) _skip(10) "Adj R-square = " %8.4f _result(8) 
noi di _newline "L_inf.    = " %8.4f `linf' _skip(10) "K            = " %8.4f `kval'
noi di _dup(60) "-"
    if "`graph'" ~= "nograph"  {
       local lilab=string(round(`linf',.0001),"%9.4f")
       local kvlab=string(round(`kval',.0001),"%9.4f")
       if "`t1title'" ==""{
          local t1title "Gulland-Holt graph"
          local t1title "`t1title',  L_inf = `lilab',  K = `kvlab'"
           }
       if "`symbol'"=="" { local symbol "O.." }
       if "`connect'"=="" { local connect ".ll" }
       if "`l1lab'"=="" {local l1lab "Delta size/Delta age" }
       label var equis "Mean size by Delta age"
       graph ye `yest' equis, `options' /*
				*/ t1("`t1title'") /*
				*/ s(`symbol') c(`connect') /*
                                */ l1(`l1lab')
       } 
}
end
