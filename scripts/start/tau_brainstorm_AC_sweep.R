# ----------------------------------------------------------
# description: A+C sweep on coup2100 — cost ∈ {10,20,30} × C on
# position: 99
# ----------------------------------------------------------
# Three parallel runs combining the LPJmL-derived adoption dampener
# (Switch C) with three literature-bracketing maintenance cost values
# from Switch A. These are the actual recommended headline combinations
# for a model-improvement PR.
#
# Cost levels come from the Alston/Pardey R&D-depreciation range
# (2–4 %/yr), which at Dietrich's τ=1.6 lump-sum of ~200–300 USD/ha
# translates to effective maintenance ~4–12 USD/ha/yr. At τ≈1.6 the
# scalar `s13_maintenance_cost` multiplies (τ−1)=0.6 so:
#   cost=10 → 6 USD/ha/yr  (literature lower bound)
#   cost=20 → 12 USD/ha/yr (central)
#   cost=30 → 18 USD/ha/yr (above canonical, useful as upper sensitivity)

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

stopifnot(file.exists("modules/14_yields/input/f14_adoption.cs3"))

runs <- list(
  list(title = "tauBS_AC_maint10_full",
       config = list(s13_maintenance_cost = 10, s14_adoption_on = 1)),
  list(title = "tauBS_AC_maint20_full",
       config = list(s13_maintenance_cost = 20, s14_adoption_on = 1)),
  list(title = "tauBS_AC_maint30_full",
       config = list(s13_maintenance_cost = 30, s14_adoption_on = 1))
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
message("\n===== A+C sweep launched in parallel =====")
