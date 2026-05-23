#' Help content for the chutedesign Shiny app
#'
#' A dataset of structured help content used throughout the `chutedesign`
#' Shiny application. Each row represents a reusable help item that can be
#' composed into popovers, sidebars, overlays, and other UI elements.
#'
#' The dataset is designed to support a parameterized and composable help
#' workflow. Content is stored at two levels of detail:
#'
#' \describe{
#'   \item{id}{Unique identifier for the help item.}
#'   \item{title}{Human-readable title for the help item.}
#'   \item{summary}{Short summary text suitable for compact help contexts.}
#'   \item{detail}{Expanded help text suitable for detailed explanation.}
#' }
#'
#' @format A tibble with 4 variables:
#' \describe{
#'   \item{id}{Character scalar uniquely identifying the help item.}
#'   \item{title}{Character scalar naming the help item.}
#'   \item{summary}{Character scalar containing concise help text.}
#'   \item{detail}{Character scalar containing detailed help text, often in Markdown.}
#' }
#'
#' @source `data-raw/create_help_data.R`
#'
#' @examples
#' head(help_data)
#' subset(help_data, id %in% c("width", "width_series"))
"help_data"
