# ----------------------------------------------------------
# description: v3 matrix - C governance+distance, D SOM-coupled
# position: 99
# ----------------------------------------------------------
# After replacing the LPJmL-based C derivation with governance + travel
# time, and replacing the LPJmL-ceiling-based D mechanism with a
# SOM-coupled yield feedback (using 59_som's pcm_carbon_density), rerun
# the headline matrix to compare against the v2 numbers.
#
#   tauBS_Tref_v3   regression check (all switches off)
#   tauBS_C_v3      Switch C alone (governance + distance)
#   tauBS_D_v3      Switch D2 alone (SOM coupling)
#   tauBS_AC20_v3   A20 + C
#   tauBS_ACD_v3    A20 + C + D2 (full package)
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
  list(title = "tauBS_Tref_v3",  config = list()),
  list(title = "tauBS_C_v3",     config = list(s14_adoption_on = 1)),
  list(title = "tauBS_D_v3",     config = list(s14_som_yld_loss_on = 1)),
  list(title = "tauBS_AC20_v3",  config = list(s13_maintenance_cost = 20,
                                               s14_adoption_on      = 1)),
  list(title = "tauBS_ACD_v3",   config = list(s13_maintenance_cost = 20,
                                               s14_adoption_on      = 1,
                                               s14_som_yld_loss_on  = 1))
)

for (r in runs) {
  message("\n===== Launching ", r$title, " =====")
  cfg$title <- r$title
  cfg$gms$s13_maintenance_cost <- 0
  cfg$gms$s14_tau_exponent_on  <- 0
  cfg$gms$s14_tau_exponent     <- 1
  cfg$gms$s14_adoption_on      <- 0
  cfg$gms$s14_som_yld_loss_on  <- 0
  for (k in names(r$config)) cfg$gms[[k]] <- r$config[[k]]
  start_run(cfg, codeCheck = FALSE)
}
message("\n===== v3 matrix launched =====")
