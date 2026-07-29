program define nlsvbgfm
   version 6.0
*Author: Salgado-Ugarte, I.H.
*First written: 4/05/2012 (version 1.00)
*Updated 13/06/2020; 02/04/2026; Salgado-Ugarte, I.H. & V.M. Saito-Quezada
*Revised 02/04/2026
      if "`1'"=="?"  {
         global S_2 /*
*/ "Seasonal VBGF,$S_E_depv=Li*(1-exp(-1*(C*sin(2*_pi*(`2' - s)/12)+K*(`2'-(t0)))))"
         global S_1 "Li K t0 C s"
         local exp "[$S_E_wgt $S_E_exp]"
         global Li=60
         global K=0.1
         global t0=0.01
         global C = 1
         global s = 1
         exit
      }
      replace `1'= $Li*(1-exp(-1*($C*sin(2*_pi*(`2'-$s)/12)+$K*(`2'-$t0))))
end
