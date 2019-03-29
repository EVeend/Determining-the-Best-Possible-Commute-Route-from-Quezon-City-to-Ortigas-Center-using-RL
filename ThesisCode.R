# Thesis Code

# Database Functions
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
  query <- paste("select * from Environment where ENVIRONMENT_ID = ", environment_id)
  data <- dbGetQuery(con, query)

  return(data)
}

# End of Database Function

# Environment Generator
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
# End of Environment Generator

# Action Selection
randomActionSelection <- function(Q, state, epsilon) {
  return(names(sample(values(Q[[state]]), 1)))
}


modifiedLookupActionSelection <- function(type) {
  if (type == "random") {
    return(randomActionSelection)
  }
}

# Experience Play
modifiedExperiencePlay <- function(D, Q, control, ...) {
  for (i in 1:nrow(D)) {
    d <- D[i, ]
    state <- d$s
    action <- d$a
    punishment <- d$p
    nextState <- d$s_new
    
    currentQ <- Q[[state]][[action]]
    if(has.key(nextState,Q)) {
      minNextQ <- min(values(Q[[nextState]]))
    } else{
      minNextQ <- 0
    }
    Q[[state]][[action]] <- currentQ + control$alpha *
      (punishment + control$gamma * minNextQ - currentQ)
  }
  
  out <- list(Q = Q)
  return(out)
}
# End of Action Selection

# Learning Rule
modifiedLookupLearningRule <- function(type) {
 if(type == "modifiedExperiencePlay"){
    return(modifiedExperiencePlay)
  }
  
}
# End of Learning Rule

# Policy
modifiedPolicy <- function(x) {
  UseMethod("modifiedPolicy", x)
}

#' @export
modifiedPolicy.matrix <- function(x) {
  policy <- colnames(x)[apply(x, 1, which.min)]
  names(policy) <- rownames(x)
  return(policy)
}

#' @export
modifiedPolicy.data.frame <- function(x) {
  return(policy(as.matrix(x)))
}

#' @export
modifiedPolicy.rl <- function(x) {
  return(policy(x$Q))
}

#' @export
modifiedPolicy.default <- function(x) {
  stop("Argument invalid.")
}
# End of Policy

# Reinforcement Learning
ModifiedReinforcementLearning <- function(data, s = "s", a = "a", p = "p", s_new = "s_new",
                                  learningRule = "modifiedExperiencePlay", iter = 1,
                                  control = list(alpha = 0.1, gamma = 0.1, epsilon = 0.1), verbose = F,
                                  model = NULL, ...) {
  if (is.null(model)) {
    Q <- hash()
    punishmentSequence <- c()
  } else {
    Q <- model$Q_hash
    punishmentSequence <- model$PunishmentSequence
  }
  for (i in unique(d$s)[!unique(d$s) %in% names(Q)]) {
    Q[[i]] <- hash(unique(d$a), rep(0, length(unique(d$a))))
  }
  
  agentFunction <- modifiedLookupLearningRule(learningRule)
  knowledge <- list("Q" = Q)
  learned <- list()
  for (i in 1:iter) {
    if (verbose) {
      cat0("Iteration: ", i, "\\" , iter)
    }
    learned[[i]] <- agentFunction(d, knowledge$Q, control)
    knowledge <- learned[[i]]
  }
  
  out <- list()
  out$Q_hash <- learned[[length(learned)]]$Q
  out$Q <- lapply(as.list(learned[[length(learned)]]$Q, all.names = T), function(x)
    as.list(x, all.names = T))
  out$Q <- t(data.frame(lapply(out$Q, unlist)))
  out$States <- rownames(out$Q)
  out$Actions <- colnames(out$Q)
  out$Policy <- modifiedPolicy(out$Q)
  out$LearningRule <- learningRule
  out$Punishment <- sum(d$p)
  out$PunishmentSequence <- c(punishmentSequence, rep(sum(d$p), iter))
  class(out) <- "rl"
  return(out)
}

#' @export
print.rl <- function(x, ...) {
  cat("State-Action function Q\n")
  print(x$Q)
  cat("\nPolicy\n")
  print(x$Policy)
  # cat("\nPunishment (last iteration)\n")
  # print(x$Punishment)
}

get_policy <- function(x,...){
  # cat("\nPolicy\n")
  # print(x$Policy)
  return(x)
}

#' @importFrom stats median sd
#' @export
summary.rl <- function(object, ...) {
  cat0("\nModel details")
  cat0("Learning rule:           ", object$LearningRule)
  cat0("Learning iterations:     ", length(object$PunishmentSequence))
  cat0("Number of states:        ", length(rownames(object$Q)))
  cat0("Number of actions:       ", length(colnames(object$Q)))
  cat0("Total Punishment:            ", object$Punishment)
  
  cat0("\nPunishment details (per iteration)")
  cat0("Min:                     ", min(object$PunishmentSequence))
  cat0("Max:                     ", max(object$PunishmentSequence))
  cat0("Average:                 ", mean(object$PunishmentSequence))
  cat0("Median:                  ", median(object$PunishmentSequence))
  cat0("Standard deviation:      ", sd(object$PunishmentSequence))
}

#' @export
predict.rl <- function(object, newdata = NULL, ...) {
  if (missing(newdata) || is.null(newdata)) {
    return(policy(object))
  }
  p <- policy(object)

  out <- p[sapply(newdata, function(y) which(names(p) == y))]
  names(out) <- NULL
  
  return(out)
}

#' @importFrom graphics plot
#' @export
plot.rl <- function(x, type = "o", xlab = "Learning iteration",
                    ylab = "Punishment", main = "Reinforcement learning curve", ...) {
  plot(x = seq(1:length(x$PunishmentSequence)), y = x$PunishmentSequence,
       type = type, xlab = xlab, ylab = ylab, main = main, ...)
}

cat0 <- function(...) {
  cat(..., "\n", sep = "")
}
# End of Reinforcement Learning

# Sample Experience
modifiedSampleExperience <- function (N, env, dataset, states, goal_states, actions, actionSelection = "random", 
          control = list(alpha = 0.1, gamma = 0.1, epsilon = 0.1), 
          model = NULL, ...) 
{

  if (is.null(model)) {
    Q <- hash()
  }
  else {
    Q <- model$Q_hash
  }
  for (i in unique(states)[!unique(states) %in% names(Q)]) {
    Q[[i]] <- hash(unique(actions), rep(0, length(unique(actions))))
  }
  actionSelectionFunction <- modifiedLookupActionSelection(actionSelection)
  sampleStates <- sample(states, N, replace = T)
  sampleActions <- sapply(sampleStates, function(x) actionSelectionFunction(Q, 
                                                                            x, control$epsilon))
  # print("Sample Actions")
  # print(sampleActions)
  response <- lapply(1:length(sampleStates), function(x) env(dataset, goal_states, sampleStates[x],
                                                             sampleActions[x]))
  # response <- lapply(1:length(sampleStates), function(x) env(sampleStates[x], 
  #                                                            sampleActions[x]))
  response <- data.table::rbindlist(lapply(response, data.frame))
  out <- data.frame(State = sampleStates, Action = sampleActions, 
                    Punishment = response$Punishment, NextState = as.character(response$NextState), 
                    stringsAsFactors = F)
  return(out)
}
# End of Sample Experience

# Punishment Function
punishment_function <- function(speed, distance, transport_fare){
  punishment <- (distance / speed) + transport_fare
  return(punishment)
}
# End of Punishment Function

# Routes
# Create Route S4 Class
setClass("Route", slots = list(origin="character", destination="character", mode_of_transportation="character", 
                               route_id="character", distance="numeric", transport_fare="numeric", 
                               route_code="character", action_name="character"))

setGeneric("summary")

summary.Route <- function(object, ...) {
  ## implement summary.foo
  invisible(cat("Origin:", object@"origin", "\n"))
  invisible(cat("Destination:", object@"destination", "\n"))
  invisible(cat("Action Name:", object@"action_name", "\n"))
}

setMethod("summary", "Route", summary.Route)

setMethod("show", "Route", function(object){
  invisible(cat(object@"action_name", "\n"))
  invisible(cat("Transport Fare:", "P", object@"transport_fare", "\n"))
})
# End of Routes

# Show Best Path
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
# End Show Best Path