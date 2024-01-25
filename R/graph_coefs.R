



#' Draw Forest Plot
#'
#' @param data Model coefficients.
#' @param title Graph title.
#'
#' @return Forest plot (ggplot object)
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 geom_pointrange
#' @importFrom ggplot2 geom_text
#' @importFrom ggplot2 coord_flip
#' @importFrom ggplot2 geom_hline
#' @importFrom ggplot2 ylab
#' @importFrom ggplot2 xlab
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 ggtitle
#' @importFrom ggplot2 scale_y_continuous
#' @importFrom ggplot2 facet_wrap
#' @importFrom ggplot2 aes
#' @importFrom scales label_number
#'
#'
#' @examples
#' create_survtable(
#'   exposure_vars = c("exposure_2cat", "exposure_continuous"),
#'   outcome_vars = c("outcome1", "outcome2"),
#'   covariates = "age + sex + hla",
#'   time_var = "cens_time",
#'   data_name = "example_ti") |>
#'   model_survtable() |>
#'   get_coefs(c("exposure_2cat", "exposure_continuous")) |>
#'   graph_coefs(title = "**Your title here**")#'
#' @export
#'


graph_coefs <- function(data, title) {
  graph_data <- data %>%
    dplyr::mutate(sig = ifelse(p.value < 0.05, 1, 0))

  graph_data <- graph_data %>%
    dplyr::mutate(sig = factor(sig, levels = c(0, 1),
                        labels = c("p>=0.05", "p<0.05"))) %>% 
    dplyr::mutate(graph_facet = ifelse(is.na(submodel_value), paste0(outcome), paste0(outcome, ":", submodel_value)))
  graph_data %>%
    ggplot2::ggplot(ggplot2::aes(x = term, y = exp(estimate),
               ymin = exp(estimate - 1.96 * std.error),
               ymax = exp(estimate + 1.96 * std.error),
               colour = sig)) +
    ggplot2::geom_pointrange() +
    ggplot2::geom_text(ggplot2::aes(label = paste0(sprintf("%.2f", signif(exp(estimate), 3)), " (",
                                 sprintf("%.2f", signif(exp(estimate - 1.96 * std.error), 3)), ",",
                                 sprintf("%.2f", signif(exp(estimate + 1.96 * std.error), 3)), ")")),
              vjust = -0.5,
              size = 3.75) +
    ggplot2::coord_flip() +
    ggplot2::geom_hline(yintercept = 1, linetype = "dashed", colour = "grey40") +
    ggplot2::ylab("Hazard Ratio") +
    ggplot2::xlab(NULL) +
    ggplot2::theme(legend.position = "none") +
    ggplot2::ggtitle({{ title }}) +
    ggplot2::scale_y_continuous(trans = "log", labels = scales::label_number(max_n = 2)) +
    ggplot2::scale_colour_manual(values = c("grey51","grey40")) +
    ggplot2::facet_wrap(~factor(graph_facet))
}
