build_gmug_scc_list <- function(x) {
  read_excel(x, sheet = 1) |>
    janitor::clean_names() |>
    select(-biological_group) |>
    mutate(
      status_r = "Species of Conservation Concern",
      status_s = "Grand Mesa, Uncumpahgre and Gunnison National Forests",
      status_c = "USFS Species of Conservation Concern",
      status_a = paste(status_s, status_r, sep = " ")
    ) |>
    get_taxonomies()
}
