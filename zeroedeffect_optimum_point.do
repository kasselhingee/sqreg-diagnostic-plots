args lhec filename
/// assumes that bggw_mean_2 coefficient is negative
file open myfile using `filename', write append

nlcom - ([q10]_b[bggw_mean] + [q10]_b[interaction7] * `lhec') / (2 * [q10]_b[bggw_mean_2])
file write myfile (0.1) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

nlcom - ([q20]_b[bggw_mean] + [q20]_b[interaction7] * `lhec') / (2 * [q20]_b[bggw_mean_2])
file write myfile (0.2) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

nlcom - ([q30]_b[bggw_mean] + [q30]_b[interaction7] * `lhec') / (2 * [q30]_b[bggw_mean_2])
file write myfile (0.3) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

nlcom - ([q40]_b[bggw_mean] + [q40]_b[interaction7] * `lhec') / (2 * [q40]_b[bggw_mean_2])
file write myfile (0.4) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

nlcom - ([q50]_b[bggw_mean] + [q50]_b[interaction7] * `lhec') / (2 * [q50]_b[bggw_mean_2])
file write myfile (0.5) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

nlcom - ([q60]_b[bggw_mean] + [q60]_b[interaction7] * `lhec') / (2 * [q60]_b[bggw_mean_2])
file write myfile (0.6) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

nlcom - ([q70]_b[bggw_mean] + [q70]_b[interaction7] * `lhec') / (2 * [q70]_b[bggw_mean_2])
file write myfile (0.7) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

nlcom - ([q80]_b[bggw_mean] + [q80]_b[interaction7] * `lhec') / (2 * [q80]_b[bggw_mean_2])
file write myfile (0.8) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

nlcom - ([q90]_b[bggw_mean] + [q90]_b[interaction7] * `lhec') / (2 * [q90]_b[bggw_mean_2])
file write myfile (0.9) _tab (`lhec') _tab (r(b)[1,1]) _tab (r(V)[1,1]) _tab _n

file close myfile

