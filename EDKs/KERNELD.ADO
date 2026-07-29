*! version 2.00 94/12/12        STB-xx: snp6.x
program define kerneld
  version 3.1
*First written (version 1.00) 94/10/28 ; Last revised 95/04/10
*Authors: Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi
*This program calculates kernel density estimator of a series of 
*values according to the weight functions coded as follows:
* 1 = Uniform
* 2 = Triangle 
* 3 = Epanechnikov
* 4 = Quartic (Biweight)
* 5 = Triweight
* 6 = Gaussian
* 7 = Cosinus
*Based on the procedures described in Fox (1990), Silverman (1986),
*Haerdle (1991) and Scott (1992)
*This integrated new version permits to stablish the number of points 
*to consider for calculations. Chambers et al. (1983), suggest using 50,
*but the user may employ for example 100 points (as in Haerdle, 1991
*programs).
*---------------------------------------------------------------------------
*IMPORTANT NOTES:
*Take into account that, as the number of points increases, the time for
*calculation increases too. On the other hand, if the number of points is
*less than 50, the approximation may be too rough to be useful.
*If `nuobs' is less than `np' then the program sets the number of the 
*observations = `np' to obtain the full set of estimations.
*---------------------------------------------------------------------------
*The interval has been adjusted too.
*syntax: kerneld varname [if exp] [in range] [, Bwidth(#) Kercode(#) NPoint(#)
*                         Gen(densivar gridvar) noGraph graph_options]

local varlist "req ex min(1) max(1)"
local if "opt"
local in "opt"
#delimit ;
local options "Bwidth(real 0) Kercode(integer 0) NPoint(integer 0) Gen(string)
                    noGraph T1title(string) Symbol(string) Connect(string) *";
#delimit cr
parse "`*'"
parse "`varlist'", parse(" ")

quietly {

tempvar xvar
gen `xvar'=`1' `if' `in'
drop if `xvar'==.
if `xvar'[1]==. {
   di in red "no observations"
   exit}
local hv=`bwidth'
local kc=`kercode'
local np=`npoint'

if `np'>_N {
     set obs `np'
     }

if `hv'==0 {
     di in red "you must provide the bandwidth"
     exit}
if `kc'==0 {
     di in red "you must provide the kernel code"
     exit}
if `kc'>7 {
     di in red "invalid choice of kernel"
     exit} 
if `np'==0 {
     di in red "you must provide the number of grid points (n>=50 suggested)
     exit}

  tempvar fkx xo z kz sums
  gen `fkx'=0
  local count=1
  gen `xo'=0
  gen `sums'=0
  gen `z'=0
  gen `kz'=0
  tempvar maxval minval range inter midval
  summ `xvar'
  local nuobs=_result(1)
  local maxval=_result(6)+`hv'+((_result(6)-_result(5))*0.1)
  local minval=_result(5)-`hv'-((_result(6)-_result(5))*0.1)
  local range=`maxval'-`minval'
  local inter=`range'/`np'
  gen `midval'=sum(`inter')+`minval'+`inter'/2
*  set more 1
*  noi di "WORKING WITH EACH VALUE. PLEASE BE PATIENT"
  while `count'<=`np' {
*    noi di "Calculating fk(x) number = " `count'
    replace `xo'=`midval'[`count']
    replace `z'=(`xo'-`xvar')/`hv'

    if `kc'==1 {
        replace `kz'=0.5 if abs(`z')<=1
    }
    else if `kc'==2 {
        replace `kz'=(1-abs(`z')) if abs(`z')<=1
    }
    else if `kc'==3 {
        replace `kz'=(3/4)*(1-`z'^2) if abs(`z')<=1
    }
    else if `kc'==4 {
        replace `kz'=(15/16)*((1-`z'^2))^2 if abs(`z')<=1
    }
    else if `kc'==5 {
        replace `kz'=(35/32)*(1-`z'^2)^3 if abs(`z')<=1
    }
    else if `kc'==6 {
        replace `kz'=(1/(sqrt(2*_pi)))*exp(-0.5*`z'^2) if abs(`z')<=3
    }
    else {
        replace `kz'=(_pi/4)*cos((_pi/2)*`z') if abs(`z')<=1
    }
    replace `sums'= sum(`kz')
    replace `fkx'=(1/(`nuobs'*`hv'))*`sums'[_N] if _n==`count'
    replace `kz'=0
    local count = `count'+1
  }
  replace `fkx'=. if _n>`np'
  replace `midval'=. if _n>`np'
  set more 0
  label var `fkx' "Density"
  label var `midval' "Midpoints"
    if "`graph'" ~= "nograph"  {
       if "`t1title'" ==""{
          local t1title "Kernel Density Estimation"
          local t1title "`t1title', bw = `hv', k = `kc', npoints = `np'"
          }
       if "`symbol'"=="" { local symbol "i" }
       if "`connect'"=="" { local connect "l" }
       graph `fkx' `midval', `options' /*
				*/ t1("`t1title'") /*
				*/ s(`symbol') c(`connect')
   } 
  if "`gen'"~="" {
     parse "`gen'", parse(" ")  
     gen `1'=`fkx'
     gen `2'=`midval'
  }
}
end
