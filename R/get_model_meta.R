

#' Get Model Metadata
#'
#' @param model_list List of Cox Proportional Hazard Models
#'
#' @return Data frame describing the model formula, the total number of observations in analyses, number of events, number of missing observations.

#' @importFrom magrittr %>%
#' @importFrom purrr map
#' @examples
#'
#' create_survtable(
#'   exposure_vars = c("exposure_2cat", "exposure_continuous"),
#'   outcome_vars = c("outcome1", "outcome2"),
#'   covariates = "age + sex + hla",
#'   time_var = "cens_time",
#'   data_name = "example_ti") |>
#'   model_survtable() |>
#'   get_model_meta()
#'
#' @export
#'

get_model_meta <- function(model_list) {
  # Check if models and combinations are aligned

  # Use map to extract data from each model and create a list of data.frames
  model_data_list <- purrr::map(model_list, function(model) {

    #Extract the model formula
    formula <- formula(model) %>%
      deparse()  %>%
      paste(collapse = "") %>%
      remove_multiple_spaces() #this custom function is defined in this script (at the moment 1.6)

    #Gather information to a data.frame

    data.frame("n" = model$n,
               "n_event" = model$nevent,
               "n_missing" = length(model$na.action),
               "formula" = formula)
  })

  # Combine all data.frames into one
  model_data_combined <- do.call(rbind, model_data_list)

  return(model_data_combined)
}

