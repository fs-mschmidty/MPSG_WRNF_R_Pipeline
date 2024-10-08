build_co_te_list <- function(x) {
  data_r <- read_excel(x) |>
    clean_names() |>
    rename(scientific_name = gname, common_name = scomname) |>
    mutate(scientific_name = str_replace(scientific_name, " pop\\. 1", "")) |>
    filter(majorgroup != "Natural Communities") |>
    filter(!is.na(costatus))

  state_status <- data_r |>
    filter(costatus != "-") |>
    mutate(
      status_r = case_when(
        costatus == "SE" ~ "Endangered",
        costatus == "ST" ~ "Threatened",
        TRUE ~ NA
      ),
      status_s = "Colorado",
      status_c = "T and E",
      status_a = paste(status_s, status_c, status_r, sep = " ")
    ) |>
    select(scientific_name, common_name, status_a, status_c, status_r) |>
    filter(!is.na(status_r)) |>
    get_taxonomies()

  state_status
}
