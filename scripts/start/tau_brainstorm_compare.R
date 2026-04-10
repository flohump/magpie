# ----------------------------------------------------------
# description: Compare tau brainstorming test-run outputs
# position: 100
# ----------------------------------------------------------
# Parses fulldata.gdx from the tauBS_* runs using magpie4 helpers
# and produces comparison tables: global crop yield, global tau,
# cropland area, total TC cost. Optionally reads additional runs.
#
# Usage: Rscript scripts/start/tau_brainstorm_compare.R

suppressPackageStartupMessages({
  library(magpie4)
  library(magclass)
  library(dplyr, warn.conflicts = FALSE)
  library(tidyr)
})

runs <- c(
  Tref = "output/tauBS_Tref/fulldata.gdx",
  TB   = "output/tauBS_TB_exp07/fulldata.gdx",
  TA   = "output/tauBS_TA_maint50/fulldata.gdx"
)

reportYears <- c("y1995", "y2020", "y2050", "y2100")

# ---- helpers ------------------------------------------------

safe <- function(expr, label) {
  v <- tryCatch(expr, error = function(e) {
    message("  ! ", label, ": ", conditionMessage(e)); NULL
  })
  v
}

# Aggregate global crop yield from reportYields() "Productivity|Yield|Crops (t DM/ha)"
globalCropYield <- function(gdx) {
  r <- safe(reportYields(gdx), "reportYields")
  if (is.null(r)) return(NULL)
  key <- "Productivity|Yield|Crops (t DM/ha)"
  if (!(key %in% dimnames(r)[[3]])) {
    message("  key not found: ", key); return(NULL)
  }
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
  # reportCostTC returns a (i, t) magpie object for a single scalar indicator
  # The GLO row is the total.
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

# ---- parse --------------------------------------------------

results <- list(yield = NULL, tau = NULL, cost = NULL, cropland = NULL)

for (nm in names(runs)) {
  gdx <- runs[[nm]]
  if (!file.exists(gdx)) {
    message("skip ", nm, " (missing: ", gdx, ")"); next
  }
  message("parse ", nm)
  y <- globalCropYield(gdx);  if (!is.null(y)) { y$run <- nm; results$yield    <- rbind(results$yield,    y) }
  t <- globalTau(gdx);        if (!is.null(t)) { t$run <- nm; results$tau      <- rbind(results$tau,      t) }
  c <- globalTechCost(gdx);   if (!is.null(c)) { c$run <- nm; results$cost     <- rbind(results$cost,     c) }
  l <- globalCropland(gdx);   if (!is.null(l)) { l$run <- nm; results$cropland <- rbind(results$cropland, l) }
}

# ---- print --------------------------------------------------

asWide <- function(df, valueCol) {
  if (is.null(df) || nrow(df) == 0) return(NULL)
  w <- pivot_wider(df, names_from = run, values_from = all_of(valueCol))
  w$year_str <- paste0("y", w$year)
  w <- w[w$year_str %in% reportYears, ]
  w <- w[, setdiff(names(w), "year_str")]
  if (all(c("Tref", "TB") %in% names(w))) w$dTB_pct <- (w$TB / w$Tref - 1) * 100
  if (all(c("Tref", "TA") %in% names(w))) w$dTA_pct <- (w$TA / w$Tref - 1) * 100
  w
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
  # convert to plain data.frame for pretty printing
  w <- as.data.frame(w)
  for (col in setdiff(names(w), "year")) {
    w[[col]] <- formatC(w[[col]], format = "f", digits = 3, big.mark = "")
  }
  print(w, row.names = FALSE)
}

saveRDS(results, "/Users/flo/PIK/Brainstorming/TC/tauBS_results.rds")
cat("\nSaved to /Users/flo/PIK/Brainstorming/TC/tauBS_results.rds\n")
