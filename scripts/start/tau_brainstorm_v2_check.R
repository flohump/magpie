# ----------------------------------------------------------
# description: v2 check — regression + AC20 on in-GAMS derivation
# position: 99
# ----------------------------------------------------------
# After moving f14_adoption / f14_tau_ceiling derivation out of the
# external R generator and into `preloop.gms` (using crop-area-weighted
# means across `knbe14`), we verify:
#   1. tauBS_Tref_v2  — all switches off, should match tauBS_Tref_full bit-for-bit
#   2. tauBS_AC20_v2  — A20 + C, should be close to tauBS_AC_maint20_full
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
  list(title = "tauBS_Tref_v2",
       config = list()),
  list(title = "tauBS_AC20_v2",
       config = list(s13_maintenance_cost = 20, s14_adoption_on = 1))
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
message("\n===== v2 check launched =====")
