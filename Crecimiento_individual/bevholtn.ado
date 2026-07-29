*! version 3.00 28/04/2020
program define bevholtn
   version 11.0

*version 2.00 14/06/99
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
     YTitle(string) MSymbol(string) Connect(string) LEGend(string) *];

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
if r(N) == 0 { 
	error 2000
	}


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
     exit
	 }
tempvar difvar
gen difvar=log(`liv' - `msize')

regress difvar `agevar'
predict difest

local b=_b[`agevar']
local a=_b[_cons]

 if `b'>=0 {
    noi di in red "The slope of the line of the observed points is >=0" 
    exit
	}
 else 

local kval=`b'*-1
local tzero= (`a'-log(`liv'))/`kval'

noi di _newline "Estimation of K and t_0 values by the Beverton-Holt Method"
noi di _dup(60) "-"
noi di as text "Intercept = " as res %8.4f _b[_cons] _skip(10) /*
    */ as text "Slope        = " as res %8.4f _b[`agevar']
noi di _newline as text "R-square  = " as res %8.4f _result(7) _skip(10) /*
    */ as text "Adj R-square = " as res %8.4f _result(8) 
noi di _newline as text "K         = " as res %8.4f `kval' _skip(10) /*
	*/ as text "t_0          = " as res %8.4f `tzero'
noi di _dup(60) as text "-"
noi di _newline as text "Estimated von Bertalanffy Growth Function"
noi di _dup(60) as text "-"

   if `tzero' < 0 {
   local tzplus = `tzero'*-1
   noi di _newline as text "l_t = " as res %8.4f `liv' _skip(1) /*
   */ as text "* (1 - exp(" as res %8.4f `b' _skip(1) /*
   */ as text "*(t +" as res %8.4f `tzplus' _skip(1) as text ")))" 
   }
   else {
   noi di _newline as text "l_t = " as res %8.4f `liv' _skip(1) /*
   */ as text "* (1 - exp(" as res %8.4f `b' _skip(1) /*
   */ as text "*(t -" as res %8.4f `tzero' _skip(1) as text ")))"
   }

noi di _dup(60) as text "-"


    if "`graph'" ~= "nograph"  {
       local kvlab=string(round(`kval',.0001),"%9.4f")
       local tzlab=string(round(`tzero',.0001),"%9.4f")
	   
       if "`t1title'" ==""{
          local t1title "Beverton-Holt graph"
          local t1title "`t1title', {it:K} = `kvlab',  {it:t}{sub:0} = `tzlab'"
           }
       if "`msymbol'"=="" { 
	   	local msymbol "Oh i" 
		}
       if "`connect'"=="" { 
	   	local connect ". l" 
		}      
       if "`ytitle'"=="" {
	   	local ytitle "{it:Ln}({it:L}{sub:{&infin}} - l{sub:t})" 
		}
	   if "`legend'"=="" {
		local legend "off"
		}

       scatter difvar difest `agevar', `options' /*
	*/ t1("`t1title'") ms(`msymbol') c(`connect') /*
	*/ ytitle("`ytitle'") legend(`legend')
       } 

drop difvar difest

  if "`gen'"~="" {
   capture restore, not
   tokenize `gen'  
     gen `1'=`liv'*(1-exp(`b'*(`agevar'-`tzero')))
  }

}
end
