program define nlsvbgff
   version 16.0
*Authors: Salgado-Ugarte, I.H. & V.M. Saito-Quezada
*First written: 05/05/2020 (version 1.00)
   syntax varlist(min=2 max=2) [aw fw iw] [if], at(name)
   local ye: word 1 of `varlist'
   local equis: word 2 of `varlist'
   // Retrieve parameters out of at matrix
   tempname Li K t0 C s
   scalar `Li' = `at'[1,1]
   scalar `K' = `at'[1,2]
   scalar `t0' = `at'[1,3]
   scalar `C' = `at'[1,4]
   scalar `s' = `at'[1,5]
   // Some temporary variables
   tempvar cterm kterm
   generate double `cterm'=`C'*sin(2*_pi*(`equis'-`s')/52) `if'
   generate double `kterm'=`K'*(`equis'-`t0') `if'
   // Now fill in dependent variables
   replace `ye' = `Li'*(1-exp(-1*(`cterm'+`kterm'))) `if'
  end
  