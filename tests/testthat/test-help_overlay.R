test_that("help_overlay returns a tag with relative container and absolute overlay", {
  main <- tags$div(id = "main-content")
  help_ui <- tags$div(id = "help-ui")
  out <- help_overlay(main, help_ui)

  expect_s3_class(out, "shiny.tag")
  out_chr <- as.character(out)

  # wrapper must be relatively positioned
  expect_match(out_chr, "position:\\s*relative")

  # overlay must be absolutely positioned
  expect_match(out_chr, "position:\\s*absolute")

  # main and help UI elements should be present inside the output
  expect_match(out_chr, "id=\\\"main-content\\\"")
  expect_match(out_chr, "id=\\\"help-ui\\\"")
})

test_that("help_overlay applies custom offsets and z-index", {
  main <- tags$p("content")
  help_ui <- tags$span("help")
  out <- help_overlay(main, help_ui, top = "10px", right = "20px", z = 9999)
  out_chr <- as.character(out)

  expect_match(out_chr, "top:\\s*10px")
  expect_match(out_chr, "right:\\s*20px")
  expect_match(out_chr, "z-index:\\s*9999")
})

test_that("help_overlay supports different kinds of UI tags", {
  # Use a non-trivial tag as main and a button as help UI
  main <- tags$div(id = "plot-area", tags$svg())
  help_ui <- tags$button(id = "help-btn", "i")
  out <- help_overlay(main, help_ui)
  out_chr <- as.character(out)

  expect_match(out_chr, "id=\\\"plot-area\\\"")
  expect_match(out_chr, "id=\\\"help-btn\\\"")
})