program define nlsvbgfs, rclass
   version 11.0
*Authors: Salgado-Ugarte, I.H. & V.M. Saito-Quezada
*First written: 05/05/2020 (version 1.00)
   syntax varlist(min=2 max=2) [aw fw iw] [if], at(name)
   local ye: word 1 of `varlist'
   local equis: word 2 of `varlist'
   // Retrieve parameters out of at matrix
   tempname Li K t0 C ts
   scalar `Li' = `at'[1,1]
   scalar `K' = `at'[1,2]
   scalar `t0' = `at'[1,3]
   scalar `C' = `at'[1,4]
   scalar `ts' = `at'[1,5]
   // Some temporary variables
   tempvar kterm Stterm S0term
   generate double `kterm'=`K'*(`equis'-`t0') `if'
   generate double `Stterm'=(`C'*`K')/(2*_pi)*sin(2*_pi*(`equis'-`ts')) `if'
   generate double `S0term'=(`C'*`K')/(2*_pi)*sin(2*_pi*(`t0'-`ts')) `if'
   // Now fill in dependent variables
   replace `ye' = `Li'*(1-exp(-`kterm'-`Stterm'+`S0term')) `if'
end
  