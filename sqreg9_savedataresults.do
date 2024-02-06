* arguments are directory and aname (for a model name)
* space in directory or aname are not supported
args modname

* keep only data used
*gen used = e(sample)
*keep if used==1

* save sqreg
save `modname'_data, replace
*putexcel set `modname'_tables, sheet("Estimated Coefficients") modify
*estimates replay
*putexcel A1 = etable

* get summary data about the data set. estat summarize automatically restricts to the estimation sample
*putexcel set `modname'_tables, sheet("Observations Summary") modify
//estat summarize
*putexcel A1=matrix(r(stats)), names
//save for each numerical value
//ds, has(type numeric)
//local numericalvars = r(varlist)
//foreach var of varlist `numericalvars' {
//	histogram `var', frequency
//	graph export `modname'_histogram_`var'.pdf, replace
//}

* export predictions to variables
forvalues lname = 1(1)9 {
	predict pred`lname', equation(#`lname') xb
	gen resid`lname' = L_pphec - pred`lname'
	scalar q`lname' = e(q`lname') * 100
}
save `modname'_data_augmented, replace //the scalars aren't saved through