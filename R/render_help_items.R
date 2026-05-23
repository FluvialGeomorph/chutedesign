#' Render one or more help items as Shiny UI
#'
#' @inheritParams compose_help_items
#'
#' @return A `shiny::renderUI()` expression.
#'
#' @details
#' This is the rendering layer for parameterized and composable help. It wraps
#' `compose_help_items()` in `shiny::renderUI()` so the same composition logic
#' can be reused both inside and outside reactive Shiny outputs.
#'
#' @importFrom shiny renderUI
#' @export
render_help_items <- function(
    ids = NULL,
    ...,
    data = NULL,
    data_name = NULL,
    package = NULL,
    fields = c("summary", "detail"),
    include_title = FALSE,
    title_field = "title",
    title_tag = shiny::tags$strong,
    separator = shiny::tags$hr(),
    container = shiny::tagList,
    on_missing = c("error", "warn", "drop"),
    deduplicate = FALSE
) {
  shiny::renderUI({
    compose_help_items(
      ids = ids,
      ...,
      data = data,
      data_name = data_name,
      package = package,
      fields = fields,
      include_title = include_title,
      title_field = title_field,
      title_tag = title_tag,
      separator = separator,
      container = container,
      on_missing = on_missing,
      deduplicate = deduplicate
    )
  })
}