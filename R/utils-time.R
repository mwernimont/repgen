## Utility functions that deal with time, timezone, dates, etc

#' @title Will attempt to parse a DV, UTC time, or offset time.
#' 
#' @description A convienence function that will attempt to parse a (day
#'   point-type) date, UTC time, or offset time extremes JSON.
#' @param x A character vector of length one or greater of the dates/times.
#' @param timezone A character vector of length one, indicating a time zone code.
#' @param shiftTimeToNoon Reference time to 12:00 p.m. if TRUE; interpret
#'        literally when FALSE.
#' @return time vector
#' @importFrom lubridate parse_date_time
#' @importFrom lubridate hours
#' @export
flexibleTimeParse <- function(x, timezone, shiftTimeToNoon = TRUE) {
  format_str <- c("Ymd HMOS z", "Ymd T* z*", "Ymd HMS")
  
  time <- parse_date_time(x,format_str, tz=timezone,quiet = TRUE)
  
  dvTimes <- x[which(is.na(time))]
  
  #Handle DVs
  #Try the DV format for dates that are still NA
  #Add noon as the time if necessary
  which.still.NA <- is.na(time)
  format_str_DV <- "Ymd"
  time[which.still.NA] <- parse_date_time(x[which.still.NA],format_str_DV, tz=timezone,quiet = TRUE)
  
  if (shiftTimeToNoon) {
    time[which.still.NA] <- time[which.still.NA] + hours(12)
  }
  
  return(time)
}

#'given a datetime, will remove time and set 0000 as start
#'@importFrom lubridate hour minute
#'@param time datetime to shift to start
#'@rdname toEndOfDay 
#'@export
toStartOfDay <- function(time){
  hour(time) <- 0
  minute(time) <- 0
  return(time)
}

#' Given a datetime, will remove time and set 23:59.
#' 
#' @param time datetime to shift to start
#' @rdname toStartOfDay
#' @importFrom lubridate hour<-
#' @importFrom lubridate minute<-
#' @export
toEndOfDay <- function(time) {
  hour(time) <- 23
  minute(time) <- 59
  return(time)
}

#' Given a datetime, will change the date to the 1st, plus remove time and set
#' 00:00. This is used to set the labels for Five Year Groundwater Summary
#' reports.
#' 
#' @param time datetime to shift to start
#' @rdname toEndOfMonth
#' @importFrom lubridate day<-
#' @importFrom lubridate hour<-
#' @importFrom lubridate minute<-
#' @export
toStartOfMonth <- function(time){
  day(time) <- 1
  hour(time) <- 0
  minute(time) <- 0
  return(time)
}

#' Given a datetime, will change the date to the 30th, remove time, and set 
#' 23:59. This is used to set the labels for Five Year Groundwater Summary 
#' reports.
#' 
#' @param time A datetime to shift to start.
#' @rdname toStartOfMonth
#' @importFrom lubridate day<-
#' @importFrom lubridate hour<-
#' @importFrom lubridate minute<-
#' @export
toEndOfMonth <- function(time) {
  day(time) <- 30
  hour(time) <- 23
  minute(time) <- 59
  return(time)
}

#' A hacky fix for 9999 year issue which prevents the rectangles from displaying
#' on the graphs. Apologies to the people of 2100 who have to revisit this.
#'
#' @param time datetime to shift to "the end of time"
#' @importFrom lubridate year<-
#' @export
toEndOfTime <- function(time){
  year(time) <- 2100
  return(time)
}

#' Checks to see if the date passed in is the first of the month
#' 
#' @description For a date passed into the function, returns true or false 
#' depending on if that date is the first of the month
#' 
#' @param date the date to check to see if it's the first of the month
#' @importFrom lubridate day<-
#' @return TRUE or FALSE depending on if the date is the first day of the month
isFirstDayOfMonth <- function(date) {
  isFirst <- day(date) == 1
  return(isFirst)
}

#' Calculate the number of days between two dates
#' 
#' @description For two dates passed into the function returns the number of days
#' between the two dates
#' 
#' @param startDate the start date for calculating the difference in days
#' @param endDate the end date for calculating the difference in days
#' @return days numeric number of days between the two dates
calculateTotalDays <- function(startDate, endDate) {
  days <- as.numeric(difftime(strptime(endDate, format="%Y-%m-%d"), strptime(startDate,format="%Y-%m-%d"), units="days"))
  return(days)
}

#' Bound Date
#' @description Applied bounds to the provided date using a number of padding days.
#' For example, if the date is less than the start of the provided date range then
#' the date will be set to be the start of the date range - padding days.
#' @param date The date to bound
#' @param dateRange The date range to bound the date with
#' @param padDays [DEFAULT: 1] The number of days to pad the date with
boundDate <- function(date, dateRange, padDays=1){
  if(date < dateRange[[1]]){
    date <- dateRange[[1]] - days(padDays)
  } else if(date > dateRange[[2]]){
    date <- dateRange[[2]] + days(padDays)
  }
  
  return(date)
}

#' Format Time as a label with the UTC Offset
#'
#' @description Formats a time datum as a text
#' label including the UTC offset at the end.
#' @param time The time datum to format as a text label
#' @param markOpen Whether or not to replace open-ended times with "Open"
formatUTCTimeLabel <- function(time, markOpen=FALSE){
  formatted_time <- ""
  
  if(!isEmptyOrBlank(time)){
    
    #If we are marking open-ended times as "Open", do so
    if(markOpen){
      formatted_time <- formatOpenDateLabel(time)
    }
    
    #If this time didn't get turned into "Open" above, then format it
    if(as.character(formatted_time) != "Open"){
      tzf <- format(as.POSIXct(time), "%z")
      tzf <- sub("([[:digit:]]{2,2})$", ":\\1", tzf)
      formatted_time <- paste0(format(as.POSIXct(time), " %b %d, %Y %H:%M:%S"), " (UTC ", tzf, ")")
    }
    
    
  }
  
  return(formatted_time)
}

#' Format Open Date Label
#' 
#' @description Replace open ended dates (0000 and 9999) with "Open"
#' @param dates The date to format
formatOpenDateLabel <- function(dates){
  newDates <- as.character(dates)
  
  if(length(dates[which(as.numeric(year(dates)) >= 9999)]) > 0){
    newDates[which(as.numeric(year(dates)) >= 9999)] <- as.character("Open")
  } 
  
  if(length(dates[which(as.numeric(year(dates)) <= 0)]) > 0){
    newDates[which(as.numeric(year(dates)) <= 0)] <- c("Open")
  }  
  
  return(newDates)
}

