

#' Catch Models with Violations of Nonproportional Hazards Assumption
#'
#' @param model_list A list of Cox Proportional Hazards models.
#'
#' @importFrom magrittr %>%
#' @importFrom purrr map
#' @importFrom purrr imap
#' @importFrom survival cox.zph
#' @importFrom dplyr mutate
#' @importFrom dplyr bind_rows
#' @importFrom dplyr filter
#' @importFrom dplyr across
#' @importFrom tidyselect any_of
#'
#' @return Data frame including models or model parameters that violated proportional hazards assumption.
#' @export
#'
#' @examples
#'
#' create_survtable(
#'   exposure_vars = c("exposure_2cat", "exposure_continuous"),
#'   outcome_vars = c("outcome1", "outcome2"),
#'   covariates = "age + sex + hla",
#'   time_var = "cens_time",
#'   data_name = "example_ti") |>
#'   model_survtable() |>
#'   catch_nonph()
#'
catch_nonph <- function(model_list) {
  model_list %>%
    purrr::map(survival::cox.zph) %>%
      purrr::map(`[[`, "table") %>% #extract chisq/df/p-value table
      purrr::imap(~ as.data.frame(.) %>%  #turn to data frames and add variable and model names
             dplyr::mutate(variable = row.names(.),
                    model = .y)) %>%
      dplyr::bind_rows() %>% # combine all tables to a data.frame
      dplyr::filter(p < 0.05) %>%  #exlude non-significant
    dplyr::mutate(dplyr::across(tidyselect::any_of(c("p", "chisq")), ~signif(.x, 3))) # round p and chisq-values
  }
