build_t_drive_lists <- function(x) {
  ## Need to complete State data
  state_rdata <- file.path(x, "state_nhp.RData")
  attach(state_rdata)

  state_list <- state_list |>
    filter(CONHP_locale == "WRFN") |>
    select(taxon_id, CONHP_nObs,
      CONHP_minYear = CONHP_firstYear,
      CONHP_maxYear = CONHP_lastYear
    )
  detach()

  ## GBIF
  gbif_rdat <- file.path(x, "gbif.RData")
  attach(gbif_rdat)

  gbif_list <- gbif_list |>
    filter(GBIF_locale == "WRFN") |>
    select(taxon_id, GBIF_nObs:GBIF_maxYear) |>
    group_by(taxon_id) |>
    summarize(
      GBIF_nObs = max(GBIF_nObs, na.rm = T),
      GBIF_minYear = min(GBIF_minYear, na.rm = T),
      GBIF_maxYear = max(GBIF_maxYear, na.rm = T)
    ) |>
    ungroup()

  detach()

  ## Seinet

  seinet_rdat <- file.path(x, "seinet.RData")
  attach(seinet_rdat)

  seinet_list <- seinet_list |>
    filter(SEI_locale == "WRFN") |>
    select(taxon_id, SEI_nObs:SEI_maxYear) |>
    group_by(taxon_id) |>
    summarize(
      SEI_nObs = sum(SEI_nObs),
      SEI_minYear = min(SEI_minYear),
      SEI_maxYear = max(SEI_maxYear)
    ) |>
    ungroup()

  detach()

  ## IMBCR
  imbcr_rdat <- file.path(x, "imbcr.RData")
  attach(imbcr_rdat)

  imbcr_list <- imbcr_list |>
    filter(IMBCR_locale == "WRFN") |>
    select(taxon_id, IMBCR_nObs:IMBCR_maxYear)

  detach()

  lst(
    state_list,
    gbif_list,
    seinet_list,
    imbcr_list
  )
}
