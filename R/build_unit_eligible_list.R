build_unit_eligible_list <- function(co_eligible_list, t_drive_lists) {
  co_eligible_list |>
    left_join(t_drive_lists$gbif_list, by = "taxon_id") |>
    left_join(t_drive_lists$seinet_list, by = "taxon_id") |>
    left_join(t_drive_lists$imbcr_list, by = "taxon_id") |>
    left_join(t_drive_lists$state_list, by = "taxon_id") |>
    rowwise() |>
    mutate(
      sum_nObs = sum(c_across(matches("nObs")), na.rm = T),
      min_year_all = min(c_across(matches("minYear")), na.rm = T),
      max_year_all = max(c_across(matches("maxYear")), na.rm = T)
    ) |>
    filter(sum_nObs > 0 & !is.na(sum_nObs))
}
