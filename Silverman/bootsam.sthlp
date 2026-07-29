{smcl}
{* *! version 1.0.0 30/marzo2026}{...}
{hline}
{cmd:help bootsam}                                              [STB-38: snp13]
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:bootsam} {hline 2}}Bootstrap sample generator for Silverman multimodality test{p_end}
{p2colreset}{...}

{title:Syntax}
{p 8 17 2}
{cmd:boot bootsam} {varname} {cmd:,} {cmdab:k:code(}{it:#}{cmd:)}

{title:Description}

{pstd}{cmd:bandw1} bootsam in conjunction with Stata boot comand bootstrap samples adjusted according with the suggestions of Silverman (1981; 1983) implemented in Salgado-Ugarte (2002) and Salgado-Ugarte & Saito-Quezada (2020). The adjust consists in the introduction of a gaussian random value with the original sample standard deviation as a reference. The later to assure that the bootstrap samples mantain approximatelly the same variance than that of the original data set. This command combination produces two new variables "ysm" (the adjusted values of the bootstrap samples) and "_rep" (sample identificator). Besides the original data and its size repeated as many times as the iterations number. These last variables are of no use so they are leaving out of the test by the command "keep ysm _rep". In this way we are ready to perform the Silverman multimodality test.

{title:Options}

{phang}{opt arg(varname cbw)}({it:#}) are the function arguments and must be written: the variable to analyze and the critical bandwidth for the number of modes to test:

{phang}{opt iterate}({it:#}) permits to establish the number of bootstrap samples to be generated

{title:Remarks}


arg and iterate are not optional. If the use do not enter them the program halts
and display an error message. When executed these programs show the warning 
that the data in memory will be lost to be replaced by the results. Once 
obtained the results must be used for the multimodality test and taking note of
the results. The saving of the bootstrap samples is recommended in order to be 
able to repeat the analysis. To continuing with the analysis, the original data 
set is recalled (erasing the bootstrap samples previously obtained) and the 
sequence of steps is repeated: establishing a different seed, keeping ysm and 
_rep and performing the Silveman test for each of the critical bandwidths of 
the number of modes to be tested.


{title:Examples}

{phang}{stata "use silica" :. use silica}{p_end}

{phang}{stata "set seed 12345" :. set seed 12345}{p_end}

{phang}{stata "boot bootsam, arg(silica 2.4) iterate(100)" :. boot bootsam, arg(silica 2.4) iterate(100)}{p_end}

{phang}{stata "keep ysm _rep" :. keep ysm _rep}{p_end}

{pstd}100 bootstrap samples are obtained to test the critical bandwidth (previously obtained by critiband) for one mode of the chondrite daata (Silverman, 1982; Scott, 1992).

{pstd}After the test with silvtest, the original data set must be recalled and to repeat the sequence of analysis steps for the next critical bandwidth:

{phang}{stata "use silica, clear" :. use silica, clear}{p_end}

{phang}{stata "set seed 12347" :. set seed 12347}{p_end}

{phang}{stata "boot bootsam, arg(silica 1.83) iterate(100)" :. boot bootsam, arg(silica 1.83) iterate(100)}{p_end}


{pstd}And so, consecutively 

{title:References}

   Izenman, A.J. and Sommer (1988) Philatelic mixtures and multimodal densities.
	Journal of the American Statistical Association, 83(404): 941-953.
   Salgado-Ugarte, I.H. (2002) Suavizacion no parametrica para analisis de 
	datos. F.E.S. Zaragoza, U.N.A.M. Mexico. 139 p. [In Spanish]
   Salgado-Ugarte, I.H. and V.M. Saito-Quezada (2020) Métodos cuantitativos 
	computarizados para Biología Pesquera. DGAPA & FES Zaragoza, UNAM, 
	México: 487 p.
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
   Silverman, B.W. (1981) Using kernel density estimates to investigate 
	multimodality. Journal of the Royal Society, B, 43: 97-99.
   Silverman, B.W. (1983) Some properties of a test for multimodality baed on 
	kernel density estimates. In: J.F.C. Kingman & G.E.H. Reuter (Eds.) 
	Probability, Statistics and Analysis: 248-259. Cambridge University 
	Press, Cambridge.
   Silverman, B.W. (1986) Density Estimation for Statistics and Data 
	Analysis. Chapman and Hall.

{title:Authors}

Isaias H. Salgado-Ugarte & V. Mitsui Saito-Quezada
Laboratorio de Biometria y Biologia Pesquera, 
Facultad de Estudios Superiores "Zaragoza" Campus II
Batalla 5 de mayo S/N esq. Fuerte de Loreto
Ejercito de Oriente, Iztapalapa, 09230, CDMX
Mexico City
Iztapalapa 09340 CDMX Mexico City.
(Fax 55-5-773-6336; 55-5-804-4688)
e-mail: isalgado@unam.mx


{title:Also see}

{psee}
    STB: snp6 (STB-16); snp6.1 (STB-26); snp6.2 (STB-27); snp13 (STB-38)
{phang}On-line: {hi:help} for {help l2cvwarp}, {help bcvwarp}, {help varwiker}, {help varwike2}, {help warpdenm}, {help silvtest}
{p_end}