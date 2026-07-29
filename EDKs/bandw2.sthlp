{smcl}
{* *! version 1.0.0 24/jul2020}{...}
{hline}
{cmd:help bandw2}                                              [STB-27: snp6.2]
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:bandw2} {hline 2}}Bandwidth selection rules for univariate density estimators (Updated version){p_end}
{p2colreset}{...}

{title:Syntax}
{p 8 17 2}
{cmd:bandw2} {varname} {ifin} {cmd:,} {cmdab:k:code(}{it:#}{cmd:)}

{title:Description}

{pstd}{cmd:bandw2} calculates several data-based number of bins and binwidths-
bandwidths for histograms, frequency polygons, and kernel density estimators
(including ASH-WARPing estimators) for univariate data and reports the results
in a table. This is the updated version of {hi:bandw1}

{title:Options}

{phang}{opt kcode}({it:#}) is the code for the kernel (weight function):

	1 = Uniform
	2 = Triangle 
	3 = Epanechnikov
	4 = Quartic (Biweight)
	5 = Triweight
	6 = Gaussian (Default)
	7 = Cosine

{title:Remarks}

The implemented rules are as follows:
I Rules for number of bins
  a) Histograms
    1) Sturges' number of bins rule:
	 k = 1 + log2(n)
    2) Dixon & Kronmal number of lines:
	 k = 10 * ln(n)/ln(10)
    3) OS number of bins rule: (b = max; a = min)
	 (b - a)/h* >= (b - a) / hOS = (2n)^(1/3)
  b) Frequency polygons
    4) FP OS Number of bins rule:
	 (b - a)/h* >= ((147/2)*n)^(1/5)
II Rules for histogram bindwidth selection
    5) Scott's Normal bindwidth reference rule:
	 h = 3.5*sigma*n^(-1/3)
    6) Freedman-Diaconis robust binwidth rule:
	 h = 2(IQR)n^(-1/3)
    7) Oversmoothed (OS) binwidth:
	 h* <= (b - a) / (2n)^(1/3) = hOS
    8) OS homoscedastic rule:
	 h*<= 3.729*sigma*n^(-1/3) = hOS
    9) OS robust rule:
	 h* <= 2.603(IQR)n^(-1/3) = hOS
III Rules for FP binwidth selection
    10) FP Gaussian reference rule:
	 h = 2.15*sigma*n^(-1/5)
    11) FP OS rule:
      h <= (23,328/343)^(1/5) sigma*n^(-1/5) = 2.33*sigma*n^(-1/5) = hOS
IV Rules for kernel bandwidth selection (Gaussian kernel by default):
   12) Silverman's Normal bandwidth reference rule:
	 ho=0.9 min(sigma,IQR/1.349)n^(-1/5)
   13) Haerdle's Better rule of thumb:
	 ho = 1.06 min(sigma, IQR/1.349)n^(-1/5)
   14) Scott's (Gaussian) kernel oversmoothed bandwidth:
	 ho>=1.144*sigma*n^(-1/5)

   Bandwidths for other kernels are calculated using the conversion tables
   presented in Haerdle (1991), Scott (1992) and Salgado-Ugarte et al. (1995b).

All the rules based on the equations included in Silverman (1986), Fox (1990),
Haerdle (1991), Scott (1992; 2015) and Salgado-Ugarte (2002).


{title:Examples}

{phang}{stata "use bufsnow" :. use bufsnow}{p_end}

{phang}{stata "bandw1 snow" :. bandw snow}{p_end}

{phang}{stata "use bagtot" :. use bagtot}{p_end}

{phang}{stata "bandw1 bodlen if sex==1 in 1/100, k(2)" :. bandw1 bodlen if sex==1 in 1/100, k(2)}{p_end}


{title:References}

   Fox, J. (1990) Describing univariate distributions. In (Fox, J. &
        J.S. Long, Eds.) Modern Methods of Data Analysis. Sage
        Chapter 2: 58-125.
   Dixon, W. and R. A. Kronmal 1965. The choice of origin and scale for graphs. 
        Journal of the Association for Computing Machinery 12: 259–261.
   Haerdle, W. (1991) Smoothing Techniques with Implementation in S.
        Springer-Verlag Chapter 2: 43-84.
   Salgado-Ugarte, I.H. (2002) Suavizacion no parametrica para analisis de 
        datos. F.E.S. Zaragoza, U.N.A.M. Mexico. 139 p. [In Spanish]
   Salgado-Ugarte, I.H. (2013) Métodos Estadísticos Exploratorios y 
        Confirmatorios para Análisis de Datos. Un enfoque biométrico. DGAPA y
	FES Zaragoza, UNAM, México. 299 p.
   Salgado-Ugarte, I.H. (2017) Métodos Estadísticos Exploratorios y 
        Confirmatorios para Análisis de Datos. Un enfoque biométrico. DGAPA y
	FES Zaragoza, UNAM, México. Edición electrónica: 
        http://www.librosoa.unam.mx/handle/123456789/474   
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1993) snp6: Exploring
        the shape of univariate data using kernel density estimators. Stata 
        Technical Bulletin 16: 8-19.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1995a) snp6.1: ASH,
        WARPing, and kernel density estimation for univariate data. Stata
        Technical Bulletin 26: 23-31.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1995b) snp6.2: Practical
        rules for bandwidth selection in univariate density estimation. Stata
        Technical Bulletin 27: 5-19.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1997) snp6.13: 
		Nonparametric assessment of multimodality for univariate data. Stata
        Technical Bulletin 38: 27-36.
   Scott, D.W. (1992) Multivariate Density Estimation: Theory, Practice,
        and Visualization. John Wiley Chapter 6: 125-143.
   Scott, D.W. (2015) Multivariate Density Estimation: Theory, Practice,
        and Visualization. 2nd. ed. John Wiley Chapters 3-6: 51-216.
   Silverman, B.W. (1986) Density Estimation for Statistics and Data 
        Analysis. Chapman and Hall.

{title:Authors}

Original version:
Isaias H. Salgado-Ugarte, Makoto Shimizu and Toru Taniuchi
University of Tokyo, Faculty of Agriculture,
Department of Fisheries, Yayoi 1-1-1, Bunkyo-ku
Tokyo 113, Japan.(Fax 81-3-3812-0529)
Updated version:
Isaias H. Salgado-Ugarte & V. Mitsui Saito-Quezada;
Laboratorio de Biometria y Biologia Pesquera, 
Facultad de Estudios Superiores "Zaragoza" Campus II
Batalla 5 de mayo S/N esq. Fuerte de Loreto
Ejercito de Oriente, Iztapalapa, 09230, CDMX
Mexico City
e-mail: isalgado@unam.mx

{title:Also see}

{psee}
    STB: snp6 (STB-16); snp6.1 (STB-26); snp6.2 (STB-27); snp6.4 (STB-38)
{phang}On-line: {hi:help} for {help l2cvwarp}, {help bcvwarp}, {help varwiker}, {help varwike2}, {help warpdenm}, {help silvtest}
{p_end}