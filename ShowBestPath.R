show_best_path <- function(policy, initial_state, goal_states){
  # Output
  best_path <- list()
  # Get first route 
  first_route <- policy[initial_state]
  # counter for list
  counter <- 1
  
  #Get first route
  for(index in 1:length(route_list)){
    if(route_list[[index]]@"origin" == initial_state && route_list[[index]]@"route_code" == first_route){
      current_route <- route_list[[index]]
      best_path[counter] <- current_route
    }
  }
  
  # Iterate to get the best routes
  while(TRUE){
    if(!(current_route@"destination" %in% goal_states)){
      counter <- counter + 1
      current_state <- current_route@"destination"
      for(index in 1:length(route_list)){
        if(route_list[[index]]@"origin" == current_state){
          current_route <- route_list[[index]]
          best_path[counter] <- current_route
          break
        }
      }
    }
    else{
      break
    }
  }
  
  for(item in best_path){
    show(item)
  }
}
