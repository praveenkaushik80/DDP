#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

URL <- "http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv"
Quake_30days <- read.table(URL, sep = ",", header = T)

conv.time <- function(vector){
  split1 <- strsplit(paste(vector),"T")
  split2 <- strsplit(split1[[1]][2],"Z")
  fin <- paste0(split1[[1]][1],split2[[1]][1])
  paste(as.POSIXlt(fin,formate="%Y-%m-%d%H:%M:%OS3"))
}

Quake_30days$DateTime <- as.POSIXlt(sapply(Quake_30days$time,FUN=conv.time))

Quake_30days$daysfromtoday <- -round(c(Sys.time()-Quake_30days$DateTime)/(60*24),0)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Filtered Data to be used in other reactive functions
  Quake_display <- reactive({
    subset(Quake_30days, daysfromtoday >= input$daterange[1]
           & daysfromtoday <= input$daterange[2]
           & mag>=input$magrange[1] 
           & mag<=input$magrange[2]
           & grepl(", California", Quake_30days$place, ignore.case = TRUE)==TRUE, 
           select=c(longitude, latitude, mag, place))
  })
  
  
  
  # Leaflet Plot
  output$calmap <- renderLeaflet({
    leaflet(Quake_display()) %>% addTiles() %>%
      fitBounds(-124, 34, -116, 40)
  })
  
  observe({
    filtered_data<-Quake_display()
    leafletProxy("calmap", data = Quake_display()) %>%
      clearShapes() %>%
      addCircles(radius = ~10^mag/2, weight = 1, color = "#444444",
                 fillColor = heat.colors(3, alpha = NULL), fillOpacity = 0.7, popup = ~paste(mag)
      )
  }) 
  
  data <- eventReactive(input$histogram, {
    data<- Quake_display()$mag
  })
  
  output$hist <- renderPlot({
    hist(data(), main= "Histogram", xlab="Magnitude", xlim=c(0,8))
  })
  
})
