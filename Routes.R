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

