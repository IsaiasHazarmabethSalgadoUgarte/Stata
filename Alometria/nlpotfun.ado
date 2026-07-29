program define nlpotfun
   version 6.0
      if "`1'"=="?"  {
         global S_2 /*
*/ "Potential function,$S_E_depv=b0*`2'^b1"
         global S_1 "b0 b1"
         local exp "[$S_E_wgt $S_E_exp]"
         global b0=.5
         global b1=.5
         exit
      }
      replace `1'= $b0*`2'^$b1
end
