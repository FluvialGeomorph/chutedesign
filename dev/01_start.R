# Building a Prod-Ready, Robust Shiny Application.
#
# README: each step of the dev files is optional, and you don't have to
# fill every dev scripts before getting started.
# 01_start.R should be filled at start.
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
#
#
########################################
#### CURRENT FILE: ON START SCRIPT #####
########################################

usethis::use_github(
  organisation = "FluvialGeomorph",
  visibility = "public")

## Fill the DESCRIPTION ----
## Add meta data about your application and set some default {golem} options
##
## /!\ Note: if you want to change the name of your app during development,
## either re-run this function, call golem::set_golem_name(), or don't forget
## to change the name in the app_sys() function in app_config.R /!\
##
# golem::fill_desc(
#   pkg_name = "chutedesign",
#   pkg_title = "Chute Design",
#   pkg_description = "A Shiny app to perform the calculations to design a chute.", # What the package does (one paragraph).
#   authors = person(
#     given = "AUTHOR_FIRST", # Your First Name
#     family = "AUTHOR_LAST", # Your Last Name
#     email = "AUTHOR@MAIL.COM", # Your email
#     role = c("aut", "cre") # Your role (here author/creator)
#   ),
#   repo_url = NULL, # The URL of the GitHub repo (optional),
#   pkg_version = "0.0.0.9000", # The version of the package containing the app
#   set_options = TRUE # Set the global golem options
# )

## Install the required dev dependencies ----
golem::install_dev_deps()

## Create Common Files ----
## See ?usethis for more information
usethis::use_cc0_license() # You can set another license here
golem::use_readme_rmd(open = FALSE)
#devtools::build_readme()
# Note that `contact` is required since usethis version 2.1.5
# If your {usethis} version is older, you can remove that param
usethis::use_code_of_conduct(contact = "Golem User")
usethis::use_lifecycle_badge("Experimental")
usethis::use_news_md(open = FALSE)

## Init Testing Infrastructure ----
## Create a template for tests
golem::use_recommended_tests()

## Favicon ----
# If you want to change the favicon (default is golem's one)
golem::remove_favicon() # Uncomment to remove the default favicon
golem::use_favicon(path = "man/figures/castle.png") # path = "path/to/ico". Can be an online file.


## Add helper functions ----
golem::use_utils_ui(with_test = TRUE)
golem::use_utils_server(with_test = TRUE)

## Use git ----
usethis::use_git()
## Sets the remote associated with 'name' to 'url'
usethis::use_git_remote(
  name = "origin",
  url = "https://github.com/FluvialGeomorph/chutedesign.git"
)

# You're now set! ----

# go to dev/02_dev.R
rstudioapi::navigateToFile("dev/02_dev.R")
