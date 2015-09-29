# Three things you almost always need in R to examine data
require(ggplot2)
require(data.table)
require(dplyr)

# If running interactively, this arg. must be changed for each user
if(interactive()) {
  setwd("~/local/gitRepos/DukeClass/")
} else {
  
}


# Load the data
trainFile = data.table(read.csv("data/train.csv"))

# What is my target?
targetVar = "Hazard"

# What does the distribution look like?
p <- ggplot(trainFile)
p <- p + geom_histogram(aes(x=Hazard))
ggsave(file.path("report", "histogram.png", p))

# Narrow the bins
p <- ggplot(trainFile)
p <- p + geom_histogram(aes(x=Hazard), binwidth = 1)
ggsave(file.path("report", "secondHistogram.png", p))
       
# Is there something with every third value?
tempData <- trainFile %>% mutate(group = Hazard %% 3)
p <- ggplot(tempData)
p <- p + geom_histogram(aes(x=Hazard), binwidth = 1)
p <- p + facet_wrap(~ group)
ggsave(file.path("report", "facetHistogram.png", p))
       

# Let's look at all of our one-way plots
indVars = setdiff(names(trainFile), c("Hazard", "Id"))
dir.create(file.path("report"), showWarnings = FALSE)
for(v in indVars) {
  p <- ggplot(trainFile)
  p <- p + geom_bar(aes_string(x = v, y = targetVar), stat = "summary", fun.y = mean)
  ggsave(file.path("report", paste0(v, ".png")), p)
}


