*! version 1.00 24/04/2002        Stata Journal-xx: 
program define hotegfun, eclass
	version 7.0
*Author: Salgado-Ugarte, I.H.
*First written: 24/04/2002 (version 1.00); revised 03/05/2002;
*Last revised 21/11/2003; 08/10/2021
*Number format was changed from fix to general
*This program performs the multivariate test for von Bertalanffy 
*Growth Function comparison, considering Hotelling's T^2 statistic
*(based on Bernard, D.R. 1981. Multivariate analysis as a means of comparing
*growth in fish. Canadian Journal of Fisheries and Aquatic Sciences, 
*38; 223-236).

	capture confirm matrix `1'	
	capture confirm matrix `2'
	capture confirm matrix `3'
	capture confirm matrix `4'
	capture confirm number `5'
	capture confirm number `6'
	capture confirm number `7'
	
	if _rc!=0 {
		display as error "Syntax is S1 S2 P1 P2 N1 N2 CL"
		exit 198
		}

	tempname P1 P2 S1 S2 Pp1 Pp2 P1 P2 Dp Dprime n1 n2 S Sinv T2	
	matrix `S1'= `1'
	matrix `S2'= `2'
	matrix `Pp1' = `3'
	matrix `Pp2' = `4'
	matrix `P1' = `Pp1''
	matrix `P2' = `Pp2''
	matrix `Dp' = `P1'-`P2'
	matrix `Dprime' = `Dp''
	local  n1= `5'
	local  n2= `6'
	local cl= `7'
        if `cl'<1 {
             di as error "you must provide the confidence level in percentage"
            exit}
	matrix `S'= ((`n1'-1)*`S1'+(`n2'-1)*`S2')/(`n1'+`n2'-2)
	matrix `Sinv'= inv(`S')

	display as text _newline _dup(78) "="
	di as text "Multivariate test for Growth Function comparison "
	di as text "from two populations (based on Bernard, 1981)"
	di _dup(78) "_"
	di _newline "  Matrix S                               Matrix S inverse"
	#delimit ;

	di as result _newline "{text}| "%10.0g `S'[1,1] " " %10.0g `S'[1,2] " " %10.0g `S'[1,3] "{text} |"
       	"{text} | " %11.0g `Sinv'[1,1] " " %11.0g `Sinv'[1,2] " " %11.0g `Sinv'[1,3] _column(78) "{text} |";
	
	di as result "{text}| " _column(14) %10.0g `S'[2,2] " " %10.0g `S'[2,3] "{text} |"
	"{text} | " _column(52) %11.0g `Sinv'[2,2] " " %11.0g `Sinv'[2,3] _column(78) "{text} |"; 

	#delimit cr
	di as result  "{text}| " _column(25) %10.0g `S'[3,3] "{text} | " "{text}| " _column(64) %11.0g `Sinv'[3,3] _column(78) "{text} |"
	di _dup(78) "_"
	
	di as result _newline "{text}| " %10.4f `Dprime'[1,1] %10.4f `Dprime'[1,2] %10.4f `Dprime'[1,3] "{text} |   = [P1 - P2]' "
	di _dup(78) "_"

	matrix `T2'=(`n1'*`n2'/(`n1'+`n2'))*`Dprime'*`Sinv'*`Dp'
	local dof=`n1'+`n2'-4
	local sl = (100 - `cl')/100
	local T2t=(3*(`n1'+`n2'-2))/(`dof')*invfprob(3,`dof',`sl')
	local Fc = invfprob(3,`dof',`sl')

	#delimit ;
*	local sl = (100 - `cl')/100;	
	di as result _newline "{text}T^2 = " %10.4f `T2'[1,1] _column(20) 
		"{text}T^2_" %4.2f `sl' ": 3," `dof' " =" %10.4f `T2t' 
           _column(45) "{text} F_" %4.2f `sl' ": 3," `dof' " ="  %10.4f `Fc';
	di as text _dup(78) "_";

	if `T2'[1,1] > `T2t' {

	
	local llLi = `Dp'[1,1]-(((`n1'+`n2')/(`n1'*`n2'))*(3*(`n1'+`n2' -2))/
                    (`dof')*`Fc'*`S'[1,1])^.5;
	local ulLi = `Dp'[1,1]+(((`n1'+`n2')/(`n1'*`n2'))*(3*(`n1'+`n2' -2))/
                    (`dof')*`Fc'*`S'[1,1])^.5;
	local FcritLi= (`n1'*`n2'*(`n1'+`n2'-4)*(`Dp'[1,1])^2)/(3*(`n1'+`n2')*
		(`n1'+`n2'-2)*`S'[1,1]);

	local llk = `Dp'[2,1]-(((`n1'+`n2')/(`n1'*`n2'))*(3*(`n1'+`n2' -2))/
                    (`dof')*`Fc'*`S'[2,2])^.5;
	local ulk = `Dp'[2,1]+(((`n1'+`n2')/(`n1'*`n2'))*(3*(`n1'+`n2' -2))/
                    (`dof')*`Fc'*`S'[2,2])^.5;
	local Fcritk= (`n1'*`n2'*(`n1'+`n2'-4)*(`Dp'[2,1])^2)/(3*(`n1'+`n2')*
		(`n1'+`n2'-2)*`S'[2,2]);

	local llto = `Dp'[3,1]-(((`n1'+`n2')/(`n1'*`n2'))*(3*(`n1'+`n2' -2))/
                    (`dof')*`Fc'*`S'[3,3])^.5;
	local ulto = `Dp'[3,1]+(((`n1'+`n2')/(`n1'*`n2'))*(3*(`n1'+`n2' -2))/
                    (`dof')*`Fc'*`S'[3,3])^.5;
	local Fcritto= (`n1'*`n2'*(`n1'+`n2'-4)*(`Dp'[3,1])^2)/(3*(`n1'+`n2')*
		(`n1'+`n2'-2)*`S'[3,3]);
	local sl = (100 - `cl')/100;
 	
	
	
	local con=`cl';
	di as result _newline "{text}  Roy-Bose Confidence intervals of " 
	%2.0f `con' "{text} % " _column(56) "{text}Critical F";
	di as result _newline %10.4f `llLi' "{text} <= L_inf1 - L_inf2 <=" 
	_column(30) %10.4f 
	`ulLi' _column(55) %10.4f `FcritLi';
	di as result _newline %10.4f `llk' "{text} <=   K1   -   K2   <="
	_column(30) %10.4f `ulk' _column(55) %10.4f `Fcritk';
	di as result _newline %10.4f `llto' "{text} <=  t_o1  -  t_o2  <=" 
	_column(30) %10.4f `ulto' _column(55) %10.4f `Fcritto';
	display as text _newline _dup(78) "=";
	#delimit cr
        }
	else {
	local con = `cl'
	display as result _newline "The growth functions are not different at " %2.0f `con' " % confidence level" 
	display as text _newline _dup(78) "="
	     }
end
