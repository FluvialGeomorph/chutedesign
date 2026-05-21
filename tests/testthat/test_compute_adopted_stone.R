# Shared scenario used across all tests
make_scenario <- function() {
  create_scenario(
    width               = 60,
    width_start         = 40,
    width_end           = 200,
    width_by            = 20,
    length              = 2000,
    length_start        = 1000,
    length_end          = 3000,
    length_by           = 500,
    slope               = 0.01,
    slope_start         = 0,
    slope_end           = 1,
    slope_by            = 0.05,
    particle_size       = 2.6,
    particle_size_start = 1,
    particle_size_end   = 3,
    particle_size_by    = 0.1,
    side_slope          = 2.5,
    total_discharge     = 2000,
    stone_density       = 2650,
    contingency         = 1.3,
    porosity            = 0.3,
    water_density       = 998,
    gravity             = 9.787
  )
}

expected_adopted_cols <- c(
  "adopted_stone_diameter",
  "adopted_stone_weight_kg",
  "adopted_stone_weight_lbs",
  "adopted_stone_weight_ton",
  "mattress_thickness",
  "stone_vol_m3",
  "stone_vol_cuyd",
  "stone_vol_metric_ton",
  "stone_vol_us_ton",
  "number_stones"
)

test_that("compute_adopted_stone works with by_width_df", {
  scenario      <- make_scenario()
  channel_df    <- by_width_df(scenario)
  channel_dims  <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dims)
  adopted       <- compute_adopted_stone(channel_dims, stone_metrics, method = "nrcs")

  # Output type and dimensions
  expect_s3_class(adopted, "data.frame")
  expect_equal(nrow(adopted), nrow(channel_dims))

  # All expected adopted columns are present
  for (col in expected_adopted_cols) {
    expect_true(col %in% colnames(adopted),
                label = paste("column present:", col))
  }

  # stone_specific_weight is NOT an output column
  expect_false("stone_specific_weight" %in% colnames(adopted))

  # Adopted diameter equals the nrcs stone_diameter from stone_metrics
  nrcs_diameters <- stone_metrics %>%
    dplyr::filter(method == "nrcs") %>%
    dplyr::pull(stone_diameter)
  expect_equal(adopted$adopted_stone_diameter, nrcs_diameters)

  # All adopted values are positive for valid inputs
  expect_true(all(adopted$adopted_stone_diameter > 0))
  expect_true(all(adopted$adopted_stone_weight_kg > 0))
  expect_true(all(adopted$stone_vol_m3 > 0))
  expect_true(all(adopted$number_stones > 0))
})

test_that("compute_adopted_stone works with by_length_df", {
  scenario      <- make_scenario()
  channel_df    <- by_length_df(scenario)
  channel_dims  <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dims)
  adopted       <- compute_adopted_stone(channel_dims, stone_metrics, method = "nrcs")

  expect_s3_class(adopted, "data.frame")
  expect_equal(nrow(adopted), nrow(channel_dims))
  for (col in expected_adopted_cols) {
    expect_true(col %in% colnames(adopted),
                label = paste("column present:", col))
  }
})

test_that("compute_adopted_stone works with by_slope_df", {
  scenario      <- make_scenario()
  channel_df    <- by_slope_df(scenario)
  channel_dims  <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dims)
  adopted       <- compute_adopted_stone(channel_dims, stone_metrics, method = "nrcs")

  expect_s3_class(adopted, "data.frame")
  expect_equal(nrow(adopted), nrow(channel_dims))
  for (col in expected_adopted_cols) {
    expect_true(col %in% colnames(adopted),
                label = paste("column present:", col))
  }
})

test_that("compute_adopted_stone works with by_particle_size_df", {
  scenario      <- make_scenario()
  channel_df    <- by_particle_size_df(scenario)
  channel_dims  <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dims)
  adopted       <- compute_adopted_stone(channel_dims, stone_metrics, method = "nrcs")

  expect_s3_class(adopted, "data.frame")
  expect_equal(nrow(adopted), nrow(channel_dims))
  for (col in expected_adopted_cols) {
    expect_true(col %in% colnames(adopted),
                label = paste("column present:", col))
  }
})

test_that("compute_adopted_stone respects method argument", {
  scenario      <- make_scenario()
  channel_df    <- by_width_df(scenario)
  channel_dims  <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dims)

  for (m in c("nrcs", "usace", "abt_johnson", "usbr")) {
    adopted <- compute_adopted_stone(channel_dims, stone_metrics, method = m)
    expected_diameters <- stone_metrics %>%
      dplyr::filter(method == m) %>%
      dplyr::pull(stone_diameter)
    expect_equal(adopted$adopted_stone_diameter, expected_diameters,
                 label = paste("adopted_stone_diameter matches method:", m))
  }
})

test_that("compute_adopted_stone raises error for invalid method", {
  scenario      <- make_scenario()
  channel_df    <- by_width_df(scenario)
  channel_dims  <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dims)

  expect_error(
    compute_adopted_stone(channel_dims, stone_metrics, method = "invalid"),
    "method must be one of"
  )
})

test_that("compute_adopted_stone uses data-driven contingency, not hardcoded", {
  scenario      <- make_scenario()
  channel_df    <- by_width_df(scenario)
  channel_dims  <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dims)

  adopted_base    <- compute_adopted_stone(channel_dims, stone_metrics)
  channel_dims_2x <- channel_dims %>% dplyr::mutate(contingency = contingency * 2)
  adopted_2x      <- compute_adopted_stone(channel_dims_2x, stone_metrics)

  # Doubling contingency should double stone_vol_m3
  expect_equal(adopted_2x$stone_vol_m3, adopted_base$stone_vol_m3 * 2,
               tolerance = 1e-10)
})
