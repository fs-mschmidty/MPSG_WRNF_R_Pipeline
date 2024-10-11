download_bien_range_maps <- function(x, output_path) {
  plants_all <- x |>
    filter(kingdom == "Plantae") |>
    pull(scientific_name)
  BIEN_ranges_species_bulk(plants_all, directory = output_path)
}
