# server.R

source("helpers.R")

shinyServer(function(input, output) {
 
  ###############################
  # Determine simulation number #  
  ###############################  
  # assign user inputs to a data.frame (1 row)
  row_to_match <- reactive({
    
    # combine user-inputs into a row 
    # make a list, then convert to a data frame 
    as.data.frame(list(TOTALN = input$TOTALN,
                       shape = input$shape,
                       size = input$size,
                       initial_perc_FP_cover = input$initial_perc_FP_cover,
                       initial_perc_SAV_cover = input$initial_perc_SAV_cover,
                       shadingbyFP = input$shadingbyFP,
                       wind_shape2 = input$wind_shape2,
                       wind_direction = input$wind_direction))
        
  })
  
  # simulation number will be sent to the output 
  # (Not sure if this is necessary)
  output$simulation <- renderText({
    row_to_match <- row_to_match() 
    row.match(row_to_match, data, nomatch = NA) 
  })
  
  # simulation number is a reactive object 
  # that can be used by other functions below
  # just follow "sim_numb" with () - e.g., sim_numb()
  sim_numb <- renderText({
    row_to_match <- row_to_match() 
    row.match(row_to_match, data, nomatch = NA) 
  })
  
  ###########################################
  # Assign reactive inputs to the variables #
  ###########################################
  # Use to get the right path / filename for alt. state trajectories
  TOTALN <- reactive({
    input$TOTALN
  })
  
  shadingbyFP <- reactive({
    input$shadingbyFP
  })
  
  size <- reactive({
    input$size
  })
  
  shape <- reactive({
    input$shape
  })
  
  wind_direction <- reactive({
    input$wind_direction
  })
  
  wind_shape2 <- reactive({
    input$wind_shape2
  })
    
  ###########
  # COVER #
  ###########
  # if images are saved locally
  #output$cover <- renderImage({
    
    # When input$simulation is 3, filename is ./www/3/cover.jpg
    #filename <- file.path('./www',paste(sim_numb(),"/cover.jpg", sep=""))
    
    # Return a list containing the filename and alt text
    #list(src = filename, contentType = "image/jpg")
    
  #}, deleteFile = FALSE)
  
  # if images are stored remotely 
  output$cover <- renderImage({
  
    # URL varies depending on input 
    url <- paste("https://s3.amazonaws.com/model_data/",sim_numb(),"/cover.jpg",sep="")
    
    download(url,"cover.jpg",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('cover','.jpg', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)
  
  }, deleteFile = FALSE)
  
  ###########
  # INITIAL #
  ###########
  # if images are saved locally
  # output$initial <- renderImage({
  
    # When input$simulation is 3, filename is ./www/3/initial.jpg
    # filename <- file.path('./www',paste(sim_numb(),"/initial.jpg", sep=""))
    
    # Return a list containing the filename and alt text
    # list(src = filename, contentType = "image/jpg")
    
  # }, deleteFile = FALSE)
  
  # if images are stored remotely 
  output$initial <- renderImage({
    
    # URL varies depending on input 
    url <- paste("https://s3.amazonaws.com/model_data/",sim_numb(),"/initial.jpg",sep="")
    
    download(url,"initial.jpg",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('initial','.jpg', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)
    
  })
  
  ##########
  # MIDDLE #
  ##########
  # if images are saved locally
  # output$middle <- renderImage({
    
    # When input$simulation is 3, filename is ./www/3/middle.jpg
    # filename <- file.path('./www',paste(sim_numb(),"/middle.jpg", sep=""))
    
    # Return a list containing the filename and alt text
    # list(src = filename, contentType = "image/jpg")
    
  # }, deleteFile = FALSE)
  
  # if images are stored remotely 
  output$middle <- renderImage({
  
    # URL varies depending on input 
    url <- paste("https://s3.amazonaws.com/model_data/",sim_numb(),"/middle.jpg",sep="")
    
    download(url,"middle.jpg",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('middle','.jpg', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)
  
  })
  
  #########
  # FINAL #
  #########
  # if images are saved locally
  # output$final <- renderImage({
    
    # When input$simulation is 3, filename is ./www/3/final.jpg
    # filename <- file.path('./www',paste(sim_numb(),"/final.jpg", sep=""))
    
    # Return a list containing the filename and alt text
    # list(src = filename, contentType = "image/jpg")
    
  # }, deleteFile = FALSE)
  
  # if images are stored remotely 
  output$final <- renderImage({
  
    # URL varies depending on input 
    url <- paste("https://s3.amazonaws.com/model_data/",sim_numb(),"/final.jpg",sep="")
    
    download(url,"final.jpg",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('final','.jpg', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)
  
  })
  
  #############
  # NUTRIENTS #
  #############
  # if images are saved locally
  # output$nutrients <- renderImage({
    
    # When input$simulation is 3, filename is ./www/3/nutrients.jpg
    # filename <- file.path('./www',paste(sim_numb(),"/nutrients.jpg", sep=""))
    
    # Return a list containing the filename and alt text
    # list(src = filename, contentType = "image/jpg")
    
  # }, deleteFile = FALSE)
  
  # if images are stored remotely 
  output$nutrients <- renderImage({
  
    # URL varies depending on input 
    url <- paste("https://s3.amazonaws.com/model_data/",sim_numb(),"/nutrients.jpg",sep="")
  
    download(url,"nutrients.jpg",mode="wb")
  
    filename <- normalizePath(file.path('./',paste('nutrients','.jpg', sep='')))
  
    # Return a list containing the filename and alt text
    list(src = filename)
  
  })
  
  #############
  # ALT STATE #
  #############
  # if images are saved locally
  # output$AltStatePlot <- renderImage({
    
    #filename <- file.path('./www',paste(sim_numb(),"/nutrients.jpg", sep=""))
    
    # Uses all user inputs (excel intial FP and SAV) to find plot location / name 
    # filename <- file.path('./www/AltState/',paste("alt_plot_","_",
                                                  #TOTALN(),"_",
                                                  #shadingbyFP(),"_",
                                                  #size(),"_",
                                                  #shape(),"_",
                                                  #wind_direction(),"_",
                                                  #wind_shape2(),"_",
                                                  #".jpg", sep=""))
    
    # Return a list containing the filename and alt text
    #list(src = filename, contentType = "image/jpg")
    
  #}, deleteFile = FALSE)
  
  # if images are stored remotely 
  output$AltStatePlot <- renderImage({
  
    # URL varies depending on input 
    url <- paste("https://s3.amazonaws.com/model_data/AltState/",
                 "alt_plot_","_",
                 TOTALN(),"_",
                 shadingbyFP(),"_",
                 size(),"_",
                 shape(),"_",
                 wind_direction(),"_",
                 wind_shape2(),"_",
                 ".jpg",sep="")
    
    download(url,"altstate.jpg",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('altstate','.jpg', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename,
         height=500,
         width=500)
  
  })
  
  
  ########
  # WIND #  
  ########
  # this image is rendered every time (not stored remotely or locally)
  output$wind <- renderPlot({
    hist(rbeta(1000,0.04,as.numeric(input$wind_shape2)),
         main=NULL,
         xlim=c(0,1),
         xlab="Wind strength (Prop. mass moved per timestep)"
         )
  },
  width=400,
  height=400)
  
  output$wind_avg <- renderText({
    signif(
          0.04/(0.04+as.numeric(input$wind_shape2)),
          digits=4
          )
  })
  
  output$wind_var <- renderText({
    signif(
          0.04*as.numeric(input$wind_shape2)/
            ((0.04+as.numeric(input$wind_shape2))^2*
               (0.04+as.numeric(input$wind_shape2)+1)),
          digits=4
          )
  })
  
  ######################
  # IMAGES FOR WELCOME # 
  ######################
  # if images are saved locally
  output$alt_states <- renderImage({
  
  filename <- file.path("./www/alt_states.jpg")
  
  # Return a list containing the filename and alt text
  list(src = filename, contentType = "image/jpg")
  
  }, deleteFile = FALSE)
  
  ################################
  # IMAGES FOR MODEL DESCRIPTION #
  ################################
  
  # GROWTH 
  # if images are stored remotely 
  output$growth_equation <- renderImage({
    
    # URL varies depending on input 
    url <- "https://s3.amazonaws.com/model_data/Scheffer 2003 growth equations.png"
                 
    download(url,"growthEQ.png",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('growthEQ','.png', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)

  })
  
  # NUTRIENT UPTAKE  
  # if images are stored remotely 
  output$uptake_equation <- renderImage({
    
    # URL varies depending on input 
    url <- "https://s3.amazonaws.com/model_data/Scheffer 2003 uptake equations.png"
    
    download(url,"uptakeEQ.png",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('uptakeEQ','.png', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)
    
  })
  
  # DEFAULT PARAMETERS 
  # if images are stored remotely 
  output$default_parameters <- renderImage({
    
    # URL varies depending on input 
    url <- "https://s3.amazonaws.com/model_data/default_parameters.png"
    
    download(url,"defaultPARS.png",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('defaultPARS','.png', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)
    
  })
  
  # WATERBODY SHAPES
  # if images are stored remotely 
  output$waterbody_shapes <- renderImage({
    
    # URL varies depending on input 
    url <- "https://s3.amazonaws.com/model_data/waterbody_shapes.png"
    
    download(url,"shapes.png",mode="wb")
    
    filename <- normalizePath(file.path('./',paste('shapes','.png', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename)
    
  })
  
})