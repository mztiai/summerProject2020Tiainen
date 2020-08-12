# FOR CONTINUOUS SIMUL CODE
#
# distr_a / distr_b : distributions for time before infection, mean as argument
# 
# simulation_varying_time : n_events - number of rows = some upper bound on number of events
#                           ta, ka - mean time and infectivity params for type a
#                           tb, kb - mean time and infectivity params for type b
#                           pa - probability of type a -> fraction of a in population
#                           S0- number of initial susceptibles 
#                           E0 - number of initial exposed individuals (future infectors at start)                    
#                           seed - set seed for testing
# simulate: draw type and time for initial infectees -> add to PQ -> remove first event from PQ 
#                 -> infect according to type at time -> update states and set time
#                 ->  draw times and type for infectees -> add to PQ ... 
#
# draw_ka / draw_kb are not used, but allow for a potential change in infectivity based on time 
# by multiplying w. some factor based on time interval (eg. interventions or other effects)


distr_a <- function(ta){
  runif(1,1,2*ta-1)
  #rexp(1,1/ta)
}

distr_b <- function(tb){
  #runif(1,0,2*tb)
  #runif(1,1.5,2*tb-1.5)
  rexp(1,1/tb)
  #rgeom(1,tb)
}

draw_ka <- function(t, ka, multiplier){
  if(t>=5 && t<= 10){
    return (multiplier*ka)
  }else return (ka)
}

draw_kb <- function(t, kb, multiplier){
  if(t>=5 && t<= 10){
    return (multiplier*kb)
  }else return (kb)
}

simulation_varying_time <- function(n_events, ta,ka,tb,kb,pa=0.5, S0,E0, seed = FALSE){
  require("collections")
  if(seed == TRUE){
    set.seed(1234) 
  }
  times <- rep(0,n_events)
  I0 <- 0
  R0 <- 0
  total_population <- S0+E0+I0+R0
  
  S <- append(S0,rep(0,n_events-1))
  E <- append(E0,rep(0,n_events-1))
  I <- append(I0,rep(0,n_events-1))
  R <- append(R0,rep(0,n_events-1))
  
  Q <- priority_queue()
  
  # initial infectee(s) 
  for(i in 1:E0){
    if(runif(1) < pa){
      ti <- distr_a(ta)        # draw ta from distribution
      Q$push(c("a",ti),-ti)    # add status to PQ, prioritize small times -> negate priority
    }else{
      ti <- distr_b(tb)       # draw tb from distribution
      Q$push(c("b",ti),-ti)   # add status to PQ
    }
  }
  
  # infection process based on intial state and queue
  for(t in 2:n_events){
    # initialize state as same as previous state
    S[t]<-S[t] + S[t-1]
    E[t]<-E[t] + E[t-1]
    R[t]<-R[t] + R[t-1]
    times[t] <- times[t] + times[t-1]
    
    # pop next infector from PQ - if empty no one will infect anymore and the process loops to the end
    if(Q$size() != 0){
      infected <- 0
      
      type_and_time <- Q$pop()
      infector_type <- type_and_time[1]
      infector_time <- as.numeric(type_and_time[2])
      
      # infect based on previously drawn (ti,ki) pair status of infector
      # earliest entry of queue must be earliest infector
      
      # if infector of type a it infects according to ka:
      if(infector_type == "a"){
        infectivity <- min(1,ka/total_population)   # for edge case w. small pop
        infected <- rbinom(1,S[t], infectivity)
        I[t] <- I[t] + 1
      # else type b:
      }else if(infector_type == "b"){
        infectivity <- min(1,kb/total_population)
        infected <- rbinom(1,S[t], infectivity)
        I[t] <- I[t] - 1 
      }
      
      # individual has now infected ka/kb people - update state:
      S[t] <- S[t] - infected
      E[t] <- E[t] + infected - 1 
      # I[t]  set in if clause; a+=1, b-=1
      R[t+1] <- R[t+1] + 1 
      times[t] <- infector_time # always set global time when pushing to queue
      
      # assign "pair" (ti,ki) to every infected individual and add to queue 
      if(infected != 0){
        for(i in 1: infected){
          if(runif(1) < pa){
            ti <- distr_a(ta)
            Q$push(c("a",times[t]+ti),-(ti+times[t]))
          }else{
            ti <- distr_b(tb)
            Q$push(c("b",times[t]+ti),-(ti+times[t]))
          }
        }
      }
    }
    # gc() does it matter?
  }
  if(Q$size() != 0) print("queue not empty!")
  M <- cbind(S,E,I,R,times) 
}

