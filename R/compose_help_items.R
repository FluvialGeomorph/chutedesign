#' Compose one or more help items into a Shiny UI fragment
#'
#' @param ids character vector of help record ids to compose. May also be
#'   supplied through `...`.
#' @param ... additional help record ids supplied as character scalars.
#' @param data optional data.frame or tibble containing help records.
#' @param data_name optional character scalar giving the name of a dataset
#'   exported by an R package.
#' @param package optional character scalar giving the package name containing
#'   `data_name`.
#' @param fields character vector of fields to render from each help item.
#'   Default: `c("summary", "detail")`.
#' @param include_title logical; if `TRUE`, prepend each help item with its
#'   title. Default: `FALSE`.
#' @param title_field character scalar naming the title field. Default: `"title"`.
#' @param title_tag function used to wrap titles. Default: `shiny::tags$strong`.
#' @param separator optional UI tag inserted between help items. Default:
#'   `shiny::tags$hr()`. Use `NULL` for no separator.
#' @param container function used to combine all UI parts. Default:
#'   `shiny::tagList`.
#' @param on_missing how to handle ids not present in the help data. One of
#'   `"error"`, `"warn"`, or `"drop"`. Default: `"error"`.
#' @param deduplicate logical; if `TRUE`, remove duplicate ids while preserving
#'   order. Default: `FALSE`.
#'
#' @return A Shiny UI object.
#'
#' @details
#' This function is the composition layer for parameterized and composable help.
#' It is intentionally independent of specific UI placement concepts such as
#' popovers or sidebars; those concerns belong in the UI layer.
#'
#' Help data must contain at least an `id` column and any requested `fields`.
#'
#' @importFrom shiny tags tagList markdown
#' @importFrom rlang .data
#' @export
compose_help_items <- function(
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
  on_missing <- match.arg(on_missing)

  extra_ids <- c(...)
  ids <- c(ids, extra_ids)

  if (length(ids) == 0 || all(is.na(ids)) || all(ids == "")) {
    stop("At least one help item id must be supplied.")
  }

  ids <- as.character(ids)

  if (deduplicate) {
    ids <- unique(ids)
  }

  help_df <- resolve_help_data(data = data, data_name = data_name, package = package)

  required_cols <- unique(c("id", fields, if (include_title) title_field else NULL))
  missing_cols <- setdiff(required_cols, colnames(help_df))
  if (length(missing_cols) > 0) {
    stop(
      "Help data is missing required columns: ",
      paste(missing_cols, collapse = ", ")
    )
  }

  found_ids <- help_df$id
  missing_ids <- setdiff(ids, found_ids)

  if (length(missing_ids) > 0) {
    msg <- paste(
      "The following help ids were not found:",
      paste(missing_ids, collapse = ", ")
    )

    if (on_missing == "error") {
      stop(msg)
    } else if (on_missing == "warn") {
      warning(msg, call. = FALSE)
      ids <- intersect(ids, found_ids)
    } else if (on_missing == "drop") {
      ids <- intersect(ids, found_ids)
    }
  }

  if (length(ids) == 0) {
    return(container())
  }

  parts <- list()

  for (i in seq_along(ids)) {
    help_row <- help_df[help_df$id == ids[[i]], , drop = FALSE]

    item_parts <- list()

    if (include_title) {
      item_parts <- c(item_parts, list(title_tag(help_row[[title_field]][[1]])))
    }

    for (field in fields) {
      value <- help_row[[field]][[1]]

      if (!is.na(value) && nzchar(value)) {
        item_parts <- c(item_parts, list(shiny::markdown(value)))
      }
    }

    parts <- c(parts, item_parts)

    if (!is.null(separator) && i < length(ids)) {
      parts <- c(parts, list(separator))
    }
  }

  do.call(container, parts)
}

#' Resolve help data from a direct object or package dataset
#'
#' @param data optional data.frame or tibble containing help records.
#' @param data_name optional character scalar giving the dataset name.
#' @param package optional character scalar giving the package name.
#'
#' @return A data.frame or tibble.
#' @noRd
resolve_help_data <- function(data = NULL, data_name = NULL, package = NULL) {
  if (!is.null(data)) {
    if (!is.data.frame(data)) {
      stop("`data` must be a data.frame or tibble.")
    }
    return(data)
  }

  if (is.null(data_name) || is.null(package)) {
    stop("Provide either `data`, or both `data_name` and `package`.")
  }

  loaded_env <- new.env(parent = emptyenv())
  ok <- utils::data(list = data_name, package = package, envir = loaded_env)

  if (length(ok) == 0) {
    stop(
      "Could not load dataset `", data_name,
      "` from package `", package, "`."
    )
  }

  help_df <- loaded_env[[data_name]]

  if (!is.data.frame(help_df)) {
    stop(
      "Dataset `", data_name, "` from package `", package,
      "` is not a data.frame or tibble."
    )
  }

  help_df
}
