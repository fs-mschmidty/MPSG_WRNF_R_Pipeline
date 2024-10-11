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
    "scales",
    "BIEN"
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

ext_data_root <- "T:\\FS\\NFS\\PSO\\MPSG\\Data\\ExternalData"

list(
  # Base GIS data
  tar_target(t_path, file.path("T:/FS/NFS/PSO/MPSG/2024_WhiteRiverNF/1_PreAssessment", "Projects/SpeciesList_WRNF")),
  tar_target(t_path_gdb, file.path(t_path, "SpeciesList_WRNF.gdb")),
  tar_target(unit_fs, sf::read_sf(layer = lyr_planarea, dsn = t_path_gdb) |> dplyr::filter(OWNERCLASSIFICATION == "USDA FOREST SERVICE")),

  ## Build eligible list
  tar_target(natureserve_state_data, get_natureserve_state_data(state = "CO")),
  tar_target(r2_ss_list, build_r2_ss_list("data/fs/2023_R2_RegionalForestersSensitiveSppList.xlsx")),
  tar_target(co_swap_list, build_co_swap_list("data/co/CO_SWAP_Chapter2.xlsx")),
  tar_target(co_te_list, build_co_te_list("data/co/CNHP_Tracking_List_20240421.xlsx")),
  tar_target(gmug_scc_list, build_gmug_scc_list("data/fs/gmug_scc_list_2024.xlsx")),
  tar_target(co_eligible_list, build_co_eligible_list(natureserve_state_data$CO_natureserve_state_list, r2_ss_list, co_swap_list, co_te_list, gmug_scc_list)),

  ## Clean Occurrence Records
  tar_target(t_drive_lists, build_t_drive_lists(file.path(t_path, "reproduce"))),
  tar_target(unit_eligible_list, build_unit_eligible_list(co_eligible_list, t_drive_lists)),

  ## Get Range Maps
  tar_target(download_ebird_maps, download_ebird_range_maps(unit_eligible_list, output_path = "output/ebirdst")),
  tar_target(download_bien_range_maps, download_bien_range_maps(unit_eligible_list, output_path = "output/bien_maps"))
)
