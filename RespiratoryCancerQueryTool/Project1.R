# Data Source - CDC 
#
# Parameters:
#Group Results By Cancer Sites	
#And By	Age Group
#And By	Sex
#And By	Race
#And By	Ethnicity

# Crude Rates
# All Regions
# All Years 1999-2012
# All Genders
# All Races
# All Ethnicity
# Cancer sites of interest : Respiratory System
# Population for age adjusted rates : 2000 U.S. Std Million

require(dplyr)
require(plyr)
require(ggplot2)
cancerData = read.delim("data/resp_cancer_data.txt",
                        header = T,
                        sep="\t",
                        nrows = 839)

toRemove = c("Notes", "Cancer.Sites.Code",
             "Age.Group", "Sex", "Race.Code",
             "Ethnicity.Code")
cancerData$Sex.Code = revalue(cancerData$Sex.Code, c("F" = "Female", "M" = "Male"))
cancerData = cancerData[, !names(cancerData) %in% toRemove]
cancerData$Count = as.numeric(cancerData$Count)
cancerData$Crude.Rate = as.numeric(cancerData$Crude.Rate)
cancerData$Population = as.numeric(cancerData$Population)
summarizedData = group_by(cancerData, Cancer.Sites)
d = list("1" = filter(summarizedData, Cancer.Sites == levels(cancerData$Cancer.Sites)[1]),
         "2" = filter(summarizedData, Cancer.Sites == levels(cancerData$Cancer.Sites)[2]),
         "3" = filter(summarizedData, Cancer.Sites == levels(cancerData$Cancer.Sites)[3]),
         "4" = filter(summarizedData, Cancer.Sites == levels(cancerData$Cancer.Sites)[4]),
         "5" = filter(summarizedData, Cancer.Sites == levels(cancerData$Cancer.Sites)[5]),
         "6" = filter(summarizedData, Cancer.Sites == levels(cancerData$Cancer.Sites)[6])
)


