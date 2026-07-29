{smcl}
{* *! version 1.0.0 24/jul2020}{...}
{hline}
{cmd:help bhatado}                                [STB-18: sg23; STB-53: sg128]
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:bhatado} {hline 2}}Semi-graphical determination of Gaussian components in mixed distributions{p_end}
{p2colreset}{...}


{title:Description}

{pstd}Bhattacharya's method is a semi-graphical technique for estimating Gaussian
components in mixed distributions.  The method is applied to frequency data,
that is, the type of data used to plot histograms.  There are four programs
that can be used in sequence to apply Bhattacharya's method.  Help for each of
the programs is available by typing {hi:help progname}.  The four programs, in
order of use, are:

1) {cmd:diflogen} calculates the logarithmic difference of successive frequencies.

2) {cmd:bhatplot} graphs these logarithmic differences against interval midpoints.

3) {cmd:bhatmesd} estimates the parameters of a Gaussian component.

4) {cmd:gaussgen} generates an estimate of a Gaussian component.

These four simple programs have been integrated in two updated versions. These
new programs are:

1) {cmd:bhataplt1} calculates logarithmic differences and graph them agains interval
            midpoints.

2) {cmd:bhatgauc1} estimates the parameters of a Gaussian component and draw it for
            comparison with the observed frequency. Generates the Gaussian 
            component frequencies as an option.

The updated versions include more versatile and flexible options.


{title:References}

   Salgado-Ugarte, I.H., M. Shimizu & T. Taniuchi (1994) sg23: Semi-graphical 
        determination of Gaussian components in mixed distributions. 
        Stata Technical Bulletin 18:15-27.
   Salgado-Ugarte, I.H., J. Martínez-Ramírez, J.L. Gómez-Márquez, and B. 
        Peña-Mendoza (2000) sg128: Some programs for fisheries biology. Growth 
	estimation from length frequency analysis and hard parts reading. Stata 
        Technical Bulletin 53: 35-47.

{title:Authors}

1) Original versions
Isaias H. Salgado-Ugarte, Makoto Shimizu and Toru Taniuchi
University of Tokyo, Faculty of Agriculture,
Dept. of Fisheries (Fax 81-3-3812-0529)

2) Updated versions 1
Isaias H. Salgado-Ugarte
Facultad de Estudios Superiores 'Zaragoza'
Biology (Fax 52-5-773-1183)
E-mail: isalgado@servidor.unam.mx

3) Updated versions 2
Isaias Hazarmabeth Salgado-Ugarte y V. Mitsui Saito-Quezada 
Laboratorio de Biometría y Biología Pesquera
Facultad de Estudios Superiores Zaragoza
Universidad Nacional Autónoma de Mexico
e-mail: isalgado@unam.mx

{title:Also see}

{psee}
    STB: sg23 (STB-18); sg128 (STB-53)
{phang}On-line: {hi:help} for {help diflogen}, {help bhatplt1}, {help bhatmesd}, {help gaussgen}, {help bhatgauc1}
{p_end}