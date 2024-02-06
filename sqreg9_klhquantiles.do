* subset by xcovar values
* arguments are xcovar modname
args xcovar modname quantiles
local numeqs = wordcount("`quantiles'")

* save quantiles into macros - hard coded because scalars aren't saved by the save function
forvalues lname = 1/`numeqs' {
    local thisq : word `lname' of `quantiles'
	local q`lname' = `thisq'*100
}

su `xcovar', meanonly
local binstep = (r(max) - r(min))/(10-1)

egen `xcovar'_bin = cut(`xcovar'), at(`r(min)'(`binstep')`r(max)+`binstep'') label

set graphics off //so plots don't keep popping up

graph bar (count), over(`xcovar'_bin, label(angle(90))) ylabel(#5, angle(horizontal)) name(hist, replace)
//graph export "`modname'_hist_`xcovar'.pdf", replace

* compute quantiles of the residuals. For the Qth quantile model, the Qth quantile of the residual should equal 0
forvalues qnum = 1/`numeqs' {
	statsby q`qnum'v=r(c_1) q`qnum'v_l=r(lb_1) q`qnum'v_u=r(ub_1), by(`xcovar'_bin) saving("`modname'_centile_`qnum'_tmp.dta", replace): centile resid`qnum', centile(`q`qnum'')
	statsby _b, by(`xcovar'_bin) saving("`modname'_pred`qnum'_tmp.dta", replace): mean pred`qnum'
	* the saving code above means the centile results don't overwrite the existing data set).
	* the mean call with _b saves results as a variable _b_pred`qnum'
}

collapse (median) `xcovar', by(`xcovar'_bin)  //changes data set to be just the medians of xcovar and xcovar bin, required to combine all quantile results

* combine all quantile results
//use `modname'_centile_1_tmp
forvalues qnum = 1/`numeqs' {
merge 1:1 `xcovar'_bin using `modname'_centile_`qnum'_tmp, nogenerate
merge 1:1 `xcovar'_bin using `modname'_pred`qnum'_tmp, nogenerate
}


* remove temporary files
forvalues qnum = 1/`numeqs' {
	erase `modname'_centile_`qnum'_tmp.dta
	erase `modname'_pred`qnum'_tmp.dta
}

* plot panels
forvalues lname = 1/`numeqs' {
	twoway rcap q`lname'v_u q`lname'v_l `xcovar', lcolor(black) || scatter q`lname'v `xcovar', yline(0) name(plt`lname', replace) ylabel(#5, angle(horizontal) format(%5.0g)) ysize(12) xlabel(#10, angle(vertical)) mcolor(black) legend(off) xtitle("`xcovar'") ytitle("`q`lname''th Percentile")
	*remove large error bars*
	su q`lname'v, meanonly
	local tenpct = (r(max) - r(min))/10
	replace q`lname'v_u = . if q`lname'v_u>r(max) + `tenpct'
	replace q`lname'v_l = . if q`lname'v_u<r(min) - `tenpct'
	twoway scatter q`lname'v `xcovar', yline(0) name(plt`lname'_zoom, replace) ylabel(#5, angle(horizontal) format(%5.0g)) ysize(12) xlabel(#10, angle(vertical)) mcolor(black) || rcap q`lname'v_u q`lname'v `xcovar', lcolor(red) msize(large) || rcap q`lname'v q`lname'v_l `xcovar', lcolor(green) msize(large) legend(off) xtitle("`xcovar'") ytitle("`q`lname''th Percentile")
}
set graphics on //so plots pop up again

* create full plots
local plotlist = ""
forvalues qnum = 1/`numeqs' {
	local tmp "plt`qnum'"
	local plotlist = "`plotlist' `tmp'"
}
graph combine `plotlist' hist, col(3) ysize(17) xsize(15) xcommon
graph export "`modname'_`xcovar'_qall.pdf", replace

local plotlist = ""
forvalues qnum = 1/`numeqs' {
	local tmp "plt`qnum'_zoom"
	local plotlist = "`plotlist' `tmp'"
}
graph combine `plotlist' hist, col(3) ysize(17) xsize(15) xcommon
graph export "`modname'_`xcovar'_qall_zoom.pdf", replace
