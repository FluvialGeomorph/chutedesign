% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/draw_channel_3d.R
\name{draw_channel_3d}
\alias{draw_channel_3d}
\title{Draw a 3D channel}
\usage{
draw_channel_3d(
  width = 4,
  length = 20,
  slope = 0.05,
  side_slope = 2,
  depth = 2,
  flow_arrow = FALSE,
  alpha = 0.5
)
}
\arguments{
\item{width}{numeric; Width of the channel.}

\item{length}{numeric; length of the channel.}

\item{slope}{numeric; Slope of the channel.}

\item{side_slope}{numeric; Side slope of the channel (rise:run)}

\item{depth}{numeric; Depth of the water in the channel.}

\item{flow_arrow}{boolean; Display a flow direction arrow? default: FALSE}

\item{alpha}{numeric; Alpha coefficient of surface transparency.}
}
\value{
an rglwidget
}
\description{
Draw a 3D channel rglwidget.
}
