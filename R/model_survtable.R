
#' Model Survival Using Cox Proportional Hazards Models
#'
#' @param survtable A data.frame containing `data_name`, `formula_str`, `submodel_var`, `submodel_value`,
#' `outcome_var` and `exposure_var`
#' @param cluster Optional. Optional unquoted variable which clusters the observations,
#' for the purposes of a robust variance.  Defaults to NULL. See help(coxph) 
#' for further details.
#' @return A list of survival models with legnth of the number of rows in input data.frame.

#' @importFrom magrittr %>%
#' @importFrom rlang sym
#' @importFrom rlang !!
#' @importFrom purrr pmap
#' @importFrom stats as.formula
#' @importFrom stats formula
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


model_survtable <- function(survtable, cluster = NULL) {
  
  #Add ifelse here that is passed to function below
    submodels_requested <- ifelse("submodel_var" %in% names(survtable) & "submodel_var" %in% names(survtable), TRUE, FALSE)
  
    if(submodels_requested == FALSE) {
      survtable <- dplyr::mutate(survtable, submodel_var = NA, submodel_value = NA)
    }
    
    cluster <- rlang::enquo(cluster)
    
    model_list <- purrr::pmap(list(survtable$data_name, survtable$formula, survtable$exposure_var, survtable$outcome_var,
                                 survtable$submodel_var, survtable$submodel_value, survtable$time_var),
                            function(data_name, formula, exposure_var, outcome_var, submodel_var, submodel_value, time_var) {
                              
                              # Construct model names for each model
                              model_name <- ifelse(submodels_requested, 
                                                   paste0(outcome_var, "~", exposure_var, "|", 
                                                          data_name, ",", submodel_var, "==", submodel_value),
                                                   paste0(outcome_var, "~", exposure_var, "|", data_name))
                              

                              # Prepare the data frame
                              if(!is.na(submodel_var)) {
                                filter_expr <- rlang::expr(dplyr::filter(!!rlang::sym(data_name), !!rlang::sym(submodel_var) == !!submodel_value))
                                data_df <- eval(filter_expr)
                              }  else if(is.na(submodel_var)) data_df <- get(data_name)
                              
                              
                              # Construct and evaluate the formula
                              cox_formula <- stats::as.formula(formula)
                              
                              # Evaluate the cluster argument within the data_df context
                              cluster_var <- rlang::eval_tidy(cluster, data_df)
                              
                              # Run cox ph models
                              model = survival::coxph(formula = cox_formula, data = data_df, cluster = cluster_var)
                              
                              # Save model names as an attribute
                              attr(model, "model_name")     <- model_name
                              attr(model, "exposure")       <- exposure_var
                              attr(model, "outcome")        <- outcome_var
                              attr(model, "data")           <- data_name
                              attr(model, "submodel_var")   <- submodel_var
                              attr(model, "submodel_value") <- submodel_value
                              attr(model, "time")           <- time_var
                              attr(model, "cluster")        <- cluster
                              
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
