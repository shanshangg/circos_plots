setwd("C:\\Users\\home\\Desktop\\Rciros")
rm(list=ls())

library(statnet)
library(circlize)
library(tidyverse)

rm(list=ls())
data1 <- read.table("L-VJ-ResultMarix.txt", com='', quote='',
                    check.names=F, sep="\t")
data_temp<-data1[!duplicated(data1, fromLast=FALSE), ]  # 删除重复行
data1 <- data_temp[,!duplicated(t(data_temp))]   # 删除重复列

write.table(data1,"L-VJ-ResultMarix-Non-Redundant.txt",row.names=F,sep="\t",quote=F)

# 文件生成后，手动删除该表的第一行，再重新读入
rm(list=ls())
data1 <- read.table("L-VJ-ResultMarix-Non-Redundant.txt", header=T, row.names=1, com='', quote='',
                   check.names=F, sep="\t")

grid.col = NULL

circos.clear()
circos.par(gap.degree = c(rep(2, nrow(data1)-1), 10, rep(2, ncol(data1)-1), 10),
           start.degree = 180)
chordDiagram(data1, 
             directional = TRUE,
             diffHeight = 0.06,
             transparency = 0)

