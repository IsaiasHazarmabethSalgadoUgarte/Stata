{smcl}
{* *! version 1.0.0 25/jul2020}{...}
{hline}
{cmd:help warpregpy}                                [STB-30: snp10 (original version)]
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:warpregpy} {hline 2}}WARPing kernel regression (Nadaraya-Watson estimator)
 (Python script version){p_end}
{p2colreset}{...}

{title:Syntax}
{p 8 17 2}
{cmd:warpregpy} xvar yvar {ifin} {cmd:,} {cmdab:b:width(}{it:#}{cmd:)}
{cmdab:m:val(}{it:#}{cmd:)}
{cmdab:k:ercode(}{it:#}{cmd:)}
{cmdab:so:rt}
[{cmdab:g:en(}{it:cvval mval hval}{cmd:)}
{cmdab:nog:raph}
{cmd:graph_options}]


{title:Description}

{pstd}{cmd:warpegpy} calculates the WARPing approximation of the Nadaraya-Watson
estimate using ado and a Python script files for WARPing kernel regression estimation. 
As a default this command draws the graph of the estimated conditional mean over the 
midpoints used for calculation connected by a line without any symbol.

{title:Options}

{phang}{opt bwidth}({it:#}) specifies the smoothing parameter (bandwidth or halfwidth) of 
     the kernel regression estimation. 

{phang}{opt mval}({it:#}) is a nuisance parameter equivalent to the number of averaged
     shifted histograms used to calculate the required density estimations. 

{phang}{opt kercode}({it:#}) specifies the weight function (kernel) to calculate the required 
     univariate densities according to the following numerical codes:

	1 = Uniform
 	2 = Triangle 
 	3 = Epanechnikov
 	4 = Quartic (Biweight)
 	5 = Triweight
 	6 = Gaussian

{phang}{opt sort} is used to indicate that the data have been sorted by x (carrying y) to save
     time in repeated estimations.

{phang}{opt gen}({it:mhvar midvar}) permits to create two variables containing 
     respectively the estimated regression (conditional mean) values and the 
     corresponding midpoints used for calculation.

{phang}{opt nograph} suppresses the graph drawing

{phang}{opt graph_options} are any of the options allowed with {hi:graph, twoway}.


{title:Remarks}

{hi:b}width, {hi:m}val, and {hi:k}ercode, are not optional. If the user does not
provide them, the program halts and displays an error message on screen.

This program uses ado files (Salgado-Ugarte, et al. 1996) and a Python script 
file for the estimation of kernel regression. These procedures are based on the
algorithms and programs provided by Haerdle (1991), Scott (1992; 2015) and 
Salgado-Ugarte (1995; 2002).

The "smoothness" of the resulting estimate can be regulated by changing the
bandwidth: wide intervals produce smooth results; narrow intervals give noiser
results.

Except for the Gaussian kernel all the functions are supported on [-1,1].

As {hi:m}val increases, the approximation is closer to the true kernel estimation,
but the quantity of calculation increases too. A good compromise is to use an
{hi:m}val around 10 (Haerdle, 1991).

This procedure can be regarded as a descriptive smoother of scatterplots
besides a nonparametric regression estimator (Nadaraya-Watson).


{title:Examples}

{phang}{stata "use geyser" :. use geyser}{p_end}

{phang}{stata "warpregpy wait dura, bwidth(0.65) mval(10) kercode(4)" :. warpregpy wait dura, bwidth(0.65) mval(10) kercode(4)}{p_end}

Will display the Nadaraya-Watson estimation for {hi:wait} and {hi:dura} using a
smoothing parameter of 0.65, a number of 10 averaged shifted estimations, and
the Quartic (biweight) kernel.

{phang}{stata "use motcyc" :. use motcyc}{p_end}

{phang}{stata "warpregpy accel time, b(2.4) m(10) k(4) gen(m2p4 mid2p4) nog" :. warpregpy accel time, b(2.4) m(10) k(4) gen(m2p4 mid2p4) nog}{p_end}

Will calculate the Nadaraya-Watson estimate for {hi:accel} and {hi:time} using a
bandwidth of 2.4, 10 averaged shifted estimations, the Quartic weight function,
and will create two variables with the resulting conditional mean values (m2p4)
and midpoints (mid2p4) without any graphical display.


{title:References}

   Haerdle, W. (1991) Smoothing Techniques with Implementation in S.
        Springer-Verlag Chapter 2: 43-84; Chapter 5: 121-149.
   Salgado-Ugarte, I.H. (1995) Nonparametric methods for fisheries data analysis
        and their application in conjunction with other statistical techniques
        to study biological data of the Japanese sea bass {it:Lateolabrax japonicus}
        in Tokyo Bay. PhD thesis, University of Tokyo, Japan: 389 p.
   Salgado-Ugarte, I.H. (2002) Suavización no paramétrica para análisis de datos.
        DGAPA y FES Zaragoza, UNAM, México: 139 p.  
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1993) snp6: Exploring
        the shape of univariate data using kernel density estimators. Stata 
        Technical Bulletin 16: 8-19.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1995a) snp6.1: ASH,
        WARPing, and kernel density estimation for univariate data. Stata
        Technical Bulletin 26: 23-31.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1995b) snp6.2: Practical
        Rules for bandwidth selection in univariate density estimation. Stata
       Technical Bulletin 27: 5-19.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1996) snp10: Nonparametric 
        regression: Kernel, WARP and k-NN estimators. Stata Technical Bulletin 
	30: 15-30.
   Scott, D.W. (1992) Multivariate Density Estimation: Theory, Practice,
        and Visualization. John Wiley Chapter 6: 125-143; Chapter 8: 219-245.
   Silverman, B.W. (1986) Density Estimation for Statistics and Data 
        Analysis. Chapman and Hall.

{title:Authors}

Original version:
Isaias H. Salgado-Ugarte, Makoto Shimizu and Toru Taniuchi
University of Tokyo, Faculty of Agriculture,
Department of Fisheries, Yayoi 1-1-1, Bunkyo-ku
Tokyo 113, Japan.(Fax 81-3-3812-0529)
Updated version:
Isaías H. Salgado-Ugarte & V. Mitsui Saito-Quezada
Colaborators (Python): N.I. Plascencia-Díaz & M.M. Salgado-Saito
Laboratorio de Biometría y Biología Pesquera
Facultad de Estudios Superiores Zaragoza
Universidad Nacional Autónoma de México
isalgado@unam.mx

{title:Also see}

{psee}

    STB: snp6 (STB-16); snp6.1 (STB-26); snp6.2 (STB-27); snp6.4 (STB-38); 
	snp10 (STB-30)
{phang}On-line: {hi:help} for {help kernreg}, {help gwarprpy}, {help warpdenpy}
{p_end}