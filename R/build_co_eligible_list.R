build_co_eligible_list <- function(CO_natureserve_state_list, r2_ss_list, co_swap_list, co_te_list, gmug_scc_list) {
  ns_list_cl <- CO_natureserve_state_list |>
    select(
      taxon_id,
      scientific_name,
      common_name,
      species_group_broad,
      species_group_fine,
      usfws_status = u_s_endangered_species_act_status,
      gRank = nature_serve_rounded_global_rank,
      CO_sRank,
      kingdom:species,
      subspecies:form
    )

  r2_ss_list_cl <- r2_ss_list |>
    select(
      taxon_id,
      R2_ss_list = status_a,
    )

  co_swap_list_cl <- co_swap_list |>
    select(
      taxon_id,
      CO_swap = status_r
    )

  co_te_list_cl <- co_te_list |>
    select(
      taxon_id,
      CO_te = status_r
    )

  gmug_scc_list_cl <- gmug_scc_list |>
    mutate(scc_status = paste(status_s, status_r, sep = " - ")) |>
    select(
      taxon_id,
      GMUG_scc_list = scc_status
    )

  comprehensive_list <- ns_list_cl |>
    left_join(r2_ss_list_cl, by = "taxon_id") |>
    left_join(co_swap_list_cl, by = "taxon_id") |>
    left_join(co_te_list_cl, by = "taxon_id") |>
    left_join(gmug_scc_list_cl, by = "taxon_id") |>
    select(
      taxon_id:CO_sRank,
      R2_ss_list:GMUG_scc_list,
      everything()
    )

  eligible_list <- comprehensive_list |>
    filter(
      str_detect(gRank, "[GT][123]") | # G or T 1,2 and 3
        str_detect(CO_sRank, "[ST][12]") | # CO S or T 1 or 2
        !is.na(R2_ss_list) | # R2 sensitive species
        CO_swap == "Tier 1" | # Colorado SWAP Tier 1
        str_detect(CO_te, "Threatened|Endangered") | # CNHP Threatened or endangered
        !is.na(GMUG_scc_list) # GMUG SCC list Designated
    ) |>
    distinct()

  eligible_list
}
