*! v1.1.0 IHSalgado-Ugarte 01mar2015/01mar2015
*! v1.1.1 IHSalgado-Ugarte 01nov2017
program vbmltest
   version 11
   quietly {
      syntax varlist(numeric min=3 max=3) [fw], [Level(int 95)]
	  local clevel  `level'
	  *noi di `clevel'
	  nl vbgfno `1' `2' `3' `4'
	  scalar N = e(N)
      scalar rss1=e(rss)
      matrix P1 = e(b)
	  scalar Li1=P1[1,1]
	  scalar K1 = P1[1,2]
	  scalar t01 = P1[1,3]
	  scalar t01s="-" + string(t01, "%6.3f")
	     if t01*-1>0 {
		    scalar t01s = "+" + string(abs(t01), "%6.3f")
		 }
	  noi di as text _dup(80) "_"
	  noi di "Maximum likelihood F tests for two von Bertalanffy Growth Functions"
	  noi di _dup(80) "-"
	  noi di as text "Linear        | Models                              | RSS   |   F   | DF | P"
	  noi di as text "constraints   |                                     |       |       |    |"
	  noi di _dup(80) "-"
	  noi di as res "none" _col(15)"{text}|" "l_t1="  %6.2f Li1 "[1-exp{-" %6.3f K1 "(t" t01s ")}]" _col(53)"{text}|" %6.2f rss1 _col(61)"{text}|" _col(69)"{text}|" _col(74)"{text}|" 
      scalar Li2 = P1[1,4]
	  scalar K2 = P1[1,5]
	  scalar t02 = P1[1,6]
	  scalar t02s ="-" + string(t02, "%6.3f")
	  	 if t02*-1>0 {
		    scalar t02s = "+" + string(abs(t02), "%5.3f")
		 }
	  noi di as res _col(15)"{text}|" "l_t2="  %6.2f Li2 "[1-exp{-" %6.3f K2 "(t" t02s ")}]" _col(53)"{text}|" _col(61)"{text}|" _col(69)"{text}|" _col(74)"{text}|"
	  noi di _dup(80) "-"
	  nl vbgf `1' `2' `4'
	  scalar rss2 = e(rss)
	  matrix P2 = e(b)
	  scalar Lit=P2[1,1]
	  scalar Kt=P2[1,2]
	  scalar t0t=P2[1,3]
	  scalar df1 = 6-3
	  *noi di t0t
	  scalar t0ts = "-" + string(t0t, "%6.3f")
	  *noi di t0ts
	  	 if t0t*-1>0 {
		    scalar t0ts = "+" + string(abs(t0t), "%6.3f")
		 }
	  scalar df2 = N - df1*2
	  *noi di rss1
	  *noi di df2
	  scalar fc=((rss2-rss1)/(df1*2-df1))/(rss1/df2)
	  scalar pv1= Ftail(df1, df2, fc)
	  *noi di t0ts
	  noi di as res "Li1 = Li2" _col(15)"{text}|" "l_tt="  %6.2f Lit "[1-exp{-" %6.3f Kt "(t" t0ts ")}]" _col(53)"{text}|" %6.2f rss2 _col(61)"{text}|" %6.2f fc _col(69)"{text}|" %4.0f df1 _col(74)"{text}|" %6.4f pv1
	  noi di as res "K1  = K2" _col(15)"{text}|" _col(53)"{text}|" _col(61)"{text}|" _col(69)"{text}|" %4.0f df2 _col(74)"{text}|"
	  noi di as res "t01 = t02" _col(15)"{text}|" _col(53)"{text}|" _col(61)"{text}|" _col(69)"{text}|" _col(74)"{text}|"
	  noi di _dup(80) "-"
	  scalar sig = (100 - `clevel')/100
	  if pv1 > sig {
	  	  noi di as res "There are no differences between the groups with a " %5.2f `clevel' " confidence." 
		  noi di as text _dup(80) "-"
		  exit
		  }
	  	  nl vbgfel `1' `2' `3' `4'
	  scalar rssel = e(rss)
	  matrix Pel = e(b)
	  scalar Liel=Pel[1,1]
	  scalar Kel1 = Pel[1,2]
	  scalar t0el1 = Pel[1,3]
	  scalar Kel2 = Pel[1,4]
	  scalar t0el2 = Pel[1,5]
	  scalar t0el1s = "-" + string(t0el1, "%6.3f")
	     if t0el1*-1>0 {
		    scalar t0el1s = "+" + string(abs(t0el1), "%6.3f")
		 }
	  scalar t0el2s = "-" + string(t0el2, "%6.3f")
	     if t0el2*-1>0 {
		    scalar t0el2s = "+" + string(abs(t0el2), "%6.3f")
		 }
	  scalar df3=df1*2-(df1*2-1) 
	  scalar fcel= ((rssel-rss1)/(df3))/(rss1/(df2))
	  *scalar df = 1
	  scalar pvel = Ftail(df3,df2, fcel)
	  noi di as res "Li1 = Li2" _col(15)"{text}|" "l_t1="  %6.2f Liel "[1-exp{-" %6.3f Kel1 "(t" t0el1s ")}]" _col(53)"{text}|" %6.2f rssel _col(61)"{text}|" %6.2f fcel _col(69)"{text}|" %4.0f df3 _col(74)"{text}|" %6.4f pvel
	  noi di as res _col(15)"{text}|" "l_t2="  %6.2f Liel "[1-exp{-" %6.3f Kel2 "(t" t0el2s ")}]" _col(53)"{text}|" _col(61)"{text}|" _col(69)"{text}|" %4.0f df2 _col(74)"{text}|"
	  noi di as text _dup(80) "-"
	  nl vbgfek `1' `2' `3' `4'
	  scalar rssek = e(rss)
	  matrix Pek = e(b)
	  scalar Liek1 = Pek[1,1]
	  scalar Kek = Pek[1,2]
	  scalar t0ek1 = Pek[1,3]
	  scalar Liek2=Pek[1,4]
	  scalar t0ek2=Pek[1,5]
	  scalar t0ek1s = "-" + string(t0ek1, "%6.3f")
	     if t0ek1*-1>0 {
		    scalar t0ek1s = "+" + string(abs(t0ek1), "%6.3f")
		 }
	  scalar t0ek2s = "-" + string(t0ek2, "%6.3f")
	     if t0ek2*-1>0 {
		    scalar t0ek2s = "+" + string(abs(t0ek2), "%6.3f")
		 }
	  scalar fcek= ((rssek - rss1)/(df3))/(rss1/(df2))  
	  scalar pvek = Ftail(df3, df2, fcek)
	  noi di as res "K1  = K2" _col(15)"{text}|" "l_t1="  %6.2f Liek1 "[1-exp{-" %6.3f Kek "(t" t0ek1s ")}]" _col(53)"{text}|" %6.2f rssek _col(61)"{text}|" %6.2f fcek _col(69)"{text}|" %4.0f df3 _col(74)"{text}|" %6.3f pvek
	  noi di as res _col(15)"{text}|" "l_t2="  %6.2f Liek2 "[1-exp{-" %6.3f Kek "(t" t0ek2s ")}]" _col(53)"{text}|" _col(61)"{text}|" _col(69)"{text}|" %4.0f df2 _col(74)"{text}|"
	  noi di as text _dup(80) "-"
	  nl vbgfet `1' `2' `3' `4'
	  scalar rsset = e(rss)
	  matrix Pet = e(b)
	  scalar Liet1 = Pet[1,1]
	  scalar Ket1 = Pet[1,2]
	  scalar t0et = Pet[1,3]
	  scalar Liet2 = Pet[1,4]
	  scalar Ket2 = Pet[1,5]
	  scalar t0ets = "-" + string(t0et, "%6.3f")
	     if t0et*-1>0 {
		    scalar t0ets = "+" + string(abs(t0et), "%6.3f")
		 }
  	  scalar fcet=((rsset - rss1)/(df3))/(rss1/(df2))
	  scalar pvet = Ftail(df3, df2, fcet)
	  noi di as res "t01 = t02" _col(15)"{text}|" "l_t1="  %6.2f Liet1 "[1-exp{-" %6.3f Ket1 "(t" t0ets ")}]" _col(53)"{text}|" %6.2f rsset _col(61)"{text}|" %6.2f fcet _col(69)"{text}|" %4.0f df3 _col(74)"{text}|" %6.3f pvet
	  noi di as res _col(15)"{text}|" "l_t2="  %6.2f Liet2 "[1-exp{-" %6.3f Ket2 "(t" t0ets ")}]" _col(53)"{text}|" _col(61)"{text}|" _col(69)"{text}|" %4.0f df2 _col(74)"{text}|"
	  noi di as text _dup(80) "-"
   }
   end
