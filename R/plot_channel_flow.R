#' @title Plot Channel Flow Variables
#' @description Create a plot of channel flow variables from a channel
#'              dimensions data frame.
#' @param channel_dims data frame; A channel dimensions data frame.
#' @param x_axis       character; The variable to use for the x-axis. One of
#'                     "width", "slope", "particle_size"
#' @returns a ggplot object
#' @export
#' @importFrom dplyr %>% mutate
#' @importFrom tidyr pivot_longer
#' @importFrom ggplot2 ggplot aes geom_line facet_wrap labs theme_light theme
#'             element_text element_blank
#' @importFrom stringr str_to_title
plot_channel_flow <- function(channel_dims, x_axis) {
  # Validate x_axis
  valid_x_axes <- c("width", "slope", "particle_size")
  if (!(x_axis %in% valid_x_axes)) {
    stop("x_axis must be one of: ", paste(valid_x_axes, collapse = ", "))
  }

  # Human-readable labels
  param_labels <- c(
    unit_discharge = "Unit Discharge (m²/s)",
    critical_depth = "Critical Depth (m)",
    critical_velocity = "Critical Velocity (m/s)",
    critical_slope = "Critical Slope (m/m)",
    normal_depth = "Normal Depth (m)",
    normal_velocity = "Normal Velocity (m/s)",
    froude = "Froude Number",
    shear_stress = "Shear Stress (N/m²)",
    avail_stream_power = "Avail. Stream Power (kW/m²)",
    applied_stream_power = "Applied Stream Power  (kW/m²)")

  # Select and pivot to long format
  flow_vars <- channel_dims %>%
    select({{x_axis}},
           unit_discharge,
           critical_depth,
           critical_velocity,
           critical_slope,
           normal_depth,
           normal_velocity,
           froude,
           shear_stress,
           avail_stream_power,
           applied_stream_power) %>%
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
                         slope         = "Slope",
                         particle_size = "Particle Size (m)")

  # Faceted plot
  flow_plot <- ggplot(flow_vars, aes(x = !!sym(x_axis), y = value)) +
    geom_line(color = "steelblue", linewidth = 1) +
    facet_wrap(~parameter, scales = "free_y") +
    labs(
      title = "Channel Flow Parameters",
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
