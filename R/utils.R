


ignore_unused_imports <- function() {
  broom::tidy()
  ggplot2::ggplot()
  scales::label_number()
  stringr::str_detect()
  survival::coxph()
  survival::cox.zph()
}



remove_multiple_spaces <- function(text) {
  gsub(" {2,}", " ", text)
}
