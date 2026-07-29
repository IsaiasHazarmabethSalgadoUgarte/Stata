*! version 1.00 93/05/20        STB-16: snp6
program define kernsim
  version 3.0
*This program calculates a simple density estimator of a  
*series of values according to a rectangular weight function.
*Based on the procedure described in Fox, (1990)
*but considering only 50 equally spaced points
  capture confirm existence `1'
  capture confirm number `2'
  capture confirm new variable `3' `4'
  if _rc~=0 {
     di  "syntax: kernsim varname halfwidth densivar midpoivar"
     exit}
  tempvar fkx count xo z kz sums h nuobs 
  quietly {
  gen `nuobs'=_N
  gen `fkx'=0
  gen `h'=`2'
  gen `count'=1
  gen `xo'=0
  gen `sums'=0
  gen `z'=0
  gen `kz'=0
  tempvar maxval minval range inter midval
  summ `1'
  gen `maxval'=_result(6)+`h'
  gen `minval'=_result(5)-`h'
  gen `range'=`maxval'-`minval'
  gen `inter'=`range'/49
  gen `midval'=sum(`inter')+`minval'-3*`inter'/2 
  set more 1
  noi di "WORKING WITH EACH VALUE. PLEASE BE PATIENT"
  while `count'<=50 {
    noi di "Calculating fk(x) number = " `count'
    replace `xo'=`midval'[`count']
    replace `z'=(`xo'-`1')/`h'
    replace `kz'=0.5 if abs(`z')<1
    replace `sums'= sum(`kz')
    replace `fkx'=(1/(`nuobs'*`h'))*`sums'[_N] if _n==`count'
    replace `kz'=0
    replace `count'=`count'+1
  }
  replace `fkx'=. if _n>50
  replace `midval'=. if _n>50
  rename `fkx' `3'
  rename `midval' `4'
  noi di "DONE. THANKS FOR YOUR PATIENCE"
  }
end
