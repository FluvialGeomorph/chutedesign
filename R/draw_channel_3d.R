#' @title Draw a 3D channel
#' @description Draw a 3D channel rglwidget.
#' @param width       numeric; Width of the channel.
#' @param length      numeric; length of the channel.
#' @param slope       numeric; Slope of the channel.
#' @param side_slope  numeric; Side slope of the channel (rise:run)
#' @param depth       numeric; Depth of the water in the channel.
#' @param flow_arrow  boolean; Display a flow direction arrow? default: FALSE
#' @param alpha       numeric; Alpha coefficient of surface transparency.
#' @returns an rglwidget
#' @export
#' @importFrom rgl open3d bg3d quads3d arrow3d axes3d title3d rglwidget
draw_channel_3d <- function(width = 4,
                            length = 20,
                            slope = 0.05,
                            side_slope = 2,
                            depth = 2,
                            flow_arrow = FALSE,
                            alpha = 0.5) {

  # --- Elevations: high upstream to low downstream ---
  base_z0 <- 0
  base_zL <- -length * slope  # downhill

  # Bottom corners
  p1 <- c(0, -width/2, base_z0)       # front left bottom (upstream)
  p2 <- c(0,  width/2, base_z0)       # front right bottom
  p3 <- c(length, -width/2, base_zL)  # back left bottom (downstream)
  p4 <- c(length,  width/2, base_zL)  # back right bottom

  # Top corners (accounting for side slope)
  top_offset <- side_slope * depth
  p5 <- c(0, -width/2 - top_offset, base_z0 + depth)
  p6 <- c(0,  width/2 + top_offset, base_z0 + depth)
  p7 <- c(length, -width/2 - top_offset, base_zL + depth)
  p8 <- c(length,  width/2 + top_offset, base_zL + depth)

  # --- Open 3D window ---
  open3d(useNULL = TRUE)
  bg3d("white")

  # --- Draw Faces ---
  quads3d(rbind(p1, p2, p4, p3), col = "gray60", alpha = alpha)         # bottom
  #quads3d(rbind(p5, p6, p8, p7), col = "skyblue", alpha = alpha)        # top
  quads3d(rbind(p1, p3, p7, p5), col = "lightblue", alpha = alpha)      # left
  quads3d(rbind(p2, p4, p8, p6), col = "lightblue", alpha = alpha)      # right
  quads3d(rbind(p1, p2, p6, p5), col = "deepskyblue4", alpha = alpha)   # front
  quads3d(rbind(p3, p4, p8, p7), col = "deepskyblue4", alpha = alpha)   # back

  # --- Draw Flow Direction Arrow (upstream to downstream) ---
  arrow_start <- c(length * 0.25, 0, base_z0 + depth * 1.3)      # higher z
  arrow_end   <- c(length * 0.75, 0, base_zL + depth * 1.3)      # lower z
  if(flow_arrow) {
    arrow3d(p0 = arrow_start,
            p1 = arrow_end,
            type = "extrusion",
            barblen = 0.15,
            s = 1/50,
            col = "red")
  }

  # --- Axes and Labels ---
  axes3d()
  title3d("",
          xlab = "Length (m)", ylab = "Width (m)", zlab = "Elevation (m)")

  rglwidget()
}
