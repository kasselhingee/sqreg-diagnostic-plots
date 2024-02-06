args modname



use `modname'_data_augmented, clear
set graphics off 

* make two way scatter plots
twoway scatter L_pphec pred5, msymbol("+") msize(tiny)
graph export `modname'_scatter_pred5_pphec.pdf, replace
twoway scatter L_pphec pred5, msymbol("+") msize(tiny) || lowess pred9 pred5, bwidth(0.01) || lowess pred8 pred5, bwidth(0.01) || || lowess pred7 pred5, bwidth(0.01) || lowess pred6 pred5, bwidth(0.01) || lowess pred4 pred5, bwidth(0.01) || lowess pred3 pred5, bwidth(0.01) || lowess pred2 pred5, bwidth(0.01)|| lowess pred1 pred5, bwidth(0.01)
graph export `modname'_scatter_pred5_pphec_preds.pdf, replace
twoway scatter resid5 pred5, msymbol("+") msize(tiny)
graph export `modname'_scatter_pred5_resid5.pdf, replace
twoway scatter resid5 L_hectares, msymbol("+") msize(tiny) by(cropping_c_d_50 grazing_c_d_50)
graph export `modname'_scatter_L_hectares_resid5_crop_graze.pdf, replace
twoway scatter resid2 L_hectares, msymbol("+") msize(tiny) by(cropping_c_d_50 grazing_c_d_50)
graph export `modname'_scatter_L_hectares_resid2_crop_graze.pdf, replace
twoway scatter resid5 bggw_mean, msymbol("+") msize(tiny) by(cropping_c_d_50 grazing_c_d_50)
graph export `modname'_scatter_bggw_mean_resid5_crop_graze.pdf, replace
twoway scatter resid2 bggw_mean, msymbol("+") msize(tiny) by(cropping_c_d_50 grazing_c_d_50)
graph export `modname'_scatter_bggw_mean_resid2_crop_graze.pdf, replace
twoway scatter resid5 erich_mean, msymbol("+") msize(tiny) by(cropping_c_d_50 grazing_c_d_50)
graph export `modname'_scatter_erich_mean_resid5_crop_graze.pdf, replace
twoway scatter resid5 feve_mean, msymbol("+") msize(tiny) by(cropping_c_d_50 grazing_c_d_50)
graph export `modname'_scatter_feve_mean_resid5_crop_graze.pdf, replace

* box plots of original data
su L_hectares, meanonly
local binstep = (r(max) - r(min))/(20-1)
egen L_hectares_bin = cut(L_hectares), at(`r(min)'(`binstep')`r(max)+`binstep'') label
graph box L_pphec, over(L_hectares_bin, label(angle(90))) ylabel(#5, angle(horizontal)) by(cropping_c_d_50 grazing_c_d_50)
graph export `modname'_box_L_pphec_L_hectares_crop_graze.pdf, replace

************* Graphical Diagnostics for the Model
use `modname'_data_augmented, clear
run sqreg9_klhquantiles "pred5" `modname'
use `modname'_data_augmented, clear
run sqreg9_klhquantiles "pred3" `modname'
use `modname'_data_augmented, clear
run sqreg9_klhquantiles "bggw_mean" `modname'
use `modname'_data_augmented, clear
run sqreg9_klhquantiles "erich_mean" `modname'
use `modname'_data_augmented, clear
run sqreg9_klhquantiles "feve_mean" `modname'
use `modname'_data_augmented, clear
run sqreg9_klhquantiles "trend_slope_clearing" `modname'

use `modname'_data_augmented, clear
run sqreg9_klhquantiles "L_hectares" `modname'
use `modname'_data_augmented, clear
drop if cropping_c_d_50==1 | grazing_c_d_50==1
run sqreg9_klhquantiles "L_hectares" `modname'_notcg
use `modname'_data_augmented, clear
drop if cropping_c_d_50==1 | grazing_c_d_50==0
run sqreg9_klhquantiles "L_hectares" `modname'_g
use `modname'_data_augmented, clear
drop if cropping_c_d_50==0 | grazing_c_d_50==1
run sqreg9_klhquantiles "L_hectares" `modname'_c
use `modname'_data_augmented, clear
drop if cropping_c_d_50==0 | grazing_c_d_50==0
run sqreg9_klhquantiles "L_hectares" `modname'_cg

use `modname'_data_augmented, clear





drop if hectares<3000
save `modname'_data_augmented_3000, replace //the scalars aren't saved through

* make two way scatter plots
twoway scatter L_pphec pred5, msymbol("+") msize(tiny)
graph export `modname'_3000_scatter_pred5_pphec.pdf, replace
twoway scatter L_pphec pred5, msymbol("+") msize(tiny) || lowess pred9 pred5, bwidth(0.01) || lowess pred8 pred5, bwidth(0.01) || || lowess pred7 pred5, bwidth(0.01) || lowess pred6 pred5, bwidth(0.01) || lowess pred4 pred5, bwidth(0.01) || lowess pred3 pred5, bwidth(0.01) || lowess pred2 pred5, bwidth(0.01)|| lowess pred1 pred5, bwidth(0.01)
graph export `modname'_3000_scatter_pred5_pphec_preds.pdf, replace
twoway scatter resid5 pred5, msymbol("+") msize(tiny)
graph export `modname'_3000_scatter_pred5_resid5.pdf, replace
twoway scatter resid5 L_hectares, msymbol("+") msize(tiny)
graph export `modname'_3000_scatter_L_hectares_resid5.pdf, replace


************* Graphical Diagnostics for the Model
use `modname'_data_augmented_3000, clear
run sqreg9_klhquantiles "pred5" `modname'_3000
use `modname'_data_augmented_3000, clear
run sqreg9_klhquantiles "pred3" `modname'_3000
use `modname'_data_augmented_3000, clear
run sqreg9_klhquantiles "bggw_mean" `modname'_3000
use `modname'_data_augmented_3000, clear
run sqreg9_klhquantiles "erich_mean" `modname'_3000
use `modname'_data_augmented_3000, clear
run sqreg9_klhquantiles "feve_mean" `modname'_3000
//use `modname'_data_augmented_3000, clear
//run sqreg9_klhquantiles "trend_slope_clearing" `modname'_3000 //errors - perhaps data only has single value

use `modname'_data_augmented_3000, clear
run sqreg9_klhquantiles "L_hectares" `modname'_3000
use `modname'_data_augmented_3000, clear
drop if cropping_c_d_50==1 | grazing_c_d_50==1
run sqreg9_klhquantiles "L_hectares" `modname'_notcg_3000
use `modname'_data_augmented_3000, clear
drop if cropping_c_d_50==1 | grazing_c_d_50==0
run sqreg9_klhquantiles "L_hectares" `modname'_g_3000
use `modname'_data_augmented_3000, clear
drop if cropping_c_d_50==0 | grazing_c_d_50==1
run sqreg9_klhquantiles "L_hectares" `modname'_c_3000
use `modname'_data_augmented_3000, clear
drop if cropping_c_d_50==0 | grazing_c_d_50==0
run sqreg9_klhquantiles "L_hectares" `modname'_cg_3000

use `modname'_data_augmented_3000, clear
set graphics on