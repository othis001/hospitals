## best is a function that take two arguments: the 2-character abbreviated name of a state and an
## outcome name. The function reads the outcome-of-care-measures.csv file and returns a character vector
## with the name of the hospital that has the best (i.e. lowest) 30-day mortality for the specified outcome
## in that state.

best <- function(state, outcome) {
    ## Reads outcome data.
    
    thedata <- read.csv("outcome-of-care-measures.csv", na.strings="Not Available")
    
    ## Checks that state and outcome are valid.
    
    thedata <- thedata[ which(thedata$State == state), ]
    
    if(nrow(thedata) == 0) stop("invalid state")
    
    if(outcome == "heart failure") hname = "Heart.Failure"
    else if(outcome == "heart attack") hname = "Heart.Attack"
    else if(outcome == "pneumonia") hname = "Pneumonia"
    else stop("invalid outcome")
        
    hname <- paste("Hospital.30.Day.Death..Mortality..Rates.from.", hname, sep = "")
    
    ## First we find the minimum death rate.
    
    thedata <- thedata[complete.cases(thedata[, hname]), ]
    thedata[,hname] <- as.numeric(as.character(thedata[,hname]))

    deathrates <- thedata[ , hname]
    minimum <- min(deathrates)
    
    ## Now return the first hospital alphabetically that has it.
    
    thedata <- thedata[thedata[, hname] == minimum,]
    thedata <- thedata[order(thedata$Hospital.Name),]
    
    as.character(thedata[1,2])
}