test_that("compute_stone_size calculates using NRCS method correctly", {
  result <- compute_stone_size(
    method = "nrcs",
    unit_discharge = 0.5,
    slope = 0.02,
    normal_velocity = NA,
    stone_specific_weight = NA,
    h2o_specific_weight = NA
  )
  expected <- (12 * (0.233 * 0.5 * 0.02^0.58)^0.529) / 12
  expect_equal(result, expected, tolerance = 1e-6)
})

test_that("compute_stone_size calculates using USACE method correctly", {
  result <- compute_stone_size(
    method = "usace",
    unit_discharge = 0.5,
    slope = 0.02,
    normal_velocity = NA,
    stone_specific_weight = NA,
    h2o_specific_weight = NA,
    g = 9.81
  )
  expected <- (1.95 * 0.02^0.555 * 0.5^(2/3)) / 9.81^(1/3)
  expect_equal(result, expected, tolerance = 1e-6)
})

test_that("compute_stone_size calculates using Abt-Johnson method correctly", {
  result <- compute_stone_size(
    method = "abt_johnson",
    unit_discharge = 0.5,
    slope = 0.02,
    normal_velocity = NA,
    stone_specific_weight = NA,
    h2o_specific_weight = NA
  )
  expected <- (((0.5)^0.56) * 0.02^0.43 * 5.23) / 12
  expect_equal(result, expected, tolerance = 1e-6)
})

test_that("Isbash method correctly calculates stone size", {
  result <- compute_stone_size(
    method = "isbash",
    unit_discharge = NA,
    slope = NA,
    normal_velocity = 2.5,  # Critical velocity (m/s)
    stone_specific_weight = 2650 * 9.81,  # convert kg/m^3 to N/m³
    h2o_specific_weight = 1000 * 9.81,   # convert kg/m^3 to N/m³
    g = 9.81  # m/s²
  )
  # Expected output based on manual computation
  expected <- (1.2 * 2.5)^2 / (2 * 9.81 * (2650 / 1000 - 1))
  expect_equal(result, expected, tolerance = 1e-6)
})

test_that("compute_stone_size calculates using USBR method correctly", {
  result <- compute_stone_size(
    method = "usbr",
    unit_discharge = NA,
    slope = NA,
    normal_velocity = 2.5,
    stone_specific_weight = NA,
    h2o_specific_weight = NA
  )
  expected <- 0.0122 * (2.5)^2.06
  expect_equal(result, expected, tolerance = 1e-6)
})

test_that("compute_stone_size returns an error for invalid method", {
  expect_error(compute_stone_size(
    method = "invalid",
    unit_discharge = 0.5,
    slope = 0.02,
    normal_velocity = 1.5,
    stone_specific_weight = 2600 * 9.81,
    h2o_specific_weight = 1000 * 9.81,
    g = 9.81
  ), "Invalid method")
})