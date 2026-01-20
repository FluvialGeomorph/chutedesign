test_that("check latest shiny extension installs", {
  extension_url <- "https://open-vsx.org/api/posit/shiny/1.3.3/file/posit.shiny-1.3.3.vsix"
  compat <- install_positron_extension(extension_url)
  testthat::expect_false(compat$compatible)
})

test_that("check n-1 shiny extension installs", {
  extension_url <- "https://open-vsx.org/api/posit/shiny/1.3.2/file/posit.shiny-1.3.2.vsix"
  compat <- install_positron_extension(extension_url)
  testthat::expect_true(compat$compatible)
})

test_that("check latest quarto extension installs", {
  extension_url <- "https://open-vsx.org/api/quarto/quarto/1.128.0/file/quarto.quarto-1.128.0.vsix"
  compat <- install_positron_extension(extension_url)
  testthat::expect_false(compat$compatible)
})

test_that("check latest quarto extension installs", {
  extension_url <- "https://open-vsx.org/api/quarto/quarto/1.126.0/file/quarto.quarto-1.126.0.vsix"
  compat <- install_positron_extension(extension_url)
  testthat::expect_true(compat$compatible)
})