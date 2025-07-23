#' @title Create a Channel Data Frame
#' @description Compute hydraulic and stone sizing metrics for each channel
#' @param channel_df data.frame; Input data frame with required channel variables
#' @returns A data frame with derived channel dimensions and stone parameters
#' @export
#' @importFrom dplyr mutate %>%
channel_dimensions <- function(channel_df) {
  # Constants
  h2o_specific_weight <- 9787           # N/m^3
  ft_per_m <- 3.2808
  ft_per_m2 <- ft_per_m^2
  g <- unique(channel_df$gravity)       # user-provided gravity (m/s^2)
  wd <- unique(channel_df$water_density) # user-provided water density (kg/m^3)

  channel_dims <- channel_df %>%
    mutate(
      # Constants
      stone_specific_weight = stone_density * g,
      specific_gravity = stone_specific_weight / h2o_specific_weight,

      # Chute Parameters
      side_angle = atan(1 / side_slope) * (180 / pi),

      # Channel Flow Parameters
      unit_discharge = total_discharge / width,
      mannings_n = 0.034 * (particle_size * ft_per_m)^(1/6),
      critical_depth = (unit_discharge^2 / g)^(1/3),
      critical_velocity = unit_discharge / critical_depth,
      critical_slope = (critical_velocity * mannings_n / critical_depth^(2/3))^2,
      normal_depth = ((unit_discharge * mannings_n) / sqrt(slope))^(3/5),
      normal_velocity = unit_discharge / normal_depth,
      froude = normal_velocity / sqrt(g * normal_depth),
      shear_stress = h2o_specific_weight * normal_velocity * slope,
      avail_stream_power = (h2o_specific_weight * unit_discharge * slope) / 1000,
      applied_stream_power = (7.853 * wd * (shear_stress / wd)^(3/2)) / 1000,

      # Stone size methods
      stone_size_nrcs = (12 * (0.233 * unit_discharge * ft_per_m2 * slope^0.58)^0.529) / (12 * ft_per_m),
      stone_size_usace = (1.95 * slope^0.555 * unit_discharge^(2/3)) / g^(1/3),
      stone_size_abt_johnson = (((unit_discharge * ft_per_m2)^0.56) * slope^0.43 * 5.23) / (12 * ft_per_m),
      stone_size_isbash = (((1.2^2) * 2 * g * ft_per_m * ((stone_specific_weight - h2o_specific_weight) / h2o_specific_weight)) / (normal_velocity * ft_per_m)) * (1 / ft_per_m),
      stone_size_usbr = 0.0122 * (ft_per_m * normal_velocity)^2.06 * 0.3048,

      # Adopted stone and dimensions
      adopted_stone_diameter = stone_size_nrcs * 1.3,
      adopted_stone_weight_kg = (adopted_stone_diameter^3 * pi * stone_specific_weight) / (6 * g),
      adopted_stone_weight_lbs = adopted_stone_weight_kg * 2.205,
      adopted_stone_weight_ton = adopted_stone_weight_lbs / 2000,

      # Geometry and volume
      depth = normal_depth * 2,
      length_side_horz = depth * side_slope,
      length_left_bank = length_side_horz / cos(side_angle * (pi / 180)),
      matress_thickness = adopted_stone_diameter * 2,
      stone_vol_sqm = contingency * (matress_thickness * (length_left_bank + width) * length) * (1 - porosity),
      stone_vol_cuyd = stone_vol_sqm * 1.308,
      stone_vol_metric_ton = stone_vol_sqm * stone_density / 1000,
      stone_vol_us_ton = stone_vol_metric_ton * 1.102,
      number_stones = stone_vol_metric_ton / adopted_stone_weight_ton
    )

  return(channel_dims)
}
