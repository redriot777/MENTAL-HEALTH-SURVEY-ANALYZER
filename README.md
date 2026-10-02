# Mental Health Survey Analyzer

## Project Description
This project analyzes a small synthetic survey dataset using R and Shiny. It is a beginner-friendly dashboard designed for educational purposes, focusing on data visualization and basic analysis.

## Features
* Survey overview
* Stress analysis
* Sleep analysis
* Mood analysis
* Occupation comparison
* Interactive filters

## Technologies
R
Shiny
bslib
ggplot2
dplyr
tidyr
plotly
scales

## Folder Structure
```text
mental-health-survey-analyzer/
├── app.R
├── README.md
├── requirements.txt
├── .gitignore
├── data/
│   └── mental_health_survey.csv
├── R/
│   ├── data_cleaning.R
│   └── analysis.R
├── output/
│   └── .gitkeep
└── screenshots/
    └── .gitkeep
```

## Dataset
The synthetic dataset contains 60 records with the following columns:
* RespondentID: Unique identifier for each respondent
* Age: Age of the respondent (18-120)
* Occupation: Student or Employee
* SleepHours: Average sleep hours per day (0-24)
* StressLevel: Self-reported stress level (1-10)
* MoodScore: Self-reported mood score (1-10)

## Installation
Run the following command in R or RStudio to install the required packages:

```r
install.packages(c(
  "shiny",
  "bslib",
  "ggplot2",
  "dplyr",
  "tidyr",
  "plotly",
  "scales"
))
```

## Running in VS Code
1. Open the project folder in VS Code.
2. Open the terminal.
3. Make sure the terminal is inside the project folder.
4. Run the Shiny application by executing this command:

```powershell
Rscript -e "shiny::runApp('app.R', host='127.0.0.1', port=8080)"
```

Alternative full-path command for Windows if Rscript is not recognized:
```powershell
& "C:\Program Files\R\R-4.6.1\bin\Rscript.exe" -e "shiny::runApp('app.R', host='127.0.0.1', port=8080)"
```

## Expected Output
The application features three main tabs:
1. Overview: Key performance indicators and stress level distribution.
2. Survey Analysis: Interactive charts analyzing sleep, stress, and mood by occupation.
3. Respondent Data: A simple table displaying the filtered survey data.

## Troubleshooting
* Rscript not recognized: Ensure R is installed and added to your system PATH, or use the alternative full-path command.
* Missing R package: Ensure you have run the `install.packages` command to install all dependencies.
* CSV not found: Make sure the application is run from the root folder of the project.
* Port already in use: Change the port number in the run command (e.g., `port=8081`).
* No data after filtering: Adjust your filter selections to include available data.

## Future Improvements
* Larger survey dataset
* More survey questions
* Additional visualizations
* Real-world anonymized data
