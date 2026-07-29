program define nlvbgf, rclass
   version 11.0
*Author: Salgado-Ugarte, I.H.
*First written: 24/06/1999 (version 1.00)
      if "`1'"=="?"  {
         global S_2 /*
*/ "von Bertalanffy growth function,$S_E_depv=b0*(1-exp(-b1*(`2'-b2)))"
         global S_1 "b0 b1 b2"
         local exp "[$S_E_wgt $S_E_exp]"
         global b0=500
         global b1=1
         global b2=0.1
         exit
      }
      replace `1'= $b0*(1-exp(-$b1*(`2'-$b2)))
end
