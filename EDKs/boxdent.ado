*! dentrace 1.00 13/05/99; revised 14/05/99
*boxdetra.ado 1.00  13/05/93 (STB-16: snp6)
* Isaias H. Salgado-Ugarte, Makoto Shimizu and Toru Taniuchi.
* Revised and updated version by Isaias H. Salgado-Ugarte
* Following suggestions by Nick Cox.
program define boxdent
   version 6.0
*This new version calculates a density trace of a series of
*values according to the Boxcar Weight function.
*Based on the procedure described in Chambers et al. (1983)
*"if" "in" selectors, "gen" option and graph added.

   #delimit ;
   syntax varlist(min=1 max=1) [if] [in]
   , Hval(real) [Gen(str) noGraph T1title(str) Symbol(str) 
   Connect(str) * ] ;
   #delimit cr
  
   local hv `hval'  
   tokenize `varlist'
   args xvar
   marksample touse
   qui count if `touse'
   if r(N) == 0 {error 2000}

   tempvar lowcut uppcut trace count
   quietly {

   summarize `xvar' if `touse', meanonly
   local nuobs = r(N)
   gen `lowcut'=`xvar'-`hv'/2
   gen `uppcut'=`xvar'+`hv'/2
   gen `trace'=0
   local count 1
   *set more 1
   *noi di "WORKING WITH EACH VALUE. PLEASE BE PATIENT"
   while `count'<=_N {
     *noi di "Calculating f(y) number = " `count'
     summ `xvar' if (`xvar'>=`lowcut'[`count'] & `xvar'<`uppcut'[`count']) & `touse', meanonly
     replace `trace'= r(N)/(`hv'*`nuobs') if _n==`count' 
     local count=`count'+1
    }

    label variable `trace' "Density trace"
    _crcslbl `xvar' `1'
    
    if "`graph'" ~= "nograph"  {

       if "`t1title'" =="" {
           local t1title "Boxcar Density trace"
           local t1title "`t1title', h = `hv'"
       }
       if "`symbol'" == "" { local symbol "." }
       if "`connect'" == "" { local connect "l" }
    graph `trace' `xvar' if `touse', sort `options' /*
       */ t1("`t1title'") s(`symbol') c(`connect')
    }


    if "`gen'" ~= "" {
	capture restore, not 
        tokenize `gen'
        gen `1' = `trace'
     }


  }

end
