# Install and load necessary libraries
# install.packages("shiny")
library(shiny)
library(ggplot2)

# Load the AirPassengers dataset
air_passengers <- read.csv("AirPassengers.csv")

# Rename the column '#Passengers' to 'Passengers'
colnames(air_passengers)[2] <- "Passengers"

# Convert the Month column to Date format
air_passengers$Month <- as.Date(paste(air_passengers$Month, "-01", sep = ""), format = "%Y-%m-%d")

# Extract the year from the Month for filtering
air_passengers$Year <- format(air_passengers$Month, "%Y")

# Define UI (User Interface) for the dashboard
ui <- fluidPage(
  
  # App title
  titlePanel("AirPassengers Dataset Dashboard"),
  
  # Sidebar layout with input and output definitions
  sidebarLayout(
    
    # Sidebar panel for inputs
    sidebarPanel(
      
      # Input: Select year to filter the data
      selectInput(inputId = "year", 
                  label = "Select Year to Display:", 
                  choices = unique(air_passengers$Year),
                  selected = unique(air_passengers$Year)[1])
    ),
    
    # Main panel for displaying outputs
    mainPanel(
      # Output: Plot
      plotOutput(outputId = "timeSeriesPlot")
    )
  )
)

# Define server logic to create the time series plot
server <- function(input, output) {
  
  # Reactive expression to filter data based on user-selected year
  filtered_data <- reactive({
    air_passengers[air_passengers$Year == input$year, ]
  })
  
  # Render time series plot
  output$timeSeriesPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = Month, y = Passengers)) +
      geom_line(color = "blue") +
      labs(title = paste("Number of Passengers in", input$year),
           x = "Month", 
           y = "Number of Passengers") +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)