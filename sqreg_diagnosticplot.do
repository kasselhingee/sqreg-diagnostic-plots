* arguments are xcovar modname and a space-seperated character vector of the quantiles
args xcovar modname quantiles
local numeqs = wordcount("`quantiles'")

* save quantiles into macros - x100 because that is the format needed for centile
forvalues qidx = 1/`numeqs' {
    local thisq : word `qidx' of `quantiles'
	local q`qidx' = `thisq'*100
}

su `xcovar', meanonly
local binstep = (r(max) - r(min))/(10-1)

egen `xcovar'_bin = cut(`xcovar'), at(`r(min)'(`binstep')`r(max)+`binstep'') label

set graphics off //so plots don't keep popping up

graph bar (count), over(`xcovar'_bin, label(angle(90))) ylabel(#5, angle(horizontal)) name(hist, replace)
//graph export "`modname'_hist_`xcovar'.pdf", replace

* compute quantiles of the residuals. For the Qth quantile model, the Qth quantile of the residual should equal 0
forvalues qidx = 1/`numeqs' {
	statsby q`qidx'v=r(c_1) q`qidx'v_l=r(lb_1) q`qidx'v_u=r(ub_1), by(`xcovar'_bin) saving("`modname'_centile_`qidx'_tmp.dta", replace): centile resid`qidx', centile(`q`qidx'')
	statsby _b, by(`xcovar'_bin) saving("`modname'_pred`qidx'_tmp.dta", replace): mean pred`qidx'
	* the saving code above means the centile results don't overwrite the existing data set).
	* the mean call with _b saves results as a variable _b_pred`qidx'
}

collapse (median) `xcovar', by(`xcovar'_bin)  //changes data set to be just the medians of xcovar and xcovar bin, required to combine all quantile results

* combine all quantile results
//use `modname'_centile_1_tmp
forvalues qidx = 1/`numeqs' {
merge 1:1 `xcovar'_bin using `modname'_centile_`qidx'_tmp, nogenerate
merge 1:1 `xcovar'_bin using `modname'_pred`qidx'_tmp, nogenerate
}


* remove temporary files
forvalues qidx = 1/`numeqs' {
	erase `modname'_centile_`qidx'_tmp.dta
	erase `modname'_pred`qidx'_tmp.dta
}

* plot panels
forvalues qidx = 1/`numeqs' {
	twoway rcap q`qidx'v_u q`qidx'v_l `xcovar', lcolor(black) || scatter q`qidx'v `xcovar', yline(0) name(plt`qidx', replace) ylabel(#5, angle(horizontal) format(%5.0g)) ysize(12) xlabel(#10, angle(vertical)) mcolor(black) legend(off) xtitle("`xcovar'") ytitle("`q`qidx''th Percentile")
	*remove large error bars*
	su q`qidx'v, meanonly
	local tenpct = (r(max) - r(min))/10
	replace q`qidx'v_u = . if q`qidx'v_u>r(max) + `tenpct'
	replace q`qidx'v_l = . if q`qidx'v_u<r(min) - `tenpct'
	twoway scatter q`qidx'v `xcovar', yline(0) name(plt`qidx'_zoom, replace) ylabel(#5, angle(horizontal) format(%5.0g)) ysize(12) xlabel(#10, angle(vertical)) mcolor(black) || rcap q`qidx'v_u q`qidx'v `xcovar', lcolor(red) msize(large) || rcap q`qidx'v q`qidx'v_l `xcovar', lcolor(green) msize(large) legend(off) xtitle("`xcovar'") ytitle("`q`qidx''th Percentile")
}
set graphics on //so plots pop up again

* create full plots
local plotlist = ""
forvalues qidx = 1/`numeqs' {
	local tmp "plt`qidx'"
	local plotlist = "`plotlist' `tmp'"
}
graph combine `plotlist' hist, col(3) ysize(17) xsize(15) xcommon
graph export "`modname'_`xcovar'_qall.pdf", replace

local plotlist = ""
forvalues qidx = 1/`numeqs' {
	local tmp "plt`qidx'_zoom"
	local plotlist = "`plotlist' `tmp'"
}
graph combine `plotlist' hist, col(3) ysize(17) xsize(15) xcommon
graph export "`modname'_`xcovar'_qall_zoom.pdf", replace
