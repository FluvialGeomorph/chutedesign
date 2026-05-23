test_that("compose_help_items composes summary and detail by default", {
  help_df <- tibble::tibble(
    id = c("width", "width_series"),
    title = c("Width", "Width series"),
    summary = c("Width summary", "Width series summary"),
    detail = c("Width detail", "Width series detail")
  )

  ui <- compose_help_items(
    ids = c("width", "width_series"),
    data = help_df
  )

  expect_s3_class(ui, "shiny.tag.list")
  rendered <- as.character(ui)
  expect_true(any(grepl("Width summary", rendered, fixed = TRUE)))
  expect_true(any(grepl("Width detail", rendered, fixed = TRUE)))
  expect_true(any(grepl("Width series summary", rendered, fixed = TRUE)))
  expect_true(any(grepl("Width series detail", rendered, fixed = TRUE)))
})

test_that("compose_help_items can include titles", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  ui <- compose_help_items(
    ids = "width",
    data = help_df,
    include_title = TRUE
  )

  rendered <- as.character(ui)
  expect_true(any(grepl("Width", rendered, fixed = TRUE)))
})

test_that("compose_help_items respects selected fields", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  ui <- compose_help_items(
    ids = "width",
    data = help_df,
    fields = "summary"
  )

  rendered <- as.character(ui)
  expect_true(any(grepl("Width summary", rendered, fixed = TRUE)))
  expect_false(any(grepl("Width detail", rendered, fixed = TRUE)))
})

test_that("compose_help_items deduplicates ids when requested", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  ui <- compose_help_items(
    ids = c("width", "width"),
    data = help_df,
    deduplicate = TRUE,
    separator = NULL
  )

  rendered <- paste(as.character(ui), collapse = " ")
  expect_equal(length(gregexpr("Width summary", rendered, fixed = TRUE)[[1]]), 1)
})

test_that("compose_help_items errors on missing ids by default", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  expect_error(
    compose_help_items(ids = c("width", "missing_id"), data = help_df),
    "The following help ids were not found"
  )
})

test_that("compose_help_items can warn and drop missing ids", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  expect_warning(
    ui <- compose_help_items(
      ids = c("width", "missing_id"),
      data = help_df,
      on_missing = "warn"
    ),
    "The following help ids were not found"
  )

  expect_s3_class(ui, "shiny.tag.list")
})

test_that("compose_help_items returns empty container when all ids are dropped", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  ui <- compose_help_items(
    ids = "missing_id",
    data = help_df,
    on_missing = "drop"
  )

  expect_s3_class(ui, "shiny.tag.list")
})

test_that("compose_help_items validates required columns", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary"
  )

  expect_error(
    compose_help_items(ids = "width", data = help_df),
    "Help data is missing required columns"
  )
})

test_that("compose_help_items requires an id", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  expect_error(
    compose_help_items(data = help_df),
    "At least one help item id must be supplied"
  )
})

test_that("resolve_help_data rejects non-data.frame input", {
  expect_error(
    resolve_help_data(data = "not_a_data_frame"),
    "`data` must be a data.frame or tibble."
  )
})
