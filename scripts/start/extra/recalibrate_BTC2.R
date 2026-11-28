# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: land conversion cost calibration for BTC2 (AgMIP regions, IPSL-CM6A-LR ssp245)
# --------------------------------------------------------

source("scripts/start_functions.R")
source("config/default.cfg")

rev <- "rev4.138BTC2v7_b9baff04"
cfg$input["regional"] <- paste0(rev, "_magpie.tgz")
cfg$input["validation"] <- paste0(rev, "_92e02314_validation.tgz")
cfg$input["cellular"] <- paste0(rev, "_4b926f9a_cellularmagpie_c200_IPSL-CM6A-LR-ssp245_lpjml-8e6c5eb1.tgz")
cfg$input["calibration"] <- ""

cfg$title <- "calib_run_AgMIP"
cfg$results_folder <- "output/:title:"
cfg$force_replace <- TRUE
cfg$recalibrate <- FALSE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$output <- c("rds_report")
cfg$qos <- if (length(system("squeue -u $USER -h -q priority -o %i", intern = TRUE)) < 5) "priority" else "standby"
start_run(cfg, codeCheck = FALSE)
magpie4::submitCalibration("AgMIP_FAO")
