# simple survtable with time_invariant exposure variable works when subgroup analyses are NOT requested (#3)

    Code
      helper_test_survtable(submodel_var = NULL, submodel_values = NULL)
    Output
      # A tibble: 4 x 5
        data_name  exposure_var        outcome_var time_var  formula                  
        <chr>      <chr>               <chr>       <chr>     <chr>                    
      1 example_ti exposure_2cat       outcome1    cens_time Surv(cens_time, outcome1~
      2 example_ti exposure_2cat       outcome2    cens_time Surv(cens_time, outcome2~
      3 example_ti exposure_continuous outcome1    cens_time Surv(cens_time, outcome1~
      4 example_ti exposure_continuous outcome2    cens_time Surv(cens_time, outcome2~

# simple survtable with time invariant exposure variable works when subgroup analyses are requested  (#4)

    Code
      helper_test_survtable()
    Output
      # A tibble: 12 x 7
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
      # i 1 more variable: formula <chr>

# simple survtable with time varying exposure variable works when subgroup analyses are NOT requested  (#6, ti shorthand)

    Code
      helper_test_survtable(model_type = "ti", submodel_var = NULL, submodel_values = NULL)
    Output
      # A tibble: 4 x 5
        data_name  exposure_var        outcome_var time_var  formula                  
        <chr>      <chr>               <chr>       <chr>     <chr>                    
      1 example_ti exposure_2cat       outcome1    cens_time Surv(cens_time, outcome1~
      2 example_ti exposure_2cat       outcome2    cens_time Surv(cens_time, outcome2~
      3 example_ti exposure_continuous outcome1    cens_time Surv(cens_time, outcome1~
      4 example_ti exposure_continuous outcome2    cens_time Surv(cens_time, outcome2~

# simple survtable with time varying exposure variable works when subgroup analyses are NOT requested  (#6)

    Code
      helper_test_survtable(model_type = "time_invariant", submodel_var = NULL,
        submodel_values = NULL)
    Output
      # A tibble: 4 x 5
        data_name  exposure_var        outcome_var time_var  formula                  
        <chr>      <chr>               <chr>       <chr>     <chr>                    
      1 example_ti exposure_2cat       outcome1    cens_time Surv(cens_time, outcome1~
      2 example_ti exposure_2cat       outcome2    cens_time Surv(cens_time, outcome2~
      3 example_ti exposure_continuous outcome1    cens_time Surv(cens_time, outcome1~
      4 example_ti exposure_continuous outcome2    cens_time Surv(cens_time, outcome2~

# simple survtable with time varying exposure variable works when subgroup analyses are requested  (#6, ti shorthand)

    Code
      helper_test_survtable(model_type = "ti")
    Output
      # A tibble: 12 x 7
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
      # i 1 more variable: formula <chr>

# simple survtable with time varying exposure variable works when subgroup analyses are requested  (#6)

    Code
      helper_test_survtable(model_type = "time_invariant")
    Output
      # A tibble: 12 x 7
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
      # i 1 more variable: formula <chr>

