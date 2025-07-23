#' @title By Particle Size Data Frame
#' @description Create a data frame of a scenario that varies by chute
#'              particle size.
#' @param scenario list; A scenario definition list.
#' @returns a scenario data frame
#' @export
by_particle_size_df <- function(scenario) {
  particle_size_seq <- seq(from = scenario$particle_size_start,
                   to   = scenario$particle_size_end,
                   by   = scenario$particle_size_by)
  id_seq <- seq(from = 1,
                to = length(particle_size_seq),
                by = 1)

  particle_size_df <- data.frame(
    id              = id_seq,
    particle_size   = particle_size_seq,
    length          = rep(scenario$length, length(id_seq)),
    width           = rep(scenario$width, length(id_seq)),
    slope           = rep(scenario$slope, length(id_seq)),
    side_slope      = rep(scenario$side_slope, length(id_seq)),
    total_discharge = rep(scenario$total_discharge, length(id_seq)),
    stone_density   = rep(scenario$stone_density, length(id_seq)),
    contingency     = rep(scenario$contingency, length(id_seq)),
    porosity        = rep(scenario$porosity, length(id_seq)),
    water_density   = rep(scenario$water_density, length(id_seq)),
    gravity         = rep(scenario$gravity, length(id_seq))
  )

  return(particle_size_df)
}
