# ----------------------------------------------------------
# description: Derive f14_adoption.cs3 and f14_tau_ceiling.cs3 from LPJmL yields
# position: 97
# ----------------------------------------------------------
# Generates cluster- and water-regime-specific inputs for Switches C and D
# using modules/14_yields/input/lpj_yields.cs3 as the biophysical proxy.
#
# Switch C — adoption dampener α(j,w)
#   For each super-region h and each water regime w, compute a percentile
#   rank of the cluster's 1995 LPJmL yield averaged across staple crops
#   (tece, maiz, rice_pro). Map percentile p to
#       α = 0.4 + 0.6·p  ∈ [0.4, 1.0]
#   Rationale: cells in the top quartile of biophysical productivity within
#   a region adopt fully; marginal cells only absorb ~40 % of the τ uplift.
#
# Switch D — sustainable τ ceiling f14_tau_ceiling(j,w)
#   For each (j,w) compute the LPJmL-driven yield growth factor
#       y_ratio(j,w) = mean(staples, y_2100) / mean(staples, y_1995)
#   and map to
#       ceiling = clip(1.5 + 0.5·(y_ratio − 1), 1.3, 3.0)
#   Rationale: cells where LPJmL says climate will push yields up have
#   biophysical room for intensification (high ceiling); cells where
#   yields stagnate or decline run into degradation earlier (low ceiling).
#
# Output: two cs3 files in modules/14_yields/input/ matching the (j,w)
# indexing expected by the $if exist blocks in input.gms.

suppressPackageStartupMessages(library(magclass))

staples <- c("tece", "maiz", "rice_pro")

lpj <- read.magpie("modules/14_yields/input/lpj_yields.cs3")
cat("lpj_yields dim:", dim(lpj), "\n")
cat("cells (clusters):", length(getCells(lpj)), "\n")

# Extract staple yields (cells × years × staples × water) and average across crops
lpj_st <- collapseNames(lpj[, , staples])
# lpj_st now has structure (j, t, crop.water) — need to aggregate staples per water regime
waters <- c("rainfed", "irrigated")

y1995 <- array(NA_real_, dim = c(length(getCells(lpj)), length(waters)),
               dimnames = list(getCells(lpj), waters))
y2100 <- y1995

for (w in waters) {
  vals <- sapply(staples, function(c) as.numeric(lpj[, "y1995", paste(c, w, sep = ".")]))
  y1995[, w] <- rowMeans(vals, na.rm = TRUE)
  vals <- sapply(staples, function(c) as.numeric(lpj[, "y2100", paste(c, w, sep = ".")]))
  y2100[, w] <- rowMeans(vals, na.rm = TRUE)
}

cat("y1995 summary:\n"); print(summary(as.numeric(y1995)))
cat("y2100 summary:\n"); print(summary(as.numeric(y2100)))

# Identify super-region for each cluster (region code is the prefix in cell id, e.g. "CAZ.1")
regs <- sub("\\..*$", "", getCells(lpj))
cat("regions:"); print(unique(regs))

# --- Switch C: percentile rank → α ∈ [0.4, 1.0] ---
alpha <- y1995 * 0 + 1  # default 1 (no dampening)
for (r in unique(regs)) {
  idx <- which(regs == r)
  for (w in waters) {
    y <- y1995[idx, w]
    # cells with zero baseline yield get α = 0.4 (marginal by definition)
    ranks <- rank(y, ties.method = "average", na.last = "keep")
    p <- (ranks - 1) / max(1, length(ranks) - 1)   # 0..1 within region
    p[is.na(p)] <- 0
    alpha[idx, w] <- 0.4 + 0.6 * p
  }
}
alpha[y1995 <= 0] <- 0.4
cat("alpha range:", range(alpha), "\n")
cat("alpha mean by water:\n"); print(apply(alpha, 2, mean))

# --- Switch D: y_ratio → ceiling ∈ [1.3, 3.0] ---
y_ratio <- ifelse(y1995 > 0, y2100 / y1995, 1.0)
# pmin/pmax cap: very large ratios (e.g. cells starting near 0) are clipped
y_ratio <- pmin(pmax(y_ratio, 0.5), 5.0)
ceiling_ <- 1.5 + 0.5 * (y_ratio - 1)
ceiling_ <- pmin(pmax(ceiling_, 1.3), 3.0)
cat("ceiling range:", range(ceiling_), "\n")
cat("ceiling mean by water:\n"); print(apply(ceiling_, 2, mean))

# --- Write as magclass and export to cs3 ---
alpha_mag <- new.magpie(cells_and_regions = getCells(lpj),
                        names = waters, fill = 0,
                        sets = c("region", "cell", "w"))
for (w in waters) alpha_mag[, , w] <- alpha[, w]

ceiling_mag <- new.magpie(cells_and_regions = getCells(lpj),
                          names = waters, fill = 0,
                          sets = c("region", "cell", "w"))
for (w in waters) ceiling_mag[, , w] <- ceiling_[, w]

write.magpie(alpha_mag,   "modules/14_yields/input/f14_adoption.cs3")
write.magpie(ceiling_mag, "modules/14_yields/input/f14_tau_ceiling.cs3")

cat("\nWrote:\n")
cat("  modules/14_yields/input/f14_adoption.cs3\n")
cat("  modules/14_yields/input/f14_tau_ceiling.cs3\n")
cat("\nspot check alpha head:\n"); print(head(alpha_mag))
cat("\nspot check ceiling head:\n"); print(head(ceiling_mag))
