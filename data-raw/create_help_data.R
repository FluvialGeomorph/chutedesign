# Script: data-raw/create_help_data.R
# Purpose: build help_data (data.frame) for package data according to R-pkgs guidance
# This script constructs help_data with columns: id, title, popover, sidebar, placement
# Text is stored using glue::glue so Markdown can be rendered in the app.
#
# After running this script in the package development environment, save the data
# with usethis::use_data(help_data, overwrite = TRUE) so help_data is available
# in the package's data/ directory.

library(tibble)
library(glue)

help_data <- tribble(
  ~id, ~title, ~popover, ~sidebar, ~placement,

  # Inputs from create_scenario()
  "width", "Chute width (width)",
  glue("Total chute width (m). Affects unit discharge (q = Q / width) and hydraulic depth."),
  glue("
**Definition**
- **Width (m)**: the total horizontal width of the chute used to compute unit discharge and geometry.

**Why it matters**
- Unit discharge q = total_discharge / width. Smaller width → larger q → larger velocities and shear, which typically increases recommended stone size.

**Guidance**
- Sweep width ±10–50% depending on layout uncertainty. Test discrete alternative widths if multiple layouts are possible.
"), 
  "right",

  "width_series", "Width series (width_start, width_end, width_by)",
  glue("Start / end / step for width sweeps (m) used in scenario generation."),
  glue("
Use these fields to build a sequence of widths to evaluate alternative layouts. Start with a coarse set (3–5 levels) then refine around sensitive ranges. Keep steps consistent with constructable increments (e.g., 0.25–0.5 m).
"),
  "right",

  "length", "Chute length (length)",
  glue("Longitudinal length of the lined chute (m). Controls stone quantity scaling."),
  glue("
**Definition**
- **Length (m)**: longitudinal length of the chute reach used for volume and quantity calculations.

**Why it matters**
- Stone volume and total mass scale with length; longer reaches increase total ordering and placement work.

**Guidance**
- Use the construction length for the lined section. Sweep if comparing alternative reach extents.
"),
  "right",

  "length_series", "Length series (length_start, length_end, length_by)",
  glue("Start / end / step for length sweeps (m). Useful for cost/quantity sensitivity."),
  glue("Define realistic length increments (e.g., 5–10 m) and use series runs to evaluate how total material needs change with reach length."),
  "right",

  "slope", "Chute slope (slope)",
  glue("Channel bed slope (unitless, e.g. 0.03). Major control on velocity and stone sizing."),
  glue("
**Definition**
- Enter slope as a decimal (e.g. 0.03 = 3%).

**Why it matters**
- Higher slope increases velocities and shear stress, usually raising the empirically predicted stone size.

**Guidance**
- Sweep plausible site slopes (e.g. 0.01–0.10). Use finer steps near ranges where stone-size predictions change rapidly.
"),
  "right",

  "slope_series", "Slope series (slope_start, slope_end, slope_by)",
  glue("Start / end / step for slope sweeps. Use closer spacing where sensitivity is high."),
  glue("Include both mild and steep slopes when a project may span different hydraulic regimes. If slope causes flow regime shift (subcritical ↔ supercritical), interpret results cautiously."),
  "right",

  "particle_size", "Reference particle size (particle_size)",
  glue("Reference particle size (m) used to estimate roughness (Manning's n)."),
  glue("
**Definition**
- Reference particle size (m) used in the mannings_n estimate and to seed some empirical relations.

**Why it matters**
- particle_size affects mannings_n and therefore normal depth and velocity. Uncertainty here propagates to stone-size estimates.

**Guidance**
- Sweep or test typical substrate/stone gradation sizes when roughness is not well known.
"),
  "right",

  "particle_size_series", "Particle size series (particle_size_start, particle_size_end, particle_size_by)",
  glue("Series to test alternative reference particle sizes or available stone gradations."),
  glue("Use series to evaluate sensitivity to roughness assumptions. Typical human-usable steps depend on the order-of-magnitude of particle sizes (e.g., 10s of mm)."),
  "right",

  "side_slope", "Side slope (side_slope)",
  glue("Horizontal run per unit vertical rise (h:v). Controls bank geometry and lined area."),
  glue("
**Definition**
- side_slope is the horizontal to vertical ratio (e.g., 1 for 1H:1V). The code converts this to a side angle for geometry.

**Why it matters**
- It determines the sloped bank length and therefore the total area and volume of lining required.

**Guidance**
- Test flatter and steeper bank slopes if bank geometry is uncertain or if constructability constraints apply.
"),
  "right",

  "total_discharge", "Total discharge (total_discharge)",
  glue("Design or analysis discharge (m^3/s). Primary hydraulic driver of q, depths, velocities."),
  glue("
**Definition**
- total_discharge (m^3/s): flow through the chute used to compute unit discharge q, depths, velocities, shear, and stream power.

**Why it matters**
- Most stone-size relations are sensitive to discharge; varying Q will usually produce the largest changes in predicted stone size.

**Guidance**
- Sweep design storm magnitudes, use probabilistic distributions for Monte Carlo analyses, or test multiple return periods.
"),
  "right",

  "stone_density", "Stone density (stone_density)",
  glue("Bulk rock density (kg/m^3). Used to compute stone specific weight and mass."),
  glue("
**Definition**
- stone_density (kg/m^3) is used to compute stone_specific_weight = stone_density * gravity.

**Why it matters**
- Stone-specific weight and derived specific gravity affect stability relations and the conversion from diameter to mass.

**Guidance**
- Typical values ~2600–2700 kg/m^3. Test alternate densities for different lithologies (e.g., basalt, limestone).
"),
  "right",

  "contingency", "Contingency factor (contingency)",
  glue("Multiplier on computed stone volumes to account for wastage, overlap, or ordering increments."),
  glue("
**Definition**
- contingency: multiplicative factor applied to stone volume before porosity adjustment to cover placement loss and procurement rounding.

**Why it matters**
- Directly scales stone_vol_m3 and final order quantities. Typical values: 1.05–1.25 depending on placement uncertainty.

**Guidance**
- Use higher contingency when placement is difficult or supply is variable.
"),
  "right",

  "porosity", "Placed-stone porosity (porosity)",
  glue("Bulk-placed porosity fraction (unitless) used to convert placed volume to rock volume."),
  glue("
**Definition**
- porosity: fraction of voids in the placed mattress (typical 0.35–0.45 for riprap).

**Why it matters**
- stone_vol_m3 = contingency * mattress_volume * (1 - porosity). Higher porosity → more rock required.

**Guidance**
- Adjust based on placement method and compaction; document assumptions.
"),
  "right",

  "water_density", "Water density (water_density)",
  glue("Water density (kg/m^3) used in applied stream power and related computations."),
  glue("Use the standard value near 1000 kg/m^3 unless temperature/salinity justify adjustments."),
  "right",

  "gravity", "Gravity (gravity)",
  glue("Acceleration due to gravity (m/s^2). Used in depth, velocity, and mass calculations."),
  glue("Use 9.81 m/s^2 for site-level design unless a different value is required for specific analyses."),
  "right",


  # Outputs & intermediate variables from channel_dimensions()
  "stone_specific_weight", "Stone specific weight",
  glue("stone_specific_weight = stone_density * gravity (N/m^3). Converts density to unit weight."),
  glue("Used to compute specific_gravity and in mass and stability formulas. Keep units consistent across inputs."),
  "right",

  "specific_gravity", "Specific gravity (specific_gravity)",
  glue("Dimensionless ratio of stone to water specific weight (approx. Gs ~ 2.65)."),
  glue("Many stability and empirical stone-size relations depend on the relative submerged density. Verify consistent units when comparing methods."),
  "right",

  "side_angle", "Side angle (side_angle)",
  glue("Bank side angle in degrees derived from side_slope; used to compute sloped bank length."),
  glue("side_angle = atan(1 / side_slope) converted to degrees. Influences length_left_bank and total mattress area."),
  "right",

  "unit_discharge", "Unit discharge (unit_discharge)",
  glue("q = total_discharge / width (m^2/s). The primary hydraulic input for many stone-size relations."),
  glue("
**Why it matters**
- Most empirical stone-size formulae (NRCS, USACE, etc.) are sensitive to q. Changing width or Q influences q directly and therefore stone-size predictions.

**Guidance**
- Inspect how q changes across scenarios and use it as a primary explanatory variable when interpreting results.
"),
  "right",

  "mannings_n", "Manning's n (mannings_n)",
  glue("Estimated roughness using particle_size: mannings_n = 0.034 * (particle_size * ft_per_m)^(1/6)."),
  glue("n affects normal_depth and normal_velocity; test alternative n (or particle_size) values when roughness is uncertain."),
  "right",

  "critical_depth", "Critical depth (critical_depth)",
  glue("Depth at which specific energy is minimized for q: (q^2 / g)^(1/3)."),
  glue("Compare critical_depth to normal_depth to identify flow regime; proximity to critical depth indicates possible regime transitions that affect stability behavior."),
  "right",

  "normal_depth", "Normal depth (normal_depth)",
  glue("Depth computed from Manning's equation for given q, n, and slope: ((q * n) / sqrt(S))^(3/5)."),
  glue("Normal_depth sets hydraulic radius and, together with velocity, determines shear stress and stream power — key inputs to stone-size formulas."),
  "right",

  "normal_velocity", "Normal velocity (normal_velocity)",
  glue("Velocity computed as q / normal_depth (m/s). Direct driver of shear stress and several empirical stone-size relations."),
  glue("Higher velocities generally yield larger predicted stone sizes; track velocity changes across sweeps."),
  "right",

  "froude", "Froude number (froude)",
  glue("Dimensionless flow regime indicator: Fr = V / sqrt(g * depth). Values >1 indicate supercritical flow."),
  glue("Interpretation: Fr < 1 subcritical, Fr > 1 supercritical. Different regime behaviors may require separate checks or alternate design approaches."),
  "right",

  "shear_stress", "Shear stress (shear_stress)",
  glue("Bed shear stress computed in the code as h2o_specific_weight * normal_velocity * slope (N/m^2)."),
  glue("Shear is a direct measure of the driving force on bed material and is used to compute applied stream power and to contextualize stone stability."),
  "right",

  "avail_stream_power", "Available stream power (avail_stream_power)",
  glue("Specific stream power (kW/m) computed as (h2o_specific_weight * q * slope) / 1000."),
  glue("Useful energy-based metric for comparing regimes and as an input to empirical relations."),
  "right",

  "applied_stream_power", "Applied stream power (applied_stream_power)",
  glue("Alternative applied stream power metric computed in the code: (7.853 * wd * (shear_stress / wd)^(3/2)) / 1000."),
  glue("Provides an alternate representation of bed-applied energy; compare with avail_stream_power when diagnosing differences between methods."),
  "right",

  "stone_size_methods", "Empirical stone-size methods (nrcs/usace/abt_johnson/isbash/usbr)",
  glue("The app computes several candidate stone diameters using different empirical relations (stone_size_nrcs, stone_size_usace, stone_size_abt_johnson, stone_size_isbash, stone_size_usbr)."),
  glue("
**Why it matters**
- Different empirical relations use different combinations of q, velocity, slope, and specific gravity and will produce a range of recommended sizes.

**Guidance**
- Compare all method outputs. Use the spread to inform risk-based design and consider selecting a percentile (e.g., 90–95th) or applying an adoption multiplier.
"),
  "right",

  "adopted_stone_diameter", "Adopted stone diameter (adopted_stone_diameter)",
  glue("Final adopted stone diameter (m). In code default is stone_size_nrcs * 1.3."),
  glue("
**Definition**
- adopted_stone_diameter = stone_size_nrcs * 1.3 (by default in code).

**Why it matters**
- This diameter drives mattress thickness, stone mass, and ordering sizes. Sensitivity to the adoption multiplier should be evaluated as part of scenario testing.
"),
  "right",

  "adopted_stone_weight", "Adopted stone weight (kg, lbs, tons)",
  glue("Mass computed using adopted diameter and stone specific weight. Useful for procurement and handling."),
  glue("Verify that adopted stone weight matches supplier gradations and on-site handling equipment capacities before finalizing design."),
  "right",

  "mattress_thickness", "Mattress thickness (m)",
  glue("Placed stone layer thickness; code sets mattress_thickness = adopted_stone_diameter * 2."),
  glue("Thickness affects required stone volume per area and therefore total ordering. Consider constructability and bedding when choosing thickness."),
  "right",

  "stone_vol_m3", "Stone volume (stone_vol_m3)",
  glue("Computed placed rock volume (m^3) after applying contingency and porosity in code: contingency * mattress_thickness * (length_left_bank + width) * length * (1 - porosity)."),
  glue("
**Why it matters**
- This is the final ordering/estimate volume. stone_vol_m3 is sensitive to adopted_stone_diameter, porosity, contingency, width, and length.

**Guidance**
- When running sensitivity, export stone_vol_m3 and the contributing components so the source of variation is clear (e.g., geometry vs. adopted diameter).
"),
  "right",


# App tab documentation
  "getting_started", "Intro tab - app overview",
  glue("Overview of the app, workflow, and key assumptions."),
  glue("# Getting Started

    ## Purpose
    This app helps estimate the stone sizes required for chutes of various dimensions.

    ## Define the Scenario

    1. In the left sidebar, specify the design characteristics of the chute.
    2. Click the `Calculate Dimensions` button.
    
    ## Review the Results
    
    Scenario results can be explored using the tabs across the top of the app.
    
    * by Width - View results of the scenario where chute widths are varied.
    * by Slope - View results of the scenario where chute slopes are varied.
    * by Particle Size - View results of the scenario where chute particle sizes are varied.
    "),
  "right",

  "tab_intro", "Intro tab — app overview",
  glue("Overview of the app, workflow, and key assumptions."),
  glue("
**Purpose**
- High-level description of the app: build scenarios, compute chute hydraulics, evaluate empirical stone-sizing methods, and estimate material quantities.

**What you'll find**
- A short walkthrough of the typical workflow: (1) set scenario inputs (width, length, slope, discharge, material properties), (2) run sensitivity scenarios, (3) inspect method outputs and adopted stone size, (4) review quantities and export results.

**Assumptions & units**
- Inputs assume SI units (m, m^3/s, kg/m^3, unitless slopes). Gravity and water density are used in calculations—keep these consistent across scenarios.
- The app uses empirical stone-size relations and simplified hydraulics (Manning's equation based normal depth). Use the outputs for screening and preliminary design; augment with site-specific hydraulic modeling as needed.

**How to use**
- Start here to learn the app structure and recommended order of operations.
- Use the example scenarios to see expected outputs and interpretation.
- Check the 'By Width', 'By Slope', and 'By Particle Size' tabs for focused sensitivity analyses.

**Practical tips**
- Document chosen inputs and the rationale for adopted design values.
- Export results for reporting and peer review.
"),
  "left",

  "tab_by_width", "By Width tab — sensitivity to chute width",
  glue("Explore how changing chute width affects hydraulics, stone sizing, and volumes."),
  glue("
**What this tab does**
- Runs the scenario sequence varying *width* (using width_start, width_end, width_by) while holding other inputs fixed.
- Reports changes in unit_discharge (q), normal_depth, velocity, computed stone sizes (all methods), adopted diameter, stone mass, and stone volume.

**Key outputs to inspect**
- q (unit discharge) vs width: primary explanatory variable for stone-size variation.
- Adopted stone diameter and method spread: examine how different empirical methods diverge as width changes.
- stone_vol_m3: how total material needs change with width (useful for cost & procurement).

**How to interpret**
- Expect inverse relationship: narrower widths → larger q → larger predicted stone sizes and possibly larger stone volume per unit length.
- If method outputs spread widely across widths, consider conservative percentiles (e.g., 90–95th) or adoption multipliers and document reasoning.

**Recommended plots and checks**
- Line plots of D (D50/D84/adopted) vs width.
- Line plots of stone_vol_m3 vs width and stacked bars for method outputs if applicable.
- Check Froude number and critical_depth to ensure flow regime remains consistent across widths (regime changes may invalidate simple comparisons).

**Design guidance**
- Use this tab to compare alternative chute layouts. When size jumps rapidly with small width changes, reassess layout or perform finer sweeps in the sensitive interval.
"),
  "right",

  "tab_by_slope", "By Slope tab — sensitivity to chute slope",
  glue("Explore how changing slope affects flow energy, velocities, shear, and stone size recommendations."),
  glue("
**What this tab does**
- Varies slope (via slope_start, slope_end, slope_by) and computes hydraulics and empirical stone-size outputs for each slope value.

**Key outputs to inspect**
- normal_velocity, shear_stress, avail_stream_power/applied_stream_power, stone_size_* methods, and adopted_stone_diameter.
- Note changes in mattress_thickness and stone_vol_m3 as adopted diameter changes.

**How to interpret**
- Increasing slope generally increases velocity and shear, typically producing larger predicted stone sizes.
- Watch for non-linear responses: some empirical relations scale with slope exponents and can cause rapid increases in recommended size at higher slopes.
- If slope changes cause normal_depth to approach critical_depth, flow regime considerations become important and design may require additional hydraulic analysis (e.g., jump controls, stilling basins).

**Recommended plots and checks**
- Line or log-scale plots of stone size vs slope.
- Plot shear_stress and stream power vs slope to understand energy drivers.
- Compare method outputs across slope and consider selecting design percentiles informed by the spread.

**Design guidance**
- Use the slope tab to evaluate whether a proposed slope is feasible with locally available rock sizes and placement methods. If recommended stones exceed handling capacity, consider slope reduction, protective measures, or engineered structures.
"),
  "right",

  "tab_by_particle_size", "By Particle Size tab — sensitivity to reference particle/roughness",
  glue("Explore how assumptions about particle size (and the resulting Manning's n) affect hydraulics and stone-size outputs."),
  glue("
**What this tab does**
- Varies the reference particle_size (particle_size_start, particle_size_end, particle_size_by) used to estimate mannings_n and recomputes normal_depth, velocity, and stone-size estimates.

**Key outputs to inspect**
- mannings_n, normal_depth, normal_velocity, stone_size_* methods, and stone_vol_m3.
- Differences in depth and velocity caused by roughness changes (and how that propagates to stone sizing).

**How to interpret**
- Larger particle_size → larger estimated roughness (through the code's n relation) → typically deeper normal_depth and lower velocity for a fixed q, which may reduce predicted stone sizes.
- This tab isolates the effect of roughness/gradations; large changes here indicate that field-measured roughness or substrate characterization is important.

**Recommended plots and checks**
- Plot mannings_n and normal_depth vs particle_size to visualize the hydraulic effect.
- Plot adopted_stone_diameter and stone_vol_m3 vs particle_size to see practical procurement impacts.
- If available, compare to measured field roughness or perform sensitivity using alternative n values directly.

**Design guidance**
- Use this tab to bound uncertainty from roughness assumptions and to prioritize field measurements. If stone sizing is insensitive to particle_size, focus measurement efforts elsewhere; if sensitive, invest in better roughness characterization.
"),
  "right",


  # Plots
  "plot_stone_size_method_plot", "Stone size methods plot",
  glue("Line plot comparing stone-size estimates from each empirical method. Useful for comparing method sensitivity and trends with the x-axis variable."),
  glue("
**Function & inputs**
- Produced by plot_stone_size_method(channel_dims, x_axis). `x_axis` may be one of: `width`, `slope`, `particle_size`.

**What you see**
- Each empirical method (NRCS, USACE, Abt-Johnson, Isbash, USBR, etc.) is shown as a separate colored line plotting its recommended stone size (m) vs the chosen x-axis.
- The y-axis is stone size in meters; use a log scale externally if sizes span orders of magnitude.

**How to interpret**
- Compare method spread at each x value to understand epistemic uncertainty in empirical predictions.
- Identify where particular methods diverge strongly — these ranges indicate areas where method choice matters most.
- Use the plot to pick an adoption strategy: e.g., choose a conservative percentile across methods or apply an adoption multiplier to a selected method.

**Practical tips**
- Overlay the adopted stone diameter (from channel_dims$adopted_stone_diameter) in your own debug plots to see where the app's adoption rule sits relative to the methods.
- When the spread is large, consider additional checks (e.g., hydraulic modeling or site-specific tests).
"),
  "right",

  "plot_channel_flow_plot", "Hydraulic parameters faceted plot",
  glue("Faceted plot of hydraulic variables (unit discharge, depths, velocities, Froude, shear, stream power) vs the chosen x-axis. Helps diagnose hydraulic drivers of stone-size changes."),
  glue("
**Function & inputs**
- Produced by plot_channel_flow(channel_dims, x_axis). `x_axis` may be `width`, `slope`, or `particle_size`.

**What you see**
- A multi-panel (facet) plot showing: Unit Discharge, Manning's n, Critical Depth/Velocity/Slope, Normal Depth/Velocity, Froude number, Shear Stress, Available Stream Power, and Applied Stream Power. Each panel uses independent y-scales (scales = 'free_y').

**How to interpret**
- Use the faceted layout to identify which hydraulic variable(s) change in tandem with stone-size predictions.
- Look for regime changes: where normal_depth approaches critical_depth or where Froude crosses 1.0 — these indicate transitions between subcritical and supercritical flows and may invalidate simple intuition.
- Shear stress and stream power panels show the energy available to mobilize material; increases here often explain larger stone sizes.

**Practical tips**
- Inspect Manning's n panel when varying particle_size to confirm the expected roughness effect.
- Use the shear and stream power panels to justify conservative choices for adopted stone diameter when energy metrics increase rapidly.
"),
  "left",

  "plot_stone_quantities_plot", "Stone quantities & mass plot",
  glue("Plot(s) showing mattress thickness, stone volume (m^3), and stone weight (kg / lbs / tons) vs the chosen x-axis. Useful for procurement and constructability checks."),
  glue("
**Typical content**
- Visualizes the geometric and inventory outputs derived from adopted stone diameter and channel geometry:
  - mattress_thickness (m),
  - stone_vol_m3 (placed volume, m^3),
  - adopted_stone_weight_kg / lbs / ton (per-stone mass),
  - (optionally) total mass or number of stones required.

**How to interpret**
- Use these plots to translate hydraulic/design outputs into procurement and logistic metrics.
- Rapid jumps in adopted stone weight or stone_vol_m3 across a small change in the x-axis often indicate a threshold effect: either the adopted diameter crossed into the next supplier gradation or hydraulic energy increased markedly.

**Practical tips**
- If adopted stone mass exceeds handling capabilities, consider design changes (reduce slope, increase width) or staged placement strategies.
- Export tabular results for vendor quotations; plots are best used in combination with numeric tables for ordering.
"),
  "right",


  # Channel-dimensions for scenario sweeps
  "scenario_by_width_channel_dims", "Channel dimensions — by-width scenario outputs",
  glue("Channel-dimensions dataframe produced when sweeping `width` (from by_width_df -> channel_dimensions). Contains hydraulics, method outputs, and volume/weight estimates for each width value."),
  glue("
**What this object is**
- The channel_dimensions output produced by passing the by_width_df scenario to channel_dimensions(). Each row corresponds to a width value in the sweep and includes computed hydraulics (q, depths, velocities, Froude, shear, stream power), empirical stone-size estimates, adopted stone diameter and mass, and volume/quantity computations.

**Key columns to inspect**
- `width`, `unit_discharge`, `normal_depth`, `normal_velocity`, `froude`, `shear_stress`, `avail_stream_power`, `applied_stream_power`
- `stone_size_nrcs`, `stone_size_usace`, `stone_size_abt_johnson`, `stone_size_isbash`, `stone_size_usbr`
- `adopted_stone_diameter`, `adopted_stone_weight_kg`, `mattress_thickness`, `stone_vol_m3`, `length_left_bank`

**How to interpret across the sweep**
- Trace how q and velocity vary with width; these are the primary drivers of stone-size changes.
- Look at both empirical-method spread and the adopted diameter. If the adopted diameter changes discontinuously with width, investigate the cause (e.g., method crossing or adoption multiplier).

**Checks**
- Verify unit consistency (m, m^3/s, kg/m^3).
- Check Froude for regime changes: a flow regime transition may require additional hydraulic treatment beyond the app's scope.

**Reporting**
- Use summary tables and plots (stone size by method, hydraulic facets, quantities) to support design decisions and procurement estimates.
"),
  "left",

  "scenario_by_slope_channel_dims", "Channel dimensions — by-slope scenario outputs",
  glue("Channel-dimensions dataframe produced when sweeping `slope` (from by_slope_df -> channel_dimensions). Contains hydraulics, method outputs, and volume/weight estimates for each slope value."),
  glue("
**What this object is**
- The channel_dimensions output produced by passing the by_slope_df scenario to channel_dimensions(). Each row corresponds to a slope value and contains the same set of hydraulic and material outputs as other scenario sweeps.

**Key columns to inspect**
- `slope`, `normal_velocity`, `shear_stress`, `avail_stream_power`, `applied_stream_power`, plus the stone-size method outputs and quantity columns.

**How to interpret across the sweep**
- Slope strongly affects velocity and shear; expect stone-size predictions to increase with slope in most empirical relations.
- Examine non-linear responses where elevated slopes produce disproportionate jumps in predicted diameters or required volumes.

**Checks**
- For high slopes, confirm the mattress_thickness and adopted_stone_weight do not exceed practical placement/handling limits.
- If normal_depth nears critical_depth, or if Froude increases above 1, consider separate hydraulic analysis (hydraulic jumps, controls).

**Reporting**
- Use slope-sweep outputs to evaluate feasibility and to set conservative design choices when supplier or handling limits constrain stone selection.
"),
  "left",

  "scenario_by_particle_size_channel_dims", "Channel dimensions — by-particle_size scenario outputs",
  glue("Channel-dimensions dataframe produced when sweeping `particle_size` (from by_particle_size_df -> channel_dimensions). Used to evaluate roughness and gradation effects."),
  glue("
**What this object is**
- The channel_dimensions output produced by passing by_particle_size_df into channel_dimensions(). Each row corresponds to a particle_size value (used to estimate Manning's n) and includes hydraulic variables, stone-sizing method outputs, and quantities.

**Key columns to inspect**
- `particle_size`, `mannings_n`, `normal_depth`, `normal_velocity`, `stone_size_*` method outputs, and `stone_vol_m3`.

**How to interpret across the sweep**
- Changes in particle_size map to changes in estimated Mannings n; larger reference particle_size typically produces greater roughness estimates, deeper normal_depth, and lower velocities for fixed q — which can reduce predicted stone sizes.
- Use this sweep to bound uncertainty from roughness assumptions and to prioritize field measurements.

**Checks**
- If stone sizing is sensitive to particle_size, plan additional field roughness characterization (e.g., pebble counts, substrate logs).
- Confirm that changes in depth/velocity do not produce unintended regime transitions.

**Reporting**
- Present roughness sensitivity results alongside hydraulic and quantity outputs so decision-makers understand whether more site characterization is warranted.
"),
  "left"

)

# Save data to package
usethis::use_data(help_data, internal = FALSE, overwrite = TRUE)
