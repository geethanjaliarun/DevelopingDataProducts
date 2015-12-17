library(shiny)
shinyUI(
        fluidPage
        (
                titlePanel
                (
                        "Respiratory Cancer Rates"
                ),
                navlistPanel
                (
                        tabPanel
                        ("How to use this tool?",
                          sidebarLayout
                          (
                                position = "right",
                                mainPanel(),
                                sidebarPanel
                                (
                                        width = 12,
                                        strong("About"),
                                        br(),
                                        br(),
                                        p("Respiratory Cancer tool is a data exploration and data visualization tool to get the count and crude rate of the 
                                           incidence of cancers related to respiratory systems across the U.S.
                                           The data is sourced from the CDC website. The data is grouped by Cancer site,
                                           Age group, gender, race and ethnicity. The data includes all locations and the time period 
                                           is from 1999-2012."),
                                        p(" The counts report the frequency of verified cancer diagnoses in the selected population and time period."),
                                        p("Crude Rates are expressed as the number of cases reported each calendar year per 100,000 population."),
                                        br(),
                                        strong("Summarize"),
                                        br(),
                                        br(),
                                        p("This form requires the user to select the cancer site, age group,
                                          gender, race and ethnicity to get the count and crude rate. On clicking
                                          the 'Get' button the count and crude rate gets displayed."),
                                        br(),
                                        strong("Visualize"),
                                        br(),
                                        br(),
                                        p("This form requires the factor to plot the counts.")
                                )
                          )
                        
                        ),
                        tabPanel
                        ("Summarize",
                          sidebarLayout
                          (
                               position = "right",
                               mainPanel(
                
                                         p("NOTE: Crude Rates are expressed as the number of cases reported each calendar year per 100,000 population."),
                                         p("Crude Rate = Count / Population * 100,000"),
                                         p("Cancer case reports in this data set are counted by or summed by the cancer reported. 
                                                For example, a single person with more than one primary cancer verified by a medical doctor is counted as a case report for each type of primary cancer reported. 
                                                Having more than one primary cancer occurs in less than 20% of the population. The counts report the frequency of verified cancer diagnoses in the selected population and time period."),
                                         strong("SOURCE: CDC website. (http://wonder.cdc.gov/cancer-v2012.htm)"),
                                         br(),
                                         br(),
                                         verbatimTextOutput("countText"),
                                         verbatimTextOutput("crudeRateText"),
                                         br(),
                                         br(),
                                         width = 5),
                               sidebarPanel
                               (
                               width = 7,
                               selectInput("cancerSite",
                                           label = "Cancer Site",
                                           choices = list("Larynx" = 1,
                                                          "Lung and Bronchus" = 2,
                                                          "Nose, Nasal Cavity and Middle Ear" = 3,
                                                          "Pleura" = 4,
                                                          "Respiratory System" = 5,
                                                          "Trachea, Mediastinum and Other Respiratory Organs" = 6),
                                           selected = 1),
                               uiOutput("cancerSiteControls"),
                               uiOutput("ageGroupControls"),
                               uiOutput("genderControls"),
                               uiOutput("raceChoiceControls"),
                               uiOutput("ethnicityChoiceControls"),
                               actionButton("goButton", "Get Count and Crude Rate")
                               
                               )
                           )
                          ),
                          tabPanel
                          ("Visualize",
                            sidebarLayout
                            (
                                position = "right",
                                mainPanel
                                (
                                        plotOutput("countPlot"),
                                        width = 7
                                ),
                                sidebarPanel
                                (
                                        selectInput("variable",
                                            label = "Factor",
                                            choices = list("Cancer Site" = 1,
                                                           "Age Group" = 2,
                                                           "Gender" = 3,
                                                           "Race" = 4,
                                                           "Ethnicity" = 5),
                                            selected = 1),
                                        actionButton("plotButton", "Plot"),
                                        width = 5
                                )
                            )
                          ),
                          widths = c(3,8)
                )
        )
       )