#' @title By Length Data Frame
#' @description Create a data frame of a scenario that varies by chute length.
#'
#' @details
#' This function mirrors the pattern used by by_width_df: it builds a data frame
#' where each row corresponds to a length value in the user-provided sequence
#' (length_start -> length_end by length_by). All other scenario parameters are
#' repeated for each length so the resulting data frame can be passed to
#' channel_dimensions() and the plotting functions.
#'
#' @param scenario list; A scenario definition list created by create_scenario().
#'
#' @return A data.frame where each row is a scenario with a different `length`
#'   value and identical values for the other parameters.
#'
#' @export
by_length_df <- function(scenario) {
  length_seq <- seq(from = scenario$length_start,
                    to   = scenario$length_end,
                    by   = scenario$length_by)
  id_seq <- seq(from = 1,
                to = length(length_seq),
                by = 1)

  length_df <- data.frame(
    id              = id_seq,
    length          = length_seq,
    width           = rep(scenario$width, length(id_seq)),
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

  return(length_df)
}