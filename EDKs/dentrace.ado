*! dentrace 1.00 IHSU 13/05/99
* boxdetr2 and cosdetra 1.00 12/07/93
* Isaias H. Salgado-Ugarte, Makoto Shimizu and Toru Taniuchi.
* Revised and updated version by Isaias H. Salgado-Ugarte
* Following suggestions by Nick Cox.
program define dentrace
   version 6.0
*This program calculates a density trace of a  
*series of values according to the Boxcar and Cosine Weight functions.
*Based on the procedure described in Chambers, et al. (1983)
*considering a number equally spaced points (default = 50).
*Weight function codes: 1 = boxcar; 2 = cosine
   #delimit ;
   syntax varlist(min=1 max=1) [if] [in]
   , Hval(real) Fcode(int) [NPoint(int 50) Gen(str) noGraph 
     T1title(str) Symbol(str) Connect(str) * ] ;
   #delimit cr

if `fcode' < 1 | `fcode' > 2 {
                di in r "weight function code should be between 1 and 7"
                exit 198 
        }

        local fc `fcode'
        local hv `hval'
        local np `npoint'

   if "`npoint'"~="" {
        local np = `npoint'
   }

   tokenize `varlist'
   args xvar
   marksample touse
   qui count if `touse'
   if r(N) == 0 {error 2000}

tempvar fwy yo u wu sums  
quietly {
        if `np' >_N { 
	  preserve
	  set obs `np' 
        }

  summarize `xvar' if `touse'
  local nuobs = r(N)
  gen `fwy'=0
  local count=1
  gen `yo'=0
  gen `sums'=0
  gen `u'=0
  gen `wu'=0

  tempvar midval
  local maxval = r(max)
  local minval = r(min)
  local range = `maxval' - `minval'
  local inter = `range'/(`np' - 1)
  gen `midval'=sum(`inter') + `minval' - `inter' 

  while `count' <= `np' {
    replace `yo'=`midval'[`count']
    replace `u'=(`yo'-`xvar')/`hv'
       if `fcode' == 1 {
          replace `wu'=1 if abs(`u')<0.5 & `touse'
          }
       else {
          replace `wu'=1 + cos(2*_pi*`u') if abs(`u')<0.5 & `touse'
       }
    replace `sums'= sum(`wu')
    replace `fwy'=(1/(`nuobs'*`hv'))*`sums'[_N] if _n==`count'
    replace `wu'=0
    local count=`count'+1
  }
  if `np' < _N {
    replace `fwy'=. if _n> `np'
    replace `midval'=. if _n>`np'
  }

    _crcslbl `xvar' `1'

    if "`graph'" ~= "nograph"  {

       if "`t1title'" =="" {
          if `fcode' == 1 {
              local t1title "Boxcar density trace"
              local t1title "`t1title', h = `hv', np = `np'"
          }
          else {
              local t1title "Cosine density trace"
              local t1title "`t1title', h = `hv', np = `np'"
          }

       if "`symbol'" == "" { local symbol "." }
       if "`connect'" == "" { local connect "l" }

    label variable `fwy' "Density trace"
    label variable `midval' "Midpoints"

    graph `fwy' `midval', `options' /*
       */ t1("`t1title'") s(`symbol') c(`connect')
    }

    if "`gen'" ~= "" {
       capture restore, not 
       tokenize `gen'
       gen `1' = `fwy'
       gen `2' = `midval'
    }
        }
end

