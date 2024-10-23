### BirdNET Analysis ###

## In Develoment ##


# The BirdNet output format needs to be "R" for any of this to work.


# Load libraries
library(NSNSDAcoustics)
library(tidyverse)
library(hms)

# Directory for birdnet result files. All in one folder.
# Change to path to point to your folder.

dir_birdnet_out <-
  "C:/Users/jeff.matheson/audio_files/waterbirds"

# Format BirdNET outputs
birdnet_format(results.directory = dir_birdnet_out,
               timezone = 'Canada/Pacific')

# Gather formatted results in one data frame
formatted_results <- birdnet_gather(
  results.directory = dir_birdnet_out,
  formatted = TRUE)


# Create Site ID and date/time from the filename.
# Note that the code below assumes the filename format is the usual format
# from Wildlife Acoustics recordings. If not typical, then you will need to
# revise the code.

formatted_results <-
  formatted_results |>
  separate_wider_delim(
    recordingID,
    "_",
    names = c("site_id", "date", "time"),
    cols_remove = FALSE,
    too_many = "drop") |>
  mutate(time = str_sub(time, 1, 6),
         time = as_hms(parse_date_time(time, "HMS")),
         date = ymd(date)
         )


## Summarize data.Just a couple of options.

# Species list by site

sp_list <- formatted_results |>
  group_by(site_id, common_name) |>
  summarise(hits = n()) |>
  pivot_wider(names_from = "site_id", values_from = "hits") |>
  arrange(common_name)
sp_list


# Total count by date
formatted_results |>
  group_by(common_name, date) |>
  summarise(detections = n()) |>
  ggplot(aes(date, detections)) +
  geom_smooth() +
  theme_bw()


# Prediction score by species

# Note - these scores are not confidences and cannot be compared among species.

formatted.results |>
  # group_by(common_name) |>
  # summarise(conf_mean = mean(confidence)) |>
  #arrange((conf_mean)) |>
  ggplot(aes(common_name, confidence, group = common_name)) +
  geom_boxplot() +
  coord_flip() +
  theme_bw() +
  scale_x_discrete(limits=rev)


