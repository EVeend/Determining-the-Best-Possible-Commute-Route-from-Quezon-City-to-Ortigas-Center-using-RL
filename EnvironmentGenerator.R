# Get the data from dataset and convert it into a route class
get_routes <- function(dataset){
  route_list <- list()
  for(row in 1:length(dataset[[1]])){
    # print(typeof(dataset[[1]][row]))
    # print(dataset[[2]][row])
    route <- new("Route", origin=dataset[[1]][row], destination=dataset[[2]][row],
                 mode_of_transportation=dataset[[3]][row], route_id=dataset[[4]][row],
                 distance=dataset[[5]][row], transport_fare=dataset[[6]][row], route_code = dataset[[7]][row],
                 action_name = dataset[[8]][row])
    route_list[[row]] <- route
  }
  return(route_list)
}

# Generate an environment for RL 
generate_environment <- function(dataset, goal_states, state, actions){
  route_list <- get_routes(dataset)
  next_state <- state

  for(index in 1:length(route_list)){
    # print(route_list[[index]])
    if(state == state(route_list[[index]]@"origin") && actions == route_list[[index]]@"route_code"){
      next_state <- state(route_list[[index]]@"destination")
    }
    
    if(next_state == state(route_list[[index]]@"destination") && state == state(route_list[[index]]@"origin") && next_state %in% goal_states){
      distance <- route_list[[index]]@"distance"
      transport_fare <- route_list[[index]]@"transport_fare"
      punishment <- punishment_function(50, distance, transport_fare) - 100
      break
      # print(punishment)
    }
    else if(next_state == state(route_list[[index]]@"destination") && state == state(route_list[[index]]@"origin") && !(next_state %in% goal_states)){
      # print(next_state)
      # print(state)
      # print(route_list[[index]]@"destination")
      # print(route_list[[index]]@"origin")
      distance <- route_list[[index]]@"distance"
      transport_fare <- route_list[[index]]@"transport_fare"
      punishment <- punishment_function(50, distance, transport_fare) - 25
      break
      # print(punishment)
    }else{
      punishment <- 25
    }
  }
  out <- list(NextState = next_state, Punishment = punishment)
  return(out)
}



