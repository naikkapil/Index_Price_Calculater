library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)

ui <- fluidPage(
  titlePanel("Index Price Calculator"),
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Choose CSV File',
                accept = c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
      downloadButton("downloadData", "Download")
    ),
    mainPanel(
      tableOutput("table"),
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  
  data <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    read_csv(inFile$datapath, col_types = cols(
      `DEAL DATE` = col_date(format = "%m/%d/%Y")
    ))
  })
  
  filteredData <- reactive({
    req(data())
    month_map <- setNames(1:12, tolower(month.abb))
    df <- data() %>%
      mutate(DealDate = as.Date(`DEAL DATE`, format = "%m/%d/%Y"),
             DeliveryMonthNum = month_map[tolower(`DELIVERY MONTH`)],
             DeliveryDate = make_date(`DELIVERY YEAR`, DeliveryMonthNum, 1),
             DaysUntilDelivery = as.numeric(DeliveryDate - DealDate)) %>%
      filter(DaysUntilDelivery <= 180 & DaysUntilDelivery >= 0)
    
    df
  })
  
  
  calculateVWAP <- function(df, index) {
    filtered <- if (index == "COAL2") {
      df %>% filter(`DELIVERY LOCATION` %in% c("ARA", "AMS", "ROT", "ANT"))
    } else {
      df %>% filter(`COMMODITY SOURCE LOCATION` == "South Africa")
    }
    
    filtered %>%
      group_by(DealDate) %>%
      summarise(VWAP = sum(`PRICE` * `VOLUME`) / sum(`VOLUME`), .groups = 'drop') %>%
      mutate(Index = index) %>%
      arrange(DealDate)
  }
  
  output$table <- renderTable({
    req(filteredData())
    coal2 <- calculateVWAP(filteredData(), "COAL2")
    coal4 <- calculateVWAP(filteredData(), "COAL4")
    bind_rows(coal2, coal4)
  })
  
  output$plot <- renderPlot({
    req(filteredData())
    coal2 <- calculateVWAP(filteredData(), "COAL2")
    coal4 <- calculateVWAP(filteredData(), "COAL4")
    df <- bind_rows(coal2, coal4)
    ggplot(df, aes(x = DealDate, y = VWAP, color = Index)) + geom_line() + theme_minimal() + labs(x = "Deal Date", y = "VWAP")
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("index-prices-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      req(filteredData())
      coal2 <- calculateVWAP(filteredData(), "COAL2")
      coal4 <- calculateVWAP(filteredData(), "COAL4")
      df <- bind_rows(coal2, coal4)
      write.csv(df, file, row.names = FALSE)
    }
  )
}

shinyApp(ui = ui, server = server)
