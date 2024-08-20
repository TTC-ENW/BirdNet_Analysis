### BirdNET Analysis and NSNSDAcoustics Tools ###


library(NSNSDAcoustics)
library(tidyverse)
library(hms)

# Directory for birdnet result files. All in one folder.
dir_birdnet_out <-
  "C:/Users/jeff.matheson/audio_files/waterbirds"

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
    too_many = "drop") |>
  mutate(time = str_sub(time, 1, 6),
         time = as_hms(parse_date_time(time, "HMS")),
         date = ymd(date)
         )

## Summarize Data

# Species list by site

sp_list <- formatted.results |>
  group_by(site_id, common_name) |>
  summarise(hits = n()) |>
  pivot_wider(names_from = "site_id", values_from = "hits") |>
  arrange(common_name)
sp_list


# Total count by date
formatted.results |>
  group_by(common_name, date) |>
  summarise(detections = n()) |>
  ggplot(aes(date, detections)) +
  geom_smooth() +
  theme_bw()


# Prediction confidence by species

formatted.results |>
  # group_by(common_name) |>
  # summarise(conf_mean = mean(confidence)) |>
  #arrange((conf_mean)) |>
  ggplot(aes(common_name, confidence, group = common_name)) +
  geom_boxplot() +
  coord_flip() +
  theme_bw() +
  scale_x_discrete(limits=rev)


