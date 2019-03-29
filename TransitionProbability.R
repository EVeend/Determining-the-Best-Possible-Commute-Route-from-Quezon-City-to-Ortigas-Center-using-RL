library(markovchain)

transition_probability_matrix <- function(states_list){
  seq <- states_list[1]
  for(counter in 1:1000){
    seq <- paste(seq, sample(states_list, 1))
  }
  base_sequence <- strsplit(seq, " ")
  prob_matrix <- markovchainFit(base_sequence)$estimate
  prob_matrix <- as.data.frame.matrix(prob_matrix@transitionMatrix)
  return(prob_matrix)
}

get_next_state <- function(prob_matrix, current_state){
  return(sample(states, 1, prob = as.numeric(unlist(prob_matrix[current_state]))))
}
