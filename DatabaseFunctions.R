library(dbplyr)
library(odbc)
library(hash)
con <- dbConnect(odbc(), "OracleDatabase", uid = "ThesisAdmin", pwd = "beanbelter")

environment_list <- dbGetQuery(con, "select * from id_table")

get_environment_id <- function(environment_data, list){

  for(count in 1:length(list)){
    if(environment_data == environment_list[[2]][count]){
      # print(count)
      return(count)
    }
  }
}

get_dataset <- function(environment_name){
  
  con <- dbConnect(odbc(), "OracleDatabase", uid = "ThesisAdmin", pwd = "beanbelter")
  
  environment_id <- get_environment_id(environment_name, environment_list[[2]])
  environment_id <- paste("'", environment_list[[1]][environment_id], "'", sep = "")
  # print(environment_id)
  query <- paste("select * from newenvironment where ENVIRONMENT_ID = ", environment_id)
  data <- dbGetQuery(con, query)
  # print(data)
  return(data)
}

write_results <- function(best_path){
  con <- dbConnect(odbc(), "OracleDatabase", uid = "ThesisAdmin", pwd = "beanbelter")
  print("Writing to database")
  for(item in best_path){
    environment_id <- paste("'", item@"environment_id", "'", sep = "")
    case <- paste("'", item@"case_id", "'", sep = "")
    time <- paste("'", item@"time", "'", sep = "")
    ETA <- compute_ETA_minutes(item@"speed", item@"distance")
    transport_fare <- item@"transport_fare"
    action_name <- paste("'", item@"action_name", "'", sep = "")
    weather_level <- paste("'", item@"weather_level", "'", sep = "")
    query <- paste("INSERT INTO RESULTS (ENVIRONMENT_ID, CASE_ID, TIME, ESTIMATED_TRAVEL_TIME, TRANSPORT_FARE, WEATHER_LEVEL, ACTION_NAME)", 
                   "VALUES (", environment_id, ",", case[[1]], ",", time, ",", ETA, ",", 
                   transport_fare, ",", weather_level, ",", action_name, ");")
    dbGetQuery(con, query)
  }
  
}
  