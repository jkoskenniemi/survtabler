

#' Get Coefficients of Interest in Models
#'
#' @param model_list A list of Cox Proportional Hazards Models.
#' @param select_terms A character vector of terms (typically the same as exposure_vars in create_survtable).
#'
#' @return A data.frame that includes model coefficients.
#' @examples
#' create_survtable(
#'   exposure_vars = c("exposure_2cat", "exposure_continuous"),
#'   outcome_vars = c("outcome1", "outcome2"),
#'   covariates = "age + sex + hla",
#'   time_var = "cens_time",
#'   data_name = "example_ti") |>
#'   model_survtable() |>
#'   get_coefs(c("exposure_2cat", "exposure_continuous"))
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map_df
#' @importFrom dplyr filter
#' @importFrom dplyr mutate
#' @importFrom broom tidy
#' @importFrom stringr str_extract
#'
#' @export


get_coefs <- function(model_list, select_terms) {
  models_tidy <- purrr::map_df(model_list, function(model) {
    model_name <- attr(model, "model_name")  # Retrieve the model name from the attribute
    tidy_data <- broom::tidy(model) %>%
      dplyr::filter(term %in% select_terms) %>%
      dplyr::mutate(model_name = model_name)  %>%
      dplyr::mutate(data = stringr::str_extract(model_name, "(?<=\\|)[^(]*(?=\\()"),
             exposure = stringr::str_extract(model_name, "(?<=~)[^|]*(?=\\|)"),
             outcome = stringr::str_extract(model_name, "^[^~]*"),
             submodel_var = stringr::str_extract(model_name, "(?<=\\()[^=]*(?==)"),
             submodel_value = stringr::str_extract(model_name, "(?<=\\={2})[^=)]*(?=\\))"))
    return(tidy_data)
  })

  models_tidy
}
