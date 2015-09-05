library(leaflet)

ui <- bootstrapPage(tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
                    leafletOutput("map", width = "100%", height = "100%")
                    )



server <- function(input, output, session) {
  filteredData <- eventReactive(input$updateButton, {
    base <- "http://bustracker.muni.org/InfoPoint/XML/vehiclelocation.xml"
    xml_obj <- xmlParse(base)
    locations <- xmlToDataFrame(xml_obj) %>% filter(runid != "<NA>")
  })
  output$map <- renderLeaflet({
    leaflet() %>% addTiles(urlTemplate = "http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png") %>% setView(-149.85, 61.15, zoom = 12) %>%
      addMarkers(filteredData()$longitude, filteredData()$latitude) 
  })
  observe({
    leafletProxy("map", data = filteredData()) 
  })
}

shinyApp(ui, server)