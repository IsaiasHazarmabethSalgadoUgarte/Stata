{smcl}
{* *! version 1.0.0 24/jul2020}{...}
{hline}
{cmd:help bhataplt1}                                [STB-18: sg.23 (original version)]
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:bhataplt1} {hline 2}}Bhattacharya's graph to identify Gaussian components{p_end}
{p2colreset}{...}

{title:Syntax}
{p 8 17 2}
{cmd:bhataplt1} {freqvar midpoivar} {ifin} {cmd:,} {cmdab:graph_options}


{title:Description}

{pstd}{cmd:bhataplt1} graphs log differences of {it:freqvar} against {it:midpoivar} using observation
numbers as plotting symbols.  This graph of logarithmic differences of successive 
frequencies against midpoivar (containing the midpoint of the class intervals) produces 
Bhattacharya's graph for identifying Gaussian components in mixed distributions.  
Type {hi:help} {help bhatado} for information on other ado-files used in applying Bhattacharya's method.

{title:Example}

{phang}{stata "use dentex" :. use dentex}{p_end}

{phang}{stata "bhataplt1 freq midpoi, yline(0)" :. bhataplt1 freq midpoi, yline(0)}{p_end}

{title:References}

   Salgado-Ugarte, I.H., M. Shimizu & T. Taniuchi (1994) sg23: Semi-graphical 
        determination of Gaussian components in mixed distributions. 
        Stata Technical Bulletin 18:15-27.
   Salgado-Ugarte, I.H., J. Martínez-Ramírez, J.L. Gómez-Márquez, and B. 
        Peña-Mendoza (2000) sg128: Some programs for fisheries biology. Growth estimation
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
{phang}On-line: {hi:help} for {help bhatado}, {help diflogen}, {help bhatmesd}, {help gaussgen}, {help bhatgauc1}
{p_end}