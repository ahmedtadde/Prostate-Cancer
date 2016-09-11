# source('Functions.R')
# libraries()
# DT <- df
##========== Python Data: Diagnosis Prediciton-NORMAL
# 
# 
# row.n <- row.names(DT)[which(as.character(DT$Race) == 'AA')]
# data.aa <- filter(DT, as.character(Race) == 'AA')
# data.aa$Race <- NULL
# row.names(data.aa) <- row.n
# 
# row.n <- row.names(DT)[which(as.character(DT$Race) == 'EA')]
# data.ea <- filter(DT, as.character(Race) == 'EA')
# data.ea$Race <- NULL
# row.names(data.ea) <- row.n
# 
# setwd("../../Python/Diagnosis Prediction-NORMAL")
# 
# data <- xy.data(data.aa)
# X <- data$x; write.csv(X, "X_aa.csv", row.names = F)
# Y <- data$y; write.csv(Y, "Y_aa.csv", row.names = F)
# 
# data <- xy.data(data.ea)
# X <- data$x; write.csv(X, "X_ea.csv", row.names = F)
# Y <- data$y; write.csv(Y, "Y_ea.csv", row.names = F)
# 
# setwd(WD)
# 


# ##========== Python Data: Diagnosis Prediction-TSP
# row.n <- row.names(DT)[which(as.character(DT$Race) == 'AA')]
# data.aa <- filter(DT, as.character(Race) == 'AA')
# data.aa$Race <- NULL
# row.names(data.aa) <- row.n
# 
# row.n <- row.names(DT)[which(as.character(DT$Race) == 'EA')]
# data.ea <- filter(DT, as.character(Race) == 'EA')
# data.ea$Race <- NULL
# row.names(data.ea) <- row.n
# 
# data.aa <- dplyr::select(data.aa, c(which(names(data.aa)%in% AA$TOP2_TSP),22278))
# data.ea <- dplyr::select(data.ea, c(which(names(data.ea)%in% EA$TOP2_TSP),22278))
# 
# setwd("../../Python/Diagnosis Prediction-TSP")
# 
# data <- xy.data(data.aa)
# X <- data$x; write.csv(X, "X_aa.csv", row.names = F)
# Y <- data$y; write.csv(Y, "Y_aa.csv", row.names = F)
# 
# data <- xy.data(data.ea)
# X <- data$x; write.csv(X, "X_ea.csv", row.names = F)
# Y <- data$y; write.csv(Y, "Y_ea.csv", row.names = F)
# 
# setwd(WD)


# ##========== Python Data: Diagnosis Prediction-VizRank

# row.n <- row.names(DT)[which(as.character(DT$Race) == 'AA')]
# data.aa <- filter(DT, as.character(Race) == 'AA')
# data.aa$Race <- NULL
# row.names(data.aa) <- row.n
# 
# row.n <- row.names(DT)[which(as.character(DT$Race) == 'EA')]
# data.ea <- filter(DT, as.character(Race) == 'EA')
# data.ea$Race <- NULL
# row.names(data.ea) <- row.n
# 
# setwd("../../Python/Diagnosis Prediction-VizRank/VizRank Orange")
# write.csv(AA$new.train,"data_aa.csv", row.names = F)
# write.csv(EA$new.train,"data_ea.csv", row.names = F)
# 
# ####===== TO UPDATE/RE-DO vizRANK selected genes used below...
# #### Go to ./Diagnosis Prediction-VizRank/VizRank Orange directory
# #### to run the 'Prostate Cancer Project.ows' script
# #### (refer to online How-To documentatons/guides for the Orange Program )
# 
# setwd("..")
# 
# vizRank <- c("X219024_at","X221050_s_at","X218466_at","X212926_at"); AA$vizRank <- vizRank
# data.aa <- dplyr::select(data.aa, c(which(names(data.aa)%in% vizRank),22278))
# 
# vizRank <- c("X203595_s_at","X210268_at","X200653_s_at","X215921_at"); EA$vizRank <- vizRank
# data.ea <- dplyr::select(data.ea, c(which(names(data.ea)%in% vizRank),22278))
# 
# 
# data <- xy.data(data.aa)
# X <- data$x; write.csv(X, "X_aa.csv", row.names = F)
# Y <- data$y; write.csv(Y, "Y_aa.csv", row.names = F)
# 
# data <- xy.data(data.ea)
# X <- data$x; write.csv(X, "X_ea.csv", row.names = F)
# Y <- data$y; write.csv(Y, "Y_ea.csv", row.names = F)
# 
# 
# setwd(WD)


# ##========== Python Data: Diagnosis Prediction-TSP+VizRank


# row.n <- row.names(DT)[which(as.character(DT$Race) == 'AA')]
# data.aa <- filter(DT, as.character(Race) == 'AA')
# data.aa$Race <- NULL
# row.names(data.aa) <- row.n
# 
# row.n <- row.names(DT)[which(as.character(DT$Race) == 'EA')]
# data.ea <- filter(DT, as.character(Race) == 'EA')
# data.ea$Race <- NULL
# row.names(data.ea) <- row.n
# 
# 
# AA$TOP2_TSP.vizRank <- unique(c(AA$TOP2_TSP,AA$vizRank))
# data.aa <- dplyr::select(data.aa, c(which(names(data.aa)%in% AA$TOP2_TSP&vizRank),22278))
# 
# EA$TOP2_TSP.vizRank <- unique(c(EA$TOP2_TSP,EA$vizRank))
# data.ea <- dplyr::select(data.ea, c(which(names(data.ea)%in% EA$TOP2_TSP&vizRank),22278))
# 
# setwd("../../Python/Diagnosis Prediction-TSP+VizRank")
# 
# data <- xy.data(data.aa)
# X <- data$x; write.csv(X, "X_aa.csv", row.names = F)
# Y <- data$y; write.csv(Y, "Y_aa.csv", row.names = F)
# 
# data <- xy.data(data.ea)
# X <- data$x; write.csv(X, "X_ea.csv", row.names = F)
# Y <- data$y; write.csv(Y, "Y_ea.csv", row.names = F)
# 
# setwd(WD)
# 
# #=========== END
# #Cleaning up
# rm(list=c("data","data.ea","data.aa","X","Y","vizRank","row.n","DT"))
