### BirdNET Species List ###

# This script parses out the the species names.
# Eventually, will also join up with other species list to allow filtering.

# Check for latest data:
# https://github.com/kahst/BirdNET-Analyzer/tree/main/labels/V2.4

library(tidyverse)
library(readxl)

birdnet_species <-
  read_csv("dat/BirdNET_GLOBAL_6K_V2.4_Labels_en_uk.txt",
                    col_names = "BirdNET") |>
  separate_wider_delim(cols = "BirdNET", delim = "_",
                       names = c("Scientific Name", "English Name"),
                       cols_remove = FALSE)

# BC

bc_species <-
  read_excel("dat/summaryExport.xlsx") |>
  select(1:5, 11)

# NOTE: Pacific Chorus Frog names do not match up because of taxonomic problems.
# Manual adjustment to english synonyms made.

# Exploratory
# birdnet_bc <- full_join(birdnet_species, bc_species, by = "Scientific Name",
#                        keep = TRUE)
# write_excel_csv(birdnet_bc, "out/birdnet_bc.csv")


bc_birdnet_sci1 <- inner_join(bc_species, birdnet_species,
                             by = "Scientific Name",
                             keep = TRUE)

bc_birdnet_sci2 <- inner_join(bc_species, birdnet_species,
                              by = join_by("Scientific Name Synonyms" == "Scientific Name"),
                              keep = TRUE)

bc_birdnet_eng1 <- inner_join(bc_species, birdnet_species,
                              by = "English Name",
                              keep = TRUE)

bc_birdnet_eng2 <- inner_join(bc_species, birdnet_species,
                              by = join_by("English Name Synonyms" == "English Name"),
                              keep = TRUE)

bc_birdnet <- bind_rows(bc_birdnet_sci1, bc_birdnet_sci1,
                        bc_birdnet_eng1, bc_birdnet_eng2) |>
  distinct()


bc_birdnet

write_excel_csv(bc_birdnet, "out/bc_birdnet.csv")


# Alberta

ab_species <-
  read_excel("dat/list-of-elements-in-alberta-june-2022-vertebrates.xlsx",
             skip = 3)

ab_birdnet_sci <- inner_join(ab_species, birdnet_species,
                        by = join_by("SNAME" == "Scientific Name"),
                        keep = TRUE)

ab_birdnet_comm <- inner_join(ab_species, birdnet_species,
                        by = join_by("SCOMNAME" == "English Name"),
                        keep = TRUE)

ab_birdnet <- bind_rows(ab_birdnet_sci, ab_birdnet_comm) |>
  distinct()

write_excel_csv(ab_birdnet, "out/ab_birdnet.csv")

# Combined list, for conservative processing

ab_bc_combined <- bind_rows(ab_birdnet, bc_birdnet) |>
  select(BirdNET) |>
  distinct()

write_csv(ab_bc_combined, "out/ab_bc_combined.txt", col_names = FALSE)
