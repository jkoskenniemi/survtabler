


#' Graph residuals
#'
#' @param caught_models A data.frame, output from catch_nonph()
#' @param model_list A list of Cox proportional hazards models, created by model_survtable()
#'
#' @importFrom survminer ggcoxdiagnostics
#' @return ggplot objects that assess the proportionality of hazards
#' @export
#'
#' @examples
graph_resids <- function(caught_models, model_list) {
  imap(model_list[unique(caught_models$model)], ~survminer::ggcoxdiagnostics(.x, type = "schoenfeld", title = paste("Residuals for model:", .y)))
}

#' Export residuals
#'
#' @param caught_models A data.frame, output from catch_nonph()
#' @param model_list A list of Cox proportional hazards models, created by model_survtable()
#' @param height Height of the output png-file. Defaults to external vector *default_height*
#' @param width Width of the output png-file. Defaults to external vector *default_weight*
#' @param path filepath to output folder. Defaults to an external vector *default_path*
#'
#' @importFrom survminer ggcoxdiagnostics
#' @importFrom rlang ensym
#' @importFrom rlang as_string
#' @importFrom stringr str_replace_all
#' @importFrom purrr iwalk
#' @importFrom ggplot2 ggsave

#' @return Prints schoenfeld residuals using ggcoxdiagnostics from 'survminer' packge
#' @export
#'
#' @examples
export_resids <- function(caught_models, model_list, path = default_path, height = default_height, width = default_width) {
  name_enquo <- rlang::ensym(model_list)
  filepath_base <- paste0("nonph_viol_", rlang::as_string(name_enquo))
  
  # Perform the replacements
  filepath_base <- filepath_base %>%
    stringr::str_replace_all("_", "-") %>%
    stringr::str_replace_all("--", "_") %>%
    stringr::str_replace_all("~", "_") %>% 
    stringr::str_replace_all("\\|", "_")
  
  purrr::iwalk(model_list[unique(caught_models$model)], function(.x, .y) {
    # Adjustments for each model name in the filename
    model_name_for_file <- .y %>%
      stringr::str_replace_all("_", "-") %>%
      stringr::str_replace_all("--", "_") %>%
      stringr::str_replace_all("~", "_") %>% 
      stringr::str_replace_all("\\|", "_")
    
    # Generate the diagnostics plot
    plot <- survminer::ggcoxdiagnostics(.x, type = "schoenfeld", title = paste("Residuals for model:", .y))
    
    # Debug: Print the filename
    cat("Saving plot to:", paste0(filepath_base, "_", model_name_for_file, ".png"), "\n")
    
    # Save the plot using ggsave
    tryCatch({
      ggplot2::ggsave(filename = paste0(path, filepath_base, "_", model_name_for_file, ".png"), plot = plot, height = height, width = width)
    }, error = function(e) {
      cat("Failed to save plot:", e$message, "\n")
    })
  })   
}

