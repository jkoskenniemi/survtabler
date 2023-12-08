
<!-- README.md is generated from README.Rmd. Please edit that file -->

# survtabler

<!-- badges: start -->
<!-- badges: end -->

`survival` package in R is great for interactively and flexibly running
survival models. However, it does not teach a structure for an efficient
workflow. The aim of `survtabler` is to make survival analysis fast,
concise, and intuitive, while keeping the analysis code easy to read.
This is achieved by *function-based* workflow, where many typical steps
(modeling, graphing, analyses of violations of proportional hazards
model) are automated with functions.

## Motivation

Let `example_ti` be a simulated survival data.frame with 8,000
individuals who either experienced an outcome 1 or 2. An analyst would
be interested on an association between exposures `exposure_2cat` and
`exposure_continuous` on two different outcomes (`outcome1` and
`outcome2` - for simplicity here the censoring_time for both of them is
the same). Associations should be adjusted for age (`age`) and HLA DR-DQ
genotype (`hla`) unless models are run only in subgroups defined by the
HLA genotype (Type 2, Type 1, and Type 3).

<details>
<summary>
Here is a typical imperative script that analyzes the data in 129 lines
</summary>

–\>

``` r
library(dplyr)
library(survival)
library(survtabler)
library(stringr)
library(broom)
library(ggplot2)
library(scales)

# Create subgroups used in analyses
example_ti_hla1 <- example_ti %>% filter(hla == "Type 1") 
example_ti_hla2 <- example_ti %>% filter(hla == "Type 2") 
example_ti_hla3 <- example_ti %>% filter(hla == "Type 3") 

# Make models
model_outcome1_exposure2cat_hla1 <- coxph(formula = Surv(cens_time, outcome1) ~ exposure_2cat + age + sex, data = example_ti_hla1)
model_outcome1_exposure2cat_hla2 <- coxph(formula = Surv(cens_time, outcome1) ~ exposure_2cat + age + sex, data = example_ti_hla2)
model_outcome1_exposure2cat_hla3 <- coxph(formula = Surv(cens_time, outcome1) ~ exposure_2cat + age + sex, data = example_ti_hla3)
model_outcome1_exposurecont_hla1 <- coxph(formula = Surv(cens_time, outcome1) ~ exposure_continuous + age + sex, data = example_ti_hla1)
model_outcome1_exposurecont_hla2 <- coxph(formula = Surv(cens_time, outcome1) ~ exposure_continuous + age + sex, data = example_ti_hla2)
model_outcome1_exposurecont_hla3 <- coxph(formula = Surv(cens_time, outcome1) ~ exposure_continuous + age + sex, data = example_ti_hla3)
model_outcome2_exposure2cat_hla1 <- coxph(formula = Surv(cens_time, outcome2) ~ exposure_2cat + age + sex, data = example_ti_hla1)
model_outcome2_exposure2cat_hla2 <- coxph(formula = Surv(cens_time, outcome2) ~ exposure_2cat + age + sex, data = example_ti_hla2)
model_outcome2_exposure2cat_hla3 <- coxph(formula = Surv(cens_time, outcome2) ~ exposure_2cat + age + sex, data = example_ti_hla3)
model_outcome2_exposurecont_hla1 <- coxph(formula = Surv(cens_time, outcome2) ~ exposure_continuous + age + sex, data = example_ti_hla1)
model_outcome2_exposurecont_hla2 <- coxph(formula = Surv(cens_time, outcome2) ~ exposure_continuous + age + sex, data = example_ti_hla2)
model_outcome2_exposurecont_hla3 <- coxph(formula = Surv(cens_time, outcome2) ~ exposure_continuous + age + sex, data = example_ti_hla3)

#assess models
model_outcome1_exposure2cat_hla1
model_outcome1_exposure2cat_hla2
model_outcome1_exposure2cat_hla3
model_outcome1_exposurecont_hla1
model_outcome1_exposurecont_hla2
model_outcome1_exposurecont_hla3
model_outcome2_exposure2cat_hla1
model_outcome2_exposure2cat_hla2
model_outcome2_exposure2cat_hla3
model_outcome2_exposurecont_hla1
model_outcome2_exposurecont_hla2
model_outcome2_exposurecont_hla3

# Analyze proportional hazards assumptions
cox.zph(model_outcome1_exposure2cat_hla1)
cox.zph(model_outcome1_exposure2cat_hla2)
cox.zph(model_outcome1_exposure2cat_hla3)
cox.zph(model_outcome1_exposurecont_hla1)
cox.zph(model_outcome1_exposurecont_hla2)
cox.zph(model_outcome2_exposure2cat_hla1)
cox.zph(model_outcome2_exposure2cat_hla2)
cox.zph(model_outcome2_exposure2cat_hla3)
cox.zph(model_outcome2_exposurecont_hla1)
cox.zph(model_outcome2_exposurecont_hla2)
cox.zph(model_outcome2_exposurecont_hla3)

# Extract Coefficients
model_outcome1_exposure2cat_hla1_coefs <- tidy(model_outcome1_exposure2cat_hla1) %>% 
  mutate(model = "outcome1_exposure2cat_hla1_coefs")
model_outcome1_exposure2cat_hla2_coefs <- tidy(model_outcome1_exposure2cat_hla2) %>% 
  mutate(model = "outcome1_exposure2cat_hla2_coefs")
model_outcome1_exposure2cat_hla3_coefs <- tidy(model_outcome1_exposure2cat_hla3) %>% 
  mutate(model = "outcome1_exposure2cat_hla3_coefs")
model_outcome1_exposurecont_hla1_coefs <- tidy(model_outcome1_exposurecont_hla1) %>% 
  mutate(model = "outcome1_exposurecont_hla1_coefs")
model_outcome1_exposurecont_hla2_coefs <- tidy(model_outcome1_exposurecont_hla2) %>% 
  mutate(model = "outcome1_exposurecont_hla2_coefs")
model_outcome1_exposurecont_hla3_coefs <- tidy(model_outcome1_exposurecont_hla3) %>% 
  mutate(model = "outcome1_exposurecont_hla3_coefs")
model_outcome2_exposure2cat_hla1_coefs <- tidy(model_outcome2_exposure2cat_hla1) %>% 
  mutate(model = "outcome2_exposure2cat_hla1_coefs")
model_outcome2_exposure2cat_hla2_coefs <- tidy(model_outcome2_exposure2cat_hla2) %>% 
  mutate(model = "outcome2_exposure2cat_hla2_coefs")
model_outcome2_exposure2cat_hla3_coefs <- tidy(model_outcome2_exposure2cat_hla3) %>% 
  mutate(model = "outcome2_exposure2cat_hla3_coefs")
model_outcome2_exposurecont_hla1_coefs <- tidy(model_outcome2_exposurecont_hla1) %>% 
  mutate(model = "outcome2_exposurecont_hla1_coefs")
model_outcome2_exposurecont_hla2_coefs <- tidy(model_outcome2_exposurecont_hla2) %>% 
  mutate(model = "outcome2_exposurecont_hla2_coefs")
model_outcome2_exposurecont_hla3_coefs <- tidy(model_outcome2_exposurecont_hla3) %>% 
  mutate(model = "outcome2_exposurecont_hla3_coefs")

#Merge coefficients
coefficients <- model_outcome1_exposure2cat_hla1_coefs %>% 
  full_join(model_outcome1_exposure2cat_hla2_coefs) %>% 
  full_join(model_outcome1_exposure2cat_hla3_coefs) %>% 
  full_join(model_outcome1_exposurecont_hla1_coefs) %>% 
  full_join(model_outcome1_exposurecont_hla2_coefs) %>% 
  full_join(model_outcome1_exposurecont_hla3_coefs) %>% 
  full_join(model_outcome2_exposure2cat_hla1_coefs) %>% 
  full_join(model_outcome2_exposure2cat_hla2_coefs) %>% 
  full_join(model_outcome2_exposure2cat_hla3_coefs) %>% 
  full_join(model_outcome2_exposurecont_hla1_coefs) %>% 
  full_join(model_outcome2_exposurecont_hla2_coefs) %>% 
  full_join(model_outcome2_exposurecont_hla3_coefs)
  
# Create graph data
coefficients <- coefficients %>%
  filter(term %in% c("exposure_2cat", "exposure_continuous")) %>% 
    mutate(sig = ifelse(p.value < 0.05, 1, 0)) %>% 
    mutate(sig = factor(sig, levels = c(0, 1),
                        labels = c("p>=0.05", "p<0.05"))) %>% 
  mutate(model = str_remove(model, "_coefs")) %>% 
  mutate(model = str_remove(model, "exposure2cat_")) %>% 
  mutate(model = str_remove(model, "exposurecont_")) %>% 
  mutate(outcome = str_extract(model, ".*?_")) %>%
  mutate(outcome = str_remove(outcome, "_")) %>% 
  mutate(hla = str_extract(model, "(?<=_).*")) %>% 
  mutate(hla = case_when(
    hla == "hla1" ~ "Type 1",
    hla == "hla2" ~ "Type 2",
    hla == "hla3" ~ "Type 3"))

# Graph
coefficients %>%
    ggplot(aes(x = term, y = exp(estimate),
               ymin = exp(estimate - 1.96 * std.error),
               ymax = exp(estimate + 1.96 * std.error),
               colour = sig)) +
    geom_pointrange() +
    geom_text(aes(label = paste0(sprintf("%.2f", signif(exp(estimate), 3)), " (",
                                 sprintf("%.2f", signif(exp(estimate - 1.96 * std.error), 3)), ",",
                                 sprintf("%.2f", signif(exp(estimate + 1.96 * std.error), 3)), ")")),
              vjust = -0.5,
              size = 3.75) +
    coord_flip() +
    geom_hline(yintercept = 1, linetype = "dashed", colour = "grey40") +
    ylab("Hazard Ratio") +
    xlab(NULL) +
    theme(legend.position = "none") +
    ggtitle("Association between risk of 2 outcomes and 2 exposures in 3 groups defined by HLA DR genotypes") +
    scale_y_continuous(trans = "log", labels = label_number(max_n = 2)) +
  facet_wrap(~factor(outcome):factor(hla))
```

</details>
<details>
<summary>
Here is how that would be analyzed with survtabler in 15 lines (analyzed
in detail below).
</summary>

–\>

``` r
library(survtabler)

#Build a 'survtable' with combinations of survival model data and model formula
survtable_1 <- create_survtable(exposure_vars = c("exposure_2cat", "exposure_continuous"),
                                outcome_vars = c("outcome1", "outcome2"),
                                covariates = "age + sex + hla",
                                submodel_var = "hla",
                                submodel_values = c("Type 1", "Type 2", "Type 3"),
                                time_var = "cens_time",
                                data_name = "example_ti")

#Run all Cox Proportional Hazards models listed in survtable_1
models <- survtable_1 %>% model_survtable()

#Extract coefficients and graph a forrest plot
models %>% get_coefs() %>% 
  graph_coefs()

#Get model metadata
models  %>% get_model_meta()

#Catch models that violate the proportional hazards assumption
models  %>% catch_nonph()
```

</details>

The ‘survtabler way’ takes 88% of less lines of code to write and the
code is way easier to read. The advantage of using survtabler is way
more obvious when the number of model combinations increases to dozens,
hundreds or even thousands. Furthermore, survtabler function-based
scripts are easier to work with when analyses often need to be refined
later. It would be much nicer to e.g. tweak the covariates here in one
line than in possibly dozens.

## Installation

You can install the development version of `survtabler` from
[GitHub](https://github.com/) with:

``` r
install.packages("devtools")
devtools::install_github("jkoskenniemi/survtabler")
```

## Example

Below, we go through the steps of the earlier example in more detail.

The first step is to plan and specify the Survival models that are
analyzed. `create_survtable()` builds a `survtable`, a ‘recipe’
data.frame for survival analyses. Each row specifies everything that is
required by `Survival::coxph()` to run one of the desired Cox
Proportional hazards model: a model formula (`formula`) and analysis
data (`data_name`).

`survtable` is built by specifying the helper function
`create_survtable` the requested exposures (input `expoure_vars`),
outcomes (`outcome_vars`), follow-up time (`time_var`) and analysis data
(`data`). `create_survtable()` then builds all possible combinations of
exposure-outcome-time-data. Optionally, subgroup analyses can be
requested by providing the variable and values (`submodel_var` and
`submodel_values`) that that define subgroup analysis dataset
(i.e. `submodel_var`==`submodel_value1`,
`submodel_var`==`submodel_value2`, `submodel_var`==`submodel_value3`
etc.).

``` r
library(survtabler)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

#Specify all combinations of exposure, outcome, time variables and data_name
survtable_1 <- 
  create_survtable(exposure_vars = c("exposure_2cat", "exposure_continuous"),
                 outcome_vars = c("outcome1", "outcome2"),
                 covariates = "age + sex",
                 time_var = "cens_time",
                 submodel_var = "hla",
                 submodel_values = c("Type 1", "Type 2", "Type 3"),
                 data_name = "example_ti")
```

``` r
survtable_1 %>% select(data_name, formula)
#> # A tibble: 12 x 2
#>    data_name  formula                                                    
#>    <chr>      <chr>                                                      
#>  1 example_ti Surv(cens_time, outcome1) ~ exposure_2cat + age + sex      
#>  2 example_ti Surv(cens_time, outcome2) ~ exposure_2cat + age + sex      
#>  3 example_ti Surv(cens_time, outcome1) ~ exposure_continuous + age + sex
#>  4 example_ti Surv(cens_time, outcome2) ~ exposure_continuous + age + sex
#>  5 example_ti Surv(cens_time, outcome1) ~ exposure_2cat + age + sex      
#>  6 example_ti Surv(cens_time, outcome2) ~ exposure_2cat + age + sex      
#>  7 example_ti Surv(cens_time, outcome1) ~ exposure_continuous + age + sex
#>  8 example_ti Surv(cens_time, outcome2) ~ exposure_continuous + age + sex
#>  9 example_ti Surv(cens_time, outcome1) ~ exposure_2cat + age + sex      
#> 10 example_ti Surv(cens_time, outcome2) ~ exposure_2cat + age + sex      
#> 11 example_ti Surv(cens_time, outcome1) ~ exposure_continuous + age + sex
#> 12 example_ti Surv(cens_time, outcome2) ~ exposure_continuous + age + sex
```

After the `survtable` has been created, in principle the following steps
(`model_survtable()`, `get_coefs()`, `graph_coefs()`,
`get_model_metadata()`, `catch_nonph()`, can be automated and included
in a single function (to be created). However, they are all are shown
here to show the entire process.

First, each models are fitted and returned as a list

``` r
models <- survtable_1 %>%  
  model_survtable()
```

And then model coefficients are extracted and a forest plot drawn, …

``` r
models  %>%  
  get_coefs()  %>%  #Get coefficients for forrest plots
  graph_coefs(title = "**Your title here**") #Draw forest plots
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

… model metadata extracted, …

``` r
models  %>%  
  get_model_meta()
#>                                                        n n_event n_missing
#> outcome1~exposure_2cat|example_ti,hla==Type 1       4021    1998         0
#> outcome2~exposure_2cat|example_ti,hla==Type 1       4021    2045         0
#> outcome1~exposure_continuous|example_ti,hla==Type 1 4021    1998         0
#> outcome2~exposure_continuous|example_ti,hla==Type 1 4021    2045         0
#> outcome1~exposure_2cat|example_ti,hla==Type 2       3957    2009         0
#> outcome2~exposure_2cat|example_ti,hla==Type 2       3957    1951         0
#> outcome1~exposure_continuous|example_ti,hla==Type 2 3957    2009         0
#> outcome2~exposure_continuous|example_ti,hla==Type 2 3957    1951         0
#> outcome1~exposure_2cat|example_ti,hla==Type 3       4022    2013         0
#> outcome2~exposure_2cat|example_ti,hla==Type 3       4022    2033         0
#> outcome1~exposure_continuous|example_ti,hla==Type 3 4022    2013         0
#> outcome2~exposure_continuous|example_ti,hla==Type 3 4022    2033         0
#>                                                           data    submodel
#> outcome1~exposure_2cat|example_ti,hla==Type 1       example_ti hla==Type 1
#> outcome2~exposure_2cat|example_ti,hla==Type 1       example_ti hla==Type 1
#> outcome1~exposure_continuous|example_ti,hla==Type 1 example_ti hla==Type 1
#> outcome2~exposure_continuous|example_ti,hla==Type 1 example_ti hla==Type 1
#> outcome1~exposure_2cat|example_ti,hla==Type 2       example_ti hla==Type 2
#> outcome2~exposure_2cat|example_ti,hla==Type 2       example_ti hla==Type 2
#> outcome1~exposure_continuous|example_ti,hla==Type 2 example_ti hla==Type 2
#> outcome2~exposure_continuous|example_ti,hla==Type 2 example_ti hla==Type 2
#> outcome1~exposure_2cat|example_ti,hla==Type 3       example_ti hla==Type 3
#> outcome2~exposure_2cat|example_ti,hla==Type 3       example_ti hla==Type 3
#> outcome1~exposure_continuous|example_ti,hla==Type 3 example_ti hla==Type 3
#> outcome2~exposure_continuous|example_ti,hla==Type 3 example_ti hla==Type 3
```

… and finally models that violate proportionality of the hazards
assumption can be caught (the following example has none).

``` r
models  %>%  
  catch_nonph()
#>                   chisq df       p      variable
#> exposure_2cat...1  7.17  1 0.00739 exposure_2cat
#> exposure_2cat...2  8.96  1 0.00277 exposure_2cat
#> GLOBAL...3        10.50  3 0.01450        GLOBAL
#> exposure_2cat...4  4.70  1 0.03020 exposure_2cat
#> GLOBAL...5         9.10  3 0.02790        GLOBAL
#>                                                           model
#> exposure_2cat...1 outcome1~exposure_2cat|example_ti,hla==Type 1
#> exposure_2cat...2 outcome2~exposure_2cat|example_ti,hla==Type 1
#> GLOBAL...3        outcome2~exposure_2cat|example_ti,hla==Type 1
#> exposure_2cat...4 outcome2~exposure_2cat|example_ti,hla==Type 2
#> GLOBAL...5        outcome2~exposure_2cat|example_ti,hla==Type 2
```
