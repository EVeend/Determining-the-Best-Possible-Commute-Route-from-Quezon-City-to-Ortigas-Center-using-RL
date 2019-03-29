# Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre1.8.0_181")
library(dbplyr)
library(odbc)
library(hash)
con <- dbConnect(odbc(), "OracleDatabase", uid = "ThesisAdmin", pwd = "beanbelter")

# Generate Environment
library(hash)
env <- generate_environment
initial_state <- "LTFRB_1007"
goal_states <- list("LTFRB_5000")
# states <- c("LTFRB_2160", "LTFRB_2163", "LTFRB_3201", "LTFRB_3874", "LTFRB_4232", "LTFRB_3192")

# Get Dataset
DataSet <- get_dataset("University_of_the_Philippines_Ortigas_Building")

# print(Eastwood_EDSA_Shrine_Environment)

# Case List 
case_list <- unique(DataSet$CASE_ID)

# Divide Case list into two lists
case_list <- split(case_list, 1:2)

for(item in case_list[[1]][1]){
  # Get Environment
  Environment <- get_environment(DataSet, item)
  
  print(paste("Time", item))
  
  # Get Routes
  route_list <- get_routes(Environment)

  # Get states
  states <- modifyList(Environment[4], Environment[5])
  states <- unique(unlist(states))
  
  # Get Actions
  actions <- unique(unlist(Environment[10]))
  
  
  # Alpha = Learning Rate
  # Gamma = Discount Factor, future rewards are discounted
  # Epsilon = Exploration vs Exploitation; 0.1 low exploration
  control <- list(alpha = 0.1, gamma = 0.5, epsilon = 0.1)
  colnames(experience_data)
  
  
  # Start iteration, N == epoch
  experience_data <- modifiedSampleExperience(N = 100, 
                                              env = env, dataset = Environment,
                                              states = states, goal_states = goal_states,
                                              actions = actions)
  
  # Experience Data
  print(experience_data)
  
  # Reinforcement Learning
  Model <- ModifiedReinforcementLearning(experience_data, s = "State", 
                                         a = "Action", p = "Punishment", 
                                         s_new = "NextState", control = control)
  
  print(Model$Q)
  print(Model$Policy)

  best_path <- show_best_path(Model$"Policy", initial_state, goal_states)
  write_results(best_path)
}
