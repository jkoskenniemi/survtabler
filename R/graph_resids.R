


#' Graph residuals
#'
#' @param caught_models A data.frame, output from catch_nonph()
#' @param model_list A list of Cox proportional hazards models, created by 
#'
#' @importFrom survminer ggcoxdiagnostics
#' @return
#' @export
#'
#' @examples
graph_resids <- function(caught_models, model_list) {
  imap(model_list[unique(caught_models$model)], ~survminer::ggcoxdiagnostics(.x, type = "schoenfeld", title = paste("Residuals for model:", .y)))
}
