# ----------------------------------------------------------
# description: AC20 + D_lit — fully literature-anchored τ correction
# position: 99
# ----------------------------------------------------------
# Final model-improvement configuration combining all three defensible
# switches at literature-anchored parameter values:
#
#   A  s13_maintenance_cost   = 20    (Alston/Pardey canonical 3 %/yr R&D depreciation)
#   C  s14_adoption_on        = 1     (LPJmL-derived α(j,w) from f14_adoption.cs3)
#   D  s14_tau_degradation_on = 1     (rates from Borrelli 2017/2021, Lal 2004,
#                                      Sanderman 2017, IPBES 2018; ceiling tightened
#                                      to [1.25, 2.5] per Cassman & Grassini 2020)
#
# Switch B is deliberately NOT enabled — redundant with Dietrich's
# cost-side concavity unless the cost exponent is jointly recalibrated.

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
stopifnot(file.exists("modules/14_yields/input/f14_tau_ceiling.cs3"))

cfg$title <- "tauBS_ACD_lit"

# reset
cfg$gms$s13_maintenance_cost   <- 0
cfg$gms$s14_tau_exponent_on    <- 0
cfg$gms$s14_tau_exponent       <- 1
cfg$gms$s14_adoption_on        <- 0
cfg$gms$s14_tau_degradation_on <- 0

# A: maintenance cost at Alston/Pardey central value
cfg$gms$s13_maintenance_cost   <- 20

# C: LPJmL adoption dampener
cfg$gms$s14_adoption_on        <- 1

# D: overshoot degradation with literature-anchored rates
cfg$gms$s14_tau_degradation_on <- 1
cfg$gms$s14_tau_degr_rate      <- 0.005
cfg$gms$s14_tau_rec_rate       <- 0.001
cfg$gms$s14_tau_degr_max       <- 0.30

start_run(cfg, codeCheck = FALSE)
message("\n===== ACD_lit launched =====")
