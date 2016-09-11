# source('Functions.R')
# libraries()
# WD <- getwd() # to keep track of default working directory


###============================ GET DATA (Ambs' prostate)===========================
## Get data from online repository
# gseList <- getGEO('GSE6956', GSEMatrix=TRUE)
# gse <- gseList[[1]]
# data <- data.frame(t(exprs(gse)))
# labels <- pData(gse)[,8]
# race <- pData(gse)[,10]

### Recode label into simple 'Normal' or 'Cancer'.
# labels <- as.character(labels)
# labels[which(labels == 'Normal prostate')] <- 'Normal'
# labels[which(labels == 'Adenocarcinoma (NOS) of the prostate')] <- 'Cancer'
# labels <- as.factor(labels)
# 
# 
# ### Recode race into 'AA' or 'EA'
# race <- as.character(race)
# race[which(race == 'race: African American')]<- 'AA'
# race[which(race == 'race: Caucasian')] <- 'EA'
# race[which(race != 'AA' & race != 'EA')]<- NA
# race <- as.factor(race)
# 
# 
# 
# ### Z-value scaling of each column
# data <- scale(data)
# 
# ### build complete data by combining numeric gene experessions with race and diagnosis tags.
# data <- data.frame(data, Race = race, Labels = labels)
# rows <- row.names(data)
# 
# ### save data as flatfile for later uses ( no need to repeat all the previous processing steps)
# write.csv(data, "dataset.txt",row.names = FALSE )
# rm(list=c("data","labels","race", "gse", "gseList"))
# 
# 
# 
# ### Read data back into R to resume analysis.
# df <- read.csv('dataset.txt',sep=",",row.names = rows) # read in data
# df$Race <- as.factor(df$Race)
# df$Labels <- as.factor(df$Labels)
# df <- as.data.table(df, keep.rownames = FALSE)
# row.names(df) <- rows



####===================== Spliting into TRAIN/TEST ========================

#### Spliting is a custom function used to:
#### 1./ Filter data by groups of patients; 'AA' or 'EA' patients.
#### 2./ Split said data into 50/50 training and testing sets
#### 3./ Due to the low sample of patients and the resutling class imbalance 
####     (way more 'Cancer' patients than 'Normal' patients),
####     the training data is augmented synthetically so that the 'cancer' 
####     and the 'Normal'classes have nearly the same amount of patients.
#### The function returns three dataframes: 
#### testing data,untouched training data, and augmented training data(which is used for the TSP selection)


###------------------------------
# AA <- Spliting(df, 'aa')
###------------------------------
# EA <- Spliting(df, 'ea')
###------------------------------
# ALL <- Spliting(df, 'all')
###------------------------------


####===================== Boot Sampling ====================================
### create 100 different seeds for 100 boot.samples of some data
# seeds <- sample(1:1000000,100, replace = FALSE)


####------------------------- FOR AA
#### Get 100 bootsamples of AA data using the 100 seeds
# boot.samples <- foreach(j=1:100)%do%{
#   
#   
#   bootstrapping <- function(some.data){
#     
#     seed <- set.seed(seeds[j])
#     sample <- sample(1:nrow(some.data), nrow(some.data)-10, replace = TRUE)
#     sample <- filter(some.data, sample)
#     boot.sample <- list("seed" = seed, "sample" = sample)
#     rm(list=c("seed","sample"))
#     return(boot.sample)
#   }
#   ## new.train is the name of the augmented training data from the Spliting function
#   bootstrapping(AA$new.train)
# }

#### save the boot samples for later use 
# AA$samples <- boot.samples
# rm(boot.samples)

####------------------------- FOR EA
#### Get 100 bootsamples of EA data using the 100 seeds
# boot.samples <- foreach(j=1:100)%do%{
#   
#   
#   bootstrapping <- function(some.data){
#     
#     seed <- set.seed(seeds[j])
#     sample <- sample(1:nrow(some.data), nrow(some.data)-5, replace = TRUE)
#     sample <- filter(some.data, sample)
#     # sample <- sample_frac(some.data, .9999, replace = TRUE)
#     boot.sample <- list("seed" = seed, "sample" = sample)
#     rm(list=c("seed","sample"))
#     return(boot.sample)
#   }
#   
#   bootstrapping(EA$new.train)
# }
#### Save samples for later use.
# EA$samples <- boot.samples
# rm(list=c("boot.samples","bootstrapping"))





###=====================


#### For each group of patients,
#### Generate 100 different k-TSP models for the 100 bootsamples.
#### Each model uses k=5 Top Scoring Pairs (5-TSP) that are selected
#### based on the corresponding boot.samples. 
#### Hence, as a whole, 500 Top Scoring Pairs (repetition and overlaps are expected) are generated.
#### The goal is to select the top 2 TSP.

# foreach(j=1:length(seeds), .packages = c('DMwR',
#                                          "switchBox",
#                                          "plyr",
#                                          "caret",
#                                          "dplyr",
#                                          "data.table"
#                                          )
#         )%do%{
# 
# #   ##==============================
# 
#   kTSPs <-function(data, k){
#     
#     
#     
#     
#     x1 <- select(data, -c(Labels))
#     
#     
#     x1 <- x1[, lapply(.SD, as.numeric)]
#     
#     
#     
#     
#     y1 <- as.factor(data$Labels)
#     
#   
#     model <- SWAP.KTSP.Train(t(x1), 
#                              y1,
#                              krange = k,
#                              FilterFunc = SWAP.Filter.Wilcoxon,
#                              featureNo = 5000 
#                              )
#     
#     
#     
#     rm(list =c("y1","x1"))
#     
#     return(list("Model" = model))
#     
#     
#   }
# 
#   
#   set.seed(seeds[j])
#   
#   AA.model <- kTSPs(data = AA$samples[[j]]$sample, k= 5)
#   EA.model <- kTSPs(data = EA$samples[[j]]$sample, k= 5)
#   Models <- list('AA' = AA.model, 'EA' = EA.model)
#   rm(list=c("AA.model","EA.model"))
# 
# return(Models)
# 
# } -> TSP.Models ; rm(list=c("Models","j"))



#####======================================  Collect the total 500 generated TSP for each group of patients

# tsp.df.aa <- foreach(j=1:length(TSP.Models), .combine = rbind)%do%{
#   
#   TSP.Models[[j]]$AA$Model$TSPs
# }; tsp.df.aa <- data.table(tsp.df.aa)
# 
# tsp.df.ea <- foreach(j=1:length(TSP.Models), .combine = rbind)%do%{
#   
#   TSP.Models[[j]]$EA$Model$TSPs
# }; tsp.df.ea <- data.table(tsp.df.ea)
# 
#  
# TSP.Pairs <- list("AA" = tsp.df.aa,
#                   "EA" = tsp.df.ea
#                   )
# 
# rm(list=c("j", "tsp.df.aa", "tsp.df.ea"))

# TS.pairs.aa <- foreach(j=1:500,.combine = c)%do%{
#   paste(TSP.Pairs$AA[j,V1], TSP.Pairs$AA[j,V2], sep = "  |  ")
# }; TS.pairs.aa <- as.factor(TS.pairs.aa)
# 
# TS.pairs.ea <- foreach(j=1:500,.combine = c)%do%{
#   paste(TSP.Pairs$EA[j,V1], TSP.Pairs$EA[j,V2], sep = "  |  ")
# }; TS.pairs.ea <- as.factor(TS.pairs.ea)
# 

# TSP.Pairs <- list("AA" = TS.pairs.aa,
#                   "EA" = TS.pairs.ea) 
# 
# 
# rm(list=c("j", 
#           "TS.pairs.aa", 
#           "TS.pairs.ea"))

# x <- TSP.Pairs$AA
# x <- data.frame("TSP" = x)
# x <- x %>% group_by(TSP) %>% summarise("count" = n()) %>% arrange(-count)
# TSP.Pairs$AA <- x
# 
# x <- TSP.Pairs$EA
# x <- data.frame("TSP" = x)
# x <- x %>% group_by(TSP) %>% summarise("count" = n())%>% arrange(-count)
# TSP.Pairs$EA<- x
# 
# rm(x)
####======================================



#### extract the TOP 2 TSP for each group. The top 2 TSP are the 2 TSP
#### with the highest number of occurences in the list of 500 previously generated TSP
# aa <- c("X212926_at", 
#         "X221050_s_at",  
#         "X203478_at", 
#         "X218466_at")
#  
# ea <- c("X211112_at",
#         "X201104_x_at",
#         "X206128_at",  
#         "X215921_at")
# 
# 
# features <- list("AA"= aa,
#                  "EA"= ea
#                  )
# rm(list=c("aa","ea"))
###### ==============================================================================================
###### SAVING features AND TSP.Pairs variables into AA and EA lists
# AA$TOP2_TSP <- features$AA
# EA$TOP2_TSP <- features$EA ; rm(features)
# 
# AA$ALL_TSP <- TSP.Pairs$AA
# EA$ALL_TSP <- TSP.Pairs$EA ; rm(TSP.Pairs)
###### ==============================================================================================
# write.csv(seeds,"seeds.txt")
# rm(list =c("WD","rows","seeds","kTSPs","Spliting","xy.data","libraries","df","TSP.Models"))