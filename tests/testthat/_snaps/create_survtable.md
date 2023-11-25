# simple survtable with time_invariant exposure variable works when subgroup analyses are NOT requested (#3)

    Code
      helper_test_survtable(submodel_var = NULL, submodel_values = NULL)
    Output
      # A tibble: 4 x 8
        data_name  exposure_var        outcome_var time_var  covariates formula_str   
        <chr>      <chr>               <chr>       <chr>     <chr>      <chr>         
      1 example_ti exposure_2cat       outcome1    cens_time age + sex  Surv(cens_tim~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex  Surv(cens_tim~
      3 example_ti exposure_continuous outcome1    cens_time age + sex  Surv(cens_tim~
      4 example_ti exposure_continuous outcome2    cens_time age + sex  Surv(cens_tim~
      # i 2 more variables: submodel_var <lgl>, submodel_value <lgl>

# simple survtable with time invariant exposure variable works when subgroup analyses are requested  (#4)

    Code
      helper_test_survtable()
    Output
      # A tibble: 12 x 8
         submodel_var submodel_value data_name  exposure_var      outcome_var time_var
         <chr>        <chr>          <chr>      <chr>             <chr>       <chr>   
       1 hla          DR3/3          example_ti exposure_2cat     outcome1    cens_ti~
       2 hla          DR3/3          example_ti exposure_2cat     outcome2    cens_ti~
       3 hla          DR3/3          example_ti exposure_continu~ outcome1    cens_ti~
       4 hla          DR3/3          example_ti exposure_continu~ outcome2    cens_ti~
       5 hla          DR3/4          example_ti exposure_2cat     outcome1    cens_ti~
       6 hla          DR3/4          example_ti exposure_2cat     outcome2    cens_ti~
       7 hla          DR3/4          example_ti exposure_continu~ outcome1    cens_ti~
       8 hla          DR3/4          example_ti exposure_continu~ outcome2    cens_ti~
       9 hla          DR4/4          example_ti exposure_2cat     outcome1    cens_ti~
      10 hla          DR4/4          example_ti exposure_2cat     outcome2    cens_ti~
      11 hla          DR4/4          example_ti exposure_continu~ outcome1    cens_ti~
      12 hla          DR4/4          example_ti exposure_continu~ outcome2    cens_ti~
      # i 2 more variables: covariates <chr>, formula_str <chr>

# simple survtable with time varying exposure variable works when subgroup analyses are NOT requested  (#6, ti shorthand)

    Code
      helper_test_survtable(model_type = "ti", submodel_var = NULL, submodel_values = NULL)
    Output
      # A tibble: 4 x 8
        data_name  exposure_var        outcome_var time_var  covariates formula_str   
        <chr>      <chr>               <chr>       <chr>     <chr>      <chr>         
      1 example_ti exposure_2cat       outcome1    cens_time age + sex  Surv(cens_tim~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex  Surv(cens_tim~
      3 example_ti exposure_continuous outcome1    cens_time age + sex  Surv(cens_tim~
      4 example_ti exposure_continuous outcome2    cens_time age + sex  Surv(cens_tim~
      # i 2 more variables: submodel_var <lgl>, submodel_value <lgl>

# simple survtable with time varying exposure variable works when subgroup analyses are NOT requested  (#6)

    Code
      helper_test_survtable(model_type = "time_invariant", submodel_var = NULL,
        submodel_values = NULL)
    Output
      # A tibble: 4 x 8
        data_name  exposure_var        outcome_var time_var  covariates formula_str   
        <chr>      <chr>               <chr>       <chr>     <chr>      <chr>         
      1 example_ti exposure_2cat       outcome1    cens_time age + sex  Surv(cens_tim~
      2 example_ti exposure_2cat       outcome2    cens_time age + sex  Surv(cens_tim~
      3 example_ti exposure_continuous outcome1    cens_time age + sex  Surv(cens_tim~
      4 example_ti exposure_continuous outcome2    cens_time age + sex  Surv(cens_tim~
      # i 2 more variables: submodel_var <lgl>, submodel_value <lgl>

# simple survtable with time varying exposure variable works when subgroup analyses are requested  (#6, ti shorthand)

    Code
      helper_test_survtable(model_type = "ti")
    Output
      # A tibble: 12 x 8
         submodel_var submodel_value data_name  exposure_var      outcome_var time_var
         <chr>        <chr>          <chr>      <chr>             <chr>       <chr>   
       1 hla          DR3/3          example_ti exposure_2cat     outcome1    cens_ti~
       2 hla          DR3/3          example_ti exposure_2cat     outcome2    cens_ti~
       3 hla          DR3/3          example_ti exposure_continu~ outcome1    cens_ti~
       4 hla          DR3/3          example_ti exposure_continu~ outcome2    cens_ti~
       5 hla          DR3/4          example_ti exposure_2cat     outcome1    cens_ti~
       6 hla          DR3/4          example_ti exposure_2cat     outcome2    cens_ti~
       7 hla          DR3/4          example_ti exposure_continu~ outcome1    cens_ti~
       8 hla          DR3/4          example_ti exposure_continu~ outcome2    cens_ti~
       9 hla          DR4/4          example_ti exposure_2cat     outcome1    cens_ti~
      10 hla          DR4/4          example_ti exposure_2cat     outcome2    cens_ti~
      11 hla          DR4/4          example_ti exposure_continu~ outcome1    cens_ti~
      12 hla          DR4/4          example_ti exposure_continu~ outcome2    cens_ti~
      # i 2 more variables: covariates <chr>, formula_str <chr>

# simple survtable with time varying exposure variable works when subgroup analyses are requested  (#6)

    Code
      helper_test_survtable(model_type = "time_invariant")
    Output
      # A tibble: 12 x 8
         submodel_var submodel_value data_name  exposure_var      outcome_var time_var
         <chr>        <chr>          <chr>      <chr>             <chr>       <chr>   
       1 hla          DR3/3          example_ti exposure_2cat     outcome1    cens_ti~
       2 hla          DR3/3          example_ti exposure_2cat     outcome2    cens_ti~
       3 hla          DR3/3          example_ti exposure_continu~ outcome1    cens_ti~
       4 hla          DR3/3          example_ti exposure_continu~ outcome2    cens_ti~
       5 hla          DR3/4          example_ti exposure_2cat     outcome1    cens_ti~
       6 hla          DR3/4          example_ti exposure_2cat     outcome2    cens_ti~
       7 hla          DR3/4          example_ti exposure_continu~ outcome1    cens_ti~
       8 hla          DR3/4          example_ti exposure_continu~ outcome2    cens_ti~
       9 hla          DR4/4          example_ti exposure_2cat     outcome1    cens_ti~
      10 hla          DR4/4          example_ti exposure_2cat     outcome2    cens_ti~
      11 hla          DR4/4          example_ti exposure_continu~ outcome1    cens_ti~
      12 hla          DR4/4          example_ti exposure_continu~ outcome2    cens_ti~
      # i 2 more variables: covariates <chr>, formula_str <chr>

