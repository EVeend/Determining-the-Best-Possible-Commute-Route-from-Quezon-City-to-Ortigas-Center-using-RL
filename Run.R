get_num_bus_jeeps <- function(route_list){
  output <- 0
  for(index in 1:length(route_list)){
    if(is_bus_jeep(route_list[[index]]@mode_of_transportation)){
      output <- output + 1
    }
  }
  return(output)
}

is_bus_jeep <- function(item){
  if(item == "Bus" || item == "Jeepney"){
    return(TRUE)
  }else{
    return(FALSE)
  }
}

generate_cases <- function(number_of_cases){
  
  number_of_cases <- number_of_cases * 2
  print(number_of_cases)
  range_list <- list()
  
  for(count in 1:number_of_cases){
    range_list[[count]] <- 1:3
  }
  
  return(expand.grid(range_list))
}



# range_list <- list()
# range_list[[1]] <- 1:3
# 
# rm(case_generator)
# expand.grid(0:1, 0:3, 0:1)
# expand.grid(0:1, 0:1, 0:1)