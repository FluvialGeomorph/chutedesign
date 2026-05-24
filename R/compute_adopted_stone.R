#' @title Compute Adopted Stone Dimensions and Quantities
#' @description Using the stone diameter from a chosen sizing method, compute
#'   the adopted stone dimensions, weights, mattress thickness, and stone
#'   volume quantities for a chute design.
#'
#' @param channel_dims  data.frame; Wide-format channel dimensions produced by
#'   `compute_channel_dimensions()`. Must include columns `id`, `stone_density`,
#'   `gravity`, `contingency`, `porosity`, `length_left_bank`, `width`,
#'   `length`.
#' @param stone_metrics data.frame; Long-format stone metrics produced by
#'   `compute_stone_metrics()`. Must include columns `id`, `method`, and
#'   `stone_diameter`.
#' @param method        character; The sizing method whose stone diameter is
#'   adopted. One of `"nrcs"`, `"usace"`, `"abt_johnson"`, `"isbash"`,
#'   `"usbr"`. Default: `"nrcs"`.
#'
#' @return A `tibble` (wide format) with one row per scenario point, containing
#'   all columns from `channel_dims` plus the following adopted-stone columns:
#'   `adopted_stone_diameter`, `adopted_stone_weight_kg`,
#'   `adopted_stone_weight_lbs`, `adopted_stone_weight_us_ton`,
#'   `mattress_thickness`, `stone_vol_m3`, `stone_vol_cuyd`,
#'   `stone_vol_metric_ton`, `stone_vol_us_ton`, `number_stones`.
#'
#' @details
#' The adopted stone diameter is taken directly from the stone diameter
#' computed by the chosen empirical method in `compute_stone_metrics()`.
#' No additional multiplier is applied; design contingency on volume is
#' applied via the data-driven `contingency` column inherited from the
#' scenario.
#'
#' **Adopted stone weight equation:**
#' \deqn{
#'   W_{kg} = \frac{d^3 \cdot \pi \cdot \gamma_s}{6 \cdot g}
#' }
#' where:
#'   - \eqn{d}: Adopted stone diameter (m)
#'   - \eqn{\gamma_s}: Stone specific weight = \eqn{stone\_density \times gravity} (N/m^3)
#'   - \eqn{g}: Gravitational acceleration (m/s^2)
#'
#' **Stone volume equation:**
#' \deqn{
#'   V_{m^3} = contingency \times mattress\_thickness \times
#'             (length\_left\_bank + width) \times length \times (1 - porosity)
#' }
#'
#' @importFrom dplyr filter select left_join mutate select
#' @importFrom rlang .data
#' @export
compute_adopted_stone <- function(channel_dims, stone_metrics, method = "nrcs") {
  # Validate method
  valid_methods <- c("nrcs", "usace", "abt_johnson", "isbash", "usbr")
  if (!(method %in% valid_methods)) {
    stop("method must be one of: ", paste(valid_methods, collapse = ", "))
  }

  # Extract adopted stone diameter for the chosen method (one row per scenario point)
  adopted_diameter <- stone_metrics %>%
    dplyr::filter(.data$method == !!method) %>%
    dplyr::select(id, adopted_stone_diameter = stone_diameter)

  # Join adopted diameter to channel dims and compute adopted stone columns
  channel_dims %>%
    dplyr::left_join(adopted_diameter, by = "id") %>%
    dplyr::mutate(
      # Intermediate: stone specific weight (N/m^3) — retained for equation traceability
      stone_specific_weight    = stone_density * gravity,

      # Adopted stone dimensions
      adopted_stone_weight_kg     = (adopted_stone_diameter^3 * pi * stone_specific_weight) /
                                   (6 * gravity),
      adopted_stone_weight_lbs    = adopted_stone_weight_kg * 2.20462,
      adopted_stone_weight_us_ton = adopted_stone_weight_lbs / 2000,
      mattress_thickness          = adopted_stone_diameter * 2,

      # Stone quantities
      stone_vol_m3         = contingency *
                               (mattress_thickness * (length_left_bank + width) * length) *
                               (1 - porosity),
      stone_vol_cuyd       = stone_vol_m3 * 1.30795,
      stone_vol_metric_ton = stone_vol_m3 * stone_density / 1000,
      stone_vol_us_ton     = stone_vol_metric_ton * 1.10231,
      number_stones        = stone_vol_us_ton / adopted_stone_weight_us_ton
    ) %>%
    dplyr::select(-stone_specific_weight)
}
