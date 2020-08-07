# FOR ESTIMATION CODE

# estimate R0 based on synthetic results
# input: list of matrices
# output: list of R0 estimates


##################################
######ESTIMATION - DISCRETE######
########################################


estimate_R0 <- function(result, cutoff=50,est_window=5){
  n <- nrow(result[[1]])
  S0 <- result[[1]][1,1]
  R_0 <- rep(0,length(result))
  for(i in 1:length(result)){
    infected <- 0
    infections <- 1
    for(j in 1:n){
      if(S0-result[[i]][j,1]>=8*sqrt(S0)) break # choice of const.?
      if(S0-result[[i]][j,1]>=cutoff){
        #x <- result[[i]][j,1]
        #y <- result[[i]][(j+est_window),1]
        #print("S0, i=epidemic nr, j=time, j+14, sus at j, sus at j+time")
        #print(c(S0,i,j,j+14,x,y))
        infected <- (result[[i]][j,1]-result[[i]][(j+est_window),1])
        infections <- (result[[i]][(j+est_window+1),4]-result[[i]][j+1,4])
        #print(c("time:",j,"infected:", infected, "infections/coughs:", infections))
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
  # for(i in 1:length(result)){
  #    T_G <- T_G +min((1:nrow(result[[i]]))[result[[i]][,4]==max(result[[i]][,4])])
  #  }
  #  T_G <- T_G/n
  
  for(i in 1:length(result)){
    #T_G <- 0
    for(j in 1:n){
      if(S0-result[[i]][j,1]>=cutoff){
        #print(c(" 50 exceeded at time", j))
        r <- log((S0-result[[i]][j+est_window,1])/(S0-result[[i]][j,1]))/est_window
        #T_G <- T_G + result[[i]][n,4]/(min((1:n)[result[[i]][,4]==result[[i]][n,4]]))
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
    if(result[[i]][nrow(result[[i]]),1]/S0==1){ # deal with NaN
      ans[i] <- -log(result[[i]][nrow(result[[i]]),1]/S0)/(1-(result[[i]][nrow(result[[i]]),1]-1)/S0)
    }else{
      ans[i] <- -log(result[[i]][nrow(result[[i]]),1]/S0)/(1-result[[i]][nrow(result[[i]]),1]/S0)
    }
  }
  ans[ans<Inf] # unneeded?
}

compare_R0 <- function(result, cutoff=50,est_window=5,ta,ka,tb,kb,pa=0.5){
  # calc analytic val (CHECK!):
  R_0a <- ka*pa+kb*(1-pa)
  estimate <- as.vector(estimate_R0(result,cutoff=cutoff, est_window = est_window))
  estimate <- estimate[estimate>0]
  print(c("mean of estimates", mean(estimate), "true value:", R_0a))
  cbind(estimate, R_0a, estimate - R_0a)
}

##################################
######ESTIMATION - CONTINUOUS######
########################################


# use Position() to find row of suitable time (def. as input)
# use the row to check S_1 and S_2, calc. coughs?
estimate_R0_V2 <- function(result, cutoff=50,est_time=5){
  n <- nrow(result[[1]])
  S0 <- result[[1]][1,1]
  R_0 <- rep(0,length(result))
  
  for(i in 1:length(result)){
    infected <- 0
    infections <- 1
    
    for(j in 1:n){
      if(S0-result[[i]][j,1]>=8*sqrt(S0)) break # choice of const.?
      if(S0-result[[i]][j,1]>=cutoff){
        est_time_rows <- Position(function(x) x > (result[[i]][j,5]+est_time), result[[i]][,5])
        #x <- result[[i]][j,1]
        #y <- result[[i]][(est_time_rows),1]
        #print("S0, i=epidemic nr, j=starting row, end row, sus at j, sus at j+time")
        #print(c(S0,i,j,est_time_rows,x,y))
        infected <- (result[[i]][j,1]-result[[i]][est_time_rows,1])
        infections <- est_time_rows-j # number of coughs
        #print(c("time from:",j,"infected:", infected, "infections/coughs:", infections))
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
    #T_G <- 0
    for(j in 1:n){
      if(S0-result[[i]][j,1]>=cutoff){
        #print(c(" 50 exceeded at time", j))
        est_time_rows <- Position(function(x) x > (result[[i]][j,5]+est_time), result[[i]][,5])
        r <- log((S0-result[[i]][est_time_rows,1])/(S0-result[[i]][j,1]))/est_time
        #T_G <- T_G + result[[i]][n,4]/(min((1:n)[result[[i]][,4]==result[[i]][n,4]]))
        R_0[i] <- R_0[i] + exp(r*T_G) # T_G how?
        break
      }
    }
  }
  print(c("mean of estimates:", mean(R_0)))
  print(c("var of estimates:", var(R_0)))
  return (R_0)
}


# still works as previously - we only use final size 
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