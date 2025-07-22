#' @title Plot Stone Size by Methods
#' @description Plot estimated stone size according to several different
#'              methods.
#' @param channel_dims data frame; A channel dimensions data frame.
#' @returns a ggplot2 object
#' @export
#' @importFrom tidyr pivot_longer starts_with
#' @importFrom stringr str_remove
#' @importFrom dplyr mutate
#' @importFrom ggplot2 ggplot aes geom_line scale_color_brewer labs
#'             theme_light
plot_stone_size_method <- function(channel_dims) {
  # Convert from wide to long for plotting
  dims_long <- channel_dims %>%
    pivot_longer(
      cols = starts_with("stone_size_"),
      names_to = "method",
      values_to = "stone_size"
    ) %>%
    mutate(method = str_remove(.data$method, "stone_size_")) %>%
    mutate(method = factor(.data$method))

  ggplot(dims_long,
         aes(x = width, y = stone_size, color = method)) +
    geom_line(size = 1.8) +
    scale_color_brewer(palette = "Dark2") +
    labs(title = "Stone Size by Methods",
         x = "Width (m)", y = "Stone Size (m)") +
    theme_light()
}
