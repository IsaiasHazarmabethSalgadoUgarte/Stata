*! version 1.00 93/07/12        STB-16: snp6
program define boxdetr2
  version 3.0
*This program calculates a density trace of a  
*series of values according to the Boxcar Weight function.
*Based on the procedure described in Chambers, et al. (1983)
*considering 50 equally spaced points
  capture confirm existence `1'
  capture confirm number `2'
  capture confirm new variable `3' `4'
  if _rc~=0 {
     di  "syntax: boxdetr2 varname iwidth detravar midpoivar"
     exit}
  tempvar fwy count yo u wu sums h nuobs 
  quietly {
  gen `nuobs'=_N
  gen `fwy'=0
  gen `h'=`2'
  gen `count'=1
  gen `yo'=0
  gen `sums'=0
  gen `u'=0
  gen `wu'=0
  tempvar maxval minval range inter midval
  summ `1'
  gen `maxval'=_result(6)
  gen `minval'=_result(5)
  gen `range'=`maxval'-`minval'
  gen `inter'=`range'/49
  gen `midval'=sum(`inter')+`minval'-`inter'
  set more 1
  noi di "WORKING WITH EACH VALUE. PLEASE BE PATIENT"
  while `count'<=50 {
    noi di "Calculating f(y) number = " `count'
    replace `yo'=`midval'[`count']
    replace `u'=(`yo'-`1')/`h'
    replace `wu'=1 if abs(`u')<0.5
    replace `sums'= sum(`wu')
    replace `fwy'=(1/(`nuobs'*`h'))*`sums'[_N] if _n==`count'
    replace `wu'=0
    replace `count'=`count'+1
  }
  replace `fwy'=. if _n>50
  replace `midval'=. if _n>50
  rename `fwy' `3'
  rename `midval' `4'
  noi di "DONE. THANKS FOR YOUR PATIENCE"
  }
end
