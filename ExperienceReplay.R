library(hash)

ExperienceReplay <- function(D, Q, control, ...) {
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