# ----------------------------------------------------------
# description: tau brainstorming test runs (T-ref, T-B, T-A)
# position: 99
# ----------------------------------------------------------
# Run three short scenarios on quicktest2 timesteps to bracket
# the effect of the four new tau-side switches implemented on
# branch `tau-degradation-experiments`.
#
# T-ref: all new switches off  (regression vs baseline)
# T-B:   s14_tau_exponent_on=1, s14_tau_exponent=0.7  (concave)
# T-A:   s13_maintenance_cost=50                      (maintenance)
#
# quicktest2 = y1995, y2020, y2050, y2100 (4 timesteps)
# Each run produces its own output folder under output/.
#
# Florian Humpenoeder brainstorming, 2026-04-10.

library(lucode2)
library(gms)

source("scripts/start_functions.R")
source("config/default.cfg")

# Shared settings for all three runs.
cfg$gms$c_timesteps <- "quicktest2"
cfg$results_folder  <- "output/:title:"
cfg$force_replace   <- TRUE
# Avoid re-downloading / re-calibrating input data — reuse whatever the
# user's develop branch has already prepared in input/.
cfg$force_download   <- FALSE
cfg$recalibrate      <- FALSE
cfg$recalibrate_landconversion_cost <- FALSE

runs <- list(
  list(
    title  = "tauBS_Tref",
    config = list()  # defaults = all new switches off
  ),
  list(
    title  = "tauBS_TB_exp07",
    config = list(
      s14_tau_exponent_on = 1,
      s14_tau_exponent    = 0.7
    )
  ),
  list(
    title  = "tauBS_TA_maint50",
    config = list(
      s13_maintenance_cost = 50
    )
  )
)

for (r in runs) {
  message("\n===== Launching ", r$title, " =====")
  cfg$title <- r$title
  # Reset the three switches first so carry-over between iterations is explicit.
  cfg$gms$s14_tau_exponent_on  <- 0
  cfg$gms$s14_tau_exponent     <- 1
  cfg$gms$s13_maintenance_cost <- 0
  # Apply per-run overrides.
  for (k in names(r$config)) {
    cfg$gms[[k]] <- r$config[[k]]
  }
  message("  c_timesteps        : ", cfg$gms$c_timesteps)
  message("  s14_tau_exponent_on: ", cfg$gms$s14_tau_exponent_on)
  message("  s14_tau_exponent   : ", cfg$gms$s14_tau_exponent)
  message("  s13_maintenance_cost: ", cfg$gms$s13_maintenance_cost)
  start_run(cfg, codeCheck = FALSE)
}

message("\n===== All runs launched =====")
