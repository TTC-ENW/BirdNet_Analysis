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

bc_species <-
  read_excel("dat/summaryExport.xlsx")

birdnet_bc <- full_join(birdnet_species, bc_species, by = "Scientific Name") |>
  select("Scientific Name", "English Name.x", "BirdNET", "English Name.y",
         "Species Code", "Class (English)")

write_excel_csv(birdnet_bc, "out/birdnet_bc.csv")
