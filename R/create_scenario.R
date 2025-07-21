#' @title Create Scenario
#' @description Create a scenario.
#'
#' @param width               numeric; Width of chute.
#' @param width_start         numeric; Width series start value.
#' @param width_end           numeric; Width series end value.
#' @param width_by            numeric; Width by value.
#' @param length              numeric; Length of chute.
#' @param length_start        numeric; Length series start value
#' @param length_end          numeric; Length series end value.
#' @param length_by           numeric; Length series by value.
#' @param slope               numeric; Slope of chute.
#' @param slope_start         numeric; Slope series start value.
#' @param slope_end           numeric; Slope series end value.
#' @param slope_by            numeric; Slope series by value.
#' @param particle_size       numeric; Particle size.
#' @param particle_size_start numeric; Particle size series start value.
#' @param particle_size_end   numeric; Particle size series end value.
#' @param particle_size_by    numeric; Particle size series by value.
#' @param side_slope          numeric; Side slope of chute.
#' @param total_discharge     numeric; Total discharge of chute.
#' @param stone_density       numeric; Stone density.
#' @param contingency         numeric; Contingency factor on quantities.
#' @param porosity            numeric; Stone bulk-placed porosity.
#' @param water_density       numeric; Water density.
#' @param gravity             numeric; Gravity constant.
#'
#' @returns a list representing the characteristics of the scenario
#' @export
#'
create_scenario <- function(
    width, width_start, width_end, width_by,
    length, length_start, length_end, length_by,
    slope, slope_start, slope_end, slope_by,
    particle_size, particle_size_start, particle_size_end, particle_size_by,
    side_slope, total_discharge, stone_density,
    contingency, porosity, water_density, gravity) {

  scenario <- list(
    width               = width,
    width_start         = width_start,
    width_end           = width_end,
    width_by            = width_by,
    length              = length,
    length_start        = length_start,
    length_end          = length_end,
    length_by           = length_by,
    slope               = slope,
    slope_start         = slope_start,
    slope_end           = slope_end,
    slope_by            = slope_by,
    particle_size       = particle_size,
    particle_size_start = particle_size_start,
    particle_size_end   = particle_size_end,
    particle_size_by    = particle_size_by,
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
