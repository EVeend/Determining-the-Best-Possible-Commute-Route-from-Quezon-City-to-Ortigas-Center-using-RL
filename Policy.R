Policy <- function(x) {
  UseMethod("Policy", x)
}

#' @export
Policy.matrix <- function(x) {
  policy <- colnames(x)[apply(x, 1, which.min)]
  names(policy) <- rownames(x)
  return(policy)
}

#' @export
Policy.data.frame <- function(x) {
  return(policy(as.matrix(x)))
}

#' @export
Policy.rl <- function(x) {
  return(policy(x$Q))
}

#' @export
Policy.default <- function(x) {
  stop("Argument invalid.")
}