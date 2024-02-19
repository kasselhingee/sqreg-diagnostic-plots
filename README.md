# qreg-diagnostic-plots
Scripts to create diagnostic plots of stata sqreg fits.
Initially created for the publication: Clayton, H., Hingee, K. L., Chancellor, W., Lindenmayer, D., van Dijk, A., Vardon, M., & Boult, C. (2024). Private benefits of natural capital on farms across an endangered ecoregion. Ecological Economics, 218, 108116. https://doi.org/10.1016/j.ecolecon.2024.108116


## Background
In ordinary least squares regression we often create residual plots to check that residuals have the correct behavious 
(centered on zero and constant variance). If this is not the case then we must modify the model.

For quantile regression of the Qth quantile, the equivalent is that the residuals should have a Qth quantile of zero.
An example graphic for checking this is created by the `cqcheck()` function in the `qgam` package (Fasiolo et al., 2021) for R.
While Stata can do quantile regression, I could not find any methods to easily create a similar plot in Stata, thats what the scripts in this repository do.

## Author: Kassel Liam Hingee
This was my first entrance into using Stata, so there are some very clunky operations that expert Stata programmers will cringe at and reproducibility is difficult.

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

## Assessing Your Model
In every quantile regression model for quantile Q, there is an assumption that at any given covariate values, the Qth quantile of the response is predicted by the model.
Often this quantile of the response conditional on covariate values is called the 'conditional quantile'. In 'sqreg' this assumption is made for every quantile modelled.
Another way to state this assumption is that the conditional quantile of the residual (response - prediction) is zero.

Usually data is such that every measurement has a unique set of covariate values, so we cant estimate conditional quantiles of the residuals directly.
But we can get close by estimating the quantiles of the residuals binned according to covariate values.
The code here use the 'centile' command for that.
If these estimates of the conditional quantiles of the residuals are NOT WITHIN error of zero then the model assumption is wrong.

For a chosen covariate, the code generates plots with multiple panels.
The covariate is divided into 10 equally spaced bins.
The final panel is a histogram of the data binned according to the covariate.
The other panels each correspond to a requested quantile model in sqreg. They are ordered left to right, top to bottom.
The dots are the estimated quantiles of the residuals in the bin, and their error bars show the accuracy of the estimate.
If an error bar does not cross zero then the the model assumption is wrong for the quantile model.
If there is a systematic difference between quantile of the residual and the covariate then that may point to an improved model.

Below is an example where the conditional quantiles appear correctly predicted by the model for the 20th percentile.
![A panel with all error bars crossing zero](/demo_panel_pass.png)

When there are many error bars that dont cross zero then I conclude that the conditional quantiles are not predicted by the model.
The figure below is an example of this.
In this case, the model is missing the square of 'x1'
![A panel with some error bars above zero](/demo_panel_fail.png)

## References
Fasiolo, M., Wood, S.N., Zaffran, M., Nedellec, R., Goude, Y., 2021. qgam: Bayesian nonparametric quantile regression modeling in R. J. Stat. Softw. 100 (9), 1–31. https://doi.org/10.18637/jss.v100.i09.