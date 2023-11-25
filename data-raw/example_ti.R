## Create example data
set.seed(123)

# Number of observations
n <- 8000

# Simulating some mock data
example_ti <- data.frame(
  id = 1:n,
  cens_time = rexp(n, rate = 0.1), # Time-to-event, assuming exponential distribution
  outcome1 = sample(0:1, n, replace = TRUE), # Event indicator (0 = censored, 1 = event)
  outcome2 = sample(0:1, n, replace = TRUE), # Event indicator (0 = censored, 1 = event)
  age = rnorm(n, mean = 50, sd = 10), # Age of the individuals at baseline
  hla = sample(c("DR3/3", "DR3/4", "DR4/4"), n, replace = TRUE), # Sex of the individuals
  exposure_2cat = sample(c(1, 2), n, replace = TRUE), # exposure, note this doesn't work if these were characters
  exposure_continuous = rnorm(n, mean = 10, sd = 2), # exposure
  sex = sample(c("Male", "Female"), n, replace = TRUE) # Sex of the individuals
)

usethis::use_data(example_ti, overwrite = TRUE)
