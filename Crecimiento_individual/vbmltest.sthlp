{smcl}
{* *! v1.0.0 IHSalgado-Ugarte 01mar2015}{...}
{cmd:help vbmltest}
{hline}

{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{hi:vbmltest} {hline 2}}Performs a maximum likelihood F tests to compare two von Bertalanffy equations{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 17 2}
{cmd:vbmltest} lengthvar agevar group var [weight], [level(#)]

{p 4 6 2}
{cmd:weights} are allowed{p_end}


{title:Description}

{pstd}{cmd:vbmltest} permits the comparison of two von Bertalanffy growth functions by means of several maximum likelihood F tests.
It uses the routines: {cmd:nlvbgfno} which estimates a VBGF without linear constraints (independent estimation for each group) and compares it with the VBGF without considering any groupS; 
If there are significant differences the program proceeds to test each parameter: {cmd:nlvbgfel},{cmd:nlvbgfek} and {cmd:nlvbgfet} which
verify the equality of the VBGF parameters: L_inf, K and t_0.

{title:Options}

{phang} level(#)               set confidence level; default is level(95) if level is changed from default a weight must be specified. If there is no weight variable it is necessary to create one: gen one=1 and use [freq=one].{p_end}

{title:Examples}

{phang}{stata "use kimudat" : . use kimudat}{p_end}
{phang}{stata "vbmltest ml age sex" : . vbmltest ml age sex}{p_end}
{phang}{stata "vbmltest ml age sex [freq=size]" : . vbmltest ml age sex [freq=size]}{p_end}
{phang}{stata "vbmltest ml age sex [freq=size], level(99)" : . vbmltest ml age sex [freq=size], level(99)}{p_end}
{phang}{stata "gen one = 1" : . gen one = 1}{p_end}
{phang}{stata "vbmltest ml age sex [freq=one], level(90)" : . vbmltest ml age sex [freq=one], level(90)}{p_end}

{title:Author}

{phang}Isaias Hazarmabeth Salgado-Ugarte & Veronica Mitsui Saito-Quezada {break}
Laboratorio de Biometría y Biología Pesquera, FES Zaragoza, UNAM {break}
isalgado@unam.mx{p_end}

{title:References}

{phang}Haddon, M. 2001. Modelling and quantitative methods in Fisheries. Chapman & Hall/CRC, Boca Raton, 404p.{p_end}{phang}Kimura, D.K. 1980. Likelihood methods for the von Bertalanffy growth curve. Fishery Bulletin, 77(4): 765-776.{p_end}
{phang}Salgado-Ugarte, I.H. & V.M. Saito-Quezada, 2020. Métodos cuantitativos computarizados para Biología Pesquera. FES Zaragoza-DGAPA, PAPIME PE207417, UNAM: 240 p.{p_end}
{phang}Salgado-Ugarte, I.H., J.L. Gómez-Márquez & B. Peña-Mendoza, 2005. Métodos actualizados para análisis de datos biológico-pesqueros. FES Zaragoza-DGAPA, UNAM: 240 p.{p_end}
{phang}Roff, D.A. 2006. Introduction to computer-intensive methods of data analysis in Biology. Cambridge University Press, Nueva York, 368 p.{p_end} 

{title:Also see}

{psee}
Online: {manhelp nl R} {help vblrtest}
{p_end}
