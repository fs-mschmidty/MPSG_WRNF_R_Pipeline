library(sf)
library(tidyverse)
library(targets)

seinet_csv <- read_csv("T:\\FS\\NFS\\PSO\\MPSG\\2024_WhiteRiverNF\\1_PreAssessment\\Projects\\SpeciesList_WRNF\\data\\SEINetV2\\occurrences.csv")

seinet_sub <- seinet_csv |>
  head(200)

seinet_csv |>
  filter(decimalLa)


seinet_sub |>
  View()
