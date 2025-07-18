<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- rmarkdown::render(input="README.Rmd", output_file = "README.md", output_format = "md_document") -->

# `{chutedesign}`

<!-- badges: start -->
<!-- badges: end -->

## Installation

You can install the development version of `{chutedesign}` like so:

    # FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?

## Run

You can launch the application by running:

    chutedesign::run_app()

## About

You are reading the doc about version : 2025.07.18

This README has been compiled on the

    Sys.time()

    ## [1] "2025-07-18 15:38:11 CDT"

Here are the tests results and package coverage:

    devtools::check(quiet = TRUE)

    ## ℹ Loading chutedesign
    ## ✖ create_scenario.R:5: @param requires two parts: an argument name and a description.
    ## ✖ create_scenario.R:6: @param requires two parts: an argument name and a description.
    ## ✖ create_scenario.R:7: @param requires two parts: an argument name and a description.
    ## ✖ create_scenario.R:8: @param requires two parts: an argument name and a description.
    ## ✖ create_scenario.R:9: @param requires two parts: an argument name and a description.
    ## ✖ create_scenario.R:10: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:11: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:12: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:13: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:14: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:15: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:16: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:17: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:18: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:19: @param requires two parts: an argument name and a
    ##   description.
    ## ✖ create_scenario.R:22: @returns requires a value.

    ## ── R CMD check results ─────────────────────────────────── chutedesign 2025.07.18 ────
    ## Duration: 6s
    ## 
    ## ❯ checking package dependencies ... ERROR
    ##   Namespace dependencies missing from DESCRIPTION Imports/Depends entries:
    ##     'bsicons', 'bslib'
    ##   
    ##   See section 'The DESCRIPTION file' in the 'Writing R Extensions'
    ##   manual.
    ## 
    ## 1 error ✖ | 0 warnings ✔ | 0 notes ✔

    covr::package_coverage()

    ## chutedesign Coverage: 80.39%

    ## R/run_app.R: 0.00%

    ## R/app_server.R: 9.52%

    ## R/app_config.R: 100.00%

    ## R/app_ui.R: 100.00%

    ## R/create_scenario.R: 100.00%

    ## R/golem_add_external_resources.R: 100.00%
