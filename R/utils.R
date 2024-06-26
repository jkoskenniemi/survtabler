


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

utils::globalVariables(c("error", "outcome_var", "exposure_var", "covariate_var",
                         "term", "p.value", "sig", "outcome", "term" ,"estimate", 
                         "std.error", "position_dodge", "element_text", "element_rect", "element_blank",
                         "p", "sig", "submodel_value", "robust.se")) 
