# FOR DISCRETE SIMUL CODE
#
# simulation_binom_infectivity : n_events - number of rows = some upper bound on number of events
#                                ta, ka - mean time and infectivity params for type a
#                                tb, kb - mean time and infectivity params for type b
#                                pa - probability of type a -> fraction of a in population
#                                S0- number of initial susceptibles 
#                                E0 - number of initial exposed individuals (future infectors at start)    
# initialize first coughs based on initial state -> go forwards in time -> cough when events at that time
# (i.e. either a[] or b[] vectors) -> infect based on type and update states -> keep going



simulation_binom_infectivity <- function(time, ta,ka,tb,kb,pa=0.5, S0,E0,I0=0,R0=0){
  #set.seed(1234)
  #time <- seq(from= 0, to = end,by = mesh)
  S <- append(S0,rep(0,time-1))
  E <- append(E0,rep(0,time-1))
  I <- append(I0,rep(0,time-1))
  R <- append(R0,rep(0,time-1))
  a <- rep(0,time) # nr type a at time t
  b <- rep(0,time) # nr of type b at time t
  
  # NOTE: in discrete case events overlap
  
  total_population <- S0+E0+I0+R0
  
  # initial infectee(s) 
  for(i in 1:E0){
    p <- runif(1)
    if(p < pa){
      I[ta] <- I[ta] + 1
      a[ta] <- a[ta] + 1
    }else{
      I[tb] <- I[tb] + 1  
      b[tb] <- b[tb] + 1
    }
  }
  
  # infection process based on intial state
  for(t in 2:time){
    # update rule (only change I[t] upon infection):
    S[t]<-S[t] + S[t-1]
    E[t]<-E[t] + E[t-1]
    R[t]<-R[t] + R[t-1]
    if(E[t]+I[t] == 0){
      next
    }
    # check I[t], if nonzero infect people
    while(I[t] != 0){
      
      infected <- 0
      # infect based on previously drawn (ti,ki) pair status of infector
      if(a[t] != 0){
        a[t] <- a[t] - 1
        infectivity <- min(1,ka/total_population) 
        infected <- rbinom(1,S[t], infectivity)
      }else if(b[t] != 0){
        b[t] <- b[t] - 1
        infectivity <- min(1,kb/total_population)
        infected <- rbinom(1,S[t], infectivity)
      }

      # individual has now infected ka/kb people - remove from E at t and recover at next time:
      S[t] <- S[t] - infected
      E[t] <- E[t] + infected - 1 # remove infector from exposed at current time, add caused infectees
      R[t+1] <- R[t+1] + 1        # remove infectous from infected at next time
      
      # assign pair (ti,ki) to every infected individual and assign values to future table entries
      # at appropriate times + add a/b to queue
      if(infected != 0){
        for(i in 1: infected){
          if(runif(1) < pa){
            I[t+ta] <- I[t+ta] + 1
            a[t+ta] <- a[t+ta] + 1
          }else{
            I[t+tb] <- I[t+tb] + 1  
            b[t+tb] <- b[t+tb] + 1
          }
        }
      }
      if(R[t+1] == I[t]){break}
    }
  }
  
  M <- cbind(S,E,I,R)
}