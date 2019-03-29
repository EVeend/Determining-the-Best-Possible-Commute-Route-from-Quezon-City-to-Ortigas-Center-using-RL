library(ReinforcementLearning)

# Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre1.8.0_181")

env <- generate_environment
initial_state <- "LTFRB_3874"
goal_states <- list("LTFRB_3192", "LTFRB_4232")
# states <- c("LTFRB_2160", "LTFRB_2163", "LTFRB_3201", "LTFRB_3874", "LTFRB_4232", "LTFRB_3192")

states <- modifyList(Eastwood_EDSA_Shrine_Environment[1], Eastwood_EDSA_Shrine_Environment[2])
states <- unique(unlist(states))
# print(states)
# typeof(states)
# print(states)
# print(states[[2]])

actions <- unlist(Eastwood_EDSA_Shrine_Environment[7])

experience_data <- modifiedSampleExperience(N = 1000, 
                                    env = env, dataset = Eastwood_EDSA_Shrine_Environment,
                                    states = states, goal_states = goal_states,
                                    actions = actions)
print(experience_data)

control <- list(alpha = 0.1, gamma = 0.5, epsilon = 0.1)
colnames(experience_data)
EastWood_EDSAShrine_Model <- ModifiedReinforcementLearning(experience_data, s = "State", 
                                                           a = "Action", p = "Punishment", 
                                                           s_new = "NextState", control = control)
print(EastWood_EDSAShrine_Model$"Policy")
show_best_path(EastWood_EDSAShrine_Model$"Policy", initial_state, goal_states)

