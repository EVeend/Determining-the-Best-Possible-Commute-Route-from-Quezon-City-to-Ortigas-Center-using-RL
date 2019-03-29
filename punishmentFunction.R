punishment_function <- function(speed, distance, transport_fare){
  punishment <- (distance / speed) + transport_fare
  return(punishment)
}