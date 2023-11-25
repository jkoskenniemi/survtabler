


ignore_unused_imports <- function() {
  broom::tidy()
  ggplot2::ggplot()
  scales::label_number()
  stringr::str_detect()
  survival::coxph()
  survival::cox.zph()
}




#' Wrapper for Cox Proportional Hazards Modeling
#'
#' @param data Input data.frame
#' @param formula A character vector specifying the model formula
#' @param submodel_var Optional: A character vector specifying variable within data which is used for subgroup analyses. Defaults to NULL.
#' @param submodel_value Optional: A character vector specifying the values of the variable that are used for subgroup analyses. Defaults to NULL.
#'
#' @importFrom magrittr %>%
#' @importFrom survival Surv
#' @importFrom survival coxph
#' @importFrom dplyr filter
#'
#' @return An object of class cox model (check and correct this!)

analyze_coxph <- function(data, formula, submodel_var, submodel_value) {

  data_df <- get(data)
  if(!is.na(submodel_var) && !is.na(submodel_value)) {
    data_submodel <- data_df %>%
      dplyr::filter(.data[[submodel_var]] == submodel_value)
    cox_model <- survival::coxph(as.formula(paste0("survival::", formula)), data = data_submodel)
  } else {
    cox_model <- survival::coxph(as.formula(paste0("survival::", formula)), data = data_df)
  }
  cox_model
}

remove_multiple_spaces <- function(text) {
  gsub(" {2,}", " ", text)
}

