#' @title Create Scenario
#' @description Create a scenario.
#'
#' @param width_start numeric; Width of the chute
#' @param width_end
#' @param width_by
#' @param slope_start
#' @param slope_end
#' @param slope_by
#' @param particle_size_start
#' @param particle_size_end
#' @param particle_size_by
#' @param length
#' @param side_slope
#' @param total_discharge
#' @param stone_density
#' @param contingency
#' @param porosity
#' @param water_density
#' @param gravity
#'
#' @returns
#' @export
#'
create_scenario <- function(
    width_start, width_end, width_by,
    slope_start, slope_end, slope_by,
    particle_size_start, particle_size_end, particle_size_by,
    length, side_slope, total_discharge, stone_density,
    contingency, porosity, water_density, gravity) {

  scenario <- list(
    width_start         = width_start,
    width_end           = width_end,
    width_by            = width_by,
    slope_start         = slope_start,
    slope_end           = slope_end,
    slope_by            = slope_by,
    particle_size_start = particle_size_start,
    particle_size_end   = particle_size_end,
    particle_size_by    = particle_size_by,
    length              = length,
    side_slope          = side_slope,
    total_discharge     = total_discharge,
    stone_density       = stone_density,
    contingency         = contingency,
    porosity            = porosity,
    water_density       = water_density,
    gravity             = gravity
  )

  return(scenario)
}
