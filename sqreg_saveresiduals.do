* arguments are modname (for a model name)
args modname

* keep only data used
gen used = e(sample)
keep if used==1

* export predictions to variables
forvalues lname = 1/`e(n_q)' {
	predict pred`lname', equation(#`lname') xb
	gen resid`lname' = L_pphec - pred`lname'
}
save `modname'_residuals, replace