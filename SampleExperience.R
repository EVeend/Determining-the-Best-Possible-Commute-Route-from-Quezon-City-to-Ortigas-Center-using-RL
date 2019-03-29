SampleExperience <- function (N, env, dataset, states, goal_states, actions, actionSelection = "random", 
          control = list(alpha = 0.1, gamma = 0.1, epsilon = 0.1), 
          model = NULL, ...) 
{
  Q <- hash()
  for (i in unique(states)[!unique(states) %in% names(Q)]) {
    Q[[i]] <- hash(unique(actions), rep(0, length(unique(actions))))
  }
  actionSelectionFunction <- LookupActionSelection(actionSelection)
  sampleStates <- sample(states, N, replace = T)
  sampleActions <- sapply(sampleStates, function(x) actionSelectionFunction(Q, 
                                                                            x, control$epsilon))
  response <- lapply(1:length(sampleStates), function(x) env(dataset, goal_states, sampleStates[x],
                                                             sampleActions[x]))                                                  sampleActions[x]))
  response <- data.table::rbindlist(lapply(response, data.frame))
  out <- data.frame(State = sampleStates, Action = sampleActions, 
                    Punishment = response$Punishment, NextState = as.character(response$NextState), 
                    stringsAsFactors = F)
  return(out)
}