args bggw lhec filename

file open myfile using `filename', write append

lincom ([q10]bggw_mean + 2 * [q10]bggw_mean_2 * `bggw' + [q10]interaction7 * `lhec')
file write myfile (0.1) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q20]bggw_mean + 2 * [q20]bggw_mean_2 * `bggw' + [q20]interaction7 * `lhec')
file write myfile (0.2) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q30]bggw_mean + 2 * [q30]bggw_mean_2 * `bggw' + [q30]interaction7 * `lhec')
file write myfile (0.3) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q40]bggw_mean + 2 * [q40]bggw_mean_2 * `bggw' + [q40]interaction7 * `lhec')
file write myfile (0.4) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q50]bggw_mean + 2 * [q50]bggw_mean_2 * `bggw' + [q50]interaction7 * `lhec')
file write myfile (0.5) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q60]bggw_mean + 2 * [q60]bggw_mean_2 * `bggw' + [q60]interaction7 * `lhec')
file write myfile (0.6) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q70]bggw_mean + 2 * [q70]bggw_mean_2 * `bggw' + [q70]interaction7 * `lhec')
file write myfile (0.7) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q80]bggw_mean + 2 * [q80]bggw_mean_2 * `bggw' + [q80]interaction7 * `lhec')
file write myfile (0.8) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

lincom ([q90]bggw_mean + 2 * [q90]bggw_mean_2 * `bggw' + [q90]interaction7 * `lhec')
file write myfile (0.9) _tab (`bggw') _tab (`lhec') _tab (r(lb)) _tab (r(estimate)) _tab (r(ub)) _tab (r(se)) _tab _n

file close myfile

