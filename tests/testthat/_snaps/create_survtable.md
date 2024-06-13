# simple survtable with time_invariant exposure variable works when subgroup analyses are NOT requested (#3)

    Code
      helper_test_survtable(submodel_var = NULL, submodel_values = NULL)
    Output
      # A tibble: 4 x 6
        data_name  exposure_var        outcome_var time_var  covariate_var formula    
        <chr>      <chr>               <chr>       <chr>     <chr>         <chr>      
      1 example_ti exposure_2cat       outcome1    cens_time age + sex     Surv(cens_~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex     Surv(cens_~
      3 example_ti exposure_continuous outcome1    cens_time age + sex     Surv(cens_~
      4 example_ti exposure_continuous outcome2    cens_time age + sex     Surv(cens_~

# simple survtable with time invariant exposure variable works when subgroup analyses are requested  (#4)

    Code
      helper_test_survtable()
    Output
      # A tibble: 4 x 6
        data_name  exposure_var        outcome_var time_var  covariate_var formula    
        <chr>      <chr>               <chr>       <chr>     <chr>         <chr>      
      1 example_ti exposure_2cat       outcome1    cens_time age + sex     Surv(cens_~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex     Surv(cens_~
      3 example_ti exposure_continuous outcome1    cens_time age + sex     Surv(cens_~
      4 example_ti exposure_continuous outcome2    cens_time age + sex     Surv(cens_~

# simple survtable with time varying exposure variable works when subgroup analyses are NOT requested  (#6, ti shorthand)

    Code
      helper_test_survtable(model_type = "ti", submodel_var = NULL, submodel_values = NULL)
    Output
      # A tibble: 4 x 6
        data_name  exposure_var        outcome_var time_var  covariate_var formula    
        <chr>      <chr>               <chr>       <chr>     <chr>         <chr>      
      1 example_ti exposure_2cat       outcome1    cens_time age + sex     Surv(cens_~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex     Surv(cens_~
      3 example_ti exposure_continuous outcome1    cens_time age + sex     Surv(cens_~
      4 example_ti exposure_continuous outcome2    cens_time age + sex     Surv(cens_~

# simple survtable with time varying exposure variable works when subgroup analyses are NOT requested  (#6)

    Code
      helper_test_survtable(model_type = "time_invariant", submodel_var = NULL,
        submodel_values = NULL)
    Output
      # A tibble: 4 x 6
        data_name  exposure_var        outcome_var time_var  covariate_var formula    
        <chr>      <chr>               <chr>       <chr>     <chr>         <chr>      
      1 example_ti exposure_2cat       outcome1    cens_time age + sex     Surv(cens_~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex     Surv(cens_~
      3 example_ti exposure_continuous outcome1    cens_time age + sex     Surv(cens_~
      4 example_ti exposure_continuous outcome2    cens_time age + sex     Surv(cens_~

# simple survtable with time varying exposure variable works when subgroup analyses are requested  (#6, ti shorthand)

    Code
      helper_test_survtable(model_type = "ti")
    Output
      # A tibble: 4 x 6
        data_name  exposure_var        outcome_var time_var  covariate_var formula    
        <chr>      <chr>               <chr>       <chr>     <chr>         <chr>      
      1 example_ti exposure_2cat       outcome1    cens_time age + sex     Surv(cens_~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex     Surv(cens_~
      3 example_ti exposure_continuous outcome1    cens_time age + sex     Surv(cens_~
      4 example_ti exposure_continuous outcome2    cens_time age + sex     Surv(cens_~

# simple survtable with time varying exposure variable works when subgroup analyses are requested  (#6)

    Code
      helper_test_survtable(model_type = "time_invariant")
    Output
      # A tibble: 4 x 6
        data_name  exposure_var        outcome_var time_var  covariate_var formula    
        <chr>      <chr>               <chr>       <chr>     <chr>         <chr>      
      1 example_ti exposure_2cat       outcome1    cens_time age + sex     Surv(cens_~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex     Surv(cens_~
      3 example_ti exposure_continuous outcome1    cens_time age + sex     Surv(cens_~
      4 example_ti exposure_continuous outcome2    cens_time age + sex     Surv(cens_~

