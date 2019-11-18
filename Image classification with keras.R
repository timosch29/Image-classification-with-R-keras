## Header --------------------------- 
##
## Script name: Image classification
##
## Purpose of script: try out keras for r
##
## Author: Tim M. Schendzielorz 
##
## Date Created: 2019-11-18
##
## Copyright (c) Tim M. Schendzielorz, 2019
## Email: tim.schendzielorz@googlemail.com
##
## ---
##
## Notes:
## copied from  https://www.r-bloggers.com/teach-r-to-see-by-borrowing-a-brain/
##
## ---

## set working directory for Mac and PC

#setwd("~/Google Drive/")                          # Tim's working directory (mac)
#setwd("C:/Users/tim/Google Drive/")              # Tim's working directory (PC)

## Global Options ---------------------------

options(scipen = 7, digits = 2,  encoding = "UTF-8") # I prefer to view outputs in non-scientific notation
#memory.limit(30000000)               # this is needed on some PCs to increase memory allowance, but has no impact on macs.

## Packages and Functions ---------------------------

## load up the packages we will need:  (uncomment as required)

library("tidyverse")
library("parallel")

# source("functions/packages.R")       # loads up all the packages we need

## --

## load up our functions into memory

# source("functions/summarise_data.R") 

## Header End ----------------------------------------------------------------------




# first install python, tensorflow and keras through anaconda!
# for updating keras and packages see https://stackoverflow.com/questions/45197777/how-do-i-update-anaconda

# install the keras R interface
devtools::install_github("rstudio/keras")

library("keras")

# instantiate the model
resnet50 <- application_resnet50(weights = 'imagenet')

# Build a function which takes a picture as input and makes a prediction on what can be seen in it:
predict_resnet50 <- function(img_path) {
            # load the image
            img <- image_load(img_path, target_size = c(224, 224))
            x <- image_to_array(img)
            
            # ensure we have a 4d tensor with single element in the batch dimension,
            # then preprocess the input for prediction using resnet50
            x <- array_reshape(x, c(1, dim(x)))
            x <- imagenet_preprocess_input(x)
            
            # make predictions then decode and print them
            preds <- predict(resnet50, x)
            imagenet_decode_predictions(preds, top = 3)[[1]]
}



img_path <- "C:/Users/User/Pictures/Camera Roll" # change path appropriately to webcam output


# start webcam in 5 second intervals and run this function
while (TRUE) {
            files <- list.files(path = img_path, full.names = TRUE)
            img <- files[which.max(file.mtime(files))] # grab latest pic
            cat("\014") # clear console
            print(predict_resnet50(img))
            Sys.sleep(3)
}


# when finished, delete all taken pictures 
unlink(paste0(img_path, "/*")) # delete all pics in folder