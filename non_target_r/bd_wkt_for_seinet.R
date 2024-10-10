library(sf)
library(tidyverse)
library(targets)

bbox_test<-tar_read(unit_fs) |>
  st_make_valid() |> 
  st_buffer(5000) |> 
  st_bbox() |>
  st_as_sfc()   |>
  st_make_valid()

bbox_test |>
  st_as_text()

POLYGON ((38.91238 -108.2378, 38.91238 -105.7116, 40.31638 -105.7116, 40.31638 -108.2378, 38.91238 -108.2378))

ggplot()+
  geom_sf(data=bbox_test, fill="transparent")+
  geom_sf(data=tar_read(unit_fs), fill="darkgreen")
