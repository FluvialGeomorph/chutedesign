test_that("by_length_df creates expected sequence and repeats other params", {
  scenario <- list(
    width = 50,
    width_start = 50, width_end = 50, width_by = 10,
    length = 2000,
    length_start = 1000, length_end = 3000, length_by = 500,
    slope = 0.02,
    slope_start = 0.01, slope_end = 0.05, slope_by = 0.01,
    particle_size = 1.6,
    particle_size_start = 1, particle_size_end = 2, particle_size_by = 0.1,
    side_slope = 2.5,
    total_discharge = 500,
    stone_density = 2650,
    contingency = 1.2,
    porosity = 0.35,
    water_density = 998,
    gravity = 9.81
  )

  df <- by_length_df(scenario)

  # expected sequence and row count
  expected_lengths <- seq(from = scenario$length_start,
                          to = scenario$length_end,
                          by = scenario$length_by)
  expect_equal(nrow(df), length(expected_lengths))
  expect_equal(df$length, expected_lengths)

  # id sequence
  expect_equal(df$id, seq_len(length(expected_lengths)))

  # other columns should be constant and equal to scenario values
  expect_true(all(df$width == scenario$width))
  expect_true(all(df$slope == scenario$slope))
  expect_true(all(df$particle_size == scenario$particle_size))
  expect_true(all(df$side_slope == scenario$side_slope))
  expect_true(all(df$total_discharge == scenario$total_discharge))
  expect_true(all(df$stone_density == scenario$stone_density))
  expect_true(all(df$contingency == scenario$contingency))
  expect_true(all(df$porosity == scenario$porosity))
  expect_true(all(df$water_density == scenario$water_density))
  expect_true(all(df$gravity == scenario$gravity))
})