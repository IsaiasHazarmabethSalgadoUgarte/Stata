*! version 1.0 11-09-98
program define bhataplt1
 version 11.0
*Last uptdate: 13-09-98; 28-02-2020
*Author: Isaías Hazarmabeth Salgado-Ugarte
*This program calculate logaritmic differences and draw the Bhathacharya's
*plot using the observation's numbers as plotting symbols in order to 
*define the points definning negatively sloped lines, which represent
*individual gaussian components.
*This routine is a new version integrating two previous simple programs
*diflogen.ado and bhatplot.ado.
*Updated to more recent Stata version
*
local varlist "req ex min(2) max(2)"
local if "opt"
local in "opt"
#delimit ;
local options "Gen(string) noGraph T1title(string) Symbol(string) 
      Connect(string) *";
#delimit cr
parse "`*'"
parse "`varlist'", parse(" ")
*
*Logarithmic differences routine
quietly {

tempvar logfreq laglog diflog index
 gen `logfreq'=log(`1')
 gen `laglog'=`logfreq'[_n+1]
 gen `diflog'=`laglog'-`logfreq'
 gen `index' = _n
*
*Bhathacharya´s plot routine
*prelimanarly calculations

      tempvar touse 
      gen byte `touse'=0
      replace `touse'=1 `in' 
      }

* graphic routine
    if "`graph'" ~= "nograph"  {
       if "`t1title'" ==""{
          local t1title "Bhattacharya´s plot"
          }
       if "`msymbol'"=="" { 
	      local msymbol "i" 
	   }
       if "`connect'"=="" { 
	      local connect "i" 
	   }
	   if "`mlab'"=="" { 
	      local mlab "`index'"
	   }
       if "`mlabpos'"=="" { 
	      local mlabpos "0"
	   }
	   label var `diflog' "Logarithmic differences"
       scatter `diflog' `2' if `touse', `options' /*
    	*/ t1("`t1title'") ms("`msymbol'") c("`connect'") /*
		*/ mlab("`mlab'") mlabpos("`mlabpos'")
   } 

 if "`gen'"~="" {
    rename `diflog' `gen'
 }

end

