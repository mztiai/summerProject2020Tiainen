# FOR ESTIMATION CODE
# 
# discrete case: row 9-88
# continuous case: row 89 ->

# GENERIC
# estimate R0 based on generated results
# input: result = list of matrices
# output: numeric vector of R0 estimates

# three types: cases/nr events , growth rate, final size

##################################
######ESTIMATION - DISCRETE######
##################################
# Diekmann et. al. Chp 13 for theoretical
#
# estimate_R0: cutoff - number of cases estimation starts at
#              est_window - ti me (i.e. rows) to estimate over
#              returns infected/(nr infectous events)
#
# estimate_R0_growth: cutoff - number of cases estimation starts at
#                     est_window - ti me (i.e. rows) to estimate over
#                     T_G - mean generation time (time between infection of infector and infectee)
#                     returns exp(growth rate*T_G) - growth rate from log(infected_time/infected_0)/time
#
# estimate_R0_final_size: returns estimate based on final size limit 
#



estimate_R0 <- function(result, cutoff=50,est_window=5){
  n <- nrow(result[[1]])
  S0 <- result[[1]][1,1]
  R_0 <- rep(0,length(result))
  for(i in 1:length(result)){
    infected <- 0
    infections <- 1
    for(j in 1:n){
      if(S0-result[[i]][j,1]>=8*sqrt(S0)) break # const for intial phase
      if(S0-result[[i]][j,1]>=cutoff){
        infected <- (result[[i]][j,1]-result[[i]][(j+est_window),1])
        infections <- (result[[i]][(j+est_window+1),4]-result[[i]][j+1,4])
        R_0[i] <- R_0[i]+infected/infections
        break
      }
    }
  }
  
  return (R_0)
}


estimate_R0_growth <-  function(result, cutoff=50,est_window=8, T_G){
  n <- nrow(result[[1]])
  S0 <- result[[1]][1,1]
  R_0 <- rep(0,length(result))
  r <- 0
  # T_G given as argument, estimating hard!
  # for(i in 1:length(result)){
  #    T_G <- T_G +min((1:nrow(result[[i]]))[result[[i]][,4]==max(result[[i]][,4])])
  #  }
  #  T_G <- T_G/n
  
  for(i in 1:length(result)){
    for(j in 1:n){
      if(S0-result[[i]][j,1]>=cutoff){
        r <- log((S0-result[[i]][j+est_window,1])/(S0-result[[i]][j,1]))/est_window
        R_0[i] <- R_0[i] + exp(r*T_G) # T_G how?
        break
      }
    }
  }
  print(c("mean of estimates:", mean(R_0)))
  return (R_0)
}

estimate_R0_final_size <- function(result){
  ans <- rep(0,length(result))
  S0 <- result[[1]][1,1]
  for(i in 1:length(result)){
    if(result[[i]][nrow(result[[i]]),1]/S0==1){
      ans[i] <- -log(result[[i]][nrow(result[[i]]),1]/S0)/(1-(result[[i]][nrow(result[[i]]),1]-1)/S0)
    }else{
      ans[i] <- -log(result[[i]][nrow(result[[i]]),1]/S0)/(1-result[[i]][nrow(result[[i]]),1]/S0)
    }
  }
  ans[ans<Inf]
}

compare_R0 <- function(result, cutoff=50,est_window=5,ta,ka,tb,kb,pa=0.5){
  R_0a <- ka*pa+kb*(1-pa)
  estimate <- as.vector(estimate_R0(result,cutoff=cutoff, est_window = est_window))
  estimate <- estimate[estimate>0]
  print(c("mean of estimates", mean(estimate), "true value:", R_0a))
  cbind(estimate, R_0a, estimate - R_0a)
}

##################################
######ESTIMATION - CONTINUOUS######
####################################
#
# functions almost identical as discrete case, but timed using separate time vector 
# instead of number of rows

# use Position() to find row of suitable time (def. as input)
estimate_R0_V2 <- function(result, cutoff=50,est_time=5){
  n <- nrow(result[[1]])
  S0 <- result[[1]][1,1]
  R_0 <- rep(0,length(result))
  
  for(i in 1:length(result)){
    infected <- 0
    infections <- 1
    
    for(j in 1:n){
      if(S0-result[[i]][j,1]>=8*sqrt(S0)) break
      if(S0-result[[i]][j,1]>=cutoff){
        est_time_rows <- Position(function(x) x > (result[[i]][j,5]+est_time), result[[i]][,5])
        infected <- (result[[i]][j,1]-result[[i]][est_time_rows,1])
        infections <- est_time_rows-j # number of coughs
        R_0[i] <- R_0[i]+infected/infections
        break
      }
    }
  }
  
  return (R_0)
}


# use Position() to find row of suitable time (def. as input)
# use the row to check S_1 and S_2, def T_G as input

estimate_R0_growth_V2 <-  function(result, cutoff=50,est_time=8, T_G){
  n <- nrow(result[[1]])
  S0 <- result[[1]][1,1]
  R_0 <- rep(0,length(result))
  r <- 0
  
  for(i in 1:length(result)){
    for(j in 1:n){
      if(S0-result[[i]][j,1]>=cutoff){
        est_time_rows <- Position(function(x) x > (result[[i]][j,5]+est_time), result[[i]][,5])
        r <- log((S0-result[[i]][est_time_rows,1])/(S0-result[[i]][j,1]))/est_time
        R_0[i] <- R_0[i] + exp(r*T_G) # T_G how?
        break
      }
    }
  }
  print(c("mean of estimates:", mean(R_0)))
  print(c("var of estimates:", var(R_0)))
  return (R_0)
}


# still works as previously - only final size is used 
# NOTE: assumes whole population sus. at beginning! (see Diekmann et. al.)

#estimate_R0_final_size <- function(result){
#  ans <- rep(0,length(result))
#  S0 <- result[[1]][1,1]
#  for(i in 1:length(result)){
#    if(result[[i]][nrow(result[[i]]),1]==1){
#      result[[i]][nrow(result[[i]]),1] <- result[[i]][nrow(result[[i]]),1]+1
#    }
#    ans[i] <- -log(result[[i]][nrow(result[[i]]),1]/S0)/(1-result[[i]][nrow(result[[i]]),1]/S0)
#  }
#  ans[ans<Inf]
#}