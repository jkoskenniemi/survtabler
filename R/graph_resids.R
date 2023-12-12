


#' Graph residuals
#'
#' @param caught_models A data.frame, output from catch_nonph()
#' @param model_list A list of Cox proportional hazards models, created by model_survtable()
#' @param hline.col,hline.size,hline.alpha,hline.yintercept,hline.lty optional 
#' arguments passed to ggplot2::geom_hline() to format the horizontal line
#' @param sline.col,sline.size,sline.alpha,sline.lty optional arguments passed to ggplot2::geom_smooth() to format the loess
#' @param point.col,point.size,point.shape,point.alpha optional arguments passed to ggplot2::geom_point() to format points in the graph
#' @param subtitle,caption further arguments for formating of the resulting ggplot
#'
#' @importFrom survminer ggcoxdiagnostics
#' @return ggplot objects that assess the proportionality of hazards
#' @export
#'
#' @examples 
#' library(dplyr)
#' models_2 <- create_survtable(exposure_vars = c("exposure_2cat", "exposure_continuous"),
#' outcome_vars = c("outcome1", "outcome2"),
#' covariates = "age + sex",
#' submodel_var = "hla",
#' submodel_values = c("Type 1", "Type 2", "Type 3"),
#' time_var = "cens_time",
#' data_name = "example_ti") %>%
#' model_survtable()
#' 
#' models_2 %>%
#'   catch_nonph() %>%
#'     graph_resids(models_2)

graph_resids <- function(caught_models, model_list, 
                         hline.col = "red", hline.size = 1, hline.alpha = 1, hline.yintercept = 0, hline.lty = 'dashed',
                         sline.col = "blue", sline.size = 1, sline.alpha = 0.3, sline.lty = 'dashed',
                         point.col = "black", point.size = 1, point.shape = 19, point.alpha = 1,
                         subtitle = NULL, caption = NULL) {
  imap(model_list[unique(caught_models$model)], 
       ~graph_schoenfeld(.x, title = paste("Residuals for model:", .y),
                         hline.col = hline.col, hline.size = hline.size, hline.alpha = hline.alpha, 
                         hline.yintercept = hline.yintercept, hline.lty = hline.lty,
                         sline.col = sline.col, sline.size = sline.size, sline.alpha = sline.alpha, 
                         sline.lty = sline.lty, point.col = point.col, point.size = point.size, 
                         point.shape = point.shape, point.alpha = point.alpha, subtitle = subtitle, 
                         caption = caption))
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
#' library(dplyr)
#' models_2 <- create_survtable(exposure_vars = c("exposure_2cat", "exposure_continuous"),
#' outcome_vars = c("outcome1", "outcome2"),
#' covariates = "age + sex",
#' submodel_var = "hla",
#' submodel_values = c("Type 1", "Type 2", "Type 3"),
#' time_var = "cens_time",
#' data_name = "example_ti") %>%
#' model_survtable()
#' 
#' models_2 %>%
#'   catch_nonph() %>%
#'   export_resids(models_2, height = 6, width = 8, path = paste0(getwd(), "/"))

export_resids <- function(caught_models, model_list, path = default_path, height = default_height, width = default_width, ...) {
  
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
    plot <- graph_schoenfeld(.x, title = paste("Residuals for model:", .y),
                             hline.col = "red", hline.size = 1, hline.alpha = 1, hline.yintercept = 0, hline.lty = 'dashed',
                             sline.col = "blue", sline.size = 1, sline.alpha = 0.3, sline.lty = 'dashed',
                             point.col = "black", point.size = 1, point.shape = 19, point.alpha = 1,
                             subtitle = NULL, caption = NULL)
    
        # Debug: Print the filename
    cat("Saving plot to:", paste0(filepath_base, "_", model_name_for_file, ".png"), "\n")

    # Save the plot using ggsave
    tryCatch({
      ggplot2::ggsave(filename = paste0(path, filepath_base, "_", model_name_for_file, ".png"), plot = plot, height = height, width = width)
    }, error = function(e) {
      cat("Failed to save plot for model", .y, ":", e, "\n")
    })
  })   
}


library(dplyr)
library(ggplot2)
library(tidyr)
library(rlang)



graph_schoenfeld <- function(fit, title=NULL, 
                             hline.col = "red", hline.size = 1, hline.alpha = 1, hline.yintercept = 0, hline.lty = 'dashed',
                             sline.col = "blue", sline.size = 1, sline.alpha = 0.3, sline.lty = 'dashed',
                             point.col = "black", point.size = 1, point.shape = 19, point.alpha = 1,
                             subtitle = NULL, caption = NULL) {
  
  # Retrieve attribute strings directly
  data_name <- attr(fit, "data")
  submodel_var <- attr(fit, "submodel_var")
  submodel_value <- attr(fit, "submodel_value")
  event <- attr(fit, "outcome")
  time <- attr(fit, "time")
  
  data <- get(data_name) 
  if(!is.na(submodel_var)) data <- dplyr::filter(data, !!rlang::sym(submodel_var) == submodel_value)

  # Convert event and time names to symbols for filtering
  event <- rlang::sym(event)
  time <- rlang::sym(time)
  
  # Compute Schoenfeld residuals
  res <- as.data.frame(residuals(fit, type = "schoenfeld"))
  
  # Filter event times based on the event condition
  event_times <- dplyr::filter(data, !!event == 1) %>% dplyr::pull(!!time)
  
  # Bind event times to the residuals
  plotdata <- cbind(res, event_times = event_times) 
  
  # Convert to long format for plotting
  plotdata_long <- plotdata %>%
    tidyr::pivot_longer(cols = -event_times, names_to = "variable", values_to = "value")
  
  # Create the plot
  ggplot2::ggplot(plotdata_long, ggplot2::aes(x = event_times, y = value)) +
    ggplot2::geom_point(col = point.col, shape = point.shape,
                        size = point.size, alpha = point.alpha) + 
    ggplot2::geom_smooth(formula = y ~ x, col = sline.col, method = "loess",
                         size = sline.size, lty = sline.lty, alpha = sline.alpha) +  
    ggplot2::geom_hline(yintercept=hline.yintercept, col = hline.col,
               size = hline.size, lty = hline.lty, alpha = hline.alpha) +
    ggplot2::facet_wrap(~variable, scales = "free_y") +
    ggplot2::labs(x = rlang::as_string(time), y = "Schoenfeld Residuals", title = title)
}
