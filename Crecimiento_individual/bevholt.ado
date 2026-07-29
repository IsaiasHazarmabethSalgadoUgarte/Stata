*! version 2.00 14/06/99
program define bevholt
   version 6.0

*First written 16/09/98; last revised 17/03/99
*Revised 26/10/01
*Author: Salgado-Ugarte I.H.
*This program estimates the K and t_0 (for a given L_inf) parameters of 
*the von Bertalanffy growth function by means of the Beverton and Holt 
*(1957) method using mean size (length) at age values
*This new version is updated for Stata 6.0

   #delimit ;
   syntax varlist(min=2 max=2) [if] [in]
   , [Linf(real 0) noGraph Gen(string) T1title(string) 
     L1lab(string) Symbol(string) Connect(string) *];

   #delimit cr
   tokenize `varlist'

quietly {
preserve

*if "`gen'"~="" {
*   tempfile _data
*   save `_data'
*   }


*tempvar msize agevar
*gen `msize' = `1' `if' `in'
*gen `agevar' = `2' `if' `in'

args msize agevar
marksample touse
count if `touse'
if r(N) == 0 { error 2000}


  _crcslbl `msize' `1'
  _crcslbl `agevar' `2'

*drop if `msize'==.
*if `msize'[1]==. {
*   di in red "no observations"
*   exit}
*keep `msize'

local liv=`linf'
if `liv'==0 {
     noi di in red "you must provide the Linfinite value"
     exit}
tempvar difvar
gen difvar=log(`liv' - `msize')

regress difvar `agevar'
predict difest

local b=_b[`agevar']
local a=_b[_cons]

 if `b'>=0 {
    noi di in red "The slope of the line of the observed points is >=0" 
    exit}
 else 

local kval=`b'*-1
local tzero= (`a'-log(`liv'))/`kval'

noi di _newline "Estimation of K and t_0 values by the Beverton-Holt Method"
noi di _dup(60) "-"
noi di "Intercept = " %8.4f _b[_cons] _skip(10) "Slope        = " %8.4f _b[`agevar']
noi di _newline "R-square  = " %8.4f _result(7) _skip(10) "Adj R-square = " %8.4f _result(8) 
noi di _newline "K         = " %8.4f `kval' _skip(10) "t_0          = " %8.4f `tzero'
noi di _dup(60) "-"
noi di _newline "Estimated vonBertalanffy Growth Function"
noi di _dup(60) "-"

   if `tzero' < 0 {
   local tzplus = `tzero'*-1
   noi di _newline "l_t = " %8.4f `liv' _skip(1) "* (1 - exp(" %8.4f `b' _skip(1) /*
                 */"*(t +" %8.4f `tzplus' _skip(1) ")))" 
   }
   else {
   noi di _newline "l_t = " %8.4f `liv' _skip(1) "* (1 - exp(" %8.4f `b' _skip(1) /*
                 */"*(t -" %8.4f `tzero' _skip(1) ")))"
   }

noi di _dup(60) "-"


    if "`graph'" ~= "nograph"  {
       local kvlab=string(round(`kval',.0001),"%9.4f")
       local tzlab=string(round(`tzero',.0001),"%9.4f")
       if "`t1title'" ==""{
          local t1title "Beverton-Holt graph"
          local t1title "`t1title',  K = `kvlab',  t_0 = `tzlab'"
           }
       if "`symbol'"=="" { local symbol "O." }
       if "`connect'"=="" { local connect ".l" }      
       if "`l1lab'"=="" {local l1lab "Ln(L_inf - l_t)" }

       graph difvar difest `agevar', `options' /*
	*/ t1("`t1title'") s(`symbol') c(`connect') l1("`l1lab'")
       } 

drop difvar difest

  if "`gen'"~="" {
   capture restore, not
   tokenize `gen'  
     gen `1'=`liv'*(1-exp(`b'*(`agevar'-`tzero')))
  }

}
end
