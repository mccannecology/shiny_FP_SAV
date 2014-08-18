# ui.R

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Floating Plant-Submerged Plant Interactions"),
  
  sidebarPanel(
    h3("Description"),
    p("A multi-year, 2-d, spatially-explicit, simulation model of interactions between
      floating and submerged plants in freshwater lakes and ponds. For a complete description 
      of the model click on the 'Model Description' tab."),
    hr(),
    
    h3("User Inputs"),
    selectInput("TOTALN", 
                "TOTALN:",
                choices=c(0.1,0.5,1,2,3,4,5,6,7,8,9,10),
                selected=5
    ),
    selectInput("shape", 
                "Shape:",
                choices=c("rectangle","hook","tee","eight","cross"),
                selected="rectangle"
    ),
    selectInput("size", 
                "Size (sq.m):",
                choices=list("~400"="small","~1600"="large")
    ),
    selectInput("initial_perc_FP_cover", 
                "Initial FP cover(%):",
                choices=c(1,5,15,30,45),
                selected=15
    ),
    selectInput("initial_perc_SAV_cover", 
                "Initial SAV cover(%):",
                choices=c(1,5,15,30,45),
                selected=15
    ),
    selectInput("shadingbyFP", 
                "FP shading SAV:",
                choices=c(0.02,0.04,0.08)
    ),
    # modify this one so the input is more user-friendly 
    # e.g., wind avg - instead of wind shape 
    selectInput("wind_shape2", 
                "Wind strength:",
                choices=list("weak"=4,"strong"=0.2)
    ),
    selectInput("wind_direction", 
                "wind_direction:",
                choices=c("all","up")
    ),
    
    hr(),
    strong("Simulation number:"),
    textOutput("simulation")
    
  ),
    
  mainPanel(
    tabsetPanel(type = "tabs",     
      
        ############# 
        # COVER TAB #
        #############
        tabPanel(title="% Cover", 
        h3("Percent cover through time"),
        imageOutput("cover",height="100%")
        ),
        
        ############### 
        # INITIAL TAB #
        ###############
        tabPanel(title="Initial", 
        h3("Initial conditions"),
        imageOutput("initial",height="100%")
        ),
        
        ############## 
        # MIDDLE TAB #
        ##############
        tabPanel(title="Mid-Point",
        h3("Mid-point"),
        imageOutput("middle",height="100%")
        ),
        
        ############# 
        # FINAL TAB #
        #############
        tabPanel(title="Final",
        h3("Final conditions"),
        imageOutput("final",height="100%")
        ),
        
        ################# 
        # NUTRIENTS TAB #
        #################
        tabPanel(title="Nutrients",
        h3("Nutrients through time"),
        imageOutput("nutrients",height="100%")
        ),
        
        ############ 
        # WIND TAB #
        ############
        tabPanel(title="Wind",
        h3("Frequency distribution of wind strength"),
        plotOutput("wind"),
        br(),
        strong("Average wind strength"),
        textOutput("wind_avg"),
        strong("Variance of wind strength"),
        textOutput("wind_var")
        ),
        
        ################# 
        # ALT STATE TAB #
        #################
        tabPanel(title="Alt. States",
        h3("Alternative State Trajectory"),
        imageOutput("AltStatePlot",height="100%"),
        br(),
        h4("Note:"),
        p("This plot summarizes the result of varying the initial FP and SAV conditions. 
          All other variables are the same.")
        ),
                
        ################### 
        # DESCRIPTION TAB #
        ###################
        tabPanel(title="Model Description",
        h3("Description of the Model"),
        br(),
        h4("Background & Goals"),
        p("Text will go here."),
        br(),
        h4("Growth equations"),
        p("Text will go here."),
        br(),
        h4("Vegetative spread"),
        p("Text will go here."),
        br(),
        h4("Wind-dispersal"),
        p("Text will go here.")
        ),
        
        ################## 
        # PARAMETERS TAB #
        ##################
        tabPanel(title="Default Parameters",
        h3("Default (fixed) parameter values"),
        br(),
        
        strong("Number of years"),
        p("7"),
        strong("Days per growing season"),
        p("125"),
        br(),
        
        h4("Growth parameters"),
        strong("Max. growth rate (FP&SAV)"),
        p("0.5"),
        strong("Half-saturation N (FP)"),
        p("0.2"),
        strong("Half-saturation N (SAV)"),
        p("0"),
        strong("Uptake N (FP)"),
        p("0.075"),
        strong("Uptake N (SAV)"),
        p("0.005"),
        strong("Respiration & mortality (Loss) (FP&SAV)"),
        p("0.05"),
        strong("Self-light limitation (FP&SAV)"),
        p("0.1"),
        strong("Light attenutation in water column"),
        p("0"),
        strong("Overwintering (FP&SAV)"),
        p("0.1"),
        br(),
        
        h4("Movement/Wind parameters"),
        strong("Wind shape parameter 1"),
        p("0.04"),
        strong("Full threshold (wind)"),
        p("600"),
        strong("Amount to colonize (vegetative) (FP&SAV)"),
        p("1"),
        strong("Focal threshold (vegetative) (FP&SAV)"),
        p("0"),
        strong("Neighborhood threshold (vegetative) (FP&SAV)"),
        p("150")        
        )
    )
  )
)
)
  
