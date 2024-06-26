

#' Get Coefficients of Interest in Models
#'
#' @param model_list A list of Cox Proportional Hazards Models.
#' @param select_terms,select_exposures An optional character vector of terms, since get_coef() now by default recognizes the 'exopsures' value used in create_survtable(). Defaults to NULL.
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


get_coefs <- function(model_list, select_exposures = NULL, select_terms = NULL) {
  models_tidy <- purrr::map_df(model_list, function(model) {
    
    if(is.null(select_exposures)) {
      select_exposures <- map(model_list, get_exposures)
    }
    
    # Retrieve metadata
    attr_model_name     <- attr(model, "model_name")
    attr_exposure_var   <- attr(model, "exposure")
    attr_outcome_var    <- attr(model, "outcome") 
    attr_data           <- attr(model, "data")
    attr_submodel_value <- attr(model, "submodel_value")  
    attr_submodel_var   <- attr(model, "submodel_var")
    attr_cluster        <- attr(model, "cluster")
    
    #capture model data
    if (rlang::quo_is_null(attr_cluster)) {
      tidy_data <- broom::tidy(model) %>%
        dplyr::filter(term %in% select_exposures) %>%
        dplyr::mutate(model_name = attr_model_name)  %>%
        dplyr::mutate(data = attr_data,
                      exposure = attr_exposure_var,
                      outcome  = attr_outcome_var,
                      submodel_var = attr_submodel_var,
                      submodel_value = attr_submodel_value)
    } else {
      tidy_data <- model %>% 
        get_robust_coef() %>% 
        dplyr::rename(estimate = coef, se = robust.se) %>% 
        dplyr::filter(term %in% select_exposures) %>%
        dplyr::mutate(data = attr_data,
                      exposure = attr_exposure_var,
                      outcome  = attr_outcome_var,
                      submodel_var = attr_submodel_var,
                      submodel_value = attr_submodel_value)
    }
    
    return(tidy_data)
  })

  models_tidy
}


get_exposures <- function(model_list) {
  attr(model_list, "exposure")
}  


get_robust_coef <- function(x, ...) {
  s <- summary(x)$coefficients
  data.frame(
    term = row.names(s),
    robust.se = s[, "robust se", drop = FALSE],
    coef = s[, "coef", drop = FALSE]) 
  
}