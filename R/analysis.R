# R/analysis.R
library(dplyr)

calculate_kpis <- function(df) {
  list(
    total_respondents = nrow(df),
    avg_sleep = mean(df$SleepHours, na.rm = TRUE),
    avg_stress = mean(df$StressLevel, na.rm = TRUE),
    avg_mood = mean(df$MoodScore, na.rm = TRUE)
  )
}

stress_distribution <- function(df) {
  df %>%
    count(StressLevel) %>%
    mutate(Percentage = n / sum(n) * 100)
}

avg_stress_by_occupation <- function(df) {
  df %>%
    group_by(Occupation) %>%
    summarise(AvgStress = mean(StressLevel, na.rm = TRUE))
}

avg_mood_by_occupation <- function(df) {
  df %>%
    group_by(Occupation) %>%
    summarise(AvgMood = mean(MoodScore, na.rm = TRUE))
}
