## code to prepare `example_tv` dataset goes here
set.seed(123) # For reproducibility

# Parameters
num_subjects <- 8000
max_records_per_subject <- 3 # Maximum number of time periods per subject

# Simulate data
example_tv <- do.call(rbind, lapply(1:num_subjects, function(i) {
  num_records <- sample(1:max_records_per_subject, 1)

  tstart <- c(0, cumsum(runif(num_records - 1, min = 1, max = 5)))
  tstop <- tstart + runif(num_records, min = 1, max = 5)
  event <- c(rep(0, num_records - 1), sample(0:1, 1, prob = c(0.7, 0.3))) # Last record has event indicator

  data.frame(
    id = i,
    tstart = tstart,
    tstop = tstop,
    event = event,
    exposure_continuous = rnorm(num_records, mean = 50, sd = 10), # Some continuous covariate
    exposure_2cat = sample(c("A", "B"), num_records, replace = TRUE) # Some categorical covariate
  )
}))

head(example_tv)



usethis::use_data(example_tv, overwrite = TRUE)
