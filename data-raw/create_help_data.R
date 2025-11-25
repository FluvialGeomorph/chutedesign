## Create the `help_data` dataset.

library(dplyr)
library(glue)

# Create an empty tibble
help_data <- tibble::tibble(id = as.character(), text = as.character())

# Add help data entries
help_data <- help_data %>%
  add_row(
    id = "getting_started",
    text = glue("
    # Getting Started

    This app helps estimate the stone sizes required for chutes of various dimensions.

    ## Define the Scenario

    1. In the left sidebar, specify the design characteristics of the chute.
    2. Click the `Calculate Dimensions` button.
    
    ## Review the Results
    
    Scenario results can be explored using the tabs across the top of the app.
    
    * by Width - View results of the scenario where chute widths are varied.
    * by Slope - View results of the scenario where chute slopes are varied.
    * by Particle Size - View results of the scenario where chute particle sizes are varied.
    ")) %>%
  add_row(
    id = "intro_sidebar",
    text = glue("
    * This help panel is is available on each page.
    * It contains guidance specific to each page.
    * It can be toggled open and closed using the arrow at the top of this panel. 
    "))

# Save data to package
usethis::use_data(help_data, internal = FALSE, overwrite = TRUE)
