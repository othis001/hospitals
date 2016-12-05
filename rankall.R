## rankall is a function that takes two arguments: an outcome name (outcome) and a hospital ranking (num).
## The function reads the outcome-of-care-measures.csv file and returns a 2-column data frame
## containing the hospital in each state that has the ranking specified in num.

rankall <- function(outcome, num = "best") {
    ## Reads outcome data
    
    thedata <- read.csv("outcome-of-care-measures.csv", na.strings="Not Available")
    
    ## Checks that the outcome is valid.

    if(outcome != "heart failure" && outcome != "heart attack" && outcome != "pneumonia") stop("invalid outcome")

    ## For each state, finds the hospital of the given rank.
    ## Returns a data frame with the hospital names and the
    ## (abbreviated) state name.
    
    states <- thedata$State
    states <- unique(states)
    
    source("rankhospital.R")
    
    output <- data.frame(Hospital.Name=character(), State=character(), stringsAsFactors=FALSE)

    for(s in states) output[s, ] <- c(rankhospital(s, outcome, num), s)

    output
}