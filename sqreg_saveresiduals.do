* this do file saves residuals in a .dta file called `modname'_residuals
* arguments are yname for the set of predictions and modname (for a model name)
args yname modname

* keep only data used
gen used = e(sample)
keep if used==1

* export predictions to variables
forvalues lname = 1/`e(n_q)' {
	predict pred`lname', equation(#`lname') xb
	gen resid`lname' = `yname' - pred`lname'
}
save `modname'_residuals, replace