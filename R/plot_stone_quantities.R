#' @title Plot Channel Stone Quantities
#' @description Create a plot of estimated stone quantities from a channel
#'              dimensions data frame.
#' @param channel_dims data frame; A channel dimensions data frame.
#' @param x_axis       character; The variable to use for the x-axis. One of
#'                     "width", "length", "slope", "particle_size"
#' @returns a ggplot object
#' @export
#' @importFrom dplyr %>% mutate
#' @importFrom tidyr pivot_longer
#' @importFrom rlang sym
#' @importFrom ggplot2 ggplot aes geom_line facet_wrap labs theme_light theme
#'             element_text element_blank
#' @importFrom stringr str_to_title
plot_stone_quantities <- function(channel_dims, x_axis) {
  # Validate x_axis
  valid_x_axes <- c("width", "length", "slope", "particle_size")
  if (!(x_axis %in% valid_x_axes)) {
    stop("x_axis must be one of: ", paste(valid_x_axes, collapse = ", "))
  }

  # Human-readable labels
  param_labels <- c(
    adopted_stone_diameter = "Median Stone Diameter (m)",
    mattress_thickness = "Mattress Thickness (m)",
    adopted_stone_weight_ton = "Median Stone Weight (US ton)",
    stone_vol_us_ton = "Stone Volume (US ton)",
    number_stones = "Number of Stones (count)"
    )

  # Select and pivot to long format
  stone_vars <- channel_dims %>%
    select({{x_axis}},
           adopted_stone_diameter,
           mattress_thickness,
           adopted_stone_weight_ton,
           stone_vol_us_ton,
           number_stones) %>%
    pivot_longer(
      cols = -{{x_axis}},
      names_to = "parameter",
      values_to = "value") %>%
    mutate(parameter = factor(.data$parameter,
                              levels = names(param_labels),
                              labels = param_labels))

  # Determine x_axis labels
  x_axis_label <- switch(x_axis,
                         width         = "Width (m)",
                         length        = "Length (m)",
                         slope         = "Slope",
                         particle_size = "Particle Size (m)")

  # Faceted plot
  flow_plot <- ggplot(stone_vars, aes(x = !!sym(x_axis), y = value)) +
    geom_line(color = "#990006FF", linewidth = 1) +
    facet_wrap(~parameter, scales = "free_y") +
    labs(
      title = "Stone Quantities",
      x = x_axis_label,
      y = NULL
    ) +
    theme_light(base_size = 13) +
    theme(
      strip.text = element_text(face = "bold"),
      panel.grid.minor = element_blank()
    )
  #flow_plot
  return(flow_plot)
}
