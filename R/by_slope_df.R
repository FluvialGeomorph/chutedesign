#' @title By Slope Data Frame
#' @description Create a data frame of a scenario that varies by chute slope.
#' @param scenario list; A scenario definition list.
#' @returns a scenario data frame
#' @export
by_slope_df <- function(scenario) {
  slope_seq <- seq(from = scenario$slope_start,
                   to   = scenario$slope_end,
                   by   = scenario$slope_by)
  id_seq <- seq(from = 1,
                to = length(slope_seq),
                by = 1)

  slope_df <- data.frame(
    id              = id_seq,
    slope           = slope_seq,
    length          = rep(scenario$length, length(id_seq)),
    width           = rep(scenario$width, length(id_seq)),
    particle_size   = rep(scenario$particle_size, length(id_seq)),
    side_slope      = rep(scenario$side_slope, length(id_seq)),
    total_discharge = rep(scenario$total_discharge, length(id_seq)),
    stone_density   = rep(scenario$stone_density, length(id_seq)),
    contingency     = rep(scenario$contingency, length(id_seq)),
    porosity        = rep(scenario$porosity, length(id_seq)),
    water_density   = rep(scenario$water_density, length(id_seq)),
    gravity         = rep(scenario$gravity, length(id_seq))
  )

  return(slope_df)
}
