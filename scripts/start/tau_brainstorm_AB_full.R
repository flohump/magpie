# ----------------------------------------------------------
# description: Switch A and Switch B alone on default coup2100 timesteps
# position: 99
# ----------------------------------------------------------
# Two missing runs to complete the 7-run second-wave matrix:
#   tauBS_TA_maint10_full   s13_maintenance_cost = 10   (Switch A only)
#   tauBS_TB_exp07_full     s14_tau_exponent    = 0.7   (Switch B only)
#
# Launched in parallel via cfg$sequential = FALSE.

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
  list(title = "tauBS_TA_maint10_full",
       config = list(s13_maintenance_cost = 10)),
  list(title = "tauBS_TB_exp07_full",
       config = list(s14_tau_exponent_on = 1,
                     s14_tau_exponent    = 0.7))
)

for (r in runs) {
  message("\n===== Launching ", r$title, " =====")
  cfg$title <- r$title
  # reset all
  cfg$gms$s13_maintenance_cost   <- 0
  cfg$gms$s14_tau_exponent_on    <- 0
  cfg$gms$s14_tau_exponent       <- 1
  cfg$gms$s14_adoption_on        <- 0
  cfg$gms$s14_tau_degradation_on <- 0
  for (k in names(r$config)) cfg$gms[[k]] <- r$config[[k]]
  start_run(cfg, codeCheck = FALSE)
}
message("\n===== A and B launched in parallel =====")
