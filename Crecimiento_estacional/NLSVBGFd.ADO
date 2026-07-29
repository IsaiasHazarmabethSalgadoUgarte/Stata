program define nlsvbgfd
   version 6.0
*Author: Salgado-Ugarte, I.H.
*First written: 4/05/2012 (version 1.00)
      if "`1'"=="?"  {
         global S_2 /*
*/ "Seasonal VBGF,$S_E_depv=b0*(1-exp(-1*(C*sin(2*_pi*(`2' - S)/365.25)+b1*(`2'-(b2)))))"
         global S_1 "b0 b1 b2 C S"
         local exp "[$S_E_wgt $S_E_exp]"
         global b0=100
         global b1=.01
         global b2=0.1
         global C =0.1
         global S =4
         exit
      }
      replace `1'= $b0*(1-exp(-1*($C*sin(2*_pi*(`2'-$S)/365.25)+$b1*(`2'-($b2)))))
end
