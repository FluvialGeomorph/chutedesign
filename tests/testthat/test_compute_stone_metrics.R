test_that("compute_stone_metrics calculates stone sizes per method", {
  scenario <- create_scenario (
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
  channel_df <- by_width_df(scenario)
  channel_dimensions <- compute_channel_dimensions(channel_df)
  stone_metrics <- compute_stone_metrics(channel_dimensions)
  
  # Validate essential columns exist
  expect_true("method" %in% colnames(stone_metrics))
  expect_true("stone_diameter" %in% colnames(stone_metrics))
  expect_true("stone_vol_m3" %in% colnames(stone_metrics))

  # Validate stone size metrics across all methods
  expected_methods <- c("nrcs", "usace", "abt_johnson", "isbash", "usbr")
  expect_equal(sort(unique(stone_metrics$method)), sort(expected_methods))

  # Specific numerical validations
  expect_gt(stone_metrics$stone_diameter[1], 0)
  expect_gt(stone_metrics$stone_weight_kg[1], 0)

  # Test missing inputs
  invalid_dimensions <- channel_dimensions %>% dplyr::select(-unit_discharge)
  expect_error(compute_stone_metrics(invalid_dimensions), "object 'unit_discharge' not found")

  # Edge case: invalid stone_density or porosity
  invalid_density <- channel_dimensions %>% dplyr::mutate(stone_density = 0)
  stone_metrics_invalid_density <- compute_stone_metrics(invalid_density)
  expect_equal(stone_metrics_invalid_density$stone_weight_kg, 
               rep(0, length(stone_metrics_invalid_density$stone_weight_kg)))
  
  invalid_porosity <- channel_dimensions %>% dplyr::mutate(porosity = -1)
  stone_metrics_invalid_porosity <- compute_stone_metrics(invalid_porosity)
  expect_true(all(stone_metrics_invalid_porosity$stone_vol_m3 > stone_metrics$stone_vol_m3))
})