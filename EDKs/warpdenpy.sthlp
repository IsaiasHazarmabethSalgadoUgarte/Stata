{smcl}
{* *! version 1.0.0 24/jul2020}{...}
{hline}
{cmd:help warpdenpy}                                [STB-27: snp6.2 (original version)]
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:warpdenpy} {hline 2}}Kernel density estimation (Python script version){p_end}
{p2colreset}{...}

{title:Syntax}
{p 8 17 2}
{cmd:warpdenpy} {varname} {ifin} {cmd:,} {cmdab:b:width(}{it:#}{cmd:)}
{cmdab:m:val(}{it:#}{cmd:)}
{cmdab:k:ercode(}{it:#}{cmd:)}
[{cmdab:st:ep}
{cmdab:nos:ort}
{cmdab:g:en(}{it:denvar midvar}{cmd:)}
{cmdab:nog:raph}
{cmd:graph_options}]

{title:Description}

{pstd}{cmd:warpdenpy} estimates univariate density by means of the 
ASH-WARPing procedure (Scott, 1985, 1992; Haerdle, 1991) and draws the result.

{title:Options}

{phang}{opt bwidth}({it:#}) is the smoother parameter {it:h} (binwidth for histograms,
     frequency polygons and averaged shifted histograms or FP-ASH; bandwidth
     for kernel density estimators)

{phang}{opt mval}({it:#}) is the number of averaged shifted histograms used to calculate
    the required density estimations. 

{phang}{opt kercode}({it:#}) specifies the weight function (kernel) to calculate the 
     univariate densities according to the following numerical codes:

	1 = Uniform
 	2 = Triangle 
 	3 = Epanechnikov
 	4 = Quartic (Biweight)
 	5 = Triweight
 	6 = Gaussian

{phang}{opt step} is included to draw the step (histogram like) version. The default is 
     the linear interpolated (polygon) version.

{phang}{opt nosort} is used to indicate that the data have been sorted by varname (to save
     time in repeated estimations).

{phang}{opt gen}({it:denvar midvar}) permits to create two variables containing 
     respectively the estimated density and the corresponding midpoints
     used for calculation.

{phang}{opt nograph} suppresses the graph drawing

{phang}{opt graph_options} are any of the options allowed with {cmd:graph, twoway}.


{title:Remarks}

{hi:bwidth}, {hi:mval}, and {hi:kercode}, are not optional. If the user does not
provide them, the program halts and displays an error message on screen.

This program uses a Python script file (indicated by the "py" termination)
based on the programs for density estimation presented in Salgado-Ugarte, et al. 
(1993) which in turn are adapted versions of the algorithms and programs 
provided by Haerdle (1991) and Scott (1992). As in the original program, in 
the present implementation all the parameters and results transference is 
automatic without any additional input by the user.

The "smoothness" of the resulting estimate can be regulated by changing the
bandwidth: wide intervals produce smooth results; narrow intervals give noiser
results.

Except for the Gaussian all the weight functions are supported on [-1,1].

As {opt mval} increases, the approximation is closer to the true kernel estimation,
but the quantity of calculation increases too. A good compromise is to use an
{opt mval} around 10 (Haerdle, 1991).

This procedure can be regarded as a descriptive smoother of histograms
besides a nonparametric density estimator.

{title:Examples}

  
{phang}{stata "use bufsnow" :. use bufsnow}{p_end}

{phang}{stata "warpdenpy snow, bwidth(10) mval(1) kercode(2) step" :. warpdenpy snow, bwidth(10) mval(1) kercode(2) step}{p_end}

{pstd}Will display a histogram for {hi:snow} using a bindwidth of 10.

{phang}{stata "warpdenpy snow, b(10) m(1) k(2)" :. warpdenpy snow, b(10) m(1) k(2)}{p_end}

{pstd}Will display a frequency polygon for {hi:snow}.

{phang}{stata "warpdenpy snow, b(10) m(5) k(2) step" :. warpdenpy snow, b(10) m(5) k(2) step}{p_end}

{pstd}Will display the estimate from averaging five histograms with the
   triangle weight function.

{phang}{stata "warpdenpy snow, b(15) m(10) k(4) gen(denq15 midq15) nog" :. warpdenpy snow, b(15) m(10) k(4) gen(denq15 midq15) nog}{p_end} 

{pstd}Will calculate the WARPing approximation for the Quartic kernel, and will
generate two variables with the resulting density estimation and the 
corresponding midpoints, without any graphical display.


{title:References}

   Haerdle, W. (1991) Smoothing Techniques with Implementation in S.
        Springer-Verlag Chapter 2: 43-84; Chapters 1-2: 1-84.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1993) snp6: Exploring
        the shape of univariate data using kernel density estimators. Stata 
        Technical Bulletin 16: 8-19.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1995a) snp6.1: ASH,
        WARPing, and kernel density estimation for univariate data. Stata
        Technical Bulletin 26: 23-31.
   Salgado-Ugarte, I.H., M. Shimizu, and T. Taniuchi (1995b) snp6.2: Practical
        Rules for bandwidth selection in univariate density estimation. Stata
       Technical Bulletin 27: 5-19.
   Scott, D.W. (1992) Multivariate Density Estimation: Theory, Practice,
        and Visualization. John Wiley Chapter 6: 125-143; Chapters 3-6: 47-193.
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
    STB: snp6 (STB-16); snp6.1 (STB-26); snp6.2 (STB-27)
{phang}On-line: {hi:help} for {help kerneld}, {help bandw}, {help l2cvwarp}, {help bcvwarp}, {help kernreg}
{p_end}