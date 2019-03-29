ReinforcementLearning <- function(data, s = "s", a = "a", p = "p", s_new = "s_new",
                                  learningRule = "ExprienceReplay", iter = 1,
                                  control = list(alpha = 0.1, gamma = 0.1, epsilon = 0.1), verbose = F,
                                  model = NULL, ...) {
  d <- data.frame(
    s = data[, s],
    a = data[, a],
    p = data[, p],
    s_new = data[, s_new],
    stringsAsFactors = F
  )
  colnames(d)

  Q <- hash()
    punishmentSequence <- c()
  for (i in unique(d$s)[!unique(d$s) %in% names(Q)]) {
    Q[[i]] <- hash(unique(d$a), rep(0, length(unique(d$a))))
  }
  
  agentFunction <- LookupLearningRule(learningRule)
  knowledge <- list("Q" = Q)
  print("Knowledge")
  print(knowledge)
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
  out$Policy <- Policy(out$Q)
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

