* simulate some data
clear
set obs 1000
egen bggw_mean = fill(-0.98(0.002)1)
gen erich_mean = bggw_mean^4
gen feve_mean = bggw_mean^3
gen L_hectares = erich_mean^3
gen hectares = exp(L_hectares)
gen trend_slope_clearing = 1/(erich_mean)
gen cropping_c_d_50 = bggw_mean > 0.25
gen grazing_c_d_50 = erich_mean < 0.1

gen bggw_mean_2 = bggw_mean^2
drawnorm xrand, sds(0.9) seed(3141)
gen interaction7 = abs(xrand) * bggw_mean

gen L_pphec = -20*L_hectares + 10*L_hectares*L_hectares + bggw_mean + bggw_mean_2 + interaction7 + xrand
scatter L_pphec L_hectares

* fit quantile regression simultaneously
sqreg L_pphec bggw_mean bggw_mean_2 L_hectares interaction7, quantiles(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9) reps(2)

local modname = "amodel"

run sqreg9_savedataresults `modname'

use `modname'_data_augmented, clear
run sqreg9_klhquantiles "pred5" `modname'