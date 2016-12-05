## rankhospital is a function that takes three arguments: the 2-character abbreviated name of a
## state (state), an outcome (outcome), and the ranking of a hospital in that state for that outcome (num).
## The function reads the outcome-of-care-measures.csv file and returns a character vector with the name
## of the hospital that has the ranking specified by the num argument.

rankhospital <- function(state, outcome, num = "best") {
    ## Reads outcome data.

    thedata <- read.csv("outcome-of-care-measures.csv", na.strings="Not Available")
    
    ## Checks that state and outcome are valid.
    
    thedata <- thedata[ which(thedata$State == state), ]
    
    if(nrow(thedata) == 0) stop("invalid state")
    
    if(outcome == "heart failure") hname <- "Heart.Failure"
    else if(outcome == "heart attack") hname <- "Heart.Attack"
    else if(outcome == "pneumonia") hname <- "Pneumonia"
    else stop("invalid outcome")
    
    hname <- paste("Hospital.30.Day.Death..Mortality..Rates.from.", hname, sep = "")
    
    ## First we extract and sort the deathrates.
    
    thedata <- thedata[complete.cases(thedata[ , hname]), ]
    thedata[ , hname] <- as.numeric(as.character(thedata[,hname]))
    
    deathrates <- thedata[ , hname]
    deathrates <- sort(deathrates)
    
    ## Now we find the desired position (pos) and value (val) in the sorted deathrate vector.
    
    if(num == "best") pos <- 1
    else if(num == "worst") pos <- length(deathrates)
    else if(num > length(deathrates) || num < 1) return(NA)
    else pos <- num

    val <- deathrates[pos]

    ## minpos is the position of the first occurence of val in our deathrates vector.
    
    minpos <- min(which(deathrates == val))

    ## Now we remove all rows except for ones with a deathrate of val, and order.
    
    thedata <- thedata[thedata[, hname] == val,]
    thedata <- thedata[order(thedata$Hospital.Name),]
    
    ## pos-minpos+1 will be the correct position in whats left in our data frame.
    
    as.character(thedata[pos - minpos + 1,2])
}