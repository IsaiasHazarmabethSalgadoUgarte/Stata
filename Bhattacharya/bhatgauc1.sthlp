{smcl}
{* *! version 1.0.0 24/jul2020}{...}
{hline}
{cmd:help bhatgauc1}                                [STB-53: sg.128 (updated version)]
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:bhatgauc1} {hline 2}}Bhattacharya's method for estimating Gaussian component parameters{p_end}
{p2colreset}{...}

{title:Syntax}
{p 8 17 2}
{cmd:bhatgauc1 freqvar midpoivar} {ifin}{cmd:, }{cmdab:g:en(}{it:gaucovar}{cmd:)}
{cmdab:nog:raph}
{cmdab:graph_options}
       
{title:Description}

This program estimates the parameters (mean, standard deviation and frequency) 
of the Gaussian component in a specified points range. {hi:freqvar} is the frequency
variable, and {hi:midpoivar} is the midclass interval variable. {cmd:bhatgauc1} displays
also the graphical comparison of the observed frequencies and the estimated
Gaussian component.

This routine is a new version of the two previous simple programs {hi:bhatmesd.ado}
and {hi:gaussgen.ado} that includes more versatile options.

Type {hi: help} {help bhatado} for information on other ado-files used in applying 
Bhattacharya's method.


{title:Options}

{phang}{opt gen}({it:gaucovar}) permits to create a variable with the frequencies of the estimated
             Gaussian component. 

{phang}{opt nograph} suppresses the graph drawing

{phang}{opt graph_options} are any of the options allowed with {cmd:graph, twoway}.


{title:Remarks}

Besides the graph, a table containing the mean, the s.d. and the frequency of  
estimated values in addition with r_squared information of the negatively  
sloped segment used is displayed.


{title:Examples}

{phang}{stata "bhatgauc1 freq midpoi in 4/12" :. bhatgauc1 freq midpoi in 4/12}{p_end}

{pstd}Draws the observed frequency and the Gaussian component frequency for the
specified range. A table with the parameters and regression information is 
shown.

{phang}{stata "bhatgauc1 freq midpoi in 4/12, gen(gauco1)" :. bhatgauc1 freq midpoi in 4/12, gen(gauco1)}{p_end}

{pstd}In addition to the graph and table, the Gaussian component frequency is 
generated and included in the {hi:gauco1} variable


{title:References}

   Salgado-Ugarte, I.H., M. Shimizu & T. Taniuchi (1994) sg23: Semi-graphical 
        determination of Gaussian components in mixed distributions. 
        Stata Technical Bulletin 18:15-27.
   Salgado-Ugarte, I.H., J. Martinez-Ramirez, J.L. Gomez-Marquez, and B. 
        Pena-Mendoza. Some programs for fisheries biology. Growth estimation
        from length frequency analysis and hard parts reading. Stata 
        Technical Bulletin 53: 35-47.

{title:Authors}

Original version:
Isaias H. Salgado-Ugarte, Makoto Shimizu & Toru Taniuchi
University of Tokyo, Faculty of Agriculture,
Dept. of Fisheries
Updated version:
Isaías H. Salgado-Ugarte & V. Mitsui Saito-Quezada
Laboratorio de Biometria y Biologia Pesquera
Facultad de Estudios Superiores Zaragoza
Universidad Nacional Autonoma de Mexico
isalgado@unam.mx

{title:Also see}

{psee}

    STB: sg23 (STB-18); sg128 (STB-53)
{phang}On-line: {hi:help} for {help bhatado}, {help diflogen}, {help bhatmesd}, {help gaussgen}, {help bhataplt1}
