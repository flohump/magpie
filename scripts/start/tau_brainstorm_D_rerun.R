# ----------------------------------------------------------
# description: Switch D rerun with literature-anchored parameters
# position: 99
# ----------------------------------------------------------
# Replaces the expert-guessed Switch D parameters with literature
# anchors from the D-parameter research round:
#
#   s14_tau_degr_rate 0.02   -> 0.005  (Borrelli 2017/2021, IPBES 2018,
#                                        Lal 2004 imply 0.003-0.010/yr)
#   s14_tau_rec_rate  0.001  -> 0.001  (Sanderman 2017, Minasny 2017:
#                                        keep; it already lands inside
#                                        the 0.0005-0.002/yr range)
#   s14_tau_degr_max  0.30   -> 0.30   (IPBES 2018, GLADA, Montpellier
#                                        Panel: central 0.2-0.4)
#   ceiling bounds    [1.3, 3.0] -> [1.25, 2.5]
#                                        (Lobell 2009, Cassman & Grassini
#                                        2020: "80 % of Yp" rule; 3.0
#                                        had no literature support)
#
# The ceiling bounds live in scripts/start/tau_brainstorm_make_inputs.R
# and the regenerated f14_tau_ceiling.cs3 is already on disk.
#
# Launched alongside any currently-running jobs via sequential=FALSE.

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

stopifnot(file.exists("modules/14_yields/input/f14_tau_ceiling.cs3"))

cfg$title <- "tauBS_D_lit"
cfg$gms$s13_maintenance_cost   <- 0
cfg$gms$s14_tau_exponent_on    <- 0
cfg$gms$s14_tau_exponent       <- 1
cfg$gms$s14_adoption_on        <- 0
cfg$gms$s14_tau_degradation_on <- 1
cfg$gms$s14_tau_degr_rate      <- 0.005  # literature-anchored
cfg$gms$s14_tau_rec_rate       <- 0.001  # unchanged
cfg$gms$s14_tau_degr_max       <- 0.30   # unchanged
start_run(cfg, codeCheck = FALSE)
message("\n===== D_lit launched =====")
