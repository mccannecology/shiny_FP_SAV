require(prodlim)

# read in csv of parameters   
data <- read.csv("data/output30.csv")

# remove all columns from "data" that are not user-inputs 
data <- data[,c("TOTALN",
              "shape",
              "size",
              "initial_perc_FP_cover",
              "initial_perc_SAV_cover",
              "shadingbyFP",
              "wind_shape2",
              "wind_direction")]
  
  
