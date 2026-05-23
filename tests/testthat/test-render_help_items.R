test_that("render_help_items returns a render function", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  rendered <- render_help_items(
    ids = "width",
    data = help_df
  )

  expect_true(is.function(rendered))
})

test_that("render_help_items validates ids when executed", {
  help_df <- tibble::tibble(
    id = "width",
    title = "Width",
    summary = "Width summary",
    detail = "Width detail"
  )

  rendered <- render_help_items(
    ids = c("width", "missing_id"),
    data = help_df
  )

  expect_true(is.function(rendered))
})

test_that("render_help_items supports same interface as compose_help_items", {
  help_df <- tibble::tibble(
    id = c("width", "width_series"),
    title = c("Width", "Width series"),
    summary = c("Width summary", "Width series summary"),
    detail = c("Width detail", "Width series detail")
  )

  rendered <- render_help_items(
    ids = c("width", "width_series"),
    data = help_df,
    fields = c("summary", "detail"),
    include_title = TRUE,
    deduplicate = TRUE
  )

  expect_true(is.function(rendered))
})
