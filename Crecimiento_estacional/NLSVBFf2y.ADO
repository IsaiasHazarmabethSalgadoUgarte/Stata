program define nlsvbff2y
   version 11.0
*Authors: Salgado-Ugarte, I.H. & V.M. Saito-Quezada
*First written: 05/05/2020 (version 1.00)
*Revisions: 13/08/2020
   syntax varlist(min=2 max=2) [aw fw iw] [if], at(name)
   local ye: word 1 of `varlist'
   local equis: word 2 of `varlist'
   // Retrieve parameters out of at matrix
   tempname Li K t0 C1 s1 C2 s2 p
   scalar `Li' = `at'[1,1]
   scalar `K' = `at'[1,2]
   scalar `t0' = `at'[1,3]
   scalar `C1' = `at'[1,4]
   scalar `s1' = `at'[1,5]
   scalar `C2' = `at'[1,6]
   scalar `s2' = `at'[1,7]
   scalar `p' = `at'[1,8]
   // Some temporary variables
   tempvar cterm1 cterm2 kterm
   generate double `cterm1'=`C1'*sin(2*_pi*(`equis'-`s1')) `if'
   generate double `cterm2'=`C2'*sin(2*_pi*(`equis'-`s2')/`p') `if'
   generate double `kterm'=`K'*(`equis'-`t0') `if'
   // Now fill in dependent variables
   replace `ye' = `Li'*(1-exp(-1*(`cterm1'+`cterm2'+`kterm'))) `if'
end
