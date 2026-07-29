*! version 3.00 29/04/2020
program define fordwaln
   version 11.0
*First written 16/09/98; Revised 26/10/01
*Authors: Salgado-Ugarte I.H. & V.M. Saito-Quezada
*This program estimates the Linfinite parameter of the von
*Bertalanffy growth function by means of the Ford-Walford method
*Ford(1933); Walford (1946) using mean length at age values.
*This new version is updated for Stata 11.0

   #delimit ;
   syntax varlist(min=1 max=1) [if] [in]
   , [noGraph T1title(string) YTitle(string) MSymbol(string) Connect(string) 
   LEGend *];

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
    exit
	}
 else 
replace `llagest'=_b[_cons]/(1-_b[lmsize]) if _n==_N
replace lmsize=_b[_cons]/(1-_b[lmsize]) if _n==_N

local linf=lmsize[_N]
local kval=log(_b[lmsize])*-1


noi di _newline "Estimation of L_inf and K values by the Ford-Walford Method"
noi di _dup(60) "-"
noi di as text "Intercept = " as res %8.4f _b[_cons] _skip(10) /*
    */ as text "Slope        = " as res %8.4f _b[lmsize]
noi di _newline as text "R-square  = " as res %8.4f _result(7) _skip(10) /*

    */ as text "Adj R-square = " as res %8.4f _result(8) 
noi di _newline as text "L_inf.    = " as res %8.4f lmsize[_N] _skip(10) /*
    */ as text "K            = " as res %8.4f `kval'
noi di _dup(60) as text "-"

    if "`graph'" ~= "nograph"  {
       local lilab=string(round(`linf',.0001),"%9.4f")
       local kvlab=string(round(`kval',.0001),"%9.4f")
       if "`t1title'" ==""{
          local t1title "Ford-Walford graph"
          local t1title "`t1title',  {it:L{sub:{&infin}}} = `lilab',  {it:K} = `kvlab'"
       }
       if "`msymbol'"=="" { 
	   	local msymbol "Oh i i" 
	   }
       if "`connect'"=="" { 
	   	local connect ". l l" 
	   }
       if "`ytitle'"=="" {
	   	local ytitle "Size at age t + 1" 
	   }
       if "`legend'"=="" {
	   	local legend "off"
	   }
	   
	   label var lmsize "Size at age {sub:t}"
	
	   scatter llagm `llagest' lmsize lmsize, `options' /*
				*/ t1("`t1title'") /*
				*/ ms(`msymbol') c(`connect') /*
                */ ytitle("`ytitle'") legend(`legend')
       } 
}
end
  