test_that("check scenario", {
  width               = 50
  width_start         = 0
  width_end           = 100
  width_by            = 10
  slope               = 0.1
  slope_start         = 0
  slope_end           = 1
  slope_by            = 0.01
  particle_size       = 1.6
  particle_size_start = 1
  particle_size_end   = 2
  particle_size_by    = 0.1
  length              = 2000
  side_slope          = 2.5
  total_discharge     = 2000
  stone_density       = 2650
  contingency         = 1.3
  porosity            = 0.3
  water_density       = 998
  gravity             = 9.787

  scenario <- create_scenario (
    width               = width,
    width_start         = width_start,
    width_end           = width_end,
    width_by            = width_by,
    slope               = slope,
    slope_start         = slope_start,
    slope_end           = slope_end,
    slope_by            = slope_by,
    particle_size       = particle_size,
    particle_size_start = particle_size_start,
    particle_size_end   = particle_size_end,
    particle_size_by    = particle_size_by,
    length              = length,
    side_slope          = side_slope,
    total_discharge     = total_discharge,
    stone_density       = stone_density,
    contingency         = contingency,
    porosity            = porosity,
    water_density       = water_density,
    gravity             = gravity
  )
  expect_true(is.list(scenario))
  expect_equal(length(scenario), 20)
})
