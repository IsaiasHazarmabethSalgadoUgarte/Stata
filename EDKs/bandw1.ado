*! version 2.00 01/01/2018        STB-27: snp6.2 (94/10/24)
program bandw1, rclass
   version 13.0
*Authors: Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi.
*Based on bandw.ado, First written: 94/10/24 (version 1.00); revised 2003/03/16
*Version 2.00 written 2018/01/01
*This program calculates several "optimal" number of bins and
*binwidths-bandwidths for kernel density estimators for univariate
* data according to the following expressions: 
*I Rules for number of bins
*a) Histograms
* 1) Sturges' number of bins rule: k = 1 + log2(n)
* 2) OS number of bins rule: (b - a)/h* >= (b-a)/hOS = (2n)^1/3
*b) Frequency polygons
* 3) FP OS Number of bins rule: (b - a)/h* >= ((147/2)*n)^1/5
*II Rules for histogram bindwidth selection
* 4) Scott's Normal bindwidth reference rule: h = 3.5*sigma*n^-1/3
* 5) Freedman-Diaconis robust binwidth rule: h = 2(IQ)n^-1/3
* 6) Oversmoothed (OS) binwidth: h* <= (b - a)/(2n)^1/3 = hOS
* 7) OS homoscedastic rule: h*<= 3.729*sigma*n^-1/3 = hOS
* 8) OS robust rule: h* <= 2.603(IQ)n^-1/3 = hOS
*III Rules for FP binwidth selection
* 9) FP Gaussian reference rule: h = 2.15*sigma*n^-1/5
* 10) FP OS rule: h <= (23,328/343)^1/5 sigma*n^-1/5 = 2.33*sigma*n^-1/5 = hOS
*IV Rules for kernel bandwidth selection. This new version transform the bandwidth
*according to the selected kernel function following tables presented in
*Haerdle (1990), Scott (1992) and Salgado-Ugarte (2002).
* 1 = Uniform
* 2 = Triangle 
* 3 = Epanechnikov
* 4 = Quartic (Biweight)
* 5 = Triweight
* 6 = Gaussian
* 7 = Cosine
* 11) Silverman's Normal bandwidth reference rule: ho=0.9 min(sigma,IQ/1.349)n^-1/5
* 12) Haerdle's Better rule of thumb: ho = 1.06 min(sigma, IQ/1.349)n^-1/5
* 13) Scott's (Gaussian) kernel oversmoothed bandwidth: ho>=1.144*sigma*n^-1/5
*Based on the equations included in Fox (1990), Silverman (1986),
*Haerdle (1991) and Scott (1992)
 
 syntax varlist(max=1 numeric) [if] [in] , [Kercode(int 6)] /* modificado */
 local kc `kercode'
 tokenize `varlist'
 args xvar
 marksample touse
 quietly count if `touse'
 if r(N) == 0 { /* modificado */
        error 2000 /* modificado */
 } /* modificado */
 quietly {
 summ `xvar' if `touse', detail
 local nuobs= r(N)
 local maxval= r(max)
 local minval= r(min)
 local sigma= r(sd)
 lv `xvar' if `touse'
 local iqr= r(u_F) - r(l_F)
 local psigma= `iqr'/1.349
 local ks=1 + log(`nuobs')/log(2)
 local osb= (2*`nuobs')^(1/3)
 local fposb=((147/2)*`nuobs')^(1/5)
 local hs= 3.5*`sigma'*`nuobs'^(-1/3)
 local hfd= 2*(`iqr')*`nuobs'^(-1/3)
 local osht= (`maxval'-`minval')/`osb' /*((2*`nuobs')^(1/3)) */
 local osuv= 3.729*`sigma'*`nuobs'^(-1/3)
 local osr= 2.603*`iqr'*`nuobs'^(-1/3)
 local fpg= 2.15*`sigma'*`nuobs'^(-1/5)
 local fpos=2.33*`sigma'*`nuobs'^(-1/5)
 local hsv= 0.9*min(`sigma',`psigma')*`nuobs'^(-1/5)
 local hh= 1.06*min(`sigma',`psigma')*`nuobs'^(-1/5)
 local osh=1.144*`sigma'*`nuobs'^(-1/5)
 if `kc' != 6 {
         if `kc'==1 {
                 local hsv= `hsv'*1.74
                 local hh = `hh' *1.74
                 local osh= `osh'*1.74
         }
         else if `kc'==2 {
                 local hsv= `hsv'*2.432
                 local hh = `hh' *2.432
                 local osh= `osh'*2.432
         }
         else if `kc'==3 {
                 local hsv= `hsv'*2.214
                 local hh = `hh' *2.214
                 local osh= `osh'*2.214
         }
         else if `kc'==4 {
                 local hsv= `hsv'*2.623
                 local hh = `hh' *2.623
                 local osh= `osh'*2.623
         }
         else if `kc'==5 {
                 local hsv= `hsv'*2.978
                 local hh = `hh' *2.978
                 local osh= `osh'*2.978
         }
         else if `kc'==7 {
                 local hsv= `hsv'*2.288
                 local hh = `hh' *2.288
                 local osh= `osh'*2.288
         }
 }
 }
 display as text _dup(60) "_"
 display as text "Some practical number of bins and binwidth-bandwidth rules"
 display as text "for univariate density estimation using histograms,"
 display as text "frequency polygons (FP) and kernel density estimators"
 display as text _dup(60) "="
 display _newline as text "Sturges' number of bins = " as res _col(50) %8.4f `ks'
 display as text "Oversmoothed number of bins <= " as res _col(50)%8.4f `osb'
 display as text _dup(60) "-"
 display as text "FP oversmoothed number of bins <= " as res _col(50)%8.4f `fposb'
 display as text _dup(60) "="
 display _newline as text "Scott's optimal Gaussian binwidth = " as res _col(50)%8.4f `hs'
 display as text "Freedman-Diaconis optimal robust binwidth = " as res _col(50)%8.4f `hfd'
 display as text"Terrell-Scott's oversmoothed binwidth >= " as res _col(50)%8.4f `osht'
 display as text "Oversmoothed homoscedastic binwidth >= " as res _col(50)%8.4f `osuv'
 display as text "Oversmoothed robust binwidth >= " as res _col(50)%8.4f `osr'
 display as text _dup(60) "-"
 display as text "FP optimal Gaussian binwidth = " as res _col(50)%8.4f `fpg'
 display as text "FP oversmoothed binwidth >= " as res _col(50)%8.4f `fpos'
 display as text _dup(60) "="
 if `kc' == 1 {
         local kerfun=`"Uniform kernel (1)"'
         display _newline `"`kerfun'"'
         }
 else if `kc'==2 {
         local kerfun=`"Triangular kernel (2)"'
         display as res _newline `"`kerfun'"'
         }
 else if `kc'==3 {
         local kerfun=`"Epanechnikov kernel (3)"'
         display as res _newline `"`kerfun'"'
         }
 else if `kc'==4 {
         local kerfun=`"Quartic kernel (4)"'
         display as res _newline `"`kerfun'"'
         }
 else if `kc'==5 {
         local kerfun=`"Triweight kernel (5)"'
         display as res _newline `"`kerfun'"'
         }
 else if `kc'==6 {
         local kerfun=`"Gaussian kernel (6)"'
         display as res _newline `"`kerfun'"'
         }
 else if `kc'==7 {
         local kerfun=`"Cosine kernel (7)"'
         display as res _newline `"`kerfun'"'
         }
 display as text _dup(60) "="
 display as text "Silverman's optimal bandwidth = " as res _col(50)%8.4f `hsv'
 display as text "Haerdle's 'better' optimal bandwidth = " as res _col(50)%8.4f `hh'
 display as text "Scott's oversmoothed bandwidth = " as res _col(50)%8.4f `osh'
 display as text _dup(60) "_"
 ret scalar nbin_St = `ks'
 ret scalar nbin_os = `osb'
 ret scalar nbinfp_os = `fposb'
 ret scalar binw_oSc = `hs'
 ret scalar binw_oFD = `hfd'
 ret scalar binw_osTSc = `osht'
 ret scalar binw_oshsd = `osuv'
 ret scalar binw_osrob = `osr'
 ret scalar binw_ofp = `fpg'
 ret scalar binw_osfp = `fpos'
 ret local kernel = `"`kerfun'"'
 ret scalar bandw_oS = `hsv'
 ret scalar bandw_oH = `hh'
 ret scalar bandw_os = `osh'
end
