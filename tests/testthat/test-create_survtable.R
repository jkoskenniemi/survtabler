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


helper_test_survtable()


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
