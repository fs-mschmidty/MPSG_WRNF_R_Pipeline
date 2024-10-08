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
  ## Base GIS data
  tar_target(t_path, file.path("T:/FS/NFS/PSO/MPSG/2024_WhiteRiverNF/1_PreAssessment", "Projects/SpeciesList_WRNF")),
  tar_target(t_path_gdb, file.path(t_path, "SpeciesList_WRNF.gdb")),
  tar_target(unit_fs, sf::read_sf(layer = lyr_planarea, dsn = t_path_gdb) |> dplyr::filter(OWNERCLASSIFICATION == "USDA FOREST SERVICE")),

  ## Build eligible list
  tar_target(natureserve_state_data, get_natureserve_state_data(state = "CO")),
  tar_target(r2_ss_list, build_r2_ss_list("data/fs/2023_R2_RegionalForestersSensitiveSppList.xlsx")),
  tar_target(co_swap_list, build_co_swap_list("data/co/CO_SWAP_Chapter2.xlsx")),
  tar_target(co_te_list, build_co_te_list("data/co/CNHP_Tracking_List_20240421.xlsx")),
  tar_target(gmug_scc_list, build_gmug_scc_list("data/fs/gmug_scc_list_2024.xlsx")),
  tar_target(eligible_list_wo_nn, build_eligible_list(natureserve_state_data, r2_ss_list, co_swap_list, co_swap_list, co_te_list))
)
