# ----------------------------------------------------------
# description: re-run TB (fixed gating) and TA (cost=10)
# position: 99
# ----------------------------------------------------------
# TB was compromised by a Switch B gating bug (fixed in the next
# commit on tau-degradation-experiments). TA with cost=50 was
# infeasible at y2050 under the 30-year quicktest2 jump, so we
# lower the cost to 10 USD/ha/(tau-1)/yr for this diagnostic.
# Tref is unaffected and keeps its prior fulldata.gdx.

library(lucode2)
library(gms)
source("scripts/start_functions.R")
source("config/default.cfg")

cfg$gms$c_timesteps <- "quicktest2"
cfg$results_folder  <- "output/:title:"
cfg$force_replace   <- TRUE
cfg$force_download  <- FALSE
cfg$recalibrate     <- FALSE
cfg$recalibrate_landconversion_cost <- FALSE

runs <- list(
  list(title = "tauBS_TB_exp07",
       config = list(s14_tau_exponent_on = 1, s14_tau_exponent = 0.7)),
  list(title = "tauBS_TA_maint10",
       config = list(s13_maintenance_cost = 10))
)

for (r in runs) {
  message("\n===== Re-running ", r$title, " =====")
  cfg$title <- r$title
  # reset
  cfg$gms$s14_tau_exponent_on  <- 0
  cfg$gms$s14_tau_exponent     <- 1
  cfg$gms$s13_maintenance_cost <- 0
  for (k in names(r$config)) cfg$gms[[k]] <- r$config[[k]]
  start_run(cfg, codeCheck = FALSE)
}
message("\n===== All rerun launched =====")
