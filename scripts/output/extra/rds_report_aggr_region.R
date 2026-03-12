# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------------
# description: extract report in rds and mif format from run with additional aggregated regions
# comparison script: FALSE
# ---------------------------------------------------------------

library(magclass)
library(magpie4)
library(gms)
library(quitte)
source("scripts/helper.R")
options("magclass.verbosity" = 1)

############################# BASIC CONFIGURATION #############################
if (!exists("source_include")) {
  readArgs("outputdir")
  stopifnot(exists("outputdir"))
}

cfg <- gms::loadConfig(file.path(outputdir, "config.yml"))
gdx <- file.path(outputdir, "fulldata.gdx")
rds <- file.path(outputdir, "report.rds")
mif <- sub(".rds", ".mif", rds)
runstatistics  <- file.path(outputdir, "runstatistics.rda")
###############################################################################

#
# Find aggregated region mapping and convert to long format
#
regionmappings <- setdiff(list.files(outputdir, pattern = "regionmapping.*csv"),
                          "regionmappingH12.csv")
if (length(regionmappings) == 1) {
  mapping <- mappingToLongFormat(file.path(outputdir, regionmappings[[1]]))
  aggrRegionMappingFile <- file.path(outputdir, "report_aggr_region_mapping.csv")
  write.csv(mapping, aggrRegionMappingFile, row.names = FALSE)
} else {
  stop("Found more than one non-standard regionmapping in the output dir, thus automatic detection of ",
       "aggregated region mapping failed.")
}

#
# Generate and upload report with aggregated regions
#
report <- getReport(gdx, scenario = cfg$title, level = aggrRegionMappingFile)

for (mapping in c("AR6", "NAVIGATE", "SHAPE", "AR6_MAgPIE")) {
  expectVariablesPresent(report, piamInterfaces::getMappingVariables(mapping, "M"))
}

write.report(report, file = mif)

qu <- useWorld(as.quitte(report))

saveRDS(qu, file = rds, version = 2)

saveToResultsArchive(qu, runstatistics, submit = cfg$runstatistics)
