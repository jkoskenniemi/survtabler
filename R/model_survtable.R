
#' Model Survival Using Cox Proportional Hazards Models
#'
#' @param survtable A data.frame containing `data_name`, `formula_str`, `submodel_var`, `submodel_value`,
#' `outcome_var` and `exposure_var`
#'
#' @return A list of survival models with legnth of the number of rows in input data.frame.

#' @importFrom magrittr %>%
#' @importFrom purrr pmap
#'
#' @examples
#'
#' create_survtable(
#'   exposure_vars = c("exposure_2cat", "exposure_continuous"),
#'   outcome_vars = c("outcome1", "outcome2"),
#'   covariates = "age + sex + hla",
#'   time_var = "cens_time",
#'   data_name = "example_ti") |>
#' model_survtable()
#'
#' @export
model_survtable <- function(survtable) {
  model_list <- purrr::pmap(list(survtable$data_name, survtable$formula_str,
                          survtable$submodel_var, survtable$submodel_value,
                          survtable$outcome_var, survtable$exposure_var),
                     function(data, formula_str, submodel_var, submodel_value, outcome_var, exposure_var) {
                       # Construct model names for each model
                       model_name <- paste0(outcome_var, "~", exposure_var, "|", data,
                                            ifelse(!is.null(submodel_var) && !is.null(submodel_value),
                                                   paste0("(", submodel_var, "==", submodel_value, ")"),
                                                   ""))
                       # Run cox ph models
                       model <- analyze_coxph(data, formula_str, submodel_var, submodel_value)

                       # Save model names as an attribute
                       attr(model, "model_name") <- model_name
                       model
                     })
  model_list
}



