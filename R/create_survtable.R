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
#'   are adjusted for. Defaults to NULL.
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
                             covariates = NULL,
                             model_type = "time_invariant",
                             submodel_var = NULL,
                             submodel_values = NULL) {
  # This function is organized using an if/else tree:
  # survival model type?


  # //                  1. Checks
  # //                       |
  # //      model_type == "time_invariant" #or shorthand "ti"
  # //        2.T/                     \5.F
  # // is.na(submodels_vars)    is.na(submodels_vars)
  # //    3.T/   \4.F              6.T/  \7.F

  # Credit to John Regehr for the idea for ASCII art
  # https://blog.regehr.org/archives/1653



  # 1 Checks--------------------------------------------------------------------
  # that covariates, exposure_vars, outcome_vars, data_name and time_var
  if (length(covariates) != 1 & !is.null(covariates)) stop("Invalid specification of input 'covariates'. `covariates` should have length of 1. See help(create_survtable)")
  if (!is.character(covariates) & !is.null(covariates)) stop("Invalid specification of input `covariates`. `covariates` should be a character vector with length == 1. See help(create_survtable)")
  if (!is.character(exposure_vars)) stop("Invalid specifcation of input 'exposure_vars'. `exposure_vars` should be a character vector with length >= 1. See help(create_survtable)")
  if (!is.character(outcome_vars)) stop("Invalid specification of input `outcome_vars`. `outcome_vars should be a character vector with length >= 1. See help(create_survtable)")
  if (!is.character(data_name)) stop("Invalid specification of input `data_name`. `data_name` should be a character vector with length >= 1. See help(create_survtable)")
  if (!is.character(time_var)) stop("Invalid specification of input `time_var`. `time_var` should be a character vector with length >= 1. See help(create_survtable)")

  # Ensure that the user has supplied strings and not unquoted environment variables

  if (!is.character(exposure_vars) || any(purrr::map_lgl(exposure_vars, ~ exists(.x)))) {
    stop("Invalid specification of input 'exposure_vars'. Expecting a character vector. See help(create_survtable)")
  }
  if (!is.character(outcome_vars) || any(purrr::map_lgl(outcome_vars, ~ exists(.x)))) {
    stop("Invalid specification of input 'outcome_vars'. Expecting a character vector. See help(create_survtable)")
  }
  if (!is.character(time_var) || any(purrr::map_lgl(time_var, ~ exists(.x)))) {
    stop("Invalid specification of input 'time_var'. Expecting a quoted character vector. Avoid variable_names `time`, `time_var`, or `time_vars`, as they may be environment variables an produce a false error.")
  }


  # if (exists(quote(time_var))) stop("Invalid specification of input 'time_var'. Attempting to call an unquoted environment variable. See help(create_survtable)")
  if (!model_type %in% c("time_invariant", "ti", "time_varying", "time_variant", "tv")) stop("Input 'model_type' is invalid. See help(create_survtable)")

  # Checks still left to be done:
  # 3) strings listed in exposure_vars, outcome_vars, submodel_var are variable names in `data_name`
  # 5) items within the string `covariates` are variable names in `data_name`
  # 6) submodle_var, submodel_values, covariates are character strings
  # 7) length of submodel_var is 1
  # 8) submodel_values are levels of submodel_var
  # 9) there are no more levels in submodel_values than those specified in submodel_values
  # 10) either both submodel_var and submodel_values or neither of the two are supplied



  # 2. The main exposure of interest is time-invariant--------------------------
  if (model_type %in% c("ti", "time_invariant")) {
    # 3. subgroup analyses requested--------------------------------------------
    if (!is.null(submodel_var) & !is.null(submodel_values)) {
      submodel <- tidyr::crossing("submodel_var" = submodel_var, "submodel_value" = submodel_values)
      combinations <- tidyr::crossing(
        "data_name" = data_name, "exposure_var" = exposure_vars,
        "outcome_var" = outcome_vars, "time_var" = time_var
      )
      model_input_table <- tidyr::crossing(submodel, combinations) %>%
        dplyr::mutate(dplyr::across(tidyselect::everything(), .fns = as.character))

      model_input_table %>%
        dplyr::mutate(covariates = covariates) %>%
        dplyr::mutate(formula_str =
                        paste0("Surv(", time_var, ", ", outcome_var, ") ~ ", exposure_var, " + ", covariates)) %>% 
        dplyr::mutate(formula_str = stringr::str_remove(formula_str, " \\+ $"))
        
      # 4. no subgroup analyses------------------------------------------------
    } else {
      combinations <- tidyr::crossing(
        "data_name" = data_name, "exposure_var" = exposure_vars,
        "outcome_var" = outcome_vars, "time_var" = time_var
      )
      model_input_table <- combinations %>% dplyr::mutate(dplyr::across(tidyselect::everything(), .fns = as.character))

      model_input_table %>%
        dplyr::mutate(covariates = covariates) %>%
        dplyr::mutate(formula_str = 
                        paste0("Surv(", time_var, ", ", outcome_var, ") ~ ", 
                               exposure_var, " + ", covariates)) %>% 
        dplyr::mutate(formula_str = stringr::str_remove(formula_str, " \\+ $")) %>%
        dplyr::mutate(submodel_var = NA, submodel_value = NA)
    }

    # 5. The main exposure of interest is time-varying--------------------------
  } else if (model_type %in% c("tv", "time_variant", "time_varying")) {
    # 6. no subgroup analyses---------------------------------------------------
    if (!is.null(submodel_var) & !is.null(submodel_values)) {
      submodel <- tidyr::crossing("submodel_var" = submodel_var, "submodel_value" = submodel_values)
      combinations <- tidyr::crossing(
        "data_name" = data_name, "exposure_var" = exposure_vars,
        "outcome_var" = outcome_vars, "time_var" = time_var
      )
      model_input_table <- tidyr::crossing(submodel, combinations) %>%
        dplyr::mutate(dplyr::across(tidyselect::everything(), .fns = as.character))

      model_input_table %>%
        dplyr::mutate(covariates = covariates) %>%
        dplyr::mutate(formula_str = paste0(
          "Surv(tstart, tstop, ", outcome_var, ") ~ ", exposure_var,
          " + ", covariates
        ))

      # 6. subgroup analyses requested------------------------------------------
    } else {
      combinations <- tidyr::crossing(
        "data_name" = data_name, "exposure_var" = exposure_vars,
        "outcome_var" = outcome_vars, "time_var" = time_var
      )
      model_input_table <- combinations %>% dplyr::mutate(dplyr::across(tidyselect::everything(), .fns = as.character))

      model_input_table %>%
        dplyr::mutate(covariates = covariates) %>%
        dplyr::mutate(formula_str = paste0(
          "Surv(tstart, tstop, ", outcome_var, ") ~ ", exposure_var,
          " + ", covariates
        )) %>%
        dplyr::mutate(submodel_var = NA, submodel_value = NA)
    }
  } else {
    stop("Invalid survival model specification (unclear if the survival model should time varying or time invariant)")
  }
}
