# ui.R

library(shiny)
library(downloader)

shinyUI(pageWithSidebar(
  
  headerPanel("Floating Plant-Submerged Plant Interactions"),
  
  sidebarPanel(    
    h3("User Inputs"),
    selectInput("TOTALN", 
                "Total N (mg/L):",
                choices=c(0.1,0.5,1,2,3,4,5,6,7,8,9,10),
                selected=5
    ),
    selectInput("shape", 
                "Shape:",
                choices=c("rectangle","hook","tee","eight","cross"),
                selected="rectangle"
    ),
    selectInput("size", 
                "Size (ha):",
                choices=list("0.04"="small",
                             "0.16"="large",
                             "0.64"="larger",
                             "2.25"="larger2")
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
                "FP shading SAV coefficient:",
                choices=c(0.02,0.04,0.08)
    ),
    # modify this one so the input is more user-friendly 
    # e.g., wind avg - instead of wind shape 
    selectInput("wind_shape2", 
                "Wind strength:",
                choices=list("weak"=4,"strong"=0.2)
    ),
    selectInput("wind_direction", 
                "Prevailing wind direction:",
                choices=list("none"="all","up"="up")
    ),
    
    hr(),
    strong("Simulation number:"),
    textOutput("simulation")
    
  ),
    
  mainPanel(
    tabsetPanel(type = "tabs",     
        ############## 
        # WELCOME #
        ##############
        tabPanel(title="Welcome",
        h3("Welcome"),
        imageOutput("alt_states",height="50%",width="50%"),
        br(),
        br(),
        h3("Table of Contents:"),
        HTML("<strong> - Model Description:</strong> A detailed description of the model."),
        br(),
        HTML("<strong> - Default Parameters:</strong> Definition of parameters and default values typically used."),
        br(),
        HTML("<strong> - Initial:</strong> Spatial plot of vegetation, initial."),
        br(),
        HTML("<strong> - Mid-Point:</strong> Spatial plot of vegetation, 1/2 through simulation."),
        br(),
        HTML("<strong> - Final:</strong> Spatial plot of vegetation, end of simulation."),
        br(),
        HTML("<strong> - % Cover:</strong> Plot of % cover by each plant group through time."),
        br(),
        HTML("<strong> - Nutrients:</strong> Plot of nutrient concentrations through time."),
        br(),
        HTML("<strong> - Wind:</strong> Description of wind dynamics."),
        br(),
        HTML("<strong> - Alt. States:</strong> Plot summarizing multiple simulations from different initial conditions."),
        br(),
        br(),
        h3("Contact:"),
        p("Please direct any comments, questions, or bug reports to:"),
        HTML("<strong>Michael J. McCann</strong>"),
        br(),
        HTML("Department of Ecology & Evolution"),
        br(),
        HTML("Stony Brook University"),
        br(),
        HTML("Stony Brook, NY USA"),
        br(),
        HTML("mccann AT life.bio.sunysb.edu"),
        br(),
        HTML("mccannecology.weebly.com"),
        br(),
        br(),
        HTML("<I>Last updated: 8 September 2014.</I>"),
        br(),
        br()
        ),
                
        ################### 
        # DESCRIPTION TAB #
        ###################
        tabPanel(title="Model Description",
        h3("Description of the Model"),
        br(),
        
        h4("Background & Goals"),
        p("This is a multi-year, 2-d, spatially-explicit, simulation model of interactions 
          between floating and submerged plants in freshwater lakes and ponds. The goal of this 
          model is to examine the effects of spatial processes on the alternative states 
          formed by these plant groups. Previous models of this system were developed for 
          spatially-simple habitats (e.g., agricultural ditches), so many spatial processes and
          factors were not included. Factors of interest for this model include water body size 
          and shape and wind disturbance.  
         "),
        br(),
        
        h4("Growth equations"),
        p("Plant growth is governed  by equations used in Scheffer et al. (2003).
          These equations include nutrient- and light-dependent growth. 
          "),
        imageOutput("growth_equation",height="50%",width="50%"),
        br(),
        
        h4("Nutrient uptake equations"),
        p("The current nutrient concentration is governed by the equation used in Scheffer et al. (2003)."),
        imageOutput("uptake_equation",height="25%",width="25%"),
        br(),
        
        h4("Parameter names & values"),
        p("Table of parameter names and default values used in Scheffer et al. (2003)."),
        imageOutput("default_parameters",height="60%",width="60%"),
        br(),
        
        h4("Water body size & shape"),
        p("There are four possible water body sizes to choose from: 0.04, 0.16, 0.64, and 2.25 ha (5.06 ha coming soon)."),
        p("There are five possible water body shapes to choose from."),
        imageOutput("waterbody_shapes",height="25%",width="50%"),
        br(),
        br(),
        
        h4("Initial Conditions"),
        p("There are five possible initial % cover values for floating plants and submerged plants to choose from respectively."),
        p("They are 1, 5, 15, 30, and 45%."),
        p("Initial locations are randomly assigned throughout the grid."),
        p("Initial cells contain approximately 100 g/sq. m each."),
        br(),
        
        h4("Seasonality"),
        p("Seasonality parameters are fixed for the simulations viewed here."),
        p("Each simulation runs for 4 years with 125 days per growing season."),
        p("At the end of the end of a growing season, the current biomass dies according to the parameter 'Overwinter'."),
        p("In these simulations, 10% of all biomass returns next year."),
        p("Nutrients are released back into the water column upon each overwintering."),
        br(),
        
        h4("Vegetative spread"),
        p("Both FP and SAV can colonize neighboring cells via vegetative spread."),
        p("Empty cells with lots of biomass in their neighbors are more likely to be colonized."),
        p("This process is governed by 3 parameters:"),
        p(" - Focal threshold (g dw/m2) [focal_thresh]"),
        p(" - Neigh threshold (g dw/m2) [neigh_thresh]"),
        p(" - Amount to colonize (g dw) [amnt_colonize]"),
        strong("On each time step:"),
        p(" - Any cell that is less than or equal to [focal_thresh]"),
        p(" - and whose biomass of their 8 neighbors is greater than [neigh_thresh]"),
        p(" - will gain [amnt_colonize] on the next time step."),
        p(" - Biomass moved is evenly subtracted from all cells greater than [neigh_thresh/2]."),
        br(),
        br(),
        
        h4("Wind-dispersal"),
        p("Only FP move via wind dispersal. See the 'Wind' tab for a complete description.")
        ),      
        
        ################## 
        # PARAMETERS TAB #
        ##################
        tabPanel(title="Default Parameters",
        h3("Default (fixed) parameter values"),
        br(),
         
        p("These parameters are fixed for all simulations shown here, but can be modified in other simulations."),
        br(), 
         
        strong("Number of years"),
        p("4"),
        strong("Days per growing season"),
        p("125"),
        br(),
         
        h4("Growth parameters"),
        strong("Max. growth rate (FP&SAV) (1/day)"),
        p("0.5"),
        strong("Half-saturation N (FP) (mg N/L)"),
        p("0.2"),
        strong("Half-saturation N (SAV) (mg N/L)"),
        p("0"),
        strong("Uptake N (FP) (1/(g dw/m2)"),
        p("0.075"),
        strong("Uptake N (SAV) (1/(g dw/m2)"),
        p("0.005"),
        strong("Respiration & mortality (Loss) (FP&SAV) (1/day)"),
        p("0.05"),
        strong("Self-light limitation (FP&SAV) (1/day)"),
        p("0.1"),
        strong("Light attenutation in water column"),
        p("0"),
        strong("Overwintering (FP&SAV) (proportion)"),
        p("0.1"),
        br(),
         
        h4("Movement/Wind parameters"),
        strong("Wind shape parameter 1"),
        p("0.04"),
        strong("Full threshold (wind) (g dw/m2)"),
        p("600"),
        strong("Amount to colonize (vegetative) (FP&SAV) (g dw)"),
        p("1"),
        strong("Focal threshold (vegetative) (FP&SAV) (g dw/m2)"),
        p("0"),
        strong("Neighborhood threshold (vegetative) (FP&SAV) (g dw/m2)"),
        p("150")
        ),    
        
        ############### 
        # INITIAL TAB #
        ###############
        tabPanel(title="Initial", 
        h3("Initial conditions"),
        imageOutput("initial",height="75%",width="75%"),
        br(),
        strong("Notes:"),
        p("Each cell is 1 square meter."),
        p("Units for biomass are g dw/m2."),
        p("Scale bars are unique for each plot."),
        p("FPtotal and FP01 are redundant plots."),
        p("The plot 'LAND' shows a value of 0 for water (yellow or white) 
          and a value of 1 (green) for land."),
        strong("Warning:"),
        p("This is the result of a single, stochastic simulation.
          Results may differ if this simulation is re-run.
          "),
        strong("Warning:"),
        p("Color scale is not consistent across plots 
          (i.e., equal colors are not equal biomass).")
        ),
        
        ############## 
        # MIDDLE TAB #
        ##############
        tabPanel(title="Mid-Point",
        h3("Mid-point"),
        imageOutput("middle",height="75%",width="75%"),
        br(),
        strong("Notes:"),
        p("Each cell is 1 square meter."),
        p("Units for biomass are g dw/m2."),
        p("Scale bars are unique for each plot."),
        p("FPtotal and FP01 are redundant plots."),
        p("The plot 'LAND' shows a value of 0 for water (yellow or white) 
          and a value of 1 (green) for land."),
        strong("Warning:"),
        p("This is the result of a single, stochastic simulation.
          Results may differ if this simulation is re-run.
          "),
        strong("Warning:"),
        p("Color scale is not consistent across plots 
          (i.e., equal colors are not equal biomass).")
        ),
        
        ############# 
        # FINAL TAB #
        #############
        tabPanel(title="Final",
        h3("Final conditions"),
        imageOutput("final",height="75%",width="75%"),
        br(),
        strong("Notes:"),
        p("Each cell is 1 square meter."),
        p("Units for biomass are g dw/m2."),
        p("Scale bars are unique for each plot."),
        p("FPtotal and FP01 are redundant plots."),
        p("The plot 'LAND' shows a value of 0 for water (yellow or white) 
          and a value of 1 (green) for land."),
        strong("Warning:"),
        p("This is the result of a single, stochastic simulation.
          Results may differ if this simulation is re-run.
          "),
        strong("Warning:"),
        p("Color scale is not consistent across plots 
          (i.e., equal colors are not equal biomass).")
        ),
        
        ############# 
        # COVER TAB #
        #############
        tabPanel(title="% Cover", 
        h3("Percent cover through time"),
        imageOutput("cover",height="75%",width="75%"),
        br(),
        p("Note: variables labelled 'All_FP' and 'FP_01' are redundant"),
        strong("Warning:"),
        p("This is the result of a single, stochastic simulation.
          Results may differ if this simulation is re-run.
          ")
        ),
        
        ################# 
        # NUTRIENTS TAB #
        #################
        tabPanel(title="Nutrients",
        h3("Nutrients through time"),
        imageOutput("nutrients",height="75%",width="75%"),
        strong("Note:"),
        p("Phosphorus-dependent growth is not included in this model."),
        strong("Warning:"),
        p("This is the result of a single, stochastic simulation.
          Results may differ if this simulation is re-run.
          ")
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
        textOutput("wind_var"),
        br(),
        strong("Description of wind dispersal of floating plants:"),
        p("On each time step:"),
        p("Some portion of floating plant biomass can be dispersed along the surface of the water by wind."),
        p("The wind direction is sampled from the Prevailing wind direction (see below). All cells move in the same direction for that time step."),
        p("The wind strength is governed by a beta distributions which the user selects ('strong' or 'weak')."),
        p("The proportion of biomass to move on that time step is randomly sampled from the distribution of wind strengths."),
        p("All cells move the same proportion of biomass for that step."),
        p("Biomass will move into the destination cell as long as its biomass is not greater than the full threshold (g dw/m2) [full_thresh]."),
        p("If the cell is 'too full' the biomass stays in its current cell. This allows cells to 'pile up'."),
        br(),
        strong("Prevailing wind direction:"),
        p("'all' means probability of wind blowing in any direction is random and equal."),
        p("'up' means probability of wind blowing up is 0.7 and 0.1 for all other directions"),
        br(),
        strong("Average wind strength:"),
        p("On average, on each time step, this proportion of biomass will 
         be moved in the direction of the wind on that time step")
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
          All other variables are the same."),
        strong("Warning:"),
        p("Each trajectory is the result of a single, stochastic simulation.
          Results may differ if this simulation is re-run.
          ")
        )
                  
    )
  )
)
)
  
