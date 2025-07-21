test_that("draw_channel_3d", {
width = 5
length = 30
slope = 0.03
side_slope = 2
depth = 2.5
alpha = 0.6

expect_silent({
  widget <- draw_channel_3d(width = width,
                            length = length,
                            slope = slope,
                            side_slope = side_slope,
                            depth = depth,
                            alpha = alpha)
})
expect_s3_class(widget, "rglWebGL")
})

