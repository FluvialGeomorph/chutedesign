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
    ")
  ) %>%
  add_row(
    id = "intro_sidebar",
    text = glue("
    * This help panel is is available on each page.
    * It contains guidance specific to each page.
    * It can be toggled open and closed using the arrow at the top of this panel. 
    ")
  ) %>%
  add_row(
    id = "by_width_sidebar",
    text = glue("
    by Width Help
    ")
  ) %>%
  add_row(
    id = "by_length_sidebar",
    text = glue("
    by Length Help
    ")
  ) %>%
    add_row(
    id = "by_slope_sidebar",
    text = glue("
    by Slope Help
    ")
  ) %>%
  add_row(
    id = "by_particle_sidebar",
    text = glue("
    by Particle Size Help
    ")
  ) %>%
  add_row(
    id = "width_parameters",
    text = glue("
    Use these fields to configure the range of chute widths to be calculated.
    ")
  ) %>%
  add_row(
    id = "length_parameters",
    text = glue("
    Use these fields to configure the range of chute lengths to be calculated.
    ")
  ) %>%
    add_row(
    id = "slope_parameters",
    text = glue("
    Use these fields to configure the range of chute slopes to be calculated.
    ")
  ) %>%
  add_row(
    id = "particle_parameters",
    text = glue("
    Use these fields to configure the range of chute particle sizes to be calculated.
    ")
  ) %>%
  add_row(
    id = "side_slope_parameter",
    text = glue("
    Enter the side slope (rise:run) of the chute.
    ")
  ) %>%
  add_row(
    id = "discharge_parameter",
    text = glue("
    Enter the total discharge (m^3/s) passing through the chute.
    ")
  ) %>%
  add_row(
    id = "stone_density_parameter",
    text = glue("
    Enter the stone density (kg/m^3) of stone used to construct the chute.
    ")
  ) %>%
    add_row(
    id = "contingency_parameter",
    text = glue("
    Enter the contingency factor for calculating stone quantity required for the chute.
    ")
  ) %>%
  add_row(
    id = "porosity_parameter",
    text = glue("
    Enter the bulk-placed porosity of stone used for the chute.
    ")
  ) %>%
  add_row(
    id = "water_density_parameter",
    text = glue("
    Enter the water density (kg/m^3) used in hydraulic calculations.
    ")
  ) %>%
  add_row(
    id = "grav_constant_parameter",
    text = glue("
    Enter the gravitational constant (N/m^3) in hydraulic calculations.
    ")
  )

# Save data to package
usethis::use_data(help_data, internal = FALSE, overwrite = TRUE)
