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

* fit quantile regression
sqreg L_pphec bggw_mean bggw_mean_2 L_hectares interaction7, quantiles(0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9) reps(2)

centile bggw_mean if L_hectares>3/10 & L_hectares<5/10, centile(10 20 30 40 50 60 70 80 90)
centile bggw_mean if L_hectares>5/10 & L_hectares<7/10, centile(10 20 30 40 50 60 70 80 90)
centile bggw_mean if L_hectares>7/10 & L_hectares<9/10, centile(10 20 30 40 50 60 70 80 90)

test [q30]L_hectares = [q70]L_hectares
lincom [q30]L_hectares - [q70]L_hectares

mkdir "n1000"

run zeroedeffect.do "n1000/mod"
run zeroedeffect_slope.do "n1000/mod"
run zeroedeffect_optimum.do "n1000/mod"


do sqreg9_manydiagnostics "n1000" "test"


do sqreg9_manyplots "n1000/test"
