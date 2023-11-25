#' Example data for time-variant survival analysis
#'
#' Simulated dataset for survival analyses with a time-varying exposure of interest
#'
#' @format ## `example_tv`
#' A data frame with 8,000 rows and 9 columns:
#' \describe{
#'   \item{id}{A subject-specific identifier}
#'   \item{tstart, tstop}{Start and stop times for each interval}
#'   \item{event}{A binary indicator of whetehr the event occurred}
#'   \item{exposure_continuous, exposure_2cat}{Examples of time-varying exposures/covariates}
#'   ...
#' }
#' @source Simulated data
"example_tv"
