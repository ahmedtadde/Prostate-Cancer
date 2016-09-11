



####### LIBRARIES FUNCTION
libraries <- function() {
  
  
  #### TO INSTALL BIOCONDUCTOR: COPY AND PASTE COMMENTED CODE BELOW
  #### THIS IS NECESSARY TO LOAD THE Biobase, GEOquery, and switchBox packages
  #### ------------------------------------------
  # source("https://bioconductor.org/biocLite.R")
  # biocLite()
  # biocLite(c("GEOquery"))
  # biocLite("switchBox")
  #### ------------------------------------------
  
  
  library(Biobase)
  library(GEOquery)
  
  
  
  library(plyr)
  library(dplyr)
  library(data.table)
  library(DMwR)
  library(psych)
  library(ppls)
  library(switchBox)
  library(foreach)
  library(doMC)
  library(snow) 
  library(doSNOW)
  registerDoMC(cores=8)
  registerDoSNOW(makeCluster(8, type="SOCK")) 
  library(doParallel)
  registerDoParallel(makeCluster(8))
  
}





#####================SPLITTING FUNCTION
Spliting <- function(data, race){
  
  
  if (race == 'aa'){
    
    row.n <- row.names(data)[which(as.character(data$Race) == 'AA')]
    data <- filter(data, as.character(Race) == 'AA')
    data <- select(data,c(-22278))
    row.names(data) <- row.n
  }
  
  if (race == 'ea'){
    row.n <- row.names(data)[which(as.character(data$Race) == 'EA')]
    data <- filter(data, as.character(Race) == 'EA')
    data <- select(data,c(-22278))
    row.names(data) <- row.n
  }
  
  if (race == 'all'){
    row.n <- row.names(data)  
    data <- select(data,c(-22278))
    row.names(data)<- row.n
    
  }
  
  set.seed(6006L)
  split <- createDataPartition(data$Labels, 
                               p = 0.5, 
                               list = FALSE,
                               times = 1
  )  
  row.n <- row.names(data)[-split]
  test <- data.frame(data)[-split,]
  
  test <- data.table(test)
  row.names(test) <- row.n
  
  
  
  
  train <- data.frame(data)[split,]
  train <- data.table(train)
  
  
  if (race == 'aa'){
    new.train <- SMOTE(Labels ~., 
                       data, 
                       perc.over = 600, 
                       k = 5, 
                       perc.under = 600)
    
    new.train <- new.train[complete.cases(train),]
    
    new.train <- data.table(new.train)
    new.train <- distinct(new.train)
  }
  
  if (race == 'ea'){
    new.train <- SMOTE(Labels ~., 
                       data, 
                       perc.over = 350, 
                       k = 5, 
                       perc.under = 400)
    
    new.train <- new.train[complete.cases(train),]
    
    new.train <- data.table(new.train)
    new.train <- distinct(new.train)
  }
  
  
  
  
  return(list("train" = train,
              "new.train" = new.train,
              "test" = test)
  )
  
}




#####================ XY DATA FUNCTION (TO CREATE DATA/OBSERVATIONS & OUTCOMES/LABELS DATASETS)
xy.data <- function(data){
  
  y <- as.factor(data$Labels)
  x <- data; x$Labels <- NULL
  x <- data.table(x)[, lapply(.SD, as.numeric)]
  
  return(list("x"= x, "y"=y))
}