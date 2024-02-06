args modname

/// assumes that bggw_mean_2 coefficient is negative - nlcom uses delta method so I'm guessing some very strange results when bggw_mean_2 coefficient crosses zero
file open myfile using "`modname'_zeroedeffect_optimum_table.txt", write append
file write myfile ("Percentile") _tab ("lhec") _tab ("estimate") _tab ("var") _tab _n 
file close myfile

foreach hec of numlist 50 500 1000 3000 {
	local lhec = log(`hec')
	run "zeroedeffect_optimum_point.do" `lhec' "`modname'_zeroedeffect_optimum_table.txt"
}
