helper_test_survtable <- function(exposure_vars = c("exposure_2cat", "exposure_continuous"),
                                  outcome_vars = c("outcome1", "outcome2"),
                                  covariates = "age + sex",
                                  submodel_var = "hla",
                                  submodel_values = c("DR3/3", "DR3/4", "DR4/4"),
                                  time_var = "cens_time",
                                  data_name = "example_ti",
                                  model_type = "ti") {
  create_survtable(
    exposure_vars = exposure_vars,
    outcome_vars = outcome_vars,
    covariates = covariates,
    submodel_var = submodel_var,
    submodel_values = submodel_values,
    time_var = time_var,
    data_name = data_name,
    model_type = model_type
  )
}
# 
# 
# default_covariates <- "age + sex + hla"
# 
# survtable_1 <- create_survtable(exposure_vars = c("exposure_2cat", "exposure_continuous"),
#                                 outcome_vars = c("outcome1", "outcome2"),
#                                 covariates = "age + sex + hla",
#                                 time_var = "cens_time",
#                                 data_name = "example_ti")
# 
# survtable_2 <- create_survtable(exposure_vars = c("exposure_2cat", "exposure_continuous"),
#                                 outcome_vars = c("outcome1", "outcome2"),
#                                 covariates = "age + sex",
#                                 submodel_var = "hla",
#                                 submodel_values = c("DR3/3", "DR3/4", "DR4/4"),
#                                 time_var = "cens_time",
#                                 data_name = "example_ti")
# 
# models_1 <- model_survtable(survtable_1)
# models_2 <- model_survtable(survtable_2)
# 
# coefs_1 <- get_coefs(models_1)
# coefs_2 <- get_coefs(models_2)
# 
# model_meta_1 <- get_model_meta(models_1)
# model_meta_2 <- get_model_meta(models_2)
# 
# coefs_1 %>% 
#   graph_coefs("title")
# 
# coefs_2 %>% 
#   graph_coefs("title")
# 


# 3
test_that("simple survtable with time_invariant exposure variable works when subgroup analyses are NOT requested (#3)", {
  expect_snapshot(helper_test_survtable(submodel_var = NULL, submodel_values = NULL))
})

# 4
test_that("simple survtable with time invariant exposure variable works when subgroup analyses are requested  (#4)", {
  expect_snapshot(helper_test_survtable())
})

# 6
test_that("simple survtable with time varying exposure variable works when subgroup analyses are NOT requested  (#6, ti shorthand)", {
  expect_snapshot(helper_test_survtable(model_type = "ti", submodel_var = NULL, submodel_values = NULL))
})

test_that("simple survtable with time varying exposure variable works when subgroup analyses are NOT requested  (#6)", {
  expect_snapshot(helper_test_survtable(model_type = "time_invariant", submodel_var = NULL, submodel_values = NULL))
})


# 7
test_that("simple survtable with time varying exposure variable works when subgroup analyses are requested  (#6, ti shorthand)", {
  expect_snapshot(helper_test_survtable(model_type = "ti"))
})

test_that("simple survtable with time varying exposure variable works when subgroup analyses are requested  (#6)", {
  expect_snapshot(helper_test_survtable(model_type = "time_invariant"))
})
