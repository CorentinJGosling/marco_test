library(shiny)
library(readxl)
library(tidyverse)
library(shinyWidgets)
library(DT)
library(rio)
library(shinycssloaders)
library(shinybrowser)
source("plot_umb.R")
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
font-size: 1.45rem !important;
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

 @media (max-width: 800px) {
   .split {
   overflow-y: scroll;
   max-height: 200vh !important;
   flex-direction: column !important;
   }
  .right {
     width: 100% !important;
  }
.left{
    width: 100% !important;
    display: flex;
    flex-direction:column;
    align-items: center;
    justify-content: center;
    text-align : center;
    overflow-y: scroll;
}
  .sliders{
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
 }")),
div(class = "split",
    # filtering panel ========================
    div(class = "left",
        h3("Filtering panel"),
        # uiOutput("age_group_values"),
        # selectInput("Age", "Choose column", character(0)),
        pickerInput("Age", label ="Filter1", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("BD_stage", label ="Filter2", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("design", label ="Filter3", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("GRADE", label ="Filter4", choices= NULL, multiple = TRUE, selected = NULL),
        pickerInput("AMSTAR", label ="Filter5", choices= NULL, multiple = TRUE, selected = NULL),

        # pickerInput(
        #   inputId = "Age",
        #   label = "Age",
        #   choices = unique(dat$Age),
        #   selected = unique(dat$Age),
        #   multiple = TRUE
        #   # options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE),
        # ),
        # pickerInput(
        #   inputId = "BD_stage",
        #   label = "BD stage",
        #   choices = unique(dat$BD_stage),
        #   selected = unique(dat$BD_stage),
        #   multiple = TRUE
        #   # options = pickerOptions(actionsBox = TRUE, liveSearch = TRUE),
        # ),
        # # uiOutput("BD_values"),
        # uiOutput("design_values"),
        # uiOutput("GRADE_values"),
        # uiOutput("AMSTAR_values"),
        br(),
        actionButton("download_button", "Download data") #
    ),
    # database & forest plot panel ==========
    div(class = "right",
        tabsetPanel(id = "myTabset",
                    tabPanel("Database",
                             div(class = "table",
                                 shinycssloaders::withSpinner(
                                   DT::DTOutput("table_container")))),
                    tabPanel("Forest plots",
                             div(class = "sliders",
                                 uiOutput('plotWidth'),
                                 uiOutput('plotHeight')),

                             div(class = "plot_cont",
                                 uiOutput('forest_container'))))
    )

 )
)

server <- function(input, output, session) {

  # raw data stored locally
  dat <- read.delim("dat.txt")

  observe({
    updatePickerInput(session, 'Age', choices = sort(unique(dat$Age)))
    updatePickerInput(session, 'BD_stage', choices = sort(unique(dat$BD_stage)))
    updatePickerInput(session, 'design', choices = sort(unique(dat$Design)))
    updatePickerInput(session, 'GRADE', choices = sort(unique(dat$Rank)))
    updatePickerInput(session, 'AMSTAR', choices = sort(unique(dat$AMSTAR)))
  })

  observeEvent(c(input$Age, input$GRADE, input$BD_stage, input$design, input$AMSTAR), {

    filteredData <- dat

    if (isTruthy(input$Age)) {
      filteredData <- filteredData %>% filter(Age %in% input$Age)
    }
    if (isTruthy(input$GRADE)) {
      filteredData <- filteredData %>% filter(GRADE %in% input$GRADE)
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

    filtered_values_AGE <- sort(unique(filteredData$Age))
    filtered_values_BD <- sort(unique(filteredData$BD_stage))
    filtered_values_DES <- sort(unique(filteredData$design))
    filtered_values_GRA <- sort(unique(filteredData$Rank))
    filtered_values_AMS <- sort(unique(filteredData$AMSTAR))
    updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
    updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
    updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
    updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
    updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  })
  # observeEvent(input$BD_stage, {
  #   filtered_values_AGE <- sort(unique(dat$Age[dat$BD_stage %in% input$BD_stage]))
  #   filtered_values_DES <- sort(unique(dat$design[dat$BD_stage %in% input$BD_stage]))
  #   filtered_values_GRA <- sort(unique(dat$Rank[dat$BD_stage %in% input$BD_stage]))
  #   filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$BD_stage %in% input$BD_stage]))
  #   updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
  #   updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
  #   updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
  #   updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  # })
  # observeEvent(input$design, {
  #   filtered_values_BD <- sort(unique(dat$BD_stage[dat$Design %in% input$design]))
  #   filtered_values_AGE <- sort(unique(dat$Age[dat$Design %in% input$design]))
  #   filtered_values_GRA <- sort(unique(dat$Rank[dat$Design %in% input$design]))
  #   filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$Design %in% input$design]))
  #   updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
  #   updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
  #   updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
  #   updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  # })
  # observeEvent(input$GRADE, {
  #   filtered_values_BD <- sort(unique(dat$BD_stage[dat$GRADE %in% input$GRADE]))
  #   filtered_values_DES <- sort(unique(dat$design[dat$GRADE %in% input$GRADE]))
  #   filtered_values_AGE <- sort(unique(dat$Age[dat$GRADE %in% input$GRADE]))
  #   filtered_values_AMS <- sort(unique(dat$AMSTAR[dat$GRADE %in% input$GRADE]))
  #   updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
  #   updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
  #   updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
  #   updatePickerInput(session, 'AMSTAR', choices = filtered_values_AMS, selected = input$AMSTAR)
  # })
  # observeEvent(input$AMSTAR, {
  #   filtered_values_BD <- sort(unique(dat$BD_stage[dat$AMSTAR %in% input$AMSTAR]))
  #   filtered_values_DES <- sort(unique(dat$design[dat$AMSTAR %in% input$AMSTAR]))
  #   filtered_values_GRA <- sort(unique(dat$Rank[dat$AMSTAR %in% input$AMSTAR]))
  #   filtered_values_AGE <- sort(unique(dat$Age[dat$AMSTAR %in% input$AMSTAR]))
  #   updatePickerInput(session, 'BD_stage', choices = filtered_values_BD, selected = input$BD_stage)
  #   updatePickerInput(session, 'design', choices = filtered_values_DES, selected = input$design)
  #   updatePickerInput(session, 'GRADE', choices = filtered_values_GRA, selected = input$GRADE)
  #   updatePickerInput(session, 'Age', choices = filtered_values_AGE, selected = input$Age)
  # })

  filterData <- reactive({
    filteredData <- dat

    if (isTruthy(input$Age)) {
      filteredData <- filteredData %>% filter(Age %in% input$Age)
    }
    if (isTruthy(input$GRADE)) {
      filteredData <- filteredData %>% filter(GRADE %in% input$GRADE)
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

  # output$design_values <- renderUI({
  #   selectInput("design", "Design", choices = unique(dat()[, "Design"]), multiple = TRUE)
  # })
  # output$GRADE_values <- renderUI({
  #   selectInput("GRADE", "GRADE", choices = unique(dat()[, "Rank"]), multiple = TRUE)
  # })
  # output$AMSTAR_values <- renderUI({
  #   selectInput("AMSTAR", "AMSTAR", choices = unique(dat()[, "AMSTAR"]), multiple = TRUE)
  # })

  # filtered data ==================
  # filtered_data <- reactive({
  #   data <- dat() %>% filter(!is.na(TE) & !is.na(seTE))
  #
  #   if (isTruthy(input$GRADE)) {
  #     data <- data %>% filter(Rank %in% input$GRADE)
  #   }
  #   if (isTruthy(input$BD_stage)) {
  #     data <- data %>% filter(BD_stage %in% input$BD_stage)
  #   }
  #   if (isTruthy(input$design)) {
  #     data <- data %>% filter(Design %in% input$design)
  #   }
  #   if (isTruthy(input$Age)) {
  #     data <- data %>% filter(Age %in% input$Age)
  #   }
  #   if (isTruthy(input$AMSTAR)) {
  #     data <- data %>% filter(AMSTAR %in% input$AMSTAR)
  #   }
  #   data
  # })


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
               targets = 13:17),
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
  })

  # ============================================================= #
  # ======================== PLOT =============================== #
  # ============================================================= #

  Row = reactive({ nrow(filterData()) * 25 })
  Cols = reactive({ ncol(filterData()) })
  Wdth = reactive({ shinybrowser::get_width() })
  # Hght = reactive({ shinybrowser::get_height() })

  output$plotWidth <- renderUI({
    sliderInput('plotWidth', "Plot width",
                min=1,
                max=30,
                value=ifelse(Wdth() > 1200, 20, 10))
  })

  output$plotHeight <- renderUI({
    sliderInput('plotHeight', "Plot height", min=200,
                max=50000,
                value=Row())
  })


  output$forest_imp = renderText({
    paste0("The number of comparisons is too large to be rendered in a figure (n=",
           nrow(filterData()),
           ", while your internet connexion allows a maximum of n=25 comparisons to be displayed).",
           "Please filter the dataset to visualize them in a forest plot.")
  })

  output$forest_container <- renderUI({
    if (nrow(filterData()) > 100) {
      textOutput('forest_imp')
    } else {
      shinycssloaders::withSpinner(
        plotOutput('forest', height = input$plotHeight),
        # margin above loader ,
        proxy.height="50px")
    }
  })

  mgen = reactive({
    meta::metagen(TE=TE, seTE=seTE, data=filterData())
  })
  mgenmod = reactive({
    meta::update.meta(mgen(), subgroup = Rank, tau.common = FALSE)
  })

    output$forest <- renderPlot(

      meta::forest.meta(mgenmod(),
                        sortvar = filterData()[, "invTE"],
                        common = FALSE,
                        subgroup.hetstat = FALSE,
                        sort.subgroup = TRUE,
                        colgap.left = "5mm",
                        colgap.right = "5mm",
                        plotwidth = paste0(input$plotWidth, "cm"),
                        # col.equi = "#91C8E7",
                        # fill.equi = "#CCE6F4",
                        # lty.equi = 3,
                        # lower.equi = -0.3,
                        # upper.equi = 0.3,
                        random = FALSE,
                        overall=FALSE,
                        hetstat = FALSE,
                        rightcols = c("effect.ci", "NNT"),
                        rightlabs = c( "SMD [95% CI]", "NNT"),
                        leftcols = c("Meta_review", "Outcome", "Intervention", "Rank"),
                        leftlabs = c("Meta_review", "Outcome", "Intervention", "GRADE"))

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
# forest_modif(x = filtered_data()[, c("TE", "seTE")],
#              variant = "classic",
#              # col = "Greys",
#              xlab = "SMD",
#              annotate_CI = TRUE,
#              study_table = tab(),
#              group = tab()[, "Outcome"],
#              col = "steelblue4",
#              # col = c("firebrick", "steelblue4", "Greys", "Blues")[tab()[, "GRADE"]],
#              type = "study_only",
#              text_size = 3.6,
#              x_limit = c(-2, 2),
#              # N = filtered_data()[, c("k")],
#              x_breaks = seq(-2, 2, 0.5)) , res = input$plotWidth)
#
#
# output$test <- renderText(paste0(Cols()))
# tab <- reactive({
#   data.frame(
#     Paper = filtered_data()[, c("Meta_review")],
#     Outcome = filtered_data()[, c("Outcome")],
#     Intervention = filtered_data()[, c("Intervention")],
#     GRADE = filtered_data()[, c("Rank")],
#     NNT = filtered_data()[, c("NNT")])
# })
# dat <- read.delim("dat.txt")
#
# library("shiny")
# library("shinyWidgets")
#
# ui <- fluidPage(
#   tags$h2("Update pickerInput"),
#
#   fluidRow(
#     column(
#       width = 5,
#       offset = 1,
#       pickerInput(
#         inputId = "p1",
#         label = "classic update",
#         choices = rownames(mtcars),
#         multiple=TRUE
#       )
#     ),
#     column(
#       width = 5,
#       pickerInput(
#         inputId = "p2",
#         label = "disabled update",
#         choices = rownames(mtcars),
#         multiple=TRUE)
#     )
#   ),
#
#   fluidRow(
#     column(
#       sliderInput(
#         inputId = "up",
#         label = "Select between models with mpg greater than :",
#         min = min(mtcars$mpg),
#         max = max(mtcars$mpg),
#         value = min(mtcars$mpg),
#         step = 0.1
#       )
#     )
#   )
# )
#
# server <- function(input, output, session) {
#
#   observe({
#     mtcars2 <- mtcars[mtcars$mpg >= input$up, ]
#
#     # Method 1
#     updatePickerInput(session = session, inputId = "p1",
#                       choices = rownames(mtcars2))
#
#     # Method 2
#     disabled_choices <- !rownames(mtcars) %in% rownames(mtcars2)
#     updatePickerInput(
#       session = session, inputId = "p2",
#       choices = rownames(mtcars),
#       choicesOpt = list(
#         disabled = disabled_choices,
#         style = ifelse(disabled_choices,
#                        yes = "color: rgba(119, 119, 119, 0.5);",
#                        no = "")
#       )
#     )
#   })
#
# }
#
# shinyApp(ui = ui, server = server)
#

# unique values needed to create the filters
# GRADE_values = reactive({})
# BD_values = reactive({})
# design_values = reactive({})
# age_group_values = reactive({})
# AMSTAR_values = reactive({})

# output - individual filters
# output$age_group_values <- renderUI({
#   selectInput("Age", "Age", choices = unique(dat()[, "Age"]), multiple = TRUE)
#   # pickerInput("Age", "Age", choices = unique(dat()[, "Age"]), multiple = TRUE)
# })
# observe({
#   data_save = dat() %>% filter(Age %in% input$Age)
#   updatePickerInput(session = session, inputId = "Age",
#                     choices = unique(data_save[, "Age"]))
# })

# output$BD_values <- renderUI({
#   selectInput("BD_stage", "Bipolar Disorder stage",
#               choices = unique(dat()[, "BD_stage"])
#               # ,
#               # multiple = TRUE
#               )
# })









