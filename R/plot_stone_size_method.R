#' @title Plot Stone Size by Methods
#' @description Plot estimated stone size according to several different
#'              methods.
#' @param channel_dims data frame; A channel dimensions data frame.
#' @param x_axis       character; The variable to use for the x-axis. One of
#'                     "width", "slope", "particle_size"
#' @returns a ggplot2 object
#' @export
#' @importFrom tidyr pivot_longer starts_with
#' @importFrom stringr str_remove str_to_upper
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot aes geom_line scale_color_brewer labs
#'             theme_light
#' @importFrom paletteer scale_color_paletteer_d
#' @importFrom NatParksPalettes NatParksPalettes
plot_stone_size_method <- function(channel_dims, x_axis) {
  # Validate x_axis
  valid_x_axes <- c("width", "slope", "particle_size")
  if (!(x_axis %in% valid_x_axes)) {
    stop("x_axis must be one of: ", paste(valid_x_axes, collapse = ", "))
  }

  # Convert from wide to long for plotting
  dims_long <- channel_dims %>%
    pivot_longer(
      cols = starts_with("stone_size_"),
      names_to = "method",
      values_to = "stone_size"
    ) %>%
    mutate(method = str_remove(.data$method, "stone_size_"),
           method = str_to_upper(.data$method),
           method = factor(.data$method))

  # Determine x_axis
  x_axis_label <- switch(x_axis,
                         width         = "Width (m)",
                         slope         = "Slope",
                         particle_size = "Particle Size (m)")

  # Create plot
  stone_plot <- ggplot(dims_long,
                       aes(x = .data[[x_axis]],
                           y = stone_size,
                           color = method)) +
    geom_line(linewidth = 2.5) +
    scale_color_paletteer_d("NatParksPalettes::KingsCanyon") +
    labs(title = "Stone Size by Methods",
         x = x_axis_label, y = "Stone Size (m)") +
    theme_light()

  return(stone_plot)
}
