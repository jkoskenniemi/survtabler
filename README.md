
<!-- README.md is generated from README.Rmd. Please edit that file -->

# survtabler

<!-- badges: start -->
<!-- badges: end -->

`survival` package in R is great for interactively and flexibly running
survival models and evaluate the resulting model. However, it does not
“teach” any structure for an efficient workflow, and often leads to
imperative programming and long and complicated analysis scripts. The
aim of `survtabler` is to make survival analysis fast, concise, and
intuitive while keeping the analysis code easy to read. This is achieved
by *function-based* workflow, where many typical steps (modeling,
graphing, analyses of violations of proportional hazards model) are
automated with functions.

## Installation

You can install the development version of `survtabler` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jkoskenniemi/survtabler")
#> Downloading GitHub repo jkoskenniemi/survtabler@HEAD
#> stringi (1.8.1 -> 1.8.2) [CRAN]
#> Installing 1 packages: stringi
#> 
#>   There is a binary version available but the source version is later:
#>         binary source needs_compilation
#> stringi  1.8.1  1.8.2              TRUE
#> installing the source package 'stringi'
#> Warning in i.p(...): installation of package 'stringi' had non-zero exit status
#> -- R CMD build -----------------------------------------------------------------
#>          checking for file 'C:\Users\jajoko\AppData\Local\Temp\Rtmp0Gta7F\remotes1d9026356404\jkoskenniemi-survtabler-f1665fe/DESCRIPTION' ...  v  checking for file 'C:\Users\jajoko\AppData\Local\Temp\Rtmp0Gta7F\remotes1d9026356404\jkoskenniemi-survtabler-f1665fe/DESCRIPTION' (461ms)
#>       -  preparing 'survtabler':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   v  checking DESCRIPTION meta-information
#>       -  checking for LF line-endings in source and make files and shell scripts
#>   -  checking for empty or unneeded directories
#>       -  building 'survtabler_0.0.0.9001.tar.gz'
#>      
#> 
```

## Example

The first and the most important step is to provide a recipe for the
survival analysis in R. This is done by creating a `survtable` object:
essentially a data.frame that lists in each row two items needed for Cox
Proportional Hazards Model modeled under the hood using
`survival::coxph()`: `formula` and `data`. Function `create_survtable()`
lists all combinations of analysis data (`data_name`) and variables
given for outcome, exposure, survival time (`outcome_vars`,
`exposure_vars`, `time_var`). Using these input and `covariates` used to
adjust the model, it formulates the Cox Porportional Hazards model
`formula` for each combination (each row of the `survtable` data frame).

``` r
library(survtabler)
library(magrittr)

#Specify all combinations of exposure, outcome, time variables and data_name
survtable_1 <- create_survtable(exposure_vars = c("exposure_2cat", "exposure_continuous"),
                 outcome_vars = c("outcome1", "outcome2"),
                 covariates = "age + sex + hla",
                 time_var = "cens_time",
                 data_name = "example_ti")
```

Once the `survtable` is established, it is very easy to run Cox
Proportional Hazards model for each combination and return the result as
a list

``` r
models <- survtable_1 %>%  
  model_survtable()
```

And then get the model coefficients and draw a forest plot, …

``` r
models  %>%  
  get_coefs(c("exposure_2cat", "exposure_continuous"))  %>%  #Get coefficients for forrest plots
  graph_coefs(title = "**Your title here**") #Draw forest plots
```

<img src="man/figures/README-example_4-1.png" width="100%" />

… other model metadata, …

``` r
models  %>%  
  get_model_meta()
#>      n n_event n_missing
#> 1 8000    3996         0
#> 2 8000    3996         0
#> 3 8000    3996         0
#> 4 8000    3996         0
#>                                                                 formula
#> 1 survival::Surv(cens_time, outcome1) ~ exposure_2cat + age + sex + hla
#> 2 survival::Surv(cens_time, outcome1) ~ exposure_2cat + age + sex + hla
#> 3 survival::Surv(cens_time, outcome1) ~ exposure_2cat + age + sex + hla
#> 4 survival::Surv(cens_time, outcome1) ~ exposure_2cat + age + sex + hla
```

…, and finally analyze the models for departures of proportionality of
the hazards assumption.

``` r
models  %>%  
  catch_nonph()
#> [1] chisq    df       p        variable model   
#> <0 rows> (or 0-length row.names)
```
