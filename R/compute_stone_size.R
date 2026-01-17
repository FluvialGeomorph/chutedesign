#' @title Compute Stone Size
#' @description Calculate stone sizes using specified methods.
#' @param method character; The method to use for calculation. One of
#'               "nrcs", "usace", "abt_johnson", "isbash", "usbr".
#' @param unit_discharge numeric; Unit discharge (e.g., m^2/s).
#' @param slope numeric; Channel slope (unitless).
#' @param normal_velocity numeric; Normal velocity (m/s).
#' @param stone_specific_weight numeric; Specific weight of stone (N/m^3).
#' @param h2o_specific_weight numeric; Specific weight of water (N/m^3).
#' @param g numeric; Acceleration due to gravity (default: 9.81 m/s^2).
#' @returns numeric; The calculated stone size (m).
#' 
#' @details
#' The following methods provide approaches for estimating the stone size 
#' required to resist motion under given hydraulic conditions. These methods 
#' have been extensively documented in several publications:
#' 
#' - *Stone Sizing Criteria*, Natural Resources Conservation Service, 
#'   National Engineering Handbook 210 H Part 654 - Stream Restoration Design, 
#'   [Technical Supplement 14 C](https://directives.nrcs.usda.gov//sites/default/files2/1720623369/Technical%20Supplement%2014%20C%20-%20Stone%20Sizing%20Criteria.pdf), 
#'   August 2007.
#' - *Riprap Design Criteria, Recommended Specifications, and Quality Control*, 
#'   National Cooperative Highway Research Program, 
#'   [NCHRP Report 568](https://onlinepubs.trb.org/onlinepubs/nchrp/nchrp_rpt_568.pdf), 
#'   2006.
#' - *Hydraulic Design of Flood Control Channels*, US Army Corps of Engineers,
#'   [Engineering Manual 1110-2-1601](https://www.publications.usace.army.mil/Portals/76/Publications/EngineerManuals/EM_1110-2-1601.pdf), 
#'   30 June 1994.
#' 
#' **Isbash Method Equation:**
#' \deqn{
#'   d = \frac{(1.2 \cdot v_c)^2}{2g \cdot (SG - 1)}
#' }
#'  where:
#'   - \eqn{d}: Stone diameter (m)
#'   - \eqn{v_c}: Critical velocity for stone motion (m/s)
#'   - \eqn{SG}: Specific gravity = \eqn{(\frac{\text{stone\_specific\_weight}}{\text{h2o\_specific\_weight}})}
#'   - \eqn{g}: Gravitational acceleration (m/s²).
#' 
#' @export
compute_stone_size <- function(method,
                               unit_discharge,
                               slope,
                               normal_velocity,
                               stone_specific_weight,
                               h2o_specific_weight,
                               g = 9.81) {
  method <- tolower(method)
  switch(
    method,
    "nrcs" = (12 * (0.233 * unit_discharge * slope^0.58)^0.529) / 12,
    "usace" = (1.95 * slope^0.555 * unit_discharge^(2/3)) / g^(1/3),
    "abt_johnson" = (((unit_discharge)^0.56) * slope^0.43 * 5.23) / 12,
    "isbash" = {
      SG <- stone_specific_weight / h2o_specific_weight
      if (normal_velocity <= 0 || SG <= 1) {
        stop("Invalid inputs for Isbash method: normal_velocity must be > 0 and SG must be > 1.")
      }
      d <- (1.2 * normal_velocity)^2 / (2 * g * (SG - 1))
      return(d)
    },
    "usbr" = 0.0122 * (normal_velocity)^2.06,
    stop("Invalid method. Method must be one of: 'nrcs', 'usace', 'abt_johnson', 'isbash', 'usbr'.")
  )
}