source("Project1.R")
getChoicesForAge = function(cancerSite)
{
        val = as.numeric(cancerSite)
        if(val < 1 || val > length(levels(cancerData$Cancer.Sites)))
        {
               
                return 
        }
        ageGroups = levels(cancerData$Age.Group.Code)
        ageChoices = character(0)
        d1 = d[[val]]
        for(level in ageGroups)
        {
                
                if(level %in% d1$Age.Group.Code)
                {
                        ageChoices = c(ageChoices, level)
                        
                }
        }
        as.list(ageChoices)
}

getChoicesForSex = function(cancerSite, ageChoice)
{
        if(is.null(ageChoice))
        {
                return()
        }
        cancerSite = as.numeric(cancerSite)  
        d1 = d[[cancerSite]]
        sChoices = character()
        sGroups = levels(cancerData$Sex.Code)
        temp = filter(d1, Age.Group.Code == ageChoice)
        for(level in sGroups)
        {
                
                if(level %in% temp$Sex.Code)
                {
                        sChoices = c(sChoices, level)
                }
        }
        as.list(sChoices)
        
}


getChoicesForRace = function(cancerSite, ageChoice, sexChoice)
{
        if(is.null(sexChoice))
        {
                return()
        }
        cancerSite = as.numeric(cancerSite)
        d1 = d[[cancerSite]]
        raceChoices = character()
        raceGroups = levels(cancerData$Race)
        temp = filter(d1, Age.Group.Code == ageChoice & Sex.Code == sexChoice)
        for(level in raceGroups)
        {
               
                if(level %in% temp$Race)
                {
                        raceChoices = c(raceChoices, level)
                }
        }
        as.list(raceChoices)
}

getChoicesForEthnicity = function(cancerSite, ageChoice, sexChoice, raceChoice)
{
        if(is.null(raceChoice))
        {
                return()
        }
        cancerSite = as.numeric(cancerSite)
        d1 = d[[cancerSite]]
        eChoices = character()
        eGroups = levels(cancerData$Ethnicity)
        temp = filter(d1, Age.Group.Code == ageChoice & Sex.Code == sexChoice & Race == raceChoice)
        for(level in eGroups)
        {
                
                if(level %in% temp$Ethnicity)
                {
                        eChoices = c(eChoices, level)
                }
        }
        as.list(eChoices)
        
}

getCrudeRate = function(cancerSite, ageChoice, genderChoice, raceChoice, ethnicityChoice)
{
        if(is.null(ethnicityChoice))
        {
                return()
        }
        cancerSite = as.numeric(cancerSite)
        d1 = d[[cancerSite]]
        temp = filter(d1, Age.Group.Code == ageChoice & Sex.Code == genderChoice & Race == raceChoice & Ethnicity == ethnicityChoice)
        return(temp)
}
shinyServer(
        function(input, output) 
                {
                        output$ageGroupControls = 
                                renderUI({
                                        ageChoices = getChoicesForAge(input$cancerSite)
                                        if(length(ageChoices) == 0)
                                        {
                                                return()
                                        }
                                        selectInput(inputId = "ageChoice", label = "Age Group",
                                                    choices = ageChoices,
                                                    selected = ageChoices[1])        
                                        })
                        
                        output$genderControls = 
                                renderUI({
                                         genderChoices = getChoicesForSex(input$cancerSite, input$ageChoice)
                                         if(length(genderChoices) == 0)
                                         {
                                                 return()
                                         }
                                         selectInput(inputId = "genderChoice", label = "Gender",
                                                     choices = genderChoices,
                                                     selected = genderChoices[1]) 
                                        
                                         })
                        
                        output$raceChoiceControls = 
                                renderUI({
                                        raceChoices = getChoicesForRace(input$cancerSite, input$ageChoice, input$genderChoice)
                                        if(length(raceChoices) == 0)
                                        {
                                                return()
                                        }
                                        selectInput(inputId = "raceChoice", label = "Race",
                                                    choices = raceChoices,
                                                    selected = raceChoices[1]) 
                                        
                                })
                                
                                        
                        
                        output$ethnicityChoiceControls = 
                                renderUI({
                                ethnicityChoices = getChoicesForEthnicity(input$cancerSite, input$ageChoice, input$genderChoice, input$raceChoice)
                                if(length(ethnicityChoices) == 0)
                                {
                                        return()
                                }
                                selectInput(inputId = "ethnicityChoice", label = "Ethnicity",
                                            choices = ethnicityChoices
                                            )
                        })
                        
                        crudeRate = eventReactive(input$goButton1, {
                                getCrudeRate(input$cancerSite, input$ageChoice, input$genderChoice, input$raceChoice, input$ethnicityChoice)
                        })
                        count <- eventReactive(input$goButton, {
                                getCount(input$cancerSite, input$ageChoice, input$genderChoice, input$raceChoice, input$ethnicityChoice)
                        })
                        rate =  eventReactive(input$goButton, {
                                  getCrudeRate(input$cancerSite, input$ageChoice, input$genderChoice, input$raceChoice, input$ethnicityChoice)
                                                        })
                        
                        output$countText = renderText(paste("Count is ", rate()$Count))
                        output$crudeRateText = renderText(paste("Crude Rate is", rate()$Crude.Rate))
                        
                        fPlot = eventReactive(input$plotButton,{
                                variable = switch(input$variable,
                                                  "1" = "Cancer.Sites",
                                                  "2" = "Age.Group.Code",
                                                  "3" = "Sex.Code",
                                                  "4" = "Race",
                                                  "5" = "Ethnicity")
                                dd = ddply(cancerData, variable, summarize, Count = sum(Count))
                                g = switch(input$variable,
                                           "1" = ggplot(dd, aes(x = Cancer.Sites, y = Count, fill = Cancer.Sites))
                                               + geom_bar(aes(fill = Cancer.Sites), stat = "identity")
                                               + xlab("Count") + ylab("Cancer Sites") + ggtitle("Counts")
                                               + theme(legend.position = "bottom", axis.text.y=element_blank(), legend.direction = "vertical"),
                                           "2" = ggplot(dd, aes(x = Age.Group.Code, y = Count))
                                               + geom_bar(stat = "identity", aes(fill = Age.Group.Code))
                                               + theme(legend.position = "right", legend.direction = "vertical")
                                               + xlab("Count")
                                               + ylab("Age Group")
                                               + ggtitle("Counts"),
                                           "3" = ggplot(dd, aes(x = Sex.Code, y = Count))
                                               + geom_bar(stat = "identity", aes(fill = Sex.Code))
                                               + xlab("Count")
                                               + ylab("Gender")
                                               + theme(legend.position = "bottom", legend.direction = "vertical")
                                               + ggtitle("Counts"),
                                           "4" = ggplot(dd, aes(x = Race, y = Count))
                                               + geom_bar(stat = "identity", aes(fill = Race))
                                               + xlab("Count")
                                               + ylab("Race")
                                               + ggtitle("Counts")
                                               + theme(legend.position = "bottom", axis.text.y=element_blank(), legend.direction = "vertical"),
                                           "5" = ggplot(dd, aes(x = Ethnicity, y = Count))
                                                + geom_bar(stat = "identity", aes(fill = Ethnicity))
                                                + xlab("Count")
                                                + ylab("Ethnicity")
                                                + ggtitle("Counts")
                                                + theme(legend.position = "bottom", legend.direction = "vertical")
                                           )
                                
                               g  + coord_flip()
                                  
                        })
                        output$countPlot = renderPlot({fPlot()})
                
                }
           )
                
