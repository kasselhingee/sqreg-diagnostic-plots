args modname
file open myfile using "`modname'_zeroedeffect_table.txt", write append
file write myfile ("Percentile") _tab ("BGGW") _tab ("lhec") _tab ("lb") _tab ("estimate") _tab ("ub") _tab ("se") _tab _n 
file close myfile

foreach hec of numlist 50 500 1000 3000 {
	local lhec = log(`hec')
	forvalues bggw = 0.02(0.01)1.01 {
		run "zeroedeffect_point.do" `bggw' `lhec' "`modname'_zeroedeffect_table.txt"
	}
}
