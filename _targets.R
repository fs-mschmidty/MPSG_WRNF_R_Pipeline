# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c(
    "taxize",
    "tidyverse",
    "quarto",
    "sf",
    "readxl",
    "mpsgSO",
    "janitor",
    "httr2",
    "natserv",
    "openxlsx",
    "glue",
    "ebirdst",
    "fs",
    "rnaturalearth",
    "rgbif",
    "osmdata",
    "arcgislayers",
    "scales"
  ), # Packages that your targets need for their tasks.
  format = "qs" # Optionally set the default storage format. qs is fast.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
lyr_planarea <- "WRNF_PlanArea"
lyr_admbdy <- "WRNF_AdminBndry"
lyr_buffer <- "WRNF_AdminBndry_1kmBuffer"

list(
  tar_target(t_path, file.path("T:/FS/NFS/PSO/MPSG/2024_WhiteRiverNF/1_PreAssessment", "Projects/SpeciesList_WRNF")),
  tar_target(t_path_gdb, file.path(t_path, "SpeciesList_WRNF.gdb")),
  tar_target(unit_fs, sf::read_sf(layer = lyr_planarea, dsn = t_path_gdb) |> dplyr::filter(OWNERCLASSIFICATION == "USDA FOREST SERVICE")),
  tar_target(natureserve_state_data, get_natureserve_state_data(state="CO"))
)
