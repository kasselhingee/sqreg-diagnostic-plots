* subset by xcovar values
* arguments are xcovar modname
args xcovar modname

* save quantiles into macros - hard coded because scalars aren't saved by the save function
forvalues lname = 1(1)9 {
	local q`lname' = `lname'*10
}

su `xcovar', meanonly
local binstep = (r(max) - r(min))/(10-1)

egen `xcovar'_bin = cut(`xcovar'), at(`r(min)'(`binstep')`r(max)+`binstep'') label

graph bar (count), over(`xcovar'_bin, label(angle(90))) ylabel(#5, angle(horizontal)) name(hist, replace)
//graph export "`modname'_hist_`xcovar'.pdf", replace

//box plots
graph box resid2, over(`xcovar'_bin, label(angle(90))) ylabel(#5, angle(horizontal)) name(plt_1, replace) nodraw
graph box resid5, over(`xcovar'_bin, label(angle(90))) ylabel(#5, angle(horizontal)) name(plt_2, replace) nodraw
graph box resid8, over(`xcovar'_bin, label(angle(90))) ylabel(#5, angle(horizontal)) name(plt_3, replace) nodraw
graph combine plt_1 plt_2 plt_3, col(1) iscale(1) ysize(15) 
graph export "`modname'_box_`xcovar'.pdf", replace

graph box resid2, over(`xcovar'_bin, label(angle(90))) ylabel(#40, angle(horizontal)) ysize(15)
//graph export "`modname'_box_`xcovar'_resid2zoom.pdf", replace
graph box resid5, over(`xcovar'_bin, label(angle(90))) ylabel(#40, angle(horizontal)) ysize(15)
//graph export "`modname'_box_`xcovar'_resid5zoom.pdf", replace
graph box resid8, over(`xcovar'_bin, label(angle(90))) ylabel(#40, angle(horizontal)) ysize(15)
//graph export "`modname'_box_`xcovar'_resid8zoom.pdf", replace

graph box resid5, over(`xcovar'_bin, label(angle(90))) ylabel(#5, angle(horizontal)) by(cropping_c_d_50 grazing_c_d_50)
graph export "`modname'_box_resid5_crop_graze_`xcovar'.pdf", replace

*scalar list  * lists all the scalars - scalars are not identical to macros. Scalars are used without quotes are used only in expressions
*return list  * lists the stored return values
*macro list   * lists macros

* compute quantiles of the residuals. For the nth quantile model, the nth quantile of the residual should equal 0
forvalues qnum = 1(1)9 {
	statsby q`qnum'v=r(c_1) q`qnum'v_l=r(lb_1) q`qnum'v_u=r(ub_1), by(`xcovar'_bin) saving("`modname'_centile_`qnum'_tmp.dta", replace): centile resid`qnum', centile(`q`qnum'')
	statsby _b, by(`xcovar'_bin) saving("`modname'_pred`qnum'_tmp.dta", replace): mean pred`qnum'
	* the saving code above means the centile results don't overwrite the existing data set).
	* the mean call with _b saves results as a variable _b_pred`qnum'
}

collapse (median) `xcovar', by(`xcovar'_bin)  //changes data set to be just the medians of xcovar and xcovar bin, required to combine all quantile results

* combine all quantile results
//use `modname'_centile_1_tmp
forvalues qnum = 1(1)9 {
merge 1:1 `xcovar'_bin using `modname'_centile_`qnum'_tmp, nogenerate
merge 1:1 `xcovar'_bin using `modname'_pred`qnum'_tmp, nogenerate
}

* remove temporary files
forvalues qnum = 1(1)9 {
	erase `modname'_centile_`qnum'_tmp.dta
	erase `modname'_pred`qnum'_tmp.dta
}

* plot
forvalues lname = 1(1)9 {
	twoway rcap q`lname'v_u q`lname'v_l `xcovar', lcolor(black) || scatter q`lname'v `xcovar', yline(0) name(plt`lname', replace) ylabel(#5, angle(horizontal) format(%5.0g)) ysize(12) xlabel(#10, angle(vertical)) mcolor(black) legend(off)
	*remove large error bars*
	su q`lname'v, meanonly
	local tenpct = (r(max) - r(min))/10
	replace q`lname'v_u = . if q`lname'v_u>r(max) + `tenpct'
	replace q`lname'v_l = . if q`lname'v_u<r(min) - `tenpct'
	twoway scatter q`lname'v `xcovar', yline(0) name(plt`lname'_zoom, replace) ylabel(#5, angle(horizontal) format(%5.0g)) ysize(12) xlabel(#10, angle(vertical)) mcolor(black) || rcap q`lname'v_u q`lname'v `xcovar', lcolor(red) msize(large) || rcap q`lname'v q`lname'v_l `xcovar', lcolor(green) msize(large) legend(off)
}
graph combine plt1 plt2 plt3 plt4 plt5 plt6 plt7 plt8 plt9 hist, col(3) ysize(17) xsize(15) xcommon
graph export "`modname'_`xcovar'_qall.pdf", replace
graph combine plt1_zoom plt2_zoom plt3_zoom plt4_zoom plt5_zoom plt6_zoom plt7_zoom plt8_zoom plt9_zoom hist, col(3) ysize(17) xsize(15) xcommon
graph export "`modname'_`xcovar'_qall_zoom.pdf", replace
