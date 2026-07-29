*! version 1.00 93/05/13        STB-16: snp6
program define boxdetra
  version 3.0
*This program calculates a density trace of a series of ordered 
*values according to the Boxcar Weight function.
*Based on the procedure described in Chambers et al. (1983)
  capture confirm existence `1'
  capture confirm number `2'
  capture confirm new variable `3'
  if _rc~=0 {
     di  "syntax: boxdetra varname iwidth detravar"
     exit}
  tempvar lowcut uppcut nuobs trace count
  quietly {
  summarize `1'
  gen `nuobs'=_result(1)
  gen `lowcut'=`1'-`2'/2
  gen `uppcut'=`1'+`2'/2
  gen `trace'=0
  gen `count'=1
  set more 1
  noi di "WORKING WITH EACH VALUE. PLEASE BE PATIENT"
  while `count'<=_N {
    noi di "Calculating f(y) number = " `count'
    summ `1' if `1'>=`lowcut'[`count'] & `1'<`uppcut'[`count']
    replace `trace'=_result(1)/(`2'*`nuobs') if _n==`count' 
    replace `count'=`count'+1
      }
  rename `trace' `3'
  }
  di "DONE. THANKS FOR YOUR PATIENCE"
end
