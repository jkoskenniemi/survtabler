#' Example data for time-invariant survival analysis
#'
#' Simulated dataset for survival analyses with a time-invariant exposure of interest
#'
#' @format ## `example_ti`
#' A data frame with 8,000 rows and 9 columns:
#' \describe{
#'   \item{id}{A subject-specific identifier}
#'   \item{cens_time}{Time-to-event}
#'   \item{outcome1, outcome2}{Examples of outcomes}
#'   \item{age}{Example of a covariate}
#'   \item{hla}{Example of a covariate}
#'   \item{exposure_2cat}{Example exposure (categorical, 2 categories)}
#'   \item{exposure_continuous}{Example exposure (continuous)}
#'   \item{sex}{Sex}
#'   ...
#' }
#' @source Simulated data
"example_ti"
