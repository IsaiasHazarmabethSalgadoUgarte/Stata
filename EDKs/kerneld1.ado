*! version 3.1 por Isaias H. Salgado-Ugarte, Makoto Shimizu
*! and Toru Taniuchi,University of Tokyo, Faculty of
*! Agriculture, Dept. of Fisheries (Fax 81-3-3812-0529)
*! version 11.0 modificada por Nestor A. Mosqueda Romo 01-02-2011
*! updated by Salgado-Ugarte, I.H. & V.M. Saito-Quezada, 26/03/2020; 
*! 18/04/2020, 07/08/2020; 08/08/2020
program define kerneld1
    version 11.0
*    syntax varlist(max=1 numeric) [if] [in] , Bwidth(real) Kercode(int) [NPoint(int 50) MSymbol(string) Connect(string) Gen(string) noGraph graph_options]
    local varlist "req ex min(1) max(1)"
    local if "opt"
    local in "opt"
    #delimit ;
    local options "Bwidth(real 0) Kercode(integer 0) NUMOdes MOdes NUAMOdes AMOdes NPoint(integer 50) T1title(string) MSymbol(string) Connect(string) Gen(string) noGraph graph_options *";
    #delimit cr
    parse "`*'"
    parse "`varlist'", parse(" ")
    quietly {
    tempvar xvar
    gen `xvar'=`1' `if' `in'
    drop if `xvar'==.
    if `xvar'[1]==. {
       di in red "no observations"
       exit
    } /* modificado */
    local hv=`bwidth'
    local kc=`kercode'
    local np=`npoint'
    if `np'>_N { /* modificado */
         set obs `np'
    } /* modificado */
    if `hv'==0 {
         di in red "you must provide the bandwidth"
         exit
    } /* modificado */
    if `kc'==0 {
         di in red "you must provide the kernel code"
         exit
    } /* modificado */
    if `kc'>7 {
         di in red "invalid choice of kernel"
         exit
    } /* modificado */ 
    if `np'==0 {
         di in red "you must provide the number of grid points (n>=50 suggested)
         exit
    } /* modificado */
      tempvar fkx xo z kz sums
      gen `fkx'=0
      local count=1
      gen `xo'=0
      gen `sums'=0
      gen `z'=0
      gen `kz'=0
      tempvar maxval minval range inter midval
      summ `xvar'
      local nuobs= r(N) /* modificado */
      local maxval= r(max)+`hv'+(( r(max)- r(min))*0.1) /* modificado */
      local minval= r(min)-`hv'-(( r(max)- r(min))*0.1) /* modificado */
      local range=`maxval'-`minval'
      local inter=`range'/`np'
      gen `midval'=sum(`inter')+`minval'+`inter'/2
    *!  set more 1 /* modificado */
    *!  noi di as result "WORKING WITH EACH VALUE. PLEASE BE PATIENT" /* modificado */
      while `count'<=`np' {
    *!    noi di "Calculating fk(x) number = " `count' /* modificado */
        replace `xo'=`midval'[`count']
        replace `z'=(`xo'-`xvar')/`hv'
        if `kc'==1 {
            replace `kz'=0.5 if abs(`z')<=1
        }
        else if `kc'==2 {
            replace `kz'=(1-abs(`z')) if abs(`z')<=1
        }
        else if `kc'==3 {
            replace `kz'=(3/4)*(1-`z'^2) if abs(`z')<=1
        }
        else if `kc'==4 {
            replace `kz'=(15/16)*((1-`z'^2))^2 if abs(`z')<=1
        }
        else if `kc'==5 {
            replace `kz'=(35/32)*(1-`z'^2)^3 if abs(`z')<=1
        }
        else if `kc'==6 {
            replace `kz'=(1/(sqrt(2*_pi)))*exp(-0.5*`z'^2) if abs(`z')<=3
        }
        else {
            replace `kz'=(_pi/4)*cos((_pi/2)*`z') if abs(`z')<=1
        }
        replace `sums'= sum(`kz')
        replace `fkx'=(1/(`nuobs'*`hv'))*`sums'[_N] if _n==`count'
        replace `kz'=0
        local count = `count'+1
      }
      replace `fkx'=. if _n>`np'
      replace `midval'=. if _n>`np'
      set more 0
      label var `fkx' "Density"
      label var `midval' "Midpoints"
        if "`graph'" != "nograph"  { /* modificado */
           if "`t1title'" ==""{
              local t1title "Kernel Density Estimation"
              local t1title "`t1title', bw = `hv', k = `kc', npoints = `np'"
           }
           if "`msymbol'"=="" { /* modificado */
                  local msymbol "i" /* modificado */
           } /* modificado */
           if "`connect'"=="" { /* modificado */
                  local connect "l" 
           } /* modificado */
          scatter `fkx' `midval', `options' /* /* modificado */
	    			*/ t1("`t1title'") /*
		    		*/ ms(`msymbol') c(`connect') /* modificado */
        } 

		    if "`numodes'"!="" { /* modified */
       tempvar difvar inmo sumo
       gen `difvar'=`fkx'[_n+1] - `fkx'[_n]
       gen `inmo' = 0
       replace `inmo'=1 if `difvar'[_n]>=0 & `difvar'[_n+1] < 0
       gen `sumo' = sum(`inmo')
       local numo= `sumo'[_N]
       noi di as text _newline " Number of modes = " as res `numo'
   }
   if "`modes'"!="" { /* modified */
      tempvar modes
      gen `modes'=.
      replace `modes'=`midval' if `inmo'[_n-1]==1
      sort `modes'
      local i = 1
      noi di as text _newline _dup(75) "_"
      local title " Modes in WARPing density estimation"
      noi di as text "`title'" as text", bw = " as res `hv' as text ", M = " as res `mv' as text ", Ker = " as res `kc'
      noi di as text _dup(75) "-"
   while `i'<`numo'+1 {
      noi di as text " Mode ( " %4.0f as res `i' as text " ) = " %12.4f as res `modes'[`i']
      local i = `i'+1
   }
   noi di as text _dup(75) "_"
   sort `midval'
   }
   
    if "`nuamodes'"~="" {
   tempvar difvar inamo suamo index
   gen `difvar'=`fkx'[_n+1] - `fkx'[_n]
   gen `inamo' = 0
   replace `inamo'=1 if `difvar'[_n]<=0 & `difvar'[_n+1] > 0
   gen `index'=_n if `fkx'!=.           /* modified */
   replace `inamo'=0 if `index'==1      /* modified */
   replace `inamo'=0 if `index'==`np'-1   /* modified */
   gen `suamo' = sum(`inamo')
   local nuamo= `suamo'[_N]
   noi di as text _newline " Number of antimodes = " as res `nuamo'
   }
   
   if "`amodes'"~="" {
   tempvar amodes
   gen `amodes'=.
   replace `amodes'=`midval' if `inamo'[_n-1]==1 
   sort `amodes'
   local i = 1
   noi di as text _newline _dup(75) "_"
   local title " Antimodes in WARPing density estimation"
   noi di as text "`title'" as text ", bw = " as res `hvlab' as text ", M = " as res `mv' as text ", Ker = " as res `kc'
   noi di as text _dup(75) "-"
   while `i'<`nuamo'+1 {
      noi di as text " Antimode ( " %4.0f as res `i' as text " ) = " %12.4f as res `amodes'[`i']
      local i = `i'+1
      }
   noi di as text _dup(75) "_"
   sort `midval'
   }
		
		if "`gen'"!="" { /* modificado */
         parse "`gen'", parse(" ")  
         gen `1'=`fkx'
         gen `2'=`midval'
      }
    }
    end
