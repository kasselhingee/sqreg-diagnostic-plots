* arguments are aname (for a model name), which is used to choose file names
args modname numeqs

* keep only data used
gen used = e(sample)
keep if used==1

* export predictions to variables
forvalues lname = 1(1)`numeqs' {
	predict pred`lname', equation(#`lname') xb
	gen resid`lname' = L_pphec - pred`lname'
	* scalar q`lname' = e(q`lname') * 100
}
save `modname'_data_augmented, replace //the scalars aren't saved through