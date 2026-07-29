*! version 1.00 94/11/11
program define warpden
  version 3.1
*First writen: 94/08/01; Last revised 95/03/10
*Authors: Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi
*This program calculates Haerdle-Scott warping density estimation
*(step function)
*using a TurboPascal program which utilizes modified algorithms from
*Haerdle (1991) "Smoothing Techniques with Implementations in S", 
*Springer-Verlag Series in Statistics, New York and Scott (1992) 
*"Multivariate Density Estimation. Theory, Practice, and Visualization, 
*John Wiley & Sons, New York.
*syntax: . warpden varname [if exp] [in range], Bwidth(#) Mval(#) Kercode(#)
*                      [STep noSort Gen(denvar midvar) noGraph graph_options]

local varlist "req ex min(1) max(1)"
local if "opt"
local in "opt"
#delimit ;
local options "Bwidth(real 0) Mval(integer 0) Kercode(integer 0) STep noSort
        Gen(string) noGraph T1title(string) Symbol(string) Connect(string) *";
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
   exit}
keep `xvar'
if "`nosort'"=="" { sort `xvar'}
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
     exit}
if `mv'==0 {
     di in red "you must provide the number of shifted histograms"
     exit}
if `kc'==0 {
     di in red "you must provide the kernel code"
     exit}
if `kc'>7 {
     di in red "invalid choice of kernel"
     exit} 
keep `hv' `mv' `kc'
drop if _n>1
set obs 1
outfile using _inpval, replace
drop _all
!warpingc
!del _data2.raw
!del _inpval.raw
tempvar midpoi densi inter lowcut
infile `densi' `midpoi' using resfile.
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
   if "`symbol'"=="" { local symbol "." }
   if "`connect'"=="" { 
      if "`step'"~="" {local connect "J" }
      else {local connect "l" }
   }
   if "`step'"~="" {
     gen `inter'=`midpoi'[2]-`midpoi'[1]
     gen `lowcut'=`midpoi'-(`inter'/2)
     label variable `densi' "Density"
     label variable `lowcut' "Lower cutoff"
     graph `densi' `lowcut',  `options' /*
				*/ t1("`t1title'") /*
				*/ s(`symbol') c(`connect') 
   }
   else {
      label variable `densi' "Density"
      label variable `midpoi' "Midpoints"
      graph `densi' `midpoi', `options' /*
				*/ t1("`t1title'") /*
				*/ s(`symbol') c(`connect') 
   }
!del resfile
if "`gen'"~="" {
   restore, not
   merge using `_data'
   drop _merge
   parse "`gen'", parse(" ")  
   gen `1'=`densi'
   gen `2'=`midpoi'
   }
}
end
