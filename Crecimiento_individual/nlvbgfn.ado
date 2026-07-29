program nlvbgfn, rclass
*Authors: Salgado-Ugarte, I.H., V.M. Saito-Quezada
*First written: 24/06/1999 (version 1.00)
*Updated 05/05/2020; 31/05/2020
   version 11.0
   syntax varlist(min=2 max=2) [aw fw iw] if
   local ye: word 1 of `varlist'
   local equis: word 2 of `varlist'
   return local eq "`ye'= {Li=500}*(1 - exp(-{K=1}*(`equis'-{t0=0.1} )))"
   return local title "von Bertalanffy growth function  `ye' = Li*(1 - exp(-K*(`equis'-t0)))"
end
