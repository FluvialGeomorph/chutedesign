#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),

    page_navbar(
      title = "Chute Design",

      layout_sidebar(
        sidebar = sidebar(
          "Sidebar fields",
          navset_card_tab(
            nav_panel(
              title = "Plot 1",
              "Plot 1 content"
            ),
            nav_panel(
              title = "Plot 2",
              "Plot 2 content"
            )
          ) # End navset_card_tab
        ) # End sidebar
      ) # End layout_sidebar
    ) # End page_navbar
  )
}

