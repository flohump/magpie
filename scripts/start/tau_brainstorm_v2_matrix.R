# ----------------------------------------------------------
# description: v2 matrix — 5 reruns on in-GAMS C/D derivation
# position: 99
# ----------------------------------------------------------
# After moving i14_adoption and i14_tau_ceiling into preloop.gms (derived
# from crop-area-weighted LPJmL means across knbe14 food/feed crops),
# regenerate the 5 scenarios that touch Switches C and/or D so the
# headline matrix is consistent with the in-GAMS derivation.
#
# Runs affected by the refactor:
#   tauBS_C_v2       Switch C alone
#   tauBS_D_lit_v2   Switch D alone with literature-anchored rate
#   tauBS_AC10_v2    A10 + C
#   tauBS_AC30_v2    A30 + C
#   tauBS_ACD_lit_v2 A20 + C + D_lit (full package)
#
# AC20_v2 was already run during the v2 check and does not need rerunning.
# Ref, A10-alone, A20-alone, A30-alone, A50-alone are unaffected by the
# refactor (they don't read C or D inputs) and do not need rerunning.
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
  list(title = "tauBS_C_v2",
       config = list(s14_adoption_on = 1)),
  list(title = "tauBS_D_lit_v2",
       config = list(s14_tau_degradation_on = 1,
                     s14_tau_degr_rate      = 0.005,
                     s14_tau_rec_rate       = 0.001,
                     s14_tau_degr_max       = 0.30)),
  list(title = "tauBS_AC10_v2",
       config = list(s13_maintenance_cost = 10,
                     s14_adoption_on      = 1)),
  list(title = "tauBS_AC30_v2",
       config = list(s13_maintenance_cost = 30,
                     s14_adoption_on      = 1)),
  list(title = "tauBS_ACD_lit_v2",
       config = list(s13_maintenance_cost   = 20,
                     s14_adoption_on        = 1,
                     s14_tau_degradation_on = 1,
                     s14_tau_degr_rate      = 0.005,
                     s14_tau_rec_rate       = 0.001,
                     s14_tau_degr_max       = 0.30))
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
message("\n===== v2 matrix (5 runs) launched in parallel =====")
