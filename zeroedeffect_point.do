args bggw lhec filename

file open myfile using `filename', write append

lincom ([q10]bggw_mean + [q10]bggw_mean_2 * `bggw' + [q10]interaction7 * `lhec') * `bggw' - ([q10]bggw_mean + [q10]bggw_mean_2 * 0.01 + [q10]interaction7 * `lhec') * 0.01
file write myfile (0.1) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q20]bggw_mean + [q20]bggw_mean_2 * `bggw' + [q20]interaction7 * `lhec') * `bggw' - ([q20]bggw_mean + [q20]bggw_mean_2 * 0.01 + [q20]interaction7 * `lhec') * 0.01
file write myfile (0.2) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q30]bggw_mean + [q30]bggw_mean_2 * `bggw' + [q30]interaction7 * `lhec') * `bggw' - ([q30]bggw_mean + [q30]bggw_mean_2 * 0.01 + [q30]interaction7 * `lhec') * 0.01
file write myfile (0.3) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q40]bggw_mean + [q40]bggw_mean_2 * `bggw' + [q40]interaction7 * `lhec') * `bggw' - ([q40]bggw_mean + [q40]bggw_mean_2 * 0.01 + [q40]interaction7 * `lhec') * 0.01
file write myfile (0.4) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q50]bggw_mean + [q50]bggw_mean_2 * `bggw' + [q50]interaction7 * `lhec') * `bggw' - ([q50]bggw_mean + [q50]bggw_mean_2 * 0.01 + [q50]interaction7 * `lhec') * 0.01
file write myfile (0.5) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q60]bggw_mean + [q60]bggw_mean_2 * `bggw' + [q60]interaction7 * `lhec') * `bggw' - ([q60]bggw_mean + [q60]bggw_mean_2 * 0.01 + [q60]interaction7 * `lhec') * 0.01
file write myfile (0.6) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q70]bggw_mean + [q70]bggw_mean_2 * `bggw' + [q70]interaction7 * `lhec') * `bggw' - ([q70]bggw_mean + [q70]bggw_mean_2 * 0.01 + [q70]interaction7 * `lhec') * 0.01
file write myfile (0.7) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q80]bggw_mean + [q80]bggw_mean_2 * `bggw' + [q80]interaction7 * `lhec') * `bggw' - ([q80]bggw_mean + [q80]bggw_mean_2 * 0.01 + [q80]interaction7 * `lhec') * 0.01
file write myfile (0.8) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q90]bggw_mean + [q90]bggw_mean_2 * `bggw' + [q90]interaction7 * `lhec') * `bggw' - ([q90]bggw_mean + [q90]bggw_mean_2 * 0.01 + [q90]interaction7 * `lhec') * 0.01
file write myfile (0.9) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n



file close myfile

