# R/data_cleaning.R
library(dplyr)
library(tidyr)

clean_survey_data <- function(filepath) {
  if (!file.exists(filepath)) {
    stop("Survey dataset could not be found.")
  }
  
  df <- read.csv(filepath, stringsAsFactors = FALSE)
  
  if (nrow(df) == 0) {
    stop("The survey dataset is empty.")
  }
  
  required_cols <- c("RespondentID", "Age", "Occupation", "SleepHours", "StressLevel", "MoodScore")
  missing_cols <- setdiff(required_cols, names(df))
  
  if (length(missing_cols) > 0) {
    stop(paste("Missing required columns:", paste(missing_cols, collapse = ", ")))
  }
  
  # Remove duplicates and handle missing values
  df <- df %>%
    distinct() %>%
    drop_na() %>%
    filter(
      Age >= 18, Age <= 120,
      SleepHours >= 0, SleepHours <= 24,
      StressLevel >= 1, StressLevel <= 10,
      MoodScore >= 1, MoodScore <= 10
    )
  
  return(df)
}
