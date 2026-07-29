*! version 1.00 93/05/20        STB-16: snp6
program define adgakern
  version 3.0
*This program calculates an adaptive kernel density estimator of a  
*series of values according to the gaussian weight function and the
*adaptive the procedure described in Fox, (1990) and Silverman(1986)
  capture confirm existence `1'
  capture confirm number `2'
  capture confirm new variable `3' 
  if _rc~=0 {
     di  "syntax: adgakern varname halfwidth densivar"
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
  set more 1
  noi di "WORKING WITH EACH VALUE. PLEASE BE PATIENT"
  while `count'<=_N {        
    noi di "Calculating fk(x) number = " `count'
    replace `xo'=`1'[`count']
    replace `z'=(`xo'-`1')/`h'
    replace `kz'=(1/(sqrt(2*_pi)))*exp(-.5*`z'^2) if abs(`z')<2.5
    replace `sums'= sum(`kz')
    replace `fkx'=(1/(`nuobs'*`h'))*`sums'[_N] if _n==`count'
    replace `kz'=0
    replace `count'=`count'+1
  }
  *Calculating local weights
  tempvar lnfkx lnfg fg winfac
  gen `lnfkx'=log(`fkx')
  summ `lnfkx'
  gen `lnfg'=_result(3)
  gen `fg'=exp(`lnfg')
  gen `winfac'=sqrt(`fg'/`fkx')
  tempvar count2 xo2 z2 kz2 sums2 fkx2 
  gen `count2'=1
  gen `xo2'=0
  gen `z2'=0
  gen `kz2'=0
  gen `sums2'=0
  gen `fkx2'=0
  noi di "CALCULATING ADAPTIVE VALUES. DON'T DESPAIR"
  while `count2'<=_N {   
    noi di "Working with adaptive value number = " `count2'
    replace `xo2'=`1'[`count2']
    replace `z2'=(`xo2'-`1')/(`winfac'*`h')
    replace `kz2'=(1/(sqrt(2*_pi)))*exp(-.5*`z2'^2) if abs(`z2')<2.5
    replace `sums2'=sum(`kz2'/`winfac')
    replace `fkx2'=(1/(`nuobs'*`h'))*`sums2'[_N] if _n==`count2'
    replace `kz2'=0
    replace `count2'=`count2'+1
 }
  rename `fkx2' `3'
  noi di "DONE. THANK FOR YOUR PATIENCE"
  }
end
