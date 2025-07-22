#' @title Create a Channel Data Frame
#' @description Create a channel data frame.
#'
#' @param channel_df data.frame; A channel data frame where each row
#'                   represents a channel.
#' @returns a data frame of channel dimensions
#' @export
#' @importFrom dplyr mutate %>%
channel_dimensions <- function(channel_df) {
  # Constants
  h2o_specific_weight <- 9787  # units: N/m^3

  channel_dims <- channel_df %>%
    mutate(stone_specific_weight = stone_density*gravity) %>%
    mutate(specific_gravity = stone_specific_weight/h2o_specific_weight) %>%
    mutate(side_angle = atan(1/side_slope)*(180/pi)) %>%
    mutate(unit_discharge = total_discharge/width) %>%
    mutate(mannings_n = 0.034*(particle_size*3.2808)^(1/6)) %>%
    mutate(critical_depth = ((unit_discharge^2)/gravity)^(1/3)) %>%
    mutate(critical_velocity = unit_discharge/critical_depth) %>%
    mutate(critical_slope = (critical_velocity*mannings_n*
                               (1/(critical_depth^(2/3))))^2) %>%
    mutate(normal_depth = ((unit_discharge*mannings_n)/(slope^0.5))^(3/5)) %>%
    mutate(normal_velocity = unit_discharge/normal_depth) %>%
    mutate(froude = normal_velocity/sqrt(gravity*normal_depth)) %>%
    mutate(shear_stress = h2o_specific_weight*normal_velocity*slope) %>%
    mutate(avail_stream_power = (h2o_specific_weight*unit_discharge*
                                   slope)/1000) %>%
    mutate(applied_stream_power = (7.853*water_density*
                                     (shear_stress/water_density)^(3/2))/
                                     1000) %>%
    mutate(stone_size_nrcs = (12*(0.233*unit_discharge*(3.2808^2)*
                                    slope^0.58)^0.529)/(12*3.2808))%>%
    mutate(stone_size_usace = (1.95*(slope^0.555)*(unit_discharge^(2/3)))
                                    /(gravity^(1/3))) %>%
    mutate(stone_size_abt_johnson = (((unit_discharge*(3.2808^2))^0.56)*
                                       (slope^0.43)*5.23)/(12*3.2808)) %>%
    mutate(stone_size_isbash = (((1.2^2)*2*(gravity*3.2808)*
                              ((stone_specific_weight-h2o_specific_weight)/
                              h2o_specific_weight))/(normal_velocity*3.2808))*
                              (1/3.2808)) %>%
    mutate(stone_size_usbr = 0.0122*(3.28084*normal_velocity)^2.06*0.3048) %>%
    mutate(adopted_stone_diameter = stone_size_nrcs*1.3) %>%
    mutate(adopted_stone_weight_kg = ((adopted_stone_diameter^3)*3.14*
                                     stone_specific_weight)/(6*gravity)) %>%
    mutate(adopted_stone_weight_lbs = adopted_stone_weight_kg*2.205) %>%
    mutate(adopted_stone_weight_ton = adopted_stone_weight_lbs/2000) %>%
    mutate(depth = normal_depth*2) %>%
    mutate(length_side_horz = depth*side_slope) %>%
    mutate(length_left_bank = length_side_horz/
                                  cos((side_angle * (pi / 180)))) %>%
    mutate(matress_thickness = adopted_stone_diameter*2) %>%
    mutate(stone_vol_sqm = contingency*(matress_thickness*
                          (length_left_bank+width)*length)*(1-porosity)) %>%
    mutate(stone_vol_cuyd = stone_vol_sqm*1.308) %>%
    mutate(stone_vol_metric_ton = stone_vol_sqm*stone_density/1000) %>%
    mutate(stone_vol_us_ton = stone_vol_metric_ton*1.102) %>%
    mutate(number_stones = stone_vol_metric_ton/adopted_stone_weight_ton)

  return(channel_dims)
}
