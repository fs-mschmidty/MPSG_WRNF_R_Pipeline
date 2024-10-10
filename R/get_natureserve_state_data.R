#' This function exports all species from a state with NS state rank.

#' @param state a character with state code, exmaple: "CO".

get_natureserve_state_data <- function(state) {
  get_state_rank <- function(x, state_code) {
    regex <- paste0(state_code, " \\(([^)]+)\\)")

    x |>
      str_split_1("\\\n") |>
      str_subset("^United States") |>
      str_extract(regex) |>
      str_extract("\\(([^)]+)\\)") |>
      str_replace_all("\\(|\\)", "")
  }

  export <- ns_export(location = list(nation = "US", subnation = state), format = "xlsx")
  res <- ns_export_status(export)

  while (res$state != "Finished") {
    res <- ns_export_status(export)
  }

  request(res$data$url) |>
    req_perform(tmpf <- tempfile(fileext = ".xlsx"))

  sss <- read_excel(tmpf, skip = 1) |>
    janitor::clean_names() |>
    filter(!is.na(nature_serve_global_rank)) |>
    mutate(
      source = glue("{state} Natureserve Export")
    ) |>
    rowwise() |>
    mutate("{state}_sRank" := get_state_rank(distribution, state)) |>
    ungroup() |>
    get_taxonomies()

  l <- list()
  l[[glue("{state}_export_id")]] <- export
  l[[glue("{state}_natureserve_api_response")]] <- res
  l[[glue("{state}_natureserve_state_list")]] <- sss
  l
}
