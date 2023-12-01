#' Create survival model specification tables
#'
#' Builds a data.frame that includes
#'
#' @param exposure_vars,time_var,outcome_vars,data_name Input string vectors specifying
#'   variables for exposure_vars of primary interest, follow-up time_var, and outcome_vars
#'   in survival analysis as well as survival model data_name. These are passed to
#'   tidyr::crossing() to produce all possible combinations of the 4 vectors.
#'   Note! `exposure_vars`, `time_var`, and `outcome_vars` refer to variable names in the
#'   target data_name frame whereas `data_name` refers to a data_name.frame in the R
#'   environment.
#' @param covariates Input string with length 1 specifying other variables that
#'   are adjusted for. Defaults to default_covariates, an external vector.
#' @param model_type Input string specifying whether the model type is
#'   time_var-invariant ("ti" or "time_var_invariant) or time_var-varying ("tv" or
#'   "time_var_varying"). Defaults to "time_var_invariant"
#' @param submodel_var Optional. Input string specifying the variable in study
#'   data_name that specifies subgroups. Defaults to NULL.
#' @param submodel_values Optional. Input string specifying the values of
#'   submodel_var that define subgroups. Defaults to NULL.
#'
#' @returns Hopefully one day an obejct with class `survtable`. Currently a
#'   tibble that includes a model data_name formula for survival analysis as well as
#'   individual variables that were used to produce them.
#'
#' @importFrom magrittr %>%
#' @importFrom tidyr crossing
#' @importFrom purrr map_lgl
#' @importFrom stringr str_remove
#'
#'
#' @examples
#' survtable1 <- create_survtable(
#'   exposure_vars = c("exposure_2cat", "exposure_continuous"),
#'   outcome_vars = c("outcome1", "outcome2"),
#'   covariates = "age + sex + hla",
#'   time_var = "cens_time",
#'   data_name = "example_ti"
#' )
#'
#' @export
create_survtable <- function(exposure_vars, outcome_vars, data_name, time_var,
                             covariates = default_covariates,
                             model_type = "time_invariant",
                             submodel_var = NULL,
                             submodel_values = NULL) {

  #Checks for validity of model inputs
  # check_survtable_input(exposure_vars = exposure_vars, 
  #                       outcome_vars = outcome_vars, 
  #                       data_name = data_name, 
  #                       time_var = time_var,
  #                       covariates = covariates,
  #                       model_type = model_type,
  #                       submodel_var = submodel_var,
  #                       submodel_values = submodel_values)
  
  if(!exists("default_covariates")) default_covariates <- NULL
  
  
  #Create a data.frame that has the combination of data
  combinations <- construct_combinations(data_name = data_name, 
                                         exposure_vars = exposure_vars,
                                         time_var = time_var,
                                         outcome_vars = outcome_vars,
                                         submodel_var = submodel_var,
                                         submodel_values = submodel_values)
  # #Filter data 
  # combinations_data <- add_data_filter(combinations)
  
  
  
  #Formulate model formula
  construct_model_formula(df = combinations,
                          model_type = model_type, 
                          time_var = time_var, 
                          outcome_var = outcome_var,
                          exposure_var = exposure_var,
                          covariates = covariates)
  
}

#UTILITY FUNCTIONS--------------------------------------------------


check_survtable_input <- function(exposure_vars, outcome_vars, data_name, time_var,
                                    covariates = NULL,
                                    model_type = "time_invariant",
                                    submodel_var = NULL,
                                    submodel_values = NULL) {

if (length(covariates) != 1 & !is.null(covariates)) stop("Invalid specification of input 'covariates'. `covariates` should have length of 1. See help(create_survtable)")
if (!is.character(covariates) & !is.null(covariates)) stop("Invalid specification of input `covariates`. `covariates` should be a character vector with length == 1. See help(create_survtable)")
if (!is.character(exposure_vars)) stop("Invalid specifcation of input 'exposure_vars'. `exposure_vars` should be a character vector with length >= 1. See help(create_survtable)")
if (!is.character(outcome_vars)) stop("Invalid specification of input `outcome_vars`. `outcome_vars should be a character vector with length >= 1. See help(create_survtable)")
if (!is.character(data_name)) stop("Invalid specification of input `data_name`. `data_name` should be a character vector with length >= 1. See help(create_survtable)")
if (!is.character(time_var)) stop("Invalid specification of input `time_var`. `time_var` should be a character vector with length >= 1. See help(create_survtable)")

if (!is.character(exposure_vars) || any(purrr::map_lgl(exposure_vars, ~ exists(.x)))) {
  stop("Invalid specification of input 'exposure_vars'. Expecting a character vector. See help(create_survtable)")
}
if (!is.character(outcome_vars) || any(purrr::map_lgl(outcome_vars, ~ exists(.x)))) {
  stop("Invalid specification of input 'outcome_vars'. Expecting a character vector. See help(create_survtable)")
}
if (!is.character(time_var) || any(purrr::map_lgl(time_var, ~ exists(.x)))) {
  stop("Invalid specification of input 'time_var'. Expecting a quoted character vector. Avoid variable_names `time`, `time_var`, or `time_vars`, as they may be environment variables an produce a false error.")
}
}

construct_combinations <-
  function(data_name, exposure_vars, outcome_vars, time_var,
           submodel_var, submodel_values) {

        if(is.null(submodel_var) && !is.null(submodel_values)) {
        error(paste0("submodel_var and submodel_value inconsistent: either specify
                     submodel_var or leave both submodel_var and submodel_value as
                     NULL."))}
        if(!is.null(submodel_var) && is.null(submodel_values)) {
        error(paste0("submodel_var and submodel_value inconsistent: either specify
                     submodel_value or leave both submodel_var and submodel_value
                     as NULL."))}

      tidyr::crossing("submodel_var" = submodel_var,
                      "submodel_value" = submodel_values,
                      "data_name" = data_name,
                      "exposure_var" = exposure_vars,
                      "outcome_var" = outcome_vars,
                      "time_var" = time_var)

    }
    

# 
# add_data_filter <- 
#   function(df) {
#     
#     if("submodel_var" %in% names(df) & "submodel_value" %in% names(df)) {
#       df_data <- dplyr::mutate(df, data = paste0("filter(", .data$data_name,",", 
#                                                  .data$submodel_var, " == ",  
#                                                  paste0(.data$submodel_value), ")")) %>%
#         dplyr::select(-data_name)
#       } else if(!("submodel_var" %in% names(df)) & !("submodel_value" %in% names(df))) {
#         df_data <- df %>% dplyr::rename(data = data_name)
#         } else if(!("submodel_var" %in% names(df)) & "submodel_value" %in% names(df)) {
#         error("Inconsistent input for submodel_var & submodel_value. 
#               Please supply both submodel_var & submodel_value or neither of the two.") 
#           } else if("submodel_var" %in% names(df) & !("submodel_value" %in% names(df))) {
#           error("Inconsistent input for submodel_var & submodel_value. 
#                 Please supply both submodel_var & submodel_value or neither of the two.") }
#     
#     df_data
#     
#   }



construct_model_formula <- function(df, model_type, time_var, outcome_var, exposure_var, covariates) {
 
    if(model_type %in% c("ti", "time_invariant")) {
      df <- dplyr::mutate(df, formula = 
                            paste0("Surv(", time_var, ", ", outcome_var, ") ~ ", exposure_var, " + ", covariates))
    } else if(model_type %in% c("tv", "time_variant", "time_varying")) {
      df <- dplyr::mutate(df, formula = paste0(
        "Surv(tstart, tstop, ", outcome_var, ") ~ ", exposure_var,
        " + ", covariates))
    } else {
      error("invalid model type")
    }
  
    #remove trailing "+" if covariates are NULL
    df <- dplyr::mutate(df, formula = stringr::str_remove(formula, " \\+ $"))
    
    df <- mutate(df, dplyr::across(tidyselect::everything(), .fns = as.character))
    
    df
}
