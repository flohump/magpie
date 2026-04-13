# ----------------------------------------------------------
# description: Compare tau brainstorming test-run outputs
# position: 100
# ----------------------------------------------------------
# Parses fulldata.gdx from any tauBS_* run that is present and
# produces side-by-side comparison tables (global crop yield,
# global τ, total TC cost, total cropland).
#
# Missing runs are skipped silently so the script can be run
# incrementally while runs are still solving. Delta columns are
# only shown for runs that are present alongside Tref.
#
# Usage: Rscript scripts/start/tau_brainstorm_compare.R

suppressPackageStartupMessages({
  library(magpie4)
  library(magclass)
  library(dplyr, warn.conflicts = FALSE)
  library(tidyr)
})

# In order of display: reference first, then single switches, then
# combinations. Any run whose fulldata.gdx is missing is silently skipped.
runs <- c(
  Ref   = "output/tauBS_Tref_v3/fulldata.gdx",
  A20   = "output/tauBS_TA_maint20_full/fulldata.gdx",
  C     = "output/tauBS_C_v3/fulldata.gdx",
  D     = "output/tauBS_D_v3/fulldata.gdx",
  AC20  = "output/tauBS_AC20_v3/fulldata.gdx",
  ACD   = "output/tauBS_ACD_v3/fulldata.gdx"
)

reportYears <- c(1995, 2020, 2050, 2100)

safe <- function(expr, label) {
  tryCatch(expr, error = function(e) {
    message("  ! ", label, ": ", conditionMessage(e)); NULL
  })
}

globalCropYield <- function(gdx) {
  r <- safe(reportYields(gdx), "reportYields")
  if (is.null(r)) return(NULL)
  key <- "Productivity|Yield|Crops (t DM/ha)"
  if (!(key %in% dimnames(r)[[3]])) return(NULL)
  out <- r["GLO", , key]
  data.frame(year = getYears(out, as.integer = TRUE),
             yield_tDM_ha = as.numeric(out))
}

globalTau <- function(gdx) {
  out <- safe(tau(gdx, level = "glo"), "tau")
  if (is.null(out)) return(NULL)
  data.frame(year = getYears(out, as.integer = TRUE),
             tau_avg = as.numeric(out))
}

globalTechCost <- function(gdx) {
  r <- safe(reportCostTC(gdx), "reportCostTC")
  if (is.null(r)) return(NULL)
  glo <- r["GLO", , ]
  data.frame(year = getYears(glo, as.integer = TRUE),
             techCost = as.numeric(glo))
}

globalCropland <- function(gdx) {
  out <- safe(land(gdx, level = "glo", types = "crop"), "land")
  if (is.null(out)) return(NULL)
  data.frame(year = getYears(out, as.integer = TRUE),
             cropland_mha = as.numeric(out))
}

results <- list(yield = NULL, tau = NULL, cost = NULL, cropland = NULL)
for (nm in names(runs)) {
  gdx <- runs[[nm]]
  if (!file.exists(gdx)) next
  message("parse ", nm)
  y <- globalCropYield(gdx);  if (!is.null(y)) { y$run <- nm; results$yield    <- rbind(results$yield,    y) }
  t <- globalTau(gdx);        if (!is.null(t)) { t$run <- nm; results$tau      <- rbind(results$tau,      t) }
  c <- globalTechCost(gdx);   if (!is.null(c)) { c$run <- nm; results$cost     <- rbind(results$cost,     c) }
  l <- globalCropland(gdx);   if (!is.null(l)) { l$run <- nm; results$cropland <- rbind(results$cropland, l) }
}

asWide <- function(df, valueCol) {
  if (is.null(df) || nrow(df) == 0) return(NULL)
  w <- pivot_wider(df, names_from = run, values_from = all_of(valueCol))
  w <- w[w$year %in% reportYears, ]
  if ("Ref" %in% names(w)) {
    for (col in setdiff(names(w), c("year", "Ref"))) {
      w[[paste0("d", col, "_pct")]] <- (w[[col]] / w[["Ref"]] - 1) * 100
    }
  }
  as.data.frame(w)
}

labels <- list(
  yield    = "Global crop yield (t DM / ha)",
  tau      = "Global average crop tau (1)",
  cost     = "Total TC cost (mio USD17MER / yr)",
  cropland = "Total cropland (mio ha)"
)
valueCols <- list(
  yield    = "yield_tDM_ha",
  tau      = "tau_avg",
  cost     = "techCost",
  cropland = "cropland_mha"
)

for (k in names(results)) {
  cat("\n## ", labels[[k]], "\n", sep = "")
  w <- asWide(results[[k]], valueCols[[k]])
  if (is.null(w)) { cat("(no data)\n"); next }
  for (col in setdiff(names(w), "year")) {
    w[[col]] <- formatC(w[[col]], format = "f", digits = 3, big.mark = "")
  }
  print(w, row.names = FALSE)
}

saveRDS(results, "/Users/flo/PIK/Brainstorming/TC/tauBS_results.rds")
cat("\nSaved combined tables to /Users/flo/PIK/Brainstorming/TC/tauBS_results.rds\n")
