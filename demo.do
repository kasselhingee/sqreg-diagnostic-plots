* simulate some data
clear
set obs 1000
egen x1 = fill(-0.98(0.002)1)
gen x2 = x1^2
gen x3 = x1^3
gen x4 = x1 > 0.25
drawnorm xrand, sds(0.9) seed(3141)
gen y = x1 + x2 + x3 + x4 + xrand

* fit quantile regression simultaneously. Number of reps should be much higher (eg 500), but 10 used here for speed.
sqreg y x1 x2 x3 x4, quantiles(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9) reps(10)



** PLOT DIAGNOSTICS **
* Set a model name 'modname', which is important for creating files (including temporary files)
local modname = "demo" 
* Get the quantiles used in sqreg as long string:
local quantiles = ""
forvalues qnum = 1/`e(n_q)' {
	local quantiles = "`quantiles' `e(q`qnum')'"
}
display "`quantiles'"

* export the predictions and residuals into a .dta file for use in plotting
run sqreg_saveresiduals y `modname'

* create the diagnostic plot for covariate x1
use `modname'_residuals, clear
run sqreg_diagnosticplot "x1" "`quantiles'" `modname' 

* plot the diagnostic for the 5th linear prediction (in this case corresponding to the median)
use `modname'_residuals, clear
run sqreg_diagnosticplot "pred5" "`quantiles'" `modname' 

erase `modname'_residuals.dta
