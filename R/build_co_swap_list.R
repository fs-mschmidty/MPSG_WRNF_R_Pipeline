#' This function cleans the Colorado SWAP list. It  produces a file that has a taxon_id for each species.
#' @param x path to excel sheet with SWAP categories.
build_co_swap_list <- function(x) {
  data_raw <- read_excel(x, sheet = 1)
  data_raw |>
    janitor::clean_names() |>
    mutate(common_name = ifelse(is.na(common_name), x2, common_name)) |>
    filter(!is.na(common_name)) |>
    mutate(priority_tier = ifelse(is.na(priority_tier), x4, priority_tier)) |>
    select(scientific_name = species, common_name, priority_tier) |>
    filter(priority_tier != "Priority Tier") |>
    mutate(
      status_s = "Colorado",
      status_c = "SWAP",
      status_r = priority_tier,
      status_a = paste(status_s, status_c, status_r, sep = " ")
    ) |>
    select(-priority_tier) |>
    get_taxonomies()
}
