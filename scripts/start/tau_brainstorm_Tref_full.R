# ----------------------------------------------------------
# description: tau brainstorming reference run on default coup2100 timesteps
# position: 99
# ----------------------------------------------------------
# Baseline with all new switches OFF so TC/TD/TAB/TABCD can be compared
# against a proper 18-timestep coup2100 reference (the earlier tauBS_Tref
# used only quicktest2 = 4 timesteps, which is not directly comparable
# to the new parallel runs).

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

# Make sure all brainstorm switches are default-off
cfg$gms$s13_maintenance_cost   <- 0
cfg$gms$s14_tau_exponent_on    <- 0
cfg$gms$s14_tau_exponent       <- 1
cfg$gms$s14_adoption_on        <- 0
cfg$gms$s14_tau_degradation_on <- 0

cfg$title <- "tauBS_Tref_full"
start_run(cfg, codeCheck = FALSE)
message("\n===== Tref_full launched in the background =====")
