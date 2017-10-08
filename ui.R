#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # title
  titlePanel("Quake App for California"),
  p("The ", a(href="http://usgs.gov", "U.S. Geological Survey (USGS)")," maintains a ",a(href="http://earthquake.usgs.gov/earthquakes/feed/", 
                                                                                         "Real-time Feed"), " of seismic data. This data is updated
    every 15 minutes."),
  "This app downloads the latest 30-day feed csv file, filters for California
  as the epicenter location, and displays them.",
  p("The source code is posted ", a(href="https://github.com/",
                                                 "on Github.")),
  wellPanel(
    h4("Instructions:"),
    tags$ul(tags$li("Select data and magnitude range. Plot updated automatically"),
            tags$li("Plot a histogram of different magnitude levels by pressing the Histogram button."))
  ),
  # Sidebar
  sidebarLayout(position="left",
                sidebarPanel(
                  h4("Data Range Selection"),
                  p("Using the sliders below, select the date range and the magnitude range for plot."),
                  br(),
                  sliderInput(
                    "daterange","Date Range:",
                    min = -30,
                    max = 0,
                    value = c(-15, 0)
                  ),
                  br(),
                  sliderInput("magrange", "Magnitude:", 
                              min = 0, 
                              max = 8, 
                              value = c(0,4)
                  )
                ),
                
                # Main Panel: Show a plot of the generated distribution
                mainPanel(
                  leafletOutput("calmap")
                )
  ),
  br(),
  
  wellPanel(
    h4("Magnitude Histogram"),
    p("Press the button below to display a histogram of the earthquake magnitudes"),
    actionButton(inputId = "histogram", 
                 label = "Update Histogram")
  ),
  plotOutput("hist")
  ))