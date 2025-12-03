#' Overlay a help popover over a full-width UI output
#'
#' @description
#' Wraps any Shiny output (plotOutput, DTOutput, rglwidgetOutput, etc.)
#' in a relative-positioned container and absolutely positions a help UI
#' (typically a `popover(bs_icon(...), uiOutput(...))`) in the upper-right corner.
#'
#' This preserves the wrapped output at full width (no column narrowing)
#' and avoids hard-coded widths/heights, so it is suitable for responsive
#' and mobile-friendly layouts.
#'
#' @param main UI tag representing the main output to display, e.g. `plotOutput("id")`
#' @param help_ui UI tag representing the help popover/content to overlay, e.g.
#'   `popover(bs_icon("info-circle"), uiOutput("help_id"))`
#' @param top CSS offset from the top of the wrapper (e.g. \"0.5rem\"). Default: \"0.5rem\".
#' @param right CSS offset from the right edge of the wrapper (e.g. \"0.5rem\"). Default: \"0.5rem\".
#' @param z Integer z-index for the overlay to ensure it sits above the main output. Default: 1000.
#'
#' @return An HTML tag (div) wrapping `main` with an absolutely-positioned help UI.
#' 
#' @importFrom htmltools div tagList
#' @export
help_overlay <- function(main, help_ui, top = "0.3rem", right = "0.3rem", z = 1000) {
  htmltools::div(
    style = "position: relative; width: 100%;",
    main,
    htmltools::div(
      style = sprintf("position: absolute; top: %s; right: %s; z-index: %s;", top, right, z),
      help_ui
    )
  )
}