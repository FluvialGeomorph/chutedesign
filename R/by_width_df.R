#' @title By Width Data Frame
#' @description Create a data frame of a scenario that varies by chute width.
#' @param scenario list; A scenario definition list.
#' @returns a scenario data frame
#' @export
by_width_df <- function(scenario) {
  width_seq <- seq(from = scenario$width_start,
                   to   = scenario$width_end,
                   by   = scenario$width_by)
  id_seq <- seq(from = 1,
                to = length(width_seq),
                by = 1)

  width_df <- data.frame(
    id              = id_seq,
    width           = width_seq,
    length          = rep(scenario$length, length(id_seq)),
    slope           = rep(scenario$slope, length(id_seq)),
    particle_size   = rep(scenario$particle_size, length(id_seq)),
    side_slope      = rep(scenario$side_slope, length(id_seq)),
    total_discharge = rep(scenario$total_discharge, length(id_seq)),
    stone_density   = rep(scenario$stone_density, length(id_seq)),
    contingency     = rep(scenario$contingency, length(id_seq)),
    porosity        = rep(scenario$porosity, length(id_seq)),
    water_density   = rep(scenario$water_density, length(id_seq)),
    gravity         = rep(scenario$gravity, length(id_seq))
  )

  return(width_df)
}
