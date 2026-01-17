#' @title Calculate Stone Size: Isbash Method
#' @description Calculate stone size using the Isbash method.
#' @param unit_discharge numeric; Unit discharge (e.g., m^2/s).
#' @param slope numeric; Channel slope (unitless).
#' @param normal_velocity numeric; Normal velocity (m/s).
#' @param stone_specific_weight numeric; Specific weight of stone (N/m^3).
#' @param h2o_specific_weight numeric; Specific weight of water (N/m^3).
#' @param g numeric; Acceleration due to gravity (default: 9.81 m/s^2).
#'
#' @returns numeric; The calculated stone size (m).
#' 
#' @details
#' **Isbash Method**
#' The Isbash formula (Isbash	1936)	was	developed	for	the	construction of	dams	
#' by	depositing rocks	into	moving	water. The Isbash curve	should only	be	
#' used	for	quick	estimates	or	for	comparisons. A	coefficient	is	provided	to	
#' target	high-	and	low-turbulence	flow	conditions,	so	this	method	can	be	a	
#' high- or	low-energy	application.	
#' 
#' \deqn{
#'   V_c = C \cdot ( 2 \cdot g \cdot \frac{\gamma_s - \gamma_w}{\gamma_w} ) ^{0.50} \cdot (D_{50})^{0.50}
#' }
#' 
#' \deqn{
#'   D_{50} = \frac{(C \cdot v_c)^2}{2g \cdot (SG - 1)}
#' }
#'  where:
#'   - \eqn{D_{50}}: Median stone diameter (\eqn{ft})
#'   - \eqn{C}: Chezy coefficient. Smooth channels = 1.2, Rough channels = 0.86
#'   - \eqn{v_c}: Critical velocity for stone motion (\eqn{ft/s})
#'   - \eqn{\gamma_s}: stone density (\eqn{lb/ft^3})
#'   - \eqn{\gamma_w}: water density (\eqn{lb/ft^3})
#'   - \eqn{SG}: Specific gravity = \eqn{\frac{\gamma_s - \gamma_w}{\gamma_w}}
#'   - \eqn{g}: Acceleration due to gravity, (\eqn{ft/sec})
#' 
#' U.S. Department of Agriculture, Natural Resources Conservation Service. (2007). 
#' *Stone Sizing Criteria*, 
#' [Technical Supplement 14 C](https://directives.nrcs.usda.gov//sites/default/files2/1720623369/Technical%20Supplement%2014%20C%20-%20Stone%20Sizing%20Criteria.pdf),
#' National Engineering Handbook 210 Part 654 Stream Restoration Design, p.7
#' 
#' @export
#' 
m_isbash <- function(unit_discharge,
                     slope,
                     normal_velocity,
                     stone_specific_weight,
                     h2o_specific_weight,
                     g = 9.81) {
  # Convert units from SI to Imperial
  
  
  # Specific gravity
  SG <- (stone_specific_weight - h2o_specific_weight) / h2o_specific_weight
  # This is an undefined coefficient
  chezy_coefficient <- 1.2
  # Calculate D50
  d50 <- (chezy_coefficient * normal_velocity)^2 / (2 * g * (SG - 1))
  return(d50)
}