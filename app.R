# app.R
library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(scales)

# Load R scripts
source("R/data_cleaning.R")
source("R/analysis.R")

# Clean the data
dataset_path <- "data/mental_health_survey.csv"
survey_data <- tryCatch({
  clean_survey_data(dataset_path)
}, error = function(e) {
  stop(e$message)
})

# Define UI
ui <- page_navbar(
  title = "🧠 Mental Health Survey Analyzer",
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  # Disclaimer
  header = tags$div(
    class = "alert alert-warning text-center m-2",
    "This dashboard analyzes synthetic, self-reported survey data for educational purposes only. It does not diagnose or predict any mental-health condition."
  ),
  
  # Filters in Sidebar
  sidebar = sidebar(
    title = "Filters",
    selectInput("occupation_filter", "Occupation", choices = c("All", "Student", "Employee")),
    sliderInput("age_filter", "Age Range", 
                min = min(survey_data$Age, na.rm = TRUE), 
                max = max(survey_data$Age, na.rm = TRUE), 
                value = c(min(survey_data$Age, na.rm = TRUE), max(survey_data$Age, na.rm = TRUE)))
  ),
  
  # Tab 1: Overview
  nav_panel("Overview",
    layout_columns(
      value_box(title = "Total Respondents", value = textOutput("kpi_total"), theme = "primary"),
      value_box(title = "Average Sleep", value = textOutput("kpi_sleep"), theme = "info"),
      value_box(title = "Average Stress", value = textOutput("kpi_stress"), theme = "warning"),
      value_box(title = "Average Mood", value = textOutput("kpi_mood"), theme = "success")
    ),
    card(
      card_header("Stress Level Distribution"),
      plotlyOutput("stress_dist_chart")
    )
  ),
  
  # Tab 2: Survey Analysis
  nav_panel("Survey Analysis",
    layout_columns(
      card(
        card_header("Sleep vs Stress"),
        plotlyOutput("sleep_stress_chart")
      ),
      card(
        card_header("Stress by Occupation"),
        plotlyOutput("stress_occ_chart")
      )
    ),
    card(
      card_header("Mood by Occupation"),
      plotlyOutput("mood_occ_chart")
    )
  ),
  
  # Tab 3: Respondent Data
  nav_panel("Respondent Data",
    card(
      card_header("Survey Data"),
      tableOutput("data_table")
    )
  )
)

# Define Server
server <- function(input, output, session) {
  
  # Reactive filtered data
  filtered_data <- reactive({
    data <- survey_data
    
    if (input$occupation_filter != "All") {
      data <- data %>% filter(Occupation == input$occupation_filter)
    }
    
    data <- data %>% filter(Age >= input$age_filter[1] & Age <= input$age_filter[2])
    
    data
  })
  
  # Observer to handle empty filtered data
  observe({
    if (nrow(filtered_data()) == 0) {
      showNotification("No survey responses match the selected filters.", type = "warning", duration = 3)
    }
  })
  
  # KPIs
  output$kpi_total <- renderText({
    req(nrow(filtered_data()) > 0)
    kpis <- calculate_kpis(filtered_data())
    as.character(kpis$total_respondents)
  })
  
  output$kpi_sleep <- renderText({
    req(nrow(filtered_data()) > 0)
    kpis <- calculate_kpis(filtered_data())
    as.character(round(kpis$avg_sleep, 2))
  })
  
  output$kpi_stress <- renderText({
    req(nrow(filtered_data()) > 0)
    kpis <- calculate_kpis(filtered_data())
    as.character(round(kpis$avg_stress, 2))
  })
  
  output$kpi_mood <- renderText({
    req(nrow(filtered_data()) > 0)
    kpis <- calculate_kpis(filtered_data())
    as.character(round(kpis$avg_mood, 2))
  })
  
  # Charts
  output$stress_dist_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    dist_data <- stress_distribution(filtered_data())
    p <- ggplot(dist_data, aes(x = factor(StressLevel), y = n)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(x = "Stress Level", y = "Count") +
      theme_minimal()
    ggplotly(p)
  })
  
  output$sleep_stress_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    p <- ggplot(filtered_data(), aes(x = SleepHours, y = StressLevel, color = Occupation)) +
      geom_point(size = 3, alpha = 0.7) +
      labs(x = "Sleep Hours", y = "Stress Level") +
      theme_minimal()
    ggplotly(p)
  })
  
  output$stress_occ_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    occ_stress <- avg_stress_by_occupation(filtered_data())
    p <- ggplot(occ_stress, aes(x = Occupation, y = AvgStress, fill = Occupation)) +
      geom_bar(stat = "identity") +
      labs(x = "Occupation", y = "Average Stress") +
      theme_minimal()
    ggplotly(p)
  })
  
  output$mood_occ_chart <- renderPlotly({
    req(nrow(filtered_data()) > 0)
    occ_mood <- avg_mood_by_occupation(filtered_data())
    p <- ggplot(occ_mood, aes(x = Occupation, y = AvgMood, fill = Occupation)) +
      geom_bar(stat = "identity") +
      labs(x = "Occupation", y = "Average Mood") +
      theme_minimal()
    ggplotly(p)
  })
  
  # Data Table
  output$data_table <- renderTable({
    req(nrow(filtered_data()) > 0)
    filtered_data() %>%
      select(RespondentID, Age, Occupation, SleepHours, StressLevel, MoodScore)
  })
}

shinyApp(ui = ui, server = server)
