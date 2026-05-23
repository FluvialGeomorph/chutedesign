test_that("compose_help_items can load help_data from package data", {
  ui <- compose_help_items(
    ids = c("width", "width_series"),
    data_name = "help_data",
    package = "chutedesign"
  )

  expect_s3_class(ui, "shiny.tag.list")

  rendered <- as.character(ui)
  expect_true(any(grepl("Total chute width", rendered, fixed = TRUE)))
  expect_true(any(grepl("Start / end / step for width sweeps", rendered, fixed = TRUE)))
})

test_that("compose_help_items can load a single help item from package data", {
  ui <- compose_help_items(
    ids = "tab_intro",
    data_name = "help_data",
    package = "chutedesign"
  )

  expect_s3_class(ui, "shiny.tag.list")

  rendered <- as.character(ui)
  expect_true(any(grepl("Overview of the app, workflow, and key assumptions.", rendered, fixed = TRUE)))
})

test_that("compose_help_items errors clearly when package data is missing", {
  expect_error(
    compose_help_items(
      ids = "width",
      data_name = "not_real_help_data",
      package = "chutedesign"
    )
  )
})
