test_that("compute_adopted_stone computes number_stones using consistent ton units", {
  channel_dims <- tibble::tibble(
    id = 1,
    stone_density = 2650,
    gravity = 9.81,
    contingency = 1.3,
    porosity = 0.3,
    length_left_bank = 10,
    width = 20,
    length = 100
  )

  stone_metrics <- tibble::tibble(
    id = 1,
    method = "nrcs",
    stone_diameter = 1
  )

  result <- compute_adopted_stone(
    channel_dims = channel_dims,
    stone_metrics = stone_metrics,
    method = "nrcs"
  )

  expect_equal(
    result$number_stones,
    result$stone_vol_us_ton / result$adopted_stone_weight_us_ton
  )
})
