# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: Bending the Curve 2.0, run 3 (7 core scenarios)
# position: 5
# ----------------------------------------------------------

# Usage: Rscript scripts/start/projects/project_BTC2_run3.R [INT_19 REF ...] (default: all runs)

library(lucode2)
library(gms)

source("scripts/start_functions.R")
source("config/default.cfg")

cfg$info$flag <- "BTC2v09"
cfg$results_folder <- "output/:title:"
cfg$force_replace <- TRUE

# rev4.137, AgMIP regions; cellular data with the BTC2 protocol layers (consv_prio_areas incl. BTC2, f22_reconv_target)
rev <- "rev4.137BTC2v5_b9baff04"
cellHash <- c(ssp245 = "4b926f9a", ssp126 = "5033a1ce", ssp119 = "44b34b8f")
cfg$input["regional"] <- "rev4.137_b9baff04_magpie.tgz"
cfg$input["validation"] <- "rev4.137_b9baff04_92e02314_validation.tgz"
cfg$input["calibration"] <- "calibration_AgMIP_FAO_16Nov26.tgz"
# rehabilitation targets (pool B), read by the BTC2 land reporting only
cfg$files2export$start <- c(cfg$files2export$start, "input/rehab_target_0.5.mz")

# GHG prices and 2nd gen bioenergy demand from ScenarioMIP (CMIP7)
smip <- c(M = "SMIP7-M-SSP2-main", L = "SMIP7-L-SSP2-main", VL = "SMIP7-VL-SSP2-sens")
mute <- c(M = "y2150", L = "y2030", VL = "y2030")

scenarios <- list(
  REF      = list(ssp = "ssp245", smip = "M",  policy = "NPI"),
  REF_26   = list(ssp = "ssp126", smip = "L",  policy = "NDC"),
  REF_cons = list(ssp = "ssp245", smip = "M",  policy = "NPI", consv = c(2030, 2050)),
  REF_prod = list(ssp = "ssp245", smip = "M",  policy = "NPI", prod = TRUE),
  REF_phd  = list(ssp = "ssp245", smip = "M",  policy = "NPI", phd = TRUE),
  INT_26   = list(ssp = "ssp126", smip = "L",  policy = "NDC", consv = c(2050, 2100), prod = TRUE, phd = TRUE),
  INT_19   = list(ssp = "ssp119", smip = "VL", policy = "NDC", consv = c(2030, 2050), prod = TRUE, phd = TRUE)
)

runs <- commandArgs(trailingOnly = TRUE)
if (length(runs) == 0) runs <- names(scenarios)
stopifnot(all(runs %in% names(scenarios)))

cfg0 <- cfg
for (s in runs) {
  x <- scenarios[[s]]
  cfg <- setScenario(cfg0, c("SSP2", x$policy, "AR-natveg", "cc"))
  cfg$title <- paste(cfg$info$flag, s, sep = "_")
  cfg$input["cellular"] <- paste0(rev, "_", cellHash[[x$ssp]], "_cellularmagpie_c200_IPSL-CM6A-LR-",
                                  x$ssp, "_lpjml-8e6c5eb1.tgz")
  cfg$gms$c56_pollutant_prices <- cfg$gms$c56_pollutant_prices_noselect <- smip[[x$smip]]
  cfg$gms$c60_2ndgen_biodem <- cfg$gms$c60_2ndgen_biodem_noselect <- smip[[x$smip]]
  cfg$gms$c56_mute_ghgprices_until <- mute[[x$smip]]

  if (!is.null(x$consv)) {
    # Protocol layer 4 on top of WDPA by 2030; crop and pasture keep their use, cropland tau frozen from 2030
    cfg$gms$c22_protect_scenario <- cfg$gms$c22_protect_scenario_noselect <- "BTC2"
    cfg$gms$land_consv <- "crop, past, primforest, secdforest, other"
    cfg$gms$s22_restore_land <- 0
    cfg$gms$s22_conservation_target <- 2030
    cfg$gms$c13_croparea_consv <- 1
    cfg$gms$c13_croparea_consv_tau_increase <- 0
    cfg$gms$s13_croparea_consv_tau_factor <- cfg$gms$s13_croparea_consv_tau_factor_noselect <- 1
    cfg$gms$s13_croparea_consv_start <- 2030
    cfg$gms$s13_croparea_consv_target <- 2050
    # Reconversion of pools C and D: 2030 targets by consv[1], cumulative 2050 targets by consv[2]
    cfg$gms$s22_reconversion <- 1
    cfg$gms$s22_reconv_year1 <- x$consv[1]
    cfg$gms$s22_reconv_year2 <- x$consv[2]
  }

  if (isTRUE(x$prod)) {
    # SSP1 production settings
    cfg$gms$c42_env_flow_policy <- "on"
    cfg$gms$c50_scen_neff <- "baseeff_add3_add10_add20_max75"
    cfg$gms$c55_scen_conf <- "ssp1"
    cfg$gms$c70_feed_scen <- "ssp1"
  }

  if (isTRUE(x$phd)) {
    # EAT-Lancet 2 planetary health diet and halved food waste, linear to 2050
    cfg$gms$s15_exo_diet <- 3
    cfg$gms$s15_exo_waste <- 1
    cfg$gms$s15_waste_scen <- 1.25
    cfg$gms$s15_exo_brans <- 1
    cfg$gms$s15_exo_foodscen_target <- 2050
  }

  # per run: priority while fewer than 5 priority jobs are held
  cfg$qos <- if (length(system("squeue -u $USER -h -q priority -o %i", intern = TRUE)) < 5) "priority" else "standby"
  start_run(cfg, codeCheck = FALSE)
}
