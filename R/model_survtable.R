
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
  
  model_list <- purrr::pmap(list(survtable$data_name, survtable$formula, survtable$exposure_var, survtable$outcome_var),
                            function(data, formula, exposure_var, outcome_var) {
                              # Construct model names for each model
                              model_name <- paste0(outcome_var, "~", exposure_var, "|", data)
                              
                              # Prepare the data frame
                              data_df <- get(data)
                              
                              # Construct and evaluate the formula
                              cox_formula <- as.formula(formula)
                              
                              # Run cox ph models
                              # model <- analyze_coxph(data_df, cox_formula)
                              model <- survival::coxph(formula = cox_formula, data = data_df)
                              
                              # Save model names as an attribute
                              attr(model, "model_name") <- model_name
                              
                              model
                            })
  
  #Rename models
  names(model_list) <- map(model_list, get_model_name)
  
  model_list
}

#Get Model names
get_model_name <- function(model) {
  attr(model, "model_name")
}
