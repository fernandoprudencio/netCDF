#' @title
#' read netCDF file
#'
#' @description
#' from netCDF to GeoTIFF
#'
#' @author Fernando Prudencio
#'

rm(list = ls())

#' INSTALL PACKAGES
pkg <- c("tidyverse", "ncdf4", "raster", "sf", "rgdal")

sapply(
  pkg,
  function(x) {
    is.there <- x %in% rownames(installed.packages())
    if (is.there == FALSE) {
      install.packages(x)
    }
  }
)

#' LOAD PACKAGES
library(tidyverse)
library(ncdf4)
library(raster)
library(sf)
library(rgdal)

#' READ netCDF AND WRITE AS GeoTIFF
# for (i in list_nc) {
#   print(k)
#   # i = list_nc[52]
#
#   name <- basename(i) %>% str_sub(1, -5)
#   data <- nc_open(i)
#   lon <- ncvar_get(data, "lon")
#   lat <- ncvar_get(data, "lat")
#   array <- ncvar_get(data, dname)
#   img <- raster(array,
#     xmn = min(lon), xmx = max(lon),
#     ymn = min(lat), ymx = max(lat), crs = coor
#   ) %>%
#     flip(direction = "y")
#
#   writeRaster(
#     img, sprintf("data/tif/%1$s.tif", name),
#     overwrite = T
#   )
# }

#' FUNCTION TO READ netCDF AND WRITE AS GeoTIFF
#'   buid function
nc_to_tif <- function(nc, dname, crs, out) {
  name <- basename(nc) %>% str_sub(1, -5)
  data <- nc_open(nc)
  lon <- ncvar_get(data, "lon")
  lat <- ncvar_get(data, "lat")
  array <- ncvar_get(data, dname)
  img <- raster(array,
    xmn = min(lon), xmx = max(lon),
    ymn = min(lat), ymx = max(lat), crs = crs
  ) %>%
    flip(direction = "y")

  writeRaster(
    img, sprintf("%1$s%2$s.tif", out, name), overwrite = T
  )
}
#'   load list of netCDF files
list_nc <-
  list.files(
    "/media/fernando/3EDAEA276B95688A/02_DESKTOP-PC/disco_D/05-DataSets/02-Pp/10-TRMM/netcdf4",
    pattern = ".nc",
    full.names = T
  )
#'   input parameters netCDF files
dname <- "precipitation"
coor <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs+ towgs84=0,0,0")
#'   apply function
sapply(list_nc[7142], FUN = nc_to_tif, dname, coor, "data/tif/")
# nc_to_tif(list_nc[52], dname, coor, "data/tif/")
