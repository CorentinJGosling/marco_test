library(shiny)
library(shinyjs)
library(readxl)
library(tidyverse)
library(shinyWidgets)
library(shinyalert)
library(rintrojs)
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

selectizeGroupServer_modified <-
  function(input, output, session, data, vars) {
    `%inT%` <- function(x, table) {
      if (!is.null(table) && !"" %in% table) {
        x %in% table
      } else {
        rep_len(TRUE, length(x))
      }
    }

    ns <- session$ns
    shinyWidgets:::toggleDisplayServer(
      session = session, id = ns("reset_all"),
      display = "none"
    )
    rv <- reactiveValues(data = NULL, vars = NULL)
    observe({
      if (is.reactive(data)) {
        rv$data <- data()
      } else {
        rv$data <- as.data.frame(data)
      }
      if (is.reactive(vars)) {
        rv$vars <- vars()
      } else {
        rv$vars <- vars
      }
      for (var in names(rv$data)) {
        if (var %in% rv$vars) {
          shinyWidgets:::toggleDisplayServer(session = session, id = ns(paste0(
            "container-",
            var
          )), display = "table-cell")
        } else {
          shinyWidgets:::toggleDisplayServer(session = session, id = ns(paste0(
            "container-",
            var
          )), display = "none")
        }
      }
    })
    observe({
      lapply(X = rv$vars, FUN = function(x) {
        vals <- sort(unique(rv$data[[x]]))
        updateSelectizeInput(
          session = session, inputId = x,
          choices = vals, server = TRUE
        )
      })
    })
    observeEvent(input$reset_all, {
      lapply(X = rv$vars, FUN = function(x) {
        vals <- sort(unique(rv$data[[x]]))
        updateSelectizeInput(
          session = session, inputId = x,
          choices = vals, server = TRUE
        )
      })
    })
    observe({
      vars <- rv$vars
      lapply(X = vars, FUN = function(x) {
        ovars <- vars[vars != x]
        observeEvent(input[[x]],
                     {
                       data <- rv$data
                       indicator <- lapply(X = vars, FUN = function(x) {
                         data[[x]] %inT% input[[x]]
                       })
                       indicator <- Reduce(f = `&`, x = indicator)
                       data <- data[indicator, ]
                       if (all(indicator)) {
                         shinyWidgets:::toggleDisplayServer(
                           session = session, id = ns("reset_all"),
                           display = "none"
                         )
                       } else {
                         shinyWidgets:::toggleDisplayServer(
                           session = session, id = ns("reset_all"),
                           display = "block"
                         )
                       }
                       for (i in ovars) {
                         if (is.null(input[[i]])) {
                           updateSelectizeInput(
                             session = session, inputId = i,
                             choices = sort(unique(data[[i]])), server = TRUE
                           )
                         }
                       }
                       if (is.null(input[[x]])) {
                         updateSelectizeInput(
                           session = session, inputId = x,
                           choices = sort(unique(data[[x]])), server = TRUE
                         )
                       }
                     },
                     ignoreNULL = FALSE,
                     ignoreInit = TRUE
        )
      })
    })

    observe({
      updateSelectInput(inputId = "Age",
                        choices = unique(rv$data$Age),
                        selected = "Adults")
      updateSelectInput(inputId = "BD_stage",
                        choices = unique(rv$data$BD_stage),
                        selected = "Bipolar Depression")
      updateSelectInput(inputId = "Comparison",
                        choices = unique(rv$data$Comparison),
                        selected = "placebo")
    })


    return(reactive({
      data <- rv$data
      vars <- rv$vars
      indicator <- lapply(X = vars, FUN = function(x) {
        `%inT%`(data[[x]], input[[x]])
      })
      indicator <- Reduce(f = `&`, x = indicator)
      data <- data[indicator, ]
      return(data)
    }))
  }

# UI MODULE ---------------------------------------------------------------


selectizeGroupUI_custom <-
  function(id, params, label = NULL, btn_label = "Reset filters", inline = TRUE) {
    ns <- NS(id)
    if (inline) {
      selectizeGroupTag <- tagList(
        ##### NEW LOCATION FOR THE BUTTON #####
        actionButton(
          inputId = ns("reset_all"), label = btn_label,
          style = "float: left;"
          ##### NEW LOCATION FOR THE BUTTON #####
        ),
        tags$b(label), tags$div(
          class = "btn-group-justified selectize-group",
          role = "group", `data-toggle` = "buttons", lapply(
            X = seq_along(params),
            FUN = function(x) {
              input <- params[[x]]
              tagSelect <- tags$div(
                class = "btn-group",
                id = ns(paste0("container-", input$inputId)),
                selectizeInput(
                  inputId = ns(input$inputId),
                  label = input$title, choices = input$choices,
                  selected = input$selected, multiple = ifelse(is.null(input$multiple),
                                                               TRUE, input$multiple
                  ), width = "100%",
                  options = list(
                    placeholder = input$placeholder,
                    plugins = list("remove_button"), onInitialize = I("function() { this.setValue(\"\"); }")
                  )
                )
              )
              return(tagSelect)
            }
          )
        )
      )
    } else {
      selectizeGroupTag <- tagList(tags$b(label), lapply(
        X = seq_along(params),
        FUN = function(x) {
          input <- params[[x]]
          tagSelect <- selectizeInput(
            inputId = ns(input$inputId),
            label = input$title, choices = input$choices,
            selected = input$selected, multiple = ifelse(is.null(input$multiple),
                                                         TRUE, input$multiple
            ), width = "100%", options = list(
              placeholder = input$placeholder,
              plugins = list("remove_button"), onInitialize = I("function() { this.setValue(\"\"); }")
            )
          )
          return(tagSelect)
        }
      ), actionLink(
        inputId = ns("reset_all"), label = btn_label,
        icon = icon("remove"), style = "float: right;"
      ))
    }
    tagList(
      singleton(tagList(tags$link(
        rel = "stylesheet", type = "text/css",
        href = "shinyWidgets/modules/styles-modules.css"
      ), shinyWidgets:::toggleDisplayUi())),
      selectizeGroupTag
    )
  }


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
     display: flex !important;
     gap: 1rem;
     # justify-content: space-between;
     max-width: 99vw !important;
 }
 .left {
   display: flex !important;
   flex-direction: column;
   background-color: #add6ed;
   width: 25vw !important;
   padding: 1rem;
   border-radius: 10px;
  }
  .right {
     # border: 2px solid red;
     background-color: #fff;
     overflow-x: hidden;
     width: 100% !important;
     width: 75vw !important;
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
  #warning{
    margin-top: 5rem;
    max-width: 80ch !important;
    margin-left: auto;
    margin-right: auto;
    border: 2px solid red;
    padding: 1rem;
    background-color: #F4DEDE;
  }
  #my_filters{
  display: flex !important;
  flex-direction: column !important;
  gap: 2rem !important;
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
      # display: flex !important;
      # flex-direction: column !important;
      # align-items: center !important;
      # justify-content: center !important;
      # text-align : center !important;
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
  #warning{
    margin-top: 2rem !important;
  }

 }

")),
shinyjs::useShinyjs(),
introjsUI(),

inlineCSS(list(.grey = "opacity: 0.5 !important;",
               .disappear = "display: none !important;")),

div(class = "split",
    # filtering panel ========================
    div(class = "left",
        h3("Filtering panel"),
        selectizeGroupUI_custom(
          inline = FALSE,
          id = "my_filters",
          btn_label = "Show all data",
          params = list(
            Age = list(inputId = "Age", title  = "Age",  placeholder = 'Nothing selected'),
            BD_stage = list(inputId = "BD_stage", title  = "Bipolar stage", placeholder = 'Nothing selected'),
            Intervention = list(inputId = "Intervention", title  = "Intervention", placeholder = 'Nothing selected'),
            Outcome = list(inputId = "Outcome", title  = "Outcome", placeholder = 'Nothing selected'),
            Comparison = list(inputId = "Comparison", title  = "Comparison", placeholder = 'Nothing selected'),
            Design = list(inputId = "Design", title  = "Type of meta-analysis", placeholder = 'Nothing selected'),
            Rank = list(inputId = "Rank", title  = "GRADE", placeholder = 'Nothing selected'),
            AMSTAR = list(inputId = "AMSTAR", title  = "AMSTAR", placeholder = 'Nothing selected')
          )
        ),
        br()
        # actionButton("download_button", "Download data") #
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
                                         div(class = "box_num",
                                             textOutput('comp_n')),
                                             # uiOutput('box_comp_n')),
                                     ),
                                     div(class = "box",
                                         div(class = "box_text", p("Comparisons with treatment superior to control")),
                                         div(class = "box_num",
                                             textOutput('comp_eff')),
                                             # uiOutput('box_comp_eff')),
                                     ),
                                     div(class = "box",
                                           div(class = "box_text", p("Comparisons with a High GRADE rating")),
                                           div(class = "box_num",
                                               textOutput('comp_high')),
                                              # uiOutput('box_comp_high')),
                                       ),
                                   ),

                               div(class = "row_boxes_plot",
                                   div(class = "box_plot",
                                       div(class = "plot_text",
                                           p(paste("Top 15 most studied interventions"))),
                                       div(class = "row_plots", plotlyOutput("circle_interventions"))
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
                                   div(class="plot_warning", textOutput('warning')),
                                   # plotOutput('forest', height = 200 * 14 + 500)
                                   # uiOutput('forest_warning'),
                                   uiOutput('forest_container')

                               ))
                    ),

                    tabPanel("Database",
                             div(class = "table",
                                 shinycssloaders::withSpinner(
                                   DT::DTOutput("table_container")))),
                    tabPanel("Compare",
                             div(class = "radar_table",
                                 h1("Visualise efficacy of interventions"),
                                 p("If no filter is applied, we plot the top 3 interventions on the top 3 outcomes"),
                                 p("Of note, to enable meaningful comparisons, we restricted this section to interventions compared to a placebo-only group."),
                                 selectizeGroupUI(
                                   id = "my_filters_radar",
                                   inline = TRUE,
                                   params = list(
                                     Intervention = list(inputId = "Intervention", title  = "Intervention", placeholder = 'Nothing selected'),
                                     Outcome = list(inputId = "Outcome", title  = "Outcome", placeholder = 'Nothing selected')
                                   )
                                 ),
                                 actionButton("btn_alert", "How to interpret this plot?"),
                                 shinycssloaders::withSpinner(plotlyOutput("radar_plot"))
                                 )),
        )

    )

 )
)

server <- function(input, output, session) {

  ###################################################
  ##################### DATA ########################
  ###################################################
  # raw data stored locally
  dat <- readRDS("dat.RDS")
  # dat <- dat %>%
  #   filter(Age == "Adults" & BD_stage == "Bipolar Depression" & Comparison == "placebo")

  # https://www.davidsolito.com/post/conditional-drop-down-in-shiny/
  # https://heds.nz/posts/dependent-selectInputs-shiny/
  ######################################################
  ##################### FILTERS ########################
  ######################################################
  filterData <- callModule(
    module = selectizeGroupServer_modified,
    id = "my_filters",
    data = dat,
    vars = c("Age", "BD_stage", "Intervention",
             "Outcome", "Comparison", "Design", "Rank", "AMSTAR")
  )

  ####################################################
  ##################### values #######################
  ####################################################
  row_filtered_data = reactive({ nrow(filterData()) })
  row_rank_one = reactive({ nrow(filterData() %>% filter(Rank == "I (High)")) })
  row_eff = reactive({ nrow(filterData()  %>% filter(TE_lo > 0)) })
  Wdth = reactive({ shinybrowser::get_width() })

  filterDataPlot <- reactive({
    if (row_filtered_data() > 50) {
      # filterData()[order(filterData()[, 'Rank'], abs(filterData()[, 'invTE'])), ][1:50, ]
      # dat[order(dat[, 'Rank'], abs(dat[, 'invTE'])), ][1:50, ]
      # filterData() %>%
      dat_sub = filterData() %>%
        arrange(Rank, invTE)
      dat_sub[1:50, ]

    } else {
      filterData()
    }
  })
  row_plot_data = reactive({ nrow(filterDataPlot()) })

  ####################################################
  ##################### BOXES ########################
  ####################################################
  output$comp_n = renderText({ paste0(row_filtered_data()) })
  output$comp_high = renderText({ paste0(row_rank_one()) })
  output$comp_eff = renderText({ paste0(row_eff()) })

  ########################################################
  ##################### DASHBOARD ########################
  ########################################################
  output$circle_interventions <- renderPlotly({
    # https://rdrr.io/github/djpr-data/djprshiny/man/djpr_girafe.html



    res <- filterData() %>%
    # res <- dat %>%
      # filter(Age == "Adults" & BD_stage == "Bipolar Depression" & Intervention == "lithium (mono)" & Comparison == "placebo") %>%
      # filter(Age == "Adults" & BD_stage == "Bipolar Depression" & Comparison == "placebo") %>%
      # filter(Age == "Adults" & BD_stage == "Bipolar Depression" &
      #          Intervention == "aripiprazole (mono)" &
      #          Comparison == "placebo (mono)") %>%
      mutate(es_pos = ifelse(TE_lo > 0, "effective",
                             ifelse(TE_up < 0, "harmful", "no_effect"))) %>%
      group_by(Intervention, es_pos) %>%
      summarise(value=n()) %>%
      group_by(Intervention) %>%
      mutate(Intervention_double = n(),
             n_total = sum(value)) %>%
      ungroup()

    if (nrow(res) > 50) {
      res <- res %>%
        filter(Intervention_double > 1 & n_total %in% tail(sort(n_total), 50))
    }
    res <- res %>%
      pivot_wider(names_from = es_pos,
                  values_from = value)

    res <- res[order(-res$n_total), ]

    if (!"harmful" %in% colnames(res)) {
      res$harmful = 0
    }
    if (!"no_effect" %in% colnames(res)) {
      res$no_effect = 0
    }
    if (!"effective" %in% colnames(res)) {
      res$effective = 0
    }

    fig <- plot_ly(res, x = ~effective, y = ~Intervention, type = 'bar', name = 'Beneficial',
                   marker = list(color = 'rgb(127,207,162)'))

    fig <- fig %>% add_trace(x = ~no_effect, name = 'No effect (not significant)',
                             marker = list(color = 'rgb(213,213,213)'))

    fig <- fig %>% add_trace(x = ~harmful, name = 'Harmful',
                             marker = list(color = 'rgb(217,143,143)'))

    fig <- fig %>% layout(xaxis = list(title = 'Total number of comparisons'),
                          yaxis = list(title = "", categoryorder = "total ascending"),
                          barmode = 'stack')


    # packing <- circleProgressiveLayout(res$value, sizetype='area')
    # packing$radius <- 0.95*packing$radius
    # data <- cbind(res, packing)
    # data$text <- paste("Intervention name: ", data$Intervention, "\n",
    #                    "Number of comparisons: ", data$value, "\n")
    #
    # dat.gg <- circleLayoutVertices(packing, npoints=50)
    #
    # p <- ggplot() +
    #   geom_polygon_interactive(data = dat.gg,
    #                            aes(x, y, group = id, fill=id,
    #                                tooltip = data$text[id], data_id = id),
    #                            colour = "black", alpha = 0.4) +
    #   scale_fill_viridis() +
    #   geom_text(data = data, aes(x, y, label = substr(Intervention, 1, 4)),
    #             size=2, color="black") +
    #   theme_void() +
    #   theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm") ) +
    #   coord_equal()
    # girafe(ggobj = p)

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
  })

  # ============================================================= #
  # ======================== PLOT =============================== #
  # ============================================================= #

  output$warning = renderText({
    paste0("Because the number of comparisons is too large to be rendered in a unique figure (n=",
           row_filtered_data(),
           "), we display the comparisons with the higher level of evidence (higher GRADE)",
           ", and the larger effect sizes (both positive and negative ones).")
  })
  observe({
      toggleClass(selector = ".plot_warning", class="disappear",
                  condition = !row_filtered_data() > 50)
  })

  output$forest_container <- renderUI({
    withSpinner(
      plotOutput('forest', height = row_plot_data() * 14 + 300),
      type = 5,
      size = 0.5)
  })


  mgenmod = reactive({
    mgen = meta::metagen(TE=TE, seTE=seTE, data=filterDataPlot())
    meta::update.meta(mgen, subgroup = Rank,
                      subgroup.name = "GRADE, certainty of the evidence",
                      tau.common = FALSE)
  })

  # output$forest <- renderPlot(
  output$forest <- renderPlot(

    meta::forest.meta(mgenmod(),
                      # sortvar = filterDataPlot()[, "invTE"],
                      xlab = "Equivalent Standardized Mean Difference",
                      common = FALSE,
                      subgroup.hetstat = FALSE,
                      sort.subgroup = TRUE,
                      colgap.left = "5mm",
                      colgap.right = "5mm",
                      plotwidth = paste0(ifelse(Wdth() > 1400, 14,
                                                ifelse(Wdth() > 1000, 7,
                                                       ifelse(Wdth() > 800, 5, 4))), "cm"),
                      random = FALSE,
                      overall=FALSE,
                      hetstat = FALSE,
                      rightcols = c("effect.ci", "eNNT"),
                      rightlabs = c( "eSMD [95% CI]", "eNNT / eNNH"),
                      leftcols = c("Age", "BD_stage", "Outcome_acro", "Intervention", "Comparison"), #"Meta_review",
                      leftlabs = c("Age", "BD stage", "Outcome", "Intervention", "Control group"), #"Meta_review",
                      label.right = "=> Clinically beneficial",# col.label.right = "#49733E",
                      label.left = "Clinically harmful <="#, col.label.left = "#633434"
    )

  )

  # ===================================================== #
  # ======================== RADAR plot ================= #
  # ===================================================== #
  # updatePickerInput(session = session, inputId = "interventions_radar",
  #                   choices = unique(dat$Intervention),
  #                   selected="")
  # updatePickerInput(session = session, inputId = "outcomes_radar",
  #                   choices = unique(dat$Outcome),
  #                   selected="")

  dat_rad <- callModule(
    module = selectizeGroupServer,
    id = "my_filters_radar",
    data = subset(dat, Comparison == "placebo"),
    vars = c("Intervention", "Outcome")
  )

  outcomes_rad = reactive({
    if (is.null(input[["my_filters_radar-Outcome"]])) {
      names(tail(sort(table(dat$Outcome)), 3))
    } else {
      input[["my_filters_radar-Outcome"]]
    }
  })
#
  interventions_rad = reactive({
    if (is.null(input[["my_filters_radar-Intervention"]])) {
      names(tail(sort(table(dat$Intervention)), 3))
    } else {
      input[["my_filters_radar-Intervention"]]
    }
  })

  dat_radar = reactive({
    dat_rad() %>%
      filter(Intervention %in% interventions_rad() &
               Outcome %in% outcomes_rad()) %>%
      group_by(paste(Intervention, Outcome)) %>%
      #!!!! solve when several control groups
      slice(1) %>%
      as.data.frame()
  })




  output$radar_plot <- renderPlotly({

    low = min(dat_radar()[, "TE"] - 0.2) #
    up = max(dat_radar()[, "TE"] + 0.2) #
    fig = plot_ly(
          type = 'scatterpolar',
          opacity = 0.7,
          fill = 'toself',
          mode="text") %>%
      layout(
        polar = list(
          radialaxis = list(
            angle = 90,

            # color = ~dat_radar()[,"TE"],
            # colors=c("red"),
            # color = rep("A", length(dat_radar()[, "TE"])),
            # colors=c("red"),
            # cmid = 0,
            visible = T,
            range = c(low, up),
            fillcolor = '#B6FFB4'


          )
        ),
        showlegend = T
      )


    for (INT in unique(dat_radar()[,"Intervention"])) {
      fig = fig %>%
        add_trace(
          r = subset(dat_radar(), Intervention == INT)[,"TE"],
          theta = subset(dat_radar(), Intervention == INT)[,"Outcome"],
          # fillcolor = "red",
          fillcolor = list(colorscale='Viridis'),
          marker = list(
            size=10
            # color = ~subset(dat_radar(), Intervention == INT)[,"TE"],
            # colors = viridis_pal()(length(subset(dat_radar(), Intervention == INT)[,"TE"]))
            # cmin = 0,
            # cmax = 1,
            # colorbar = dict(title='title'),
            # colorscale = 'Viridis'
          ),

          hovertemplate = "SMD = %{r},
          Outcome = %{theta}",
          # text=~paste("SMD=", r, " (",
          #               ifelse(subset(dat_radar(), Intervention == INT)[,"TE"] > 0, "clinically beneficial", "clinically harmful"), ")"),
          name = INT

        )
    }

    fig = fig %>%
      add_trace(type = "pie", labels = "Clinically beneficial",
                values = 1,
                marker = list(colors = "green"),
                hoverinfo = 'text',
                text="This green zone indicates a clinically beneficial effect. \nYou can toggle the visibility of this zone by clicking on the 'Clinically beneficial' button in the legend.",
                textinfo ="none",
                hole = ifelse(low < 0 & up > 0,
                              abs(low) / (abs(low) + abs(up)),
                              ifelse(low < 0 & up < 0, 1,
                                     ifelse(low > 0 & up > 0, 0, 1))),
                opacity = 0.2)
# ,visible = "legendonly"


    fig

  })


  observeEvent(input$btn_alert, {
    # Show a simple modal
    shinyalert(text = "Some help to interpret the plot!",
               imageUrl = "tuto_radar.png",
               imageHeight = "500",
               imageWidth = "700",
               size = "l")
  })

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
