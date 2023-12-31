% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/catch_nonph.R
\name{catch_nonph}
\alias{catch_nonph}
\title{Catch Models with Violations of Nonproportional Hazards Assumption}
\usage{
catch_nonph(model_list)
}
\arguments{
\item{model_list}{A list of Cox Proportional Hazards models.}
}
\value{
Data frame including models or model parameters that violated proportional hazards assumption.
}
\description{
Catch Models with Violations of Nonproportional Hazards Assumption
}
\examples{

create_survtable(
  exposure_vars = c("exposure_2cat", "exposure_continuous"),
  outcome_vars = c("outcome1", "outcome2"),
  covariates = "age + sex + hla",
  time_var = "cens_time",
  data_name = "example_ti") |>
  model_survtable() |>
  catch_nonph()

}
