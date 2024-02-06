# qreg-diagnostic-plots
Scripts to create diagnostic plots of stata sqreg fits.
Initially created for the publication: Clayton, H., Hingee, K. L., Chancellor, W., Lindenmayer, D., van Dijk, A., Vardon, M., & Boult, C. (2024). Private benefits of natural capital on farms across an endangered ecoregion. Ecological Economics, 218, 108116. https://doi.org/10.1016/j.ecolecon.2024.108116


## Background
In ordinary least squares regression we often create residual plots to check that residuals have the correct behavious 
(centered on zero and constant variance). If this is not the case then we must modify the model.

For quantile regression of the Qth quantile, the equivalent is that the residuals should have a Qth quantile of zero.
An example graphic for checking this is created by the `cqcheck()` function in the `qgam` package (Fasiolo et al., 2021) for R.
While Stata can do quantile regression, I could not find any methods to easily create a similar plot in Stata.

## Author
This was my first entrance into using Stata, so there are some very clunky operations that expert Stata programmers will cringe at.

## Dependencies
Stata 17

## Usage
Look at `demo.do` for an example use. Run the full demo by typing `do demo` in Stata's command pannel.

Copy `sqreg_saveresiduals.do` and `sqreg_diagnosticplot.do` into your working directory.
Run `sqreg` as you normally would.
Extract the quantiles you requested into a character string by:

```
local quantiles = ""
forvalues qnum = 1/`e(n_q)' {
	local quantiles = "`quantiles' `e(q`qnum')'"
}
display "`quantiles'"
```

Choose a name to prefix all the files generated (demo here):
```
local modname = "demo" 
```

Save the predictions and residuals from sqreg into a file with:
```
run sqreg_saveresiduals `modname'
```
This will also overwrite your returned data.


Use this file to generate diagnostic plots with:
```
use `modname'_residuals, clear
run sqreg_diagnosticplot "covariatename" `modname' "`quantiles'"
```



## References
Fasiolo, M., Wood, S.N., Zaffran, M., Nedellec, R., Goude, Y., 2021. qgam: Bayesian nonparametric quantile regression modeling in R. J. Stat. Softw. 100 (9), 1–31. https://doi.org/10.18637/jss.v100.i09.