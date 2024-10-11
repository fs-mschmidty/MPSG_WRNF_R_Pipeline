#' This function downloads range maps based on an eligible list.
#' @param
download_ebird_range_maps <- function(x, output_path) {
  eligible_birds <- x |>
    filter(class == "Aves") |>
    select(taxon_id, scientific_name) |>
    left_join(ebirdst_runs, by = "scientific_name")

  eligible_birds_w_range_maps <- eligible_birds |>
    filter(!is.na(species_code))

  eligible_birds_no_range_maps <- eligible_birds |>
    filter(is.na(species_code))

  eligible_birds_sci_names <- eligible_birds_w_range_maps |>
    pull(scientific_name)

  lapply(eligible_birds_sci_names, ebirdst_download_status, download_ranges = T, pattern = "range_smooth_27km|range_smooth_9km", path = output_path)

  lst(
    eligible_birds_w_range_maps,
    eligible_birds_no_range_maps
  )
}
