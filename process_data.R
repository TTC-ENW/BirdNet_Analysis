### BirdNET Analysis and NSNSDAcoustics Tools ###


library(NSNSDAcoustics)
library(tidyverse)
library(hms)


# Directory for birdnet result files. All in one folder.
dir_birdnet_out <- "C:/Users/jeff.matheson/audio_files/Squamish/birdnet_out"

# Format BirdNET outputs
birdnet_format(results.directory = dir_birdnet_out,
               timezone = 'Canada/Pacific')

# Gather formatted results in one data frame
formatted.results <- birdnet_gather(
  results.directory = dir_birdnet_out,
  formatted = TRUE
)


# Create Site ID and date/time from the filename.


formatted.results <-
  formatted.results |>
  separate_wider_delim(
    recordingID,
    "_",
    names = c("site_id", "date", "time"),
    cols_remove = FALSE,
    too_many = "drop")

formatted.results$time <- str_sub(formatted.results$time, 1, 6)
formatted.results$date <- ymd(formatted.results$date)
formatted.results$time <- as_hms(parse_date_time(formatted.results$time, "HMS"))

# Summarize Data



