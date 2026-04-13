# ----------------------------------------------------------
# description: Switch A sensitivity sweep on coup2100 (cost=20,30,50)
# position: 99
# ----------------------------------------------------------
# Three parallel coup2100 runs on s13_maintenance_cost ∈ {20, 30, 50}.
# Tests whether the quicktest2 infeasibility at cost=50 was a 30-yr
# timestep-jump artefact or a fundamental constraint, and brackets the
# Alston/Pardey R&D-depreciation canonical range (2–4 %/yr, which for
# the Dietrich cost stock translates to ~4–12 USD/ha/yr effective at
# τ=1.6, i.e. roughly s13_maintenance_cost ≈ 7–20 at τ=1.6).

library(lucode2)
library(gms)
source("scripts/start_functions.R")
source("config/default.cfg")

cfg$results_folder  <- "output/:title:"
cfg$force_replace   <- TRUE
cfg$force_download  <- FALSE
cfg$recalibrate     <- FALSE
cfg$recalibrate_landconversion_cost <- FALSE
cfg$sequential      <- FALSE
cfg$output          <- c("rds_report")

runs <- list(
  list(title = "tauBS_TA_maint20_full", config = list(s13_maintenance_cost = 20)),
  list(title = "tauBS_TA_maint30_full", config = list(s13_maintenance_cost = 30)),
  list(title = "tauBS_TA_maint50_full", config = list(s13_maintenance_cost = 50))
)

for (r in runs) {
  message("\n===== Launching ", r$title, " =====")
  cfg$title <- r$title
  cfg$gms$s13_maintenance_cost   <- 0
  cfg$gms$s14_tau_exponent_on    <- 0
  cfg$gms$s14_tau_exponent       <- 1
  cfg$gms$s14_adoption_on        <- 0
  cfg$gms$s14_tau_degradation_on <- 0
  for (k in names(r$config)) cfg$gms[[k]] <- r$config[[k]]
  start_run(cfg, codeCheck = FALSE)
}
message("\n===== A-sensitivity runs launched in parallel =====")
