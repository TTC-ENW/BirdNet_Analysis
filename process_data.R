### BirdNET Analysis and NSNSDAcoustics Tools ###


library(NSNSDAcoustics)

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
