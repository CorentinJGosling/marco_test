library(shiny)
library(readxl)
library(tidyverse)
library(shinyWidgets)
library(DT)
library(rio)
library(shinycssloaders)
library(shinybrowser)
library(shinydashboard)
library(packcircles)
library(ggplot2)
library(viridis)
library(ggiraph)
library(plotly)

dat <- read.delim("dat.txt")

callback <- c(
  "table.on('mouseover', 'td', function(){",
  "  var index = table.cell(this).index();",
  "  Shiny.setInputValue('cell', index, {priority: 'event'});",
  "});"
)
ui <- fluidPage(
  shinybrowser::detect(),
  tags$script(HTML('
$(document).on("shiny:tabselected", function(event) {
  if (event.target.id === "myTabset-2") {
    $(".right").css("overflow-y", "scroll");
  } else {
    $(".right").css("overflow-y", "hidden");
}
});
')),
tags$style(
  HTML("
  *,
  *::before,
  *::after {
    box-sizing: border-box;
  }

  * {
    font: inherit;
    font-family: 'Avenir Next LT Pro', sans-serif;
    scroll-behavior: smooth;
  }
  .hover{
    font-size: 1.40rem !important;
    transition: font-size 0.1s linear;
  }

  .split {
     display: flex;
     gap: 1rem;
     # justify-content: space-between;
     max-height: 95vh !important;
     max-width: 99vw !important;
     # overflow: scroll;
     # border: 2px solid blue;
  }
 .left {
   background-color: #add6ed;
   max-height: 95vh !important;
   overflow: hidden;
   padding: 1rem;
   border-radius: 10px;
  }
  .right {
     # border: 2px solid red;
     background-color: #fff;
     overflow-x: hidden;
     width: 100% !important;
     max-height: 95vh !important;
   }
  .sliders{
    display: flex;
    justify-content: space-evenly;
  }
  .tabbable .nav .active a{
    border-left: 1px solid #dddddd;
    font-weight: bold;
  }
  .tabbable .tab-content{
    border-left: 1px solid #dddddd;
    border-right: 1px solid #dddddd;
    border-bottom: 1px solid #dddddd;
    margin-bottom: 0 !important;
    padding-left: 1rem;
    padding-right: 1rem;
    padding-top: 1rem;
    padding-bottom: 1rem;
  }


#############################################
  .wrapper{
    border: 3px solid green !important;
  }
  .header{
    display: grid !important;
    justify-content: center !important;
    align-items: center !important;
    text-align: center !important;
  }
  .header h1{
    color: #000;
    font-weight: bold !important;
    text-align: center !important;
  }
  .header p{
    color: #000;
    text-align: center !important;
  }
  .row_boxes{
    display: grid !important;
    grid-template-columns : 1fr 1fr 1fr;
    justify-content: center;
    align-items: start;
    gap: 3rem;
    margin-top: 4rem;
    margin-bottom: 4rem;
    height: 100% !important;
  }

  .box{
    display: flex;
    flex-direction: column;
    justify-content: center !important;
    align-items: center !important;
    border-radius: 10px;
    box-shadow: rgba(0, 0, 0, 0.2) 0px 12px 28px 0px, rgba(0, 0, 0, 0.1) 0px 2px 4px 0px, rgba(255, 255, 255, 0.05) 0px 0px 0px 1px inset;
    width: 100% !important;;
    height: 100% !important;
  }

  .box:hover,
  .box_plot:hover{
    box-shadow: rgba(0, 0, 0, 0.5) 0px 12px 28px 0px,
    rgba(0, 0, 0, 0.3) 0px 2px 4px 5px,
    rgba(255, 255, 255, 0.3) 0px 0px 0px 1px inset;
  }


  .box_text {
    color: #fff;
    text-align: center;
    background-color: #15354A;
    border-radius: 10px 10px 0 0;
    padding: 0.75rem 1rem;
    font-weight: bold;
    width: 100% !important;;
    height: 100% !important;
  }

  .box_num{
    display: flex;
    justify-content: center;
    font-size: 4rem;
    color: #add6ed;
    font-weight: bold;
    padding: 0.75rem 1rem;
    border-radius: 0 0 10px 10px;
    width: 100%;
  }
  .row_boxes_plot{
    display: grid !important;
    grid-template-columns: 1fr;
    justify-content: center;
    align-items: center;
    gap: 3rem;
    margin-top: 4rem;
    margin-bottom: 4rem;
    height: 100% !important;
  }

  .box_plot{
    display: flex;
    flex-direction: column;
    align-items: center !important;
    border-radius: 10px;
    height: 100% !important;
    text-align:center;
    box-shadow: rgba(0, 0, 0, 0.2) 0px 12px 28px 0px, rgba(0, 0, 0, 0.1) 0px 2px 4px 0px, rgba(255, 255, 255, 0.05) 0px 0px 0px 1px inset;
  }
  .plot_text{
    width: 100%;
    color: #fff;
    background-color: #15354A;
    border-radius: 10px 10px 0 0;
    padding: 0.75rem 1rem;
    font-weight: bold;
  }
  #circle_interventions,
  #polar_outcomes{
    width:35vw !important;
  }
  #forest_container{
    color: red !important;
    margin-left: auto;
    margin-right: auto;
    font-size: 1.5rem;
    width: 100% !important;
    margin-bottom: 3rem;
    padding-bottom: 3rem;
  }
  #forest_warning{
    margin-top: 1rem;
    max-width: 80ch !important;
    margin-left: auto;
    margin-right: auto;
  }

  @media (max-width: 800px) {
   .split {
     overflow-y: scroll !important;
     max-height: 200vh !important;
     flex-direction: column !important;
   }
  .right {
     width: 100% !important;
  }
  .left{
      width: 100% !important;
      display: flex !important;
      flex-direction: column !important;
      align-items: center !important;
      justify-content: center !important;
      text-align : center !important;
      overflow-y: scroll !important;
  }
  .row_boxes{
    grid-template-columns : auto !important;
    justify-content: center !important;
    align-items: center !important;
    gap: 1rem;
    margin-top: 1rem;
    margin-bottom: 1rem;
  }
  .row_boxes_plot{
    grid-template-columns : auto !important;
    margin-top: 1rem !important;
    margin-bottom: 1rem !important;
  }

  .box_plot{
    margin-top: 2rem !important;
    width: 90vw !important;
    height: auto !important;

  }
  #forest_warning{
    margin-top: 2rem !important;
  }

 }

")),
div(class = "split",
    # filtering panel ========================
    div(class = "left",
        h3("Filtering panel"),
        pickerInput("Age", label ="Age", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("BD_stage", label ="Bipolar Stage", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("Intervention", label ="Intervention", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("Outcome", label ="Outcome", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("design", label ="Type of meta-analysis", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("GRADE", label ="GRADE", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("AMSTAR", label ="AMSTAR", choices= NULL, multiple = TRUE, selected = NULL),
        br(),
        actionButton("download_button", "Download data") #
    ),
    # database & forest plot panel ==========
    div(class = "right",
        tabsetPanel(id = "myTabset",
                    tabPanel("Dashboard",
                             div(class = "wrapper",
                               div(class = "header",
                                   h1("Summary of the results stored in the database"),
                                   p("In this dashboard, you will retrieve general information about the information stored in the database. "),
                                   p("You can use the filters to obtain more specific information."),
                               ),
                               div(class = "row_boxes",
                                     div(class = "box",
                                         div(class = "box_text", p("Overall number of comparisons")),
                                         div(class = "box_num", uiOutput('box_comp_n')),
                                     ),
                                     div(class = "box",
                                         div(class = "box_text", p("Comparisons with treatment superior to control")),
                                         div(class = "box_num", uiOutput('box_comp_eff')),
                                     ),
                                     div(class = "box",
                                           div(class = "box_text", p("Comparisons with a High GRADE rating")),
                                           div(class = "box_num", uiOutput('box_comp_high')),
                                       ),
                                   ),

                               div(class = "row_boxes_plot",
                                   div(class = "box_plot",
                                       div(class = "plot_text",
                                           p(paste("Top 15 most studied interventions"))),
                                       div(class = "row_plots", girafeOutput("circle_interventions"))
                                   ),
                                   div(class = "box_plot",
                                       div(class = "plot_text", p("Top 15 most studied outcome")),
                                       div(class = "row_plots", plotlyOutput("polar_outcomes"))
                                   )

                               ),
                               div(class = "header",
                                   h1(""),
                               ),
                               div(class = "box_plot",
                                   div(class = "plot_text", p("Forest plot of the pooled effect sizes")),
                                   uiOutput('forest_warning'),
                                   uiOutput('forest_container')
                               ))
                    ),

                      tabPanel("Database",
                               div(class = "table",
                                   shinycssloaders::withSpinner(
                                     DT::DTOutput("table_container")))),
                      )

    )

 )
)

server <- function(input, output, session) {

  ###################################################
  ##################### DATA ########################
  ###################################################
  # raw data stored locally
  dat <- read.delim("dat.txt")

  filterData <- reactive({
    filteredData <- dat

    if (isTruthy(input$Age)) {
      filteredData <- filteredData %>% filter(Age %in% input$Age)
    }
    if (isTruthy(input$Intervention)) {
      filteredData <- filteredData %>% filter(Intervention %in% input$Intervention)
    }
    if (isTruthy(input$Outcome)) {
      filteredData <- filteredData %>% filter(Outcome %in% input$Outcome)
    }
    if (isTruthy(input$GRADE)) {
      filteredData <- filteredData %>% filter(Rank %in% input$GRADE)
    }
    if (isTruthy(input$BD_stage)) {
      filteredData <- filteredData %>% filter(BD_stage %in% input$BD_stage)
    }
    if (isTruthy(input$design)) {
      filteredData <- filteredData %>% filter(Design %in% input$design)
    }
    if (isTruthy(input$AMSTAR)) {
      filteredData <- filteredData %>% filter(AMSTAR %in% input$AMSTAR)
    }

    filteredData
  })

  ####################################################
  ##################### BOXES ########################
  ####################################################
  output$comp_n = renderText({ paste0(nrow(filterData())) })
  output$box_comp_n <- renderUI({ textOutput('comp_n') })

  output$comp_high = renderText({ paste0(nrow(filterData() %>% filter(Rank == "I (High)"))) })
  output$box_comp_high <- renderUI({ textOutput('comp_high') })

  output$comp_eff = renderText({ paste0(nrow(filterData()  %>% filter(TE_lo > 0 | TE_up < 0))) })
  output$box_comp_eff <- renderUI({ textOutput('comp_eff') })

  ########################################################
  ##################### DASHBOARD ########################
  ########################################################
  output$circle_interventions <- renderGirafe({
    # https://rdrr.io/github/djpr-data/djprshiny/man/djpr_girafe.html
    res <- filterData() %>%
      group_by(Intervention) %>%
      summarise(value=n()) %>%
      arrange(value) %>%
      top_n(15)
    packing <- circleProgressiveLayout(res$value, sizetype='area')
    packing$radius <- 0.95*packing$radius
    data <- cbind(res, packing)
    data$text <- paste("Intervention name: ", data$Intervention, "\n",
                       "Number of comparisons: ", data$value, "\n")

    dat.gg <- circleLayoutVertices(packing, npoints=50)

    p <- ggplot() +
      geom_polygon_interactive(data = dat.gg,
                               aes(x, y, group = id, fill=id,
                                   tooltip = data$text[id], data_id = id),
                               colour = "black", alpha = 0.4) +
      scale_fill_viridis() +
      geom_text(data = data, aes(x, y, label = substr(Intervention, 1, 4)),
                size=2, color="black") +
      theme_void() +
      theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm") ) +
      coord_equal()

    # girafe(ggobj = p, width_svg = 7, height_svg = 7)
    girafe(ggobj = p)

  })

  output$polar_outcomes <- renderPlotly({
    res <- filterData() %>%
      group_by(Outcome) %>%
      summarise(value=n()) %>%
      arrange(value) %>%
      top_n(15)
    res <- res[order(-res$value), ]

    plot_ly(res,
            x = ~value,
            y = ~Outcome, type = "bar",
            marker = list(color = ~value, colors = viridis_pal()(nrow(dat)))) %>%
      layout(xaxis = list(title = "Number of comparisons"),
             yaxis = list(title = "Outcome", categoryorder = "total ascending"))
  })

  ######################################################
  ##################### FILTERS ########################
  ######################################################

  observe({
    updatePickerInput(session, 'Age', choices = unique(dat$Age))
    updatePickerInput(session, 'BD_stage', choices = unique(dat$BD_stage))
    updatePickerInput(session, 'Intervention', choices = unique(dat$Intervention))
    updatePickerInput(session, 'Outcome', choices = unique(dat$Outcome))
    updatePickerInput(session, 'design', choices = unique(dat$Design))
    updatePickerInput(session, 'GRADE', choices = unique(dat$Rank))
    updatePickerInput(session, 'AMSTAR', choices = unique(dat$AMSTAR))
  })

  observeEvent(input$Age, {
    if (isTruthy(input$Age)) {
      val = input$Age
    } else {
      val = unique(dat$Age)
    }

    filtered_values_BD <- sort(unique(dat$BD_stage[dat$Age %in% val]))
    filtered_values_DES <- sort(unique(dat$design[dat$Age %in% val]))
    filtered_values_GRA <- sort(unique(dat$Rank[dat$Age %in% val]))
    filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$Age %in% val]))
    filtered_values_INT <- sort(unique(dat$Intervention[dat$Age %in% val]))
    filtered_values_OUT <- sort(unique(dat$Outcome[dat$Age %in% val]))
    updatePickerInput(session, 'Intervention', choices = filtered_values_INT, selected = input$Intervention)
    updatePickerInput(session, 'Outcome', choices = filtered_values_OUT, selected = input$Outcome)
    updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
    updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
    updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
    updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  }, ignoreNULL=FALSE)

  observeEvent(input$BD_stage, {
    if (isTruthy(input$BD_stage)) {
      val = input$BD_stage
    } else {
      val = sort(unique(dat$BD_stage))
    }

    filtered_values_AGE <- sort(unique(dat$Age[dat$BD_stage %in% val]))
    filtered_values_DES <- sort(unique(dat$design[dat$BD_stage %in% val]))
    filtered_values_GRA <- sort(unique(dat$Rank[dat$BD_stage %in% val]))
    filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$BD_stage %in% val]))
    filtered_values_INT <- sort(unique(dat$Intervention[dat$BD_stage %in% val]))
    filtered_values_OUT <- sort(unique(dat$Outcome[dat$BD_stage %in% val]))
    updatePickerInput(session, 'Intervention', choices = filtered_values_INT, selected = input$Intervention)
    updatePickerInput(session, 'Outcome', choices = filtered_values_OUT, selected = input$Outcome)
    updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
    updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
    updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
    updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  }, ignoreNULL=FALSE)

  observeEvent(input$design, {
    if (isTruthy(input$design)) {
      val = input$design
    } else {
      val = sort(unique(dat$Design))
    }

    filtered_values_BD <- sort(unique(dat$BD_stage[dat$Design %in% val]))
    filtered_values_AGE <- sort(unique(dat$Age[dat$Design %in% val]))
    filtered_values_GRA <- sort(unique(dat$Rank[dat$Design %in% val]))
    filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$Design %in% val]))
    filtered_values_INT <- sort(unique(dat$Intervention[dat$Design %in% val]))
    filtered_values_OUT <- sort(unique(dat$Outcome[dat$Design %in% val]))
    updatePickerInput(session, 'Intervention', choices = filtered_values_INT, selected = input$Intervention)
    updatePickerInput(session, 'Outcome', choices = filtered_values_OUT, selected = input$Outcome)
    updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
    updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
    updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
    updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  }, ignoreNULL=FALSE)

  observeEvent(input$GRADE, {
    if (isTruthy(input$GRADE)) {
      val = input$GRADE
    } else {
      val = sort(unique(dat$Rank))
    }

    filtered_values_BD <- sort(unique(dat$BD_stage[dat$Rank %in% val]))
    filtered_values_DES <- sort(unique(dat$design[dat$Rank %in% val]))
    filtered_values_AGE <- sort(unique(dat$Age[dat$Rank %in% val]))
    filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$Rank %in% val]))
    filtered_values_INT <- sort(unique(dat$Intervention[dat$Rank %in% val]))
    filtered_values_OUT <- sort(unique(dat$Outcome[dat$Rank %in% val]))
    updatePickerInput(session, 'Intervention', choices = filtered_values_INT, selected = input$Intervention)
    updatePickerInput(session, 'Outcome', choices = filtered_values_OUT, selected = input$Outcome)
    updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
    updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
    updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
    updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  }, ignoreNULL=FALSE)

  observeEvent(input$AMSTAR, {
    if (isTruthy(input$AMSTAR)) {
      val = input$AMSTAR
    } else {
      val = sort(unique(dat$AMSTAR))
    }

    filtered_values_BD <- sort(unique(dat$BD_stage[dat$AMSTAR %in% val]))
    filtered_values_DES <- sort(unique(dat$design[dat$AMSTAR %in% val]))
    filtered_values_GRA <- sort(unique(dat$Rank[dat$AMSTAR %in% val]))
    filtered_values_AGE <- sort(unique(dat$Age[dat$AMSTAR %in% val]))
    filtered_values_INT <- sort(unique(dat$Intervention[dat$AMSTAR %in% val]))
    filtered_values_OUT <- sort(unique(dat$Outcome[dat$AMSTAR %in% val]))
    updatePickerInput(session, 'Intervention', choices = filtered_values_INT, selected = input$Intervention)
    updatePickerInput(session, 'Outcome', choices = filtered_values_OUT, selected = input$Outcome)
    updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
    updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
    updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
    updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
  }, ignoreNULL=FALSE)

  observeEvent(input$Intervention, {
    if (isTruthy(input$Intervention)) {
      val = input$Intervention
    } else {
      val = sort(unique(dat$Intervention))
    }

    filtered_values_BD <- sort(unique(dat$BD_stage[dat$Intervention %in% val]))
    filtered_values_DES <- sort(unique(dat$design[dat$Intervention %in% val]))
    filtered_values_AGE <- sort(unique(dat$Age[dat$Intervention %in% val]))
    filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$Intervention %in% val]))
    filtered_values_GRA <- sort(unique(dat$Rank[dat$Intervention %in% val]))
    filtered_values_OUT <- sort(unique(dat$Outcome[dat$Intervention %in% val]))
    updatePickerInput(session, 'Outcome', choices = filtered_values_OUT, selected = input$Outcome)
    updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
    updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
    updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
    updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
    updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  }, ignoreNULL=FALSE)

  observeEvent(input$Outcome, {
    if (isTruthy(input$Outcome)) {
      val = input$Outcome
    } else {
      val = sort(unique(dat$Outcome))
    }

    filtered_values_BD <- sort(unique(dat$BD_stage[dat$Outcome %in% val]))
    filtered_values_DES <- sort(unique(dat$design[dat$Outcome %in% val]))
    filtered_values_GRA <- sort(unique(dat$Rank[dat$Outcome %in% val]))
    filtered_values_AGE <- sort(unique(dat$Age[dat$Outcome %in% val]))
    filtered_values_INT <- sort(unique(dat$Intervention[dat$Outcome %in% val]))
    filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$Outcome %in% val]))
    updatePickerInput(session, 'Intervention', choices = filtered_values_INT, selected = input$Intervention)
    updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
    updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
    updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
    updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
    updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  }, ignoreNULL=FALSE)


  # ============================================================= #
  # ======================== TABLE ============================== #
  # ============================================================= #
  output$table_container <- DT::renderDataTable({
    DT::datatable(
      filterData(),
      escape = FALSE,
      class = "compact hover",
      extensions = 'Buttons',
      rownames = FALSE,
      style = "bootstrap",
      options = list(
        dom = '<"top"p>rt',
        scrollX = TRUE,
        scrollY = "70vh",
        pageLength = 100,
        order = list(1, 'asc'),
        autoWidth = TRUE,
        columnDefs = list(
          list(
            width = '150px',
            targets = "_all"),
          list(
            width = '180px',
            targets = 3),
          list(visible = FALSE,
               targets = 13:22),
          list(className = 'dt-center',
               targets = "_all")),
        buttons =
          list("copy", list(
            extend = "collection"
            , buttons = c("csv", "excel")
            , text = "Download"
          ))),
      callback = JS(
        "table.on('mouseover', 'tbody tr', function() {
      $(this).addClass('hover');
    });
    table.on('mouseout', 'tbody tr', function() {
      $(this).removeClass('hover');
    });"
      )
    )
    # %>%
    #   DT::formatStyle(
    #     selector = 'th',
    #     fontWeight = 'bold'
    #   )
  })

  # ============================================================= #
  # ======================== PLOT =============================== #
  # ============================================================= #

  Row = reactive({ nrow(filterData()) * 20 })
  Cols = reactive({ ncol(filterData()) })
  Wdth = reactive({ shinybrowser::get_width() })
  # Hght = reactive({ shinybrowser::get_height() })

  # output$plotWidth <- renderUI({
  #   sliderInput('plotWidth', "Forest plot width",
  #               min=1,
  #               max=30,
  #               value=ifelse(Wdth() > 1200, 20, 10))
  # })
  #
  # output$plotHeight <- renderUI({
  #   sliderInput('plotHeight', "Forest plot height", min=200,
  #               max=5000,
  #               value=Row())
  # })


  filterDataPlot <- reactive({
    if (nrow(filterData()) > 250) {
      filterData()[order(filterData()[, 'Rank'], abs(filterData()[, 'invTE'])), ][1:250, ]
    } else {
      filterData()
    }
  })

  output$forest_container <- renderUI({
    shinycssloaders::withSpinner(
      plotOutput('forest', height = nrow(filterDataPlot()) * 14 + 500),
      # margin above loader ,
      proxy.height="75px")
  })
  output$forest_warning = renderUI({
    renderText({
    if (nrow(filterData()) > 250) {
      paste0("Because the number of comparisons is too large to be rendered in a unique figure (n=",
             nrow(filterData()),
             "), we display the comparisons with the highest level of evidence (High GRADE)",
             ", and the largest effect sizes (both positive and negative ones).")
    } else {
      paste0("")
    }
    })
  })


  mgen = reactive({
    meta::metagen(TE=TE, seTE=seTE, data=filterDataPlot())
  })
  mgenmod = reactive({
    meta::update.meta(mgen(), subgroup = Rank,
                      subgroup.name = "GRADE, certainty of the evidence",
                      tau.common = FALSE)
  })

  output$forest <- renderPlot(

    meta::forest.meta(mgenmod(),
                      sortvar = filterDataPlot()[, "invTE"],
                      xlab = "Equivalent Standardized Mean Difference",
                      common = FALSE,
                      subgroup.hetstat = FALSE,
                      sort.subgroup = TRUE,
                      colgap.left = "5mm",
                      colgap.right = "5mm",
                      plotwidth = paste0(ifelse(Wdth() > 1400, 20,
                                                ifelse(Wdth() > 1000, 10,
                                                       ifelse(Wdth() > 800, 6, 4))), "cm"),
                      # col.equi = "#91C8E7",
                      # fill.equi = "#CCE6F4",
                      # lty.equi = 3,
                      # lower.equi = -0.3,
                      # upper.equi = 0.3,
                      random = FALSE,
                      overall=FALSE,
                      hetstat = FALSE,
                      rightcols = c("effect.ci", "eNNT"),
                      rightlabs = c( "eSMD [95% CI]", "eNNT / eNNH"),
                      leftcols = c("Meta_review", "Outcome_acro", "Intervention", "Rank"),
                      leftlabs = c("Meta_review", "Outcome", "Intervention", "GRADE"),
                      label.right = "=> Clinically beneficial",# col.label.right = "#49733E",
                      label.left = "Clinically harmful <="#, col.label.left = "#633434"
    )

  )


  # ============================================================= #
  # ======================== data for download ================== #
  # ============================================================= #
  observeEvent(input$download_button, {
    rio::export(filterData(), "filtered_data.xlsx")
    downloadHandler(
      filename = "dat.xlsx",
      content = function(file) {
        file.copy("dat.xlsx", file)
      }
    )
  })
}


shinyApp(ui, server)
