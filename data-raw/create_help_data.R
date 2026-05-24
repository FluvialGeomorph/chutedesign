# Script: data-raw/create_help_data.R
# Purpose: build help_data (data.frame) for package data according to R-pkgs guidance
# This script constructs help_data with columns: id, title, summary, detail
# Text is stored using glue::glue so Markdown can be rendered in the app.
#
# After running this script in the package development environment, save the data
# with usethis::use_data(help_data, overwrite = TRUE) so help_data is available
# in the package's data/ directory.

library(tibble)
library(glue)

help_data <- tribble(
  ~id,
  ~title,
  ~summary,
  ~detail,

  # Inputs from create_scenario()
  "width",
  "Chute width (width)",
  glue(
    "Total chute width (m). Affects unit discharge (q = Q / width) and hydraulic depth."
  ),
  glue(
    "
**Definition**
- **Width (m)**: the total horizontal width of the chute used to compute unit discharge and geometry.

**Why it matters**
- Unit discharge q = total_discharge / width. Smaller width → larger q → larger velocities and shear, which typically increases recommended stone size.

**Guidance**
- Sweep width ±10–50% depending on layout uncertainty. Test discrete alternative widths if multiple layouts are possible.
"
  ),

  "width_series",
  "Width series (width_start, width_end, width_by)",
  glue("Start / end / step for width sweeps (m) used in scenario generation."),
  glue(
    "
Use these fields to build a sequence of widths to evaluate alternative layouts. Start with a coarse set (3–5 levels) then refine around sensitive ranges. Keep steps consistent with constructable increments (e.g., 0.25–0.5 m).
"
  ),

  "length",
  "Chute length (`length`)",
  glue(
    "Longitudinal length of the lined chute (m). Controls stone quantity scaling."
  ),
  glue(
    "
**Definition**
- **Length (m)**: longitudinal length of the chute reach used for volume and quantity calculations.

**Why it matters**
- Stone volume and total mass scale with length; longer reaches increase total ordering and placement work.

**Guidance**
- Use the construction length for the lined section. Sweep if comparing alternative reach extents.
"
  ),

  "length_series",
  "Length series (`length_start`, `length_end`, `length_by`)",
  glue(
    "Start / end / step for length sweeps (m). Useful for cost/quantity sensitivity."
  ),
  glue(
    "Define realistic length increments (e.g., 5–10 m) and use series runs to evaluate how total material needs change with reach length."
  ),

  "slope",
  "Chute slope (`slope`)",
  glue(
    "Channel bed slope (unitless, e.g. 0.03). Major control on velocity and stone sizing."
  ),
  glue(
    "
**Definition**
- Enter slope as a decimal (e.g. 0.03 = 3%).

**Why it matters**
- Higher slope increases velocities and shear stress, usually raising the empirically predicted stone size.

**Guidance**
- Sweep plausible site slopes (e.g. 0.01–0.10). Use finer steps near ranges where stone-size predictions change rapidly.
"
  ),

  "slope_series",
  "Slope series (`slope_start`, `slope_end`, `slope_by`)",
  glue(
    "Start / end / step for slope sweeps. Use closer spacing where sensitivity is high."
  ),
  glue(
    "Include both mild and steep slopes when a project may span different hydraulic regimes. If slope causes flow regime shift (subcritical ↔ supercritical), interpret results cautiously."
  ),

  "particle_size",
  "Reference particle size (`particle_size`)",
  glue("Reference particle size (m) used to estimate roughness (Manning's n)."),
  glue(
    "
**Definition**
- Reference particle size (m) used in the mannings_n estimate and to seed some empirical relations.

**Why it matters**
- particle_size affects mannings_n and therefore normal depth and velocity. Uncertainty here propagates to stone-size estimates.

**Guidance**
- Sweep or test typical substrate/stone gradation sizes when roughness is not well known.
"
  ),

  "particle_size_series",
  "Particle size series (`particle_size_start`, `particle_size_end`, `particle_size_by`)",
  glue(
    "Series to test alternative reference particle sizes or available stone gradations."
  ),
  glue(
    "Use series to evaluate sensitivity to roughness assumptions. Typical human-usable steps depend on the order-of-magnitude of particle sizes (e.g., 10s of mm)."
  ),

  "side_slope",
  "Side slope (`side_slope`)",
  glue(
    "Horizontal run per unit vertical rise (h:v). Controls bank geometry and lined area."
  ),
  glue(
    "
**Definition**
- side_slope is the horizontal to vertical ratio (e.g., 1 for 1H:1V). The code converts this to a side angle for geometry.

**Why it matters**
- It determines the sloped bank length and therefore the total area and volume of lining required.

**Guidance**
- Test flatter and steeper bank slopes if bank geometry is uncertain or if constructability constraints apply.
"
  ),

  "total_discharge",
  "Total discharge (`total_discharge`)",
  glue(
    "Design or analysis discharge (m^3/s). Primary hydraulic driver of q, depths, velocities."
  ),
  glue(
    "
**Definition**
- total_discharge (m^3/s): flow through the chute used to compute unit discharge q, depths, velocities, shear, and stream power.

**Why it matters**
- Most stone-size relations are sensitive to discharge; varying Q will usually produce the largest changes in predicted stone size.

**Guidance**
- Sweep design storm magnitudes, use probabilistic distributions for Monte Carlo analyses, or test multiple return periods.
"
  ),

  "stone_density",
  "Stone density (`stone_density`)",
  glue(
    "Bulk rock density (kg/m^3). Used to compute stone specific weight and mass."
  ),
  glue(
    "
**Definition**
- stone_density (kg/m^3) is used to compute stone_specific_weight = stone_density * gravity.

**Why it matters**
- Stone-specific weight and derived specific gravity affect stability relations and the conversion from diameter to mass.

**Guidance**
- Typical values ~2600–2700 kg/m^3. Test alternate densities for different lithologies (e.g., basalt, limestone).
"
  ),

  "contingency",
  "Contingency factor (`contingency`)",
  glue(
    "Multiplier on computed stone volumes to account for wastage, overlap, or ordering increments."
  ),
  glue(
    "
**Definition**
- contingency: multiplicative factor applied to stone volume before porosity adjustment to cover placement loss and procurement rounding.

**Why it matters**
- Directly scales stone_vol_m3 and final order quantities. Typical values: 1.05–1.25 depending on placement uncertainty.

**Guidance**
- Use higher contingency when placement is difficult or supply is variable.
"
  ),

  "porosity",
  "Placed-stone porosity (`porosity`)",
  glue(
    "Bulk-placed porosity fraction (unitless) used in the implemented stone-volume calculation."
  ),
  glue(
    "
**Definition**
- porosity is the fraction of void space in the placed stone matrix.

**Why it matters**
- In the app, stone volume is computed using a factor of `(1 - porosity)`.
- As currently implemented, increasing porosity decreases the computed rock volume.
- Because this convention may differ from some estimating workflows, users should verify that the assumed porosity treatment matches project practice.

**Guidance**
- Confirm that the porosity assumption and its use in the volume equation are appropriate for your estimating method.
- Document the assumption clearly when reporting total quantities.
"
  ),

  "water_density",
  "Water density (`water_density`)",
  glue(
    "Water density (kg/m^3) used in applied stream power and related computations."
  ),
  glue(
    "Use the standard value near 1000 kg/m^3 unless temperature/salinity justify adjustments."
  ),

  "specific_gravity",
  "Specific gravity (`specific_gravity`)",
  glue(
    "Relative density of stone compared with water; used in stability-oriented stone-sizing methods."
  ),
  glue(
    "
**Definition**
- Specific gravity is the ratio of stone specific weight to water specific weight:

$$
SG = \\frac{{\\gamma_s}}{{\\gamma_w}}
$$

where:
- `γ_s` is stone specific weight
- `γ_w` is water specific weight

**Why it matters**
- Relative density affects the resistance of stone to hydraulic forcing.
- In the current app, this concept is especially important in the Isbash method, which uses the contrast between stone and water density in the denominator of the sizing equation.

**Guidance**
- Verify consistent units when comparing material assumptions.
- If alternative lithologies are being considered, changes in specific gravity may affect both predicted stability and procurement characteristics.
"
  ),

  "gravity",
  "Gravity (`gravity`)",
  glue(
    "Acceleration due to gravity (m/s^2). Used in depth, velocity, and mass calculations."
  ),
  glue(
    "Use 9.81 m/s^2 for site-level design unless a different value is required for specific analyses."
  ),

  # Outputs & intermediate variables from channel_dimensions()
  "stone_specific_weight",
  "Stone specific weight (stone_specific_weight)",
  glue(
    "Stone unit weight computed from density and gravity (N/m^3)."
  ),
  glue(
    "
**Definition**
- Stone specific weight is computed as

$$
\\gamma_s = \\rho_s \\cdot g
$$

where:
- `ρ_s` is stone density
- `g` is gravitational acceleration

**Why it matters**
- This quantity is used in two important places in the app:
  - to compute relative density for the Isbash stone-sizing method
  - to compute adopted stone weight from adopted stone diameter

**Guidance**
- Keep stone density and gravity units consistent.
- If comparing alternate rock types, stone specific weight is one of the key parameters linking material properties to both hydraulic sizing and procurement calculations.
"
  ),

  "side_angle",
  "Side angle (side_angle)",
  glue(
    "Bank side angle in degrees, derived from the side-slope ratio and used in chute geometry calculations."
  ),
  glue(
    "
**Definition**
- Side angle is computed from side slope as

$$
\\theta = \\tan^{{-1}}\\left( \\frac{{1}}{{side\\\\_slope}} \\right)
$$

with the result expressed in degrees.

**Why it matters**
- Side angle is used to derive sloped-bank geometry, including bank length.
- That geometry contributes to the effective lined area and therefore affects total stone quantity.

**Guidance**
- Interpret side angle together with `side_slope` and `length_left_bank`.
- Flatter banks produce different lined geometry and can materially change total quantity estimates even when hydraulic conditions are unchanged.
"
  ),

  "mannings_n",
  "Manning's n (`mannings_n`)",
  glue(
    "Estimated roughness coefficient used to compute normal depth and velocity."
  ),
  glue(
    "
**Definition**
- In the app, Manning's `n` is estimated as

$$
n = 0.034 \\cdot (particle\\\\_size \\cdot ft\\\\_per\\\\_m)^{{1/6}}
$$

where:
- `particle_size` is the reference particle size in meters
- `ft_per_m` converts meters to feet

**Why it matters**
- Roughness affects normal depth and normal velocity. Uncertainty in `n` propagates through hydraulic calculations and stone-size predictions.

**Guidance**
- Test alternative roughness assumptions when substrate size or field roughness is uncertain.
"
  ),

  "critical_depth",
  "Critical depth (`critical_depth`)",
  glue(
    "Depth at which specific energy is minimized for the current unit discharge."
  ),
  glue(
    "
**Definition**
- Critical depth is

$$
y_c = \\left( \\frac{{q^2}}{{g}} \\right)^{{1/3}}
$$

where:
- `q` is unit discharge
- `g` is gravitational acceleration

**Why it matters**
- Critical depth helps identify the transition between subcritical and supercritical flow.
- Comparing critical depth to normal depth helps interpret hydraulic regime and the stability context for stone sizing.

**Guidance**
- Review critical depth alongside normal depth and Froude number when diagnosing whether the chute is operating near a regime threshold.
"
  ),

  "normal_depth",
  "Normal depth (`normal_depth`)",
  glue(
    "Depth computed from Manning's equation for the current discharge, roughness, and slope."
  ),
  glue(
    "
**Definition**
- Normal depth is computed as

$$
y_n = \\left( \\frac{{q \\cdot n}}{{\\sqrt{{S}}}} \\right)^{{3/5}}
$$

where:
- `q` is unit discharge
- `n` is Manning's roughness
- `S` is slope

**Why it matters**
- Normal depth sets hydraulic radius and, together with velocity, determines shear stress and stream power — key inputs to stone-size formulas.

**Guidance**
- Compare normal depth to critical depth to assess regime behavior across scenarios.
"
  ),

  "unit_discharge",
  "Unit discharge (unit_discharge)",
  glue(
    "Unit discharge describes how total discharge is distributed across chute width (m^2/s)."
  ),
  glue(
    "
**Definition**
- Unit discharge is

$$
q = \\frac{{Q}}{{B}}
$$

where:
- `Q` is total discharge
- `B` is chute width

**Why it matters**
- Most empirical stone-size formulae used in the app are sensitive to unit discharge.
- Changing width or total discharge changes `q` directly and therefore influences downstream hydraulic conditions and stone-size predictions.

**Guidance**
- Inspect unit discharge across sensitivity sweeps and use it as a primary explanatory variable when interpreting changes in depth, velocity, and adopted stone size.
"
  ),

  "normal_velocity",
  "Normal velocity (`normal_velocity`)",
  glue(
    "Velocity computed from unit discharge and normal depth (m/s)."
  ),
  glue(
    "
**Definition**
- Normal velocity is

$$
V_n = \\frac{{q}}{{y_n}}
$$

where:
- `q` is unit discharge
- `y_n` is normal depth

**Why it matters**
- Velocity is a direct driver of shear stress and several empirical stone-size relations.
- Higher velocities generally yield larger predicted stone sizes.

**Guidance**
- Track how normal velocity changes across sweeps and compare it to critical velocity when assessing hydraulic sensitivity.
"
  ),

  "critical_velocity",
  "Critical velocity (`critical_velocity`)",
  glue(
    "Velocity corresponding to critical depth for the current unit discharge (m/s)."
  ),
  glue(
    "
**Definition**
- Critical velocity is

$$
V_c = \\frac{{q}}{{y_c}}
$$

where:
- `q` is unit discharge
- `y_c` is critical depth

**Why it matters**
- Comparing critical velocity to normal velocity helps interpret how close the chute flow is to critical-flow conditions.
- Near-critical conditions can indicate hydraulic sensitivity, especially where small design changes may shift regime behavior.

**Guidance**
- Review critical velocity alongside normal velocity and Froude number when diagnosing whether the chute is approaching a flow transition.
"
  ),

  "critical_slope",
  "Critical slope (`critical_slope`)",
  glue(
    "Slope associated with critical-flow conditions for the current discharge, roughness, and critical depth."
  ),
  glue(
    "
**Definition**
- Critical slope is computed as

$$
S_c = \\left( \\frac{{V_c \\cdot n}}{{y_c^{{2/3}}}} \\right)^2
$$

where:
- `V_c` is critical velocity
- `n` is Manning's roughness
- `y_c` is critical depth

**Why it matters**
- Comparing design slope to critical slope helps assess whether the chute tends toward mild, steep, or near-critical hydraulic behavior.
- This comparison can help explain changes in normal depth, velocity, and regime-sensitive stability metrics.

**Guidance**
- Compare the design slope to critical slope when interpreting sensitivity results.
- If design slope is near critical slope, use caution when comparing scenarios because small changes may alter hydraulic behavior.
"
  ),

  "froude",
  "Froude number (`froude`)",
  glue(
    "Dimensionless indicator of flow regime."
  ),
  glue(
    "
**Definition**
- Froude number is

$$
Fr = \\frac{{V}}{{\\sqrt{{g \\cdot y}}}}
$$

where:
- `V` is flow velocity
- `g` is gravitational acceleration
- `y` is flow depth

**Why it matters**
- Froude number indicates whether flow is subcritical or supercritical.
- Values near 1 suggest regime transition and may signal sensitivity in hydraulic behavior.

**Guidance**
- Interpret approximately as:
  - `Fr < 1`: subcritical
  - `Fr > 1`: supercritical
- Watch for threshold crossings across sensitivity sweeps.
"
  ),

  "shear_stress",
  "Shear stress (`shear_stress`)",
  glue(
    "Hydraulic forcing metric computed in the app from water specific weight, normal velocity, and slope (N/m^2)."
  ),
  glue(
    "
**Definition**
- In the app, shear stress is computed as

$$
\\tau = \\gamma_w \\cdot V_n \\cdot S
$$

where:
- `γ_w` is water specific weight
- `V_n` is normal velocity
- `S` is slope

**Why it matters**
- This quantity is used in the app as a hydraulic forcing metric and contributes to the applied stream power calculation.
- Larger values generally correspond to more energetic flow conditions and larger predicted stone sizes.

**Guidance**
- Interpret this quantity in the context of the app's implemented formula.
- Compare trends across scenarios rather than assuming direct equivalence with other shear-stress formulations from hydraulic design references.
"
  ),

  "avail_stream_power",
  "Available stream power (`avail_stream_power`)",
  glue(
    "Specific stream power used as an energy-based hydraulic metric (kW/m)."
  ),
  glue(
    "
**Definition**
- Available stream power is computed as

$$
\\omega = \\frac{{\\gamma_w \\cdot q \\cdot S}}{{1000}}
$$

where:
- `γ_w` is water specific weight
- `q` is unit discharge
- `S` is slope

**Why it matters**
- Stream power is a compact energy-based measure of the capacity of flow to do geomorphic work and mobilize material.

**Guidance**
- Use available stream power to compare energy conditions across scenarios and to contextualize differences among stone-size methods.
"
  ),

  "applied_stream_power",
  "Applied stream power (`applied_stream_power`)",
  glue(
    "Alternative stream power metric representing bed-applied energy (kW/m)."
  ),
  glue(
    "
**Definition**
- In the app, applied stream power is computed as

$$
\\omega_a = \\frac{{7.853 \\cdot wd \\cdot (\\tau / wd)^{{3/2}}}}{{1000}}
$$

where:
- `wd` is water density
- `τ` is shear stress

**Why it matters**
- Applied stream power provides an alternate representation of hydraulic energy acting on the bed and can help explain differences between methods or scenarios.

**Guidance**
- Compare applied stream power with available stream power when diagnosing changes in hydraulic forcing across the sweep.
"
  ),

  "stone_size_methods",
  "Empirical stone-size methods",
  glue(
    "The app computes candidate stone diameters for several empirical methods and stores them in long format."
  ),
  glue(
    "
**What this object represents**
- The app evaluates five empirical methods:
  - `nrcs`
  - `usace`
  - `abt_johnson`
  - `isbash`
  - `usbr`

**Current data structure**
- Method results are stored in the `compute_stone_metrics()` output as one row per scenario point per method.
- Key columns include:
  - `method`
  - `stone_diameter`
  - `stone_weight_kg`
  - `mattress_thickness`
  - `stone_vol_m3`

**Why it matters**
- Different empirical relations use different combinations of unit discharge, velocity, slope, and relative density, so they can produce a wide range of recommended sizes.

**Guidance**
- Compare methods to understand epistemic uncertainty.
- Use method spread to support risk-based design and to justify the selected adopted stone size.
"
  ),

  "adopted_stone_diameter",
  "Adopted stone diameter (`adopted_stone_diameter`)",
  glue(
    "Final adopted stone diameter (m), taken from the selected empirical method."
  ),
  glue(
    "
**Definition**
- In the current app pipeline, adopted stone diameter is the `stone_diameter` associated with the chosen method in `compute_adopted_stone()`.
- The default adopted method is `nrcs`.

**Why it matters**
- Adopted stone diameter drives mattress thickness, stone mass, and total quantity estimates.
- Because downstream quantities are derived from this value, it is one of the most important design outputs in the app.

**Guidance**
- Confirm which method is being adopted when interpreting results.
- If a different adoption rule is desired (for example, a conservative percentile or multiplier), that should be implemented explicitly rather than assumed in the help text.
"
  ),

  "adopted_stone_weight",
  "Adopted stone weight (`adopted_stone_weight`)",
  glue(
    "Mass of the adopted stone computed from adopted diameter and stone unit weight."
  ),
  glue(
    "
**Definition**
- In the app, adopted stone weight in kilograms is computed as

$$
W_{{kg}} = \\frac{{d^3 \\cdot \\pi \\cdot \\gamma_s}}{{6 \\cdot g}}
$$

where:
- `d` is adopted stone diameter
- `γ_s` is stone specific weight
- `g` is gravitational acceleration

- The app also reports converted values in pounds and US tons.

**Why it matters**
- Stone weight connects hydraulic sizing results to procurement, handling, and constructability.
- Large changes in adopted diameter can lead to large changes in per-stone weight.

**Guidance**
- Compare the reported adopted stone weights to supplier gradations and handling limits before finalizing design.
"
  ),

  "stone_vol_m3",
  "Stone volume (`stone_vol_m3`)",
  glue(
    "Computed placed rock volume after applying geometry, contingency, and porosity adjustments (m^3)."
  ),
  glue(
    "
**Definition**
- Stone volume is computed as

$$
V_{{stone}} = contingency \\cdot mattress\\\\_thickness \\cdot (length\\\\_left\\\\_bank + width) \\cdot length \\cdot (1 - porosity)
$$

where:
- `contingency` is the volume adjustment factor
- `mattress_thickness` is the adopted placed thickness
- `length_left_bank + width` represents effective lined width
- `length` is chute length
- `porosity` accounts for void space in placed stone

**Why it matters**
- This is the final ordering and estimating volume. It is sensitive to geometry, adopted stone size, contingency, and porosity.

**Guidance**
- When running sensitivity analyses, compare stone volume alongside the contributing variables so the source of variation is clear.
"
  ),
    
  "mattress_thickness",
  "Mattress thickness (`mattress_thickness`)",
  glue(
    "Placed stone layer thickness derived from adopted stone diameter."
  ),
  glue(
    "
**Definition**
- In the app, mattress thickness is computed as

$$
t = 2d
$$

where:
- `d` is adopted stone diameter

**Why it matters**
- Mattress thickness directly affects the stone volume calculation and therefore total procurement quantities.

**Guidance**
- Review mattress thickness together with adopted stone diameter and stone volume when comparing alternatives.
- If a different thickness rule is desired, it should be implemented explicitly in the adopted-stone calculation.
"
  ),

  "number_stones",
  "Number of stones (`number_stones`)",
  glue(
    "Estimated count of adopted stones required based on total US tonnage and per-stone US-ton weight."
  ),
  glue(
    "
**Definition**
- In the app, number of stones is computed as

$$
N = \\frac{{stone\\\\_vol\\\\_us\\\\_ton}}{{adopted\\\\_stone\\\\_weight\\\\_us\\\\_ton}}
$$

where:
- `stone_vol_us_ton` is the total required stone quantity in US tons
- `adopted_stone_weight_us_ton` is the per-stone weight in US tons

**Why it matters**
- Stone count is useful for constructability, logistics, and installation planning.
- It provides a more intuitive sense of procurement scale than volume alone.

**Guidance**
- Use this value for planning-level comparisons and logistics discussions.
- Review it together with `stone_vol_us_ton` and `adopted_stone_weight_us_ton` when assessing constructability.
"
  ),

  "stone_vol_us_ton",
  "Stone quantity (stone_vol_us_ton)",
  glue(
    "Total required stone quantity expressed in US tons."
  ),
  glue(
    "
**Definition**
- In the app, total stone quantity in US tons is derived from stone volume and stone density through the implemented conversion sequence.

**Why it matters**
- This is often one of the most decision-relevant outputs for estimating, supplier communication, and contracting.

**Guidance**
- Use this quantity when comparing alternatives for procurement and budgeting.
- Review together with `adopted_stone_weight_us_ton` and `number_stones` for a fuller picture of supply and handling implications.
"
  ),

  "stone_vol_metric_ton",
  "Stone quantity (stone_vol_metric_ton)",
  glue(
    "Total required stone quantity expressed in metric tons."
  ),
  glue(
    "
**Definition**
- In the app, metric tonnage is computed from stone volume and stone density.

**Why it matters**
- Metric tonnage is a convenient intermediate quantity linking placed volume to supplier-scale mass estimates.

**Guidance**
- Use this quantity when working with SI-based estimating workflows or when checking the app's conversion chain across units.
"
  ),

  "stone_vol_cuyd",
  "Stone quantity (stone_vol_cuyd)",
  glue(
    "Total required stone quantity expressed in cubic yards."
  ),
  glue(
    "
**Definition**
- In the app, cubic-yard quantity is derived from computed stone volume in cubic meters using a fixed conversion factor.

**Why it matters**
- Cubic yards are often used in estimating, bid documents, and construction communication in US practice.

**Guidance**
- Use cubic yards when aligning app outputs with contractor-facing quantity formats or legacy estimate templates.
"
  ),

  "adopted_stone_weight_us_ton",
  "Adopted stone weight (adopted_stone_weight_us_ton)",
  glue(
    "Per-stone adopted weight expressed in US tons."
  ),
  glue(
    "
**Definition**
- In the app, adopted stone weight in US tons is derived from the kilogram weight of the adopted stone through the implemented unit conversions.

**Why it matters**
- This is a practical unit for matching stone size recommendations to supplier gradations, lifting limits, and placement equipment.

**Guidance**
- Review this value together with `stone_vol_us_ton` and `number_stones` when assessing procurement and constructability.
"
  ),

  # App tab documentation
  "getting_started",
  "Intro Tab - app overview",
  glue("Overview of the app, workflow, and key assumptions."),
  glue(
    "# Getting Started

    ## Purpose
    This app helps estimate the stone sizes required for chutes of various dimensions.

    ## Define the Scenario

    1. In the left sidebar, specify the design characteristics of the chute.
    2. Click the `Calculate Dimensions` button.
    
    ## Review the Results
    
    Scenario results can be explored using the tabs across the top of the app.
    
    * by Width - View results of the scenario where chute widths are varied.
    * by Length - View results of the scenario where chute lengths are varied.
    * by Slope - View results of the scenario where chute slopes are varied.
    * by Particle Size - View results of the scenario where chute particle sizes are varied.
    "
  ),

  "tab_intro",
  "Intro tab — how to use and interpret the app",
  glue(
    "Guidance for using the app workflow, interpreting results, and understanding the scope of the tool."
  ),
  glue(
    "
**Recommended workflow**
1. Enter a plausible base scenario in the left sidebar.
2. Define a reasonable sweep for one variable at a time:
   - width
   - length
   - slope
   - particle size
3. Click `Calculate Dimensions`.
4. Review outputs tab-by-tab:
   - use the hydraulic plot to understand what is driving change,
   - use the method plot to compare empirical stone-sizing equations,
   - use the quantities plot and table to assess procurement and constructability impacts.
5. Compare alternatives and identify ranges where outputs are especially sensitive to small input changes.

**How to interpret results**
- The app is most useful for **screening**, **sensitivity analysis**, and **preliminary design comparison**.
- Do not focus only on the final adopted stone size. Also examine:
  - hydraulic response (`normal_depth`, `normal_velocity`, `froude`)
  - method spread across empirical stone-size equations
  - downstream effects on thickness, per-stone weight, and total quantity
- Large jumps in recommended size or quantity often indicate a threshold in the hydraulics or in the adopted-stone calculation.

**What each results tab helps answer**
- **by Width**: How do layout width choices affect hydraulics and stone size?
- **by Length**: How do protection extents affect total quantity and procurement?
- **by Slope**: How sensitive is the design to grade and flow energy?
- **by Particle Size**: How much do roughness assumptions influence the design?

**Important assumptions and limitations**
- Inputs and outputs use SI-based engineering quantities unless otherwise labeled.
- Hydraulic calculations are simplified and based on the formulas implemented in the package.
- Stone-size recommendations are empirical and should be treated as design support tools, not as a substitute for engineering judgment.
- If results suggest near-critical flow, strong method divergence, or impractically large stones, additional hydraulic analysis may be warranted.

**Practical tips**
- Start with broad sweeps, then narrow the range around sensitive values.
- Export tables when comparing alternatives for design review or estimating.
- Record which empirical method is being adopted and why.
- When presenting results, pair the selected design point with the surrounding sensitivity context rather than reporting a single stone size in isolation.
"
  ),

  "tab_by_width",
  "By Width tab — sensitivity to chute width",
  glue(
    "Use this tab to compare how alternative chute widths affect hydraulics, adopted stone size, and total quantity."
  ),
  glue(
    "
**What this tab helps answer**
- How sensitive is the design to chute width?
- Do narrower or wider layouts materially change hydraulic conditions or procurement needs?

**What to focus on**
- `unit_discharge`: width directly changes how discharge is distributed.
- hydraulic response: especially depth, velocity, and Froude behavior.
- adopted stone size: whether width changes drive larger recommended stones.
- total quantity: whether changing width materially affects total volume or tonnage.

**What patterns matter**
- Narrower widths usually increase unit discharge and hydraulic forcing.
- Sharp jumps in adopted size or quantity may indicate a sensitive design range worth studying more closely.

**How to use this tab**
- Use broad width sweeps first to locate sensitive ranges.
- Then refine the sweep where outputs change quickly or where layout tradeoffs matter most.
"
  ),

  "tab_by_length",
  "By Length tab — sensitivity to chute length",
  glue(
    "Use this tab to compare how alternative protection lengths affect total quantity, procurement, and construction scale."
  ),
  glue(
    "
**What this tab helps answer**
- How much do material quantities change if the lined reach is shorter or longer?
- What are the procurement implications of alternative chute lengths?

**What to focus on**
- total quantity outputs such as volume, tons, and stone count
- whether adopted size and hydraulic outputs remain stable under a pure length sweep

**What patterns matter**
- For fixed width, slope, discharge, and roughness, hydraulic behavior and adopted stone size should remain essentially unchanged.
- Total quantity should scale approximately with length.

**How to use this tab**
- Use this tab when comparing alternative protection extents or estimate scenarios.
- If adopted size changes in a length-only sweep, treat that as a signal to inspect inputs or upstream calculations.
"
  ),

  "tab_by_slope",
  "By Slope tab — sensitivity to chute slope",
  glue(
    "Use this tab to evaluate how changes in chute slope affect flow energy, hydraulic forcing, and adopted stone size."
  ),
  glue(
    "
**What this tab helps answer**
- How sensitive is the design to slope?
- At what slopes do hydraulic conditions or stone requirements become difficult or impractical?

**What to focus on**
- velocity, shear, and stream-power trends
- regime-sensitive behavior such as Froude and depth relationships
- adopted stone size and downstream quantity impacts

**What patterns matter**
- Increasing slope typically increases hydraulic forcing and recommended stone size.
- Nonlinear increases may indicate ranges where design feasibility changes quickly.

**How to use this tab**
- Use this tab to assess whether a proposed grade is compatible with available rock size, handling limits, and constructability.
- Pay special attention to steep ranges where small slope changes produce large design consequences.
"
  ),

  "tab_by_particle_size",
  "By Particle Size tab — sensitivity to reference particle size and roughness",
  glue(
    "Use this tab to evaluate how roughness assumptions affect hydraulics, stone sizing, and quantity outcomes."
  ),
  glue(
    "
**What this tab helps answer**
- How sensitive are results to the assumed reference particle size used in the roughness estimate?
- Is roughness uncertainty materially affecting the design?

**What to focus on**
- Manning's `n`
- changes in depth and velocity
- adopted stone size and total quantity response

**What patterns matter**
- Larger reference particle size generally increases estimated roughness.
- Roughness changes can alter hydraulic response enough to affect downstream stone-sizing decisions.

**How to use this tab**
- Use this tab to judge whether additional field roughness characterization would meaningfully improve design confidence.
- If results are insensitive to particle-size assumptions, effort may be better spent refining other inputs.
"
  ),

  # Plots
  "plot_stone_size_method_plot",
  "Stone size methods plot",
  glue(
    "Comparison plot showing how empirical stone-size methods differ across the selected sensitivity axis."
  ),
  glue(
    "
**What this plot is for**
- This plot shows how the different empirical sizing methods respond to the same scenario sweep.
- It is most useful for understanding method spread and uncertainty.

**How to read it**
- Compare the lines at each x-value to see where methods agree closely and where they diverge.
- Larger spread indicates greater sensitivity to method choice.

**What to look for**
- ranges where one or more methods separate strongly from the others
- whether method spread remains narrow or grows as conditions become more severe

**How to use it**
- Use this plot to support method selection, conservative design choices, and communication of uncertainty.
- The detailed entries in this popover explain the method family at a higher level.
"
  ),

  "plot_channel_flow_plot",
  "Hydraulic parameters faceted plot",
  glue(
    "Overview plot showing how key hydraulic variables change across the selected sensitivity axis."
  ),
  glue(
    "
**What this plot is for**
- This plot helps explain *why* stone-size or quantity outputs are changing.
- It provides the hydraulic context behind the empirical sizing results.

**How to read it**
- Scan across panels to see which variables shift most strongly as the input changes.
- Use the pattern across depth, velocity, Froude behavior, shear, and stream power to diagnose the controlling hydraulic response.

**What to look for**
- regime-sensitive behavior
- rapid increases in hydraulic forcing
- ranges where small input changes produce large hydraulic changes

**How to use it**
- Use this plot together with the stone-size methods plot and the quantities plot.
- The detailed entries in this popover explain each hydraulic variable individually.
"
  ),

  "plot_stone_quantities_plot",
  "Stone quantities & mass plot",
  glue(
    "Procurement-oriented plot showing how adopted stone size translates into thickness, per-stone weight, total quantity, and stone count."
  ),
  glue(
    "
**What this plot is for**
- This plot translates hydraulic/design outputs into practical material and construction metrics.
- It helps connect adopted stone size to procurement and constructability.

**How to read it**
- Review how per-stone weight, total quantity, and stone count change across the sensitivity sweep.
- Compare these trends to understand whether a design change mainly affects handling, total quantity, or both.

**What to look for**
- sharp increases in per-stone weight
- rapid growth in total US tons or stone count
- ranges where procurement or constructability may become difficult

**How to use it**
- Use this plot when comparing alternatives for estimating, supplier discussions, and construction planning.
- The detailed entries in this popover explain the individual quantity variables.
"
  ),

  # Channel-dimensions for scenario sweeps
  "scenario_by_width_channel_dims",
  "Channel dimensions — by-width scenario outputs",
  glue(
    "Output dataframe produced when sweeping `width` through the current app pipeline."
  ),
  glue(
    "
**What this object is**
- The output dataframe produced by passing the by-width scenario through:
  - `compute_channel_dimensions()`
  - `compute_stone_metrics()`
  - `compute_adopted_stone()`

- Each row corresponds to a width value in the sweep and contains hydraulic outputs plus adopted-stone and quantity results.

**Key columns to inspect**
- `width`, `unit_discharge`, `normal_depth`, `normal_velocity`, `froude`
- `shear_stress`, `avail_stream_power`, `applied_stream_power`
- `adopted_stone_diameter`, `adopted_stone_weight_kg`, `mattress_thickness`
- `stone_vol_m3`, `stone_vol_us_ton`, `number_stones`

**How to interpret across the sweep**
- Trace how width changes unit discharge and downstream hydraulic conditions.
- Then inspect how those changes affect adopted stone size and total quantity estimates.

**Checks**
- Verify unit consistency.
- Check for regime changes using `froude`, `critical_depth`, and `normal_depth`.

**Reporting**
- Use this table with the method plot and hydraulic plot to support layout comparison and procurement estimates.
"
  ),

  "scenario_by_length_channel_dims",
  "Channel dimensions — by-length scenario outputs",
  glue(
    "Channel-dimensions dataframe produced when sweeping `length` (from by_length_df -> compute_channel_dimensions -> compute_adopted_stone). Contains hydraulics, adopted stone metrics, and quantity estimates for each length value."
  ),
  glue(
    "
**What this object is**
- The output dataframe produced by passing the by_length_df scenario through the current app pipeline: `compute_channel_dimensions()`, `compute_stone_metrics()`, and `compute_adopted_stone()`.
- Each row corresponds to a length value in the sweep and contains hydraulic outputs, adopted stone dimensions, and total quantity estimates.

**Key columns to inspect**
- `length`, `unit_discharge`, `normal_depth`, `normal_velocity`, `froude`
- `adopted_stone_diameter`, `adopted_stone_weight_kg`, `mattress_thickness`
- `stone_vol_m3`, `stone_vol_cuyd`, `stone_vol_metric_ton`, `stone_vol_us_ton`, `number_stones`

**How to interpret across the sweep**
- Length primarily affects total quantities, not hydraulics. For a fixed width, slope, discharge, and roughness, hydraulic outputs and adopted stone size should remain essentially constant across the sweep.
- `stone_vol_m3`, `stone_vol_us_ton`, and `number_stones` should increase approximately linearly with length.

**Checks**
- Confirm that hydraulic variables (`unit_discharge`, `normal_velocity`, `froude`) are stable across the length sweep.
- If adopted stone diameter changes across length alone, inspect upstream assumptions or calculations because this would generally be unexpected.
- Verify unit consistency (m, m^3/s, kg/m^3).

**Reporting**
- Use the by-length outputs to compare material requirements and procurement implications for alternative protection extents.
- Export the table for estimating, bid support, and documenting the selected design length.
"
  ),

  "scenario_by_slope_channel_dims",
  "Channel dimensions — by-slope scenario outputs",
  glue(
    "Output dataframe produced when sweeping `slope` through the current app pipeline."
  ),
  glue(
    "
**What this object is**
- The output dataframe produced by passing the by-slope scenario through:
  - `compute_channel_dimensions()`
  - `compute_stone_metrics()`
  - `compute_adopted_stone()`

- Each row corresponds to a slope value in the sweep and contains hydraulic outputs plus adopted-stone and quantity results.

**Key columns to inspect**
- `slope`, `normal_velocity`, `shear_stress`, `avail_stream_power`, `applied_stream_power`
- `critical_depth`, `normal_depth`, `froude`
- `adopted_stone_diameter`, `adopted_stone_weight_kg`, `mattress_thickness`
- `stone_vol_m3`, `stone_vol_us_ton`, `number_stones`

**How to interpret across the sweep**
- Slope strongly affects hydraulic forcing, so stone-size and quantity outputs may change rapidly.
- Examine where increases in slope drive disproportionate jumps in adopted size or total quantity.

**Checks**
- Watch for regime-sensitive conditions using `critical_depth`, `normal_depth`, and `froude`.
- Confirm that adopted stone size and weight remain practically constructible.

**Reporting**
- Use slope-sweep results to compare feasibility and constructability across alternative chute grades.
"
  ),

  "scenario_by_particle_size_channel_dims",
  "Channel dimensions — by-particle_size scenario outputs",
  glue(
    "Output dataframe produced when sweeping `particle_size` through the current app pipeline."
  ),
  glue(
    "
**What this object is**
- The output dataframe produced by passing the by-particle-size scenario through:
  - `compute_channel_dimensions()`
  - `compute_stone_metrics()`
  - `compute_adopted_stone()`

- Each row corresponds to a `particle_size` value used to estimate Manning's roughness, along with resulting hydraulic and adopted-stone outputs.

**Key columns to inspect**
- `particle_size`, `mannings_n`, `normal_depth`, `normal_velocity`, `froude`
- `shear_stress`, `avail_stream_power`, `applied_stream_power`
- `adopted_stone_diameter`, `adopted_stone_weight_kg`, `mattress_thickness`
- `stone_vol_m3`, `stone_vol_us_ton`, `number_stones`

**How to interpret across the sweep**
- Changes in `particle_size` affect Manning's `n`, which then affects depth, velocity, and downstream stone-sizing behavior.
- Use this sweep to assess sensitivity to roughness assumptions.

**Checks**
- Confirm that trends in `mannings_n`, `normal_depth`, and `normal_velocity` are hydraulically reasonable.
- Watch for regime changes using `froude`.

**Reporting**
- Present these results when roughness uncertainty is an important design consideration.
"
  )
)

# Save data to package
usethis::use_data(help_data, internal = FALSE, overwrite = TRUE)
# Ensure the data is available at runtime
devtools::install()
