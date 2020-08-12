# UTIL (PLOTTING, VISUALS, CREATE SAMPLES ETC...)
#
# discrete case functions  row 16 - 85
# continuous case functions row 86 ->

## UTIL DISCRETE CASE:
#
# create_results: generate list of matrices using simul-function, n is length of list
#                 other inputs arguments for simul. and size of epidemics to include in list
#                 MAX_ITER bounds running time - could add count of accepted epidemics/total simul?
#
# plot_X: plot X over time for every matrix in results-list
# plot_single plots all three (S,E+I,R) curves for one specified entry in given list 
# arguments from and to allow plotting of specific interval instead of whole epidemic

# create n trials w. given parameters
create_results <- function(n=10,time, ta,ka,tb,kb,pa=0.5, S0,E0,I0=0,R0=0, ignore_small_epidemics=FALSE, small_frac = 0.33){
  results <- vector("list", n)
  MAX_ITER <- 50
  if(ignore_small_epidemics==FALSE){
    for(i in 1:n){
      results[[i]] <- simulation_binom_infectivity(time,ta,ka,tb,kb,S0=S0,E0=E0)
    }
  }else{
    for(i in 1:MAX_ITER){
      if(n==0) break
      #ignore epidemics where less than half infected
      epidemic <- simulation_binom_infectivity(time,ta,ka,tb,kb,S0=S0,E0=E0)
      if(epidemic[time,4]>S0*small_frac){
        results[[n]] <- epidemic
        n <- n-1
      } 
      
    }
  }
  return (Filter(Negate(is.null), results))
}



#plot E+I, R or S for n trials, or plot all for one single trial

plot_infected <- function(results,n=length(results),from=1, to=nrow(results[[1]])) {
  plot_to <- to
  if(to > nrow(results[[1]])){
    to <- nrow(results[[1]])
  }
  plot(x=from:to, y=(results[[1]][from:to,2]+results[[1]][from:to,3]), type="l", xla="time", ylab="number infected", main="", col="blue", xlim=c(from,plot_to),lwd=1.5)
  for (i in 2:n) {
    lines(x=from:to, y=(results[[i]][from:to,2]+results[[i]][from:to,3]), col="blue")
  }
}

plot_recovered <- function(results,n=length(results),from=1, to=nrow(results[[1]])) {
  plot_to <- to
  if(to > nrow(results[[1]])){
    to <- nrow(results[[1]])
  }
  plot(x=from:to, y=(results[[1]][from:to,4]), type="l",xla="time", ylab="number recovered", col="gold",xlim=c(from,plot_to), lwd=1.5)
  for (i in 2:n) {
    lines(x=from:to, y=(results[[i]][from:to,4]), col="gold")
  }
}

plot_susceptible <- function(results,n=length(results),from=1, to=nrow(results[[1]])) {
  plot_to <- to
  if(to > nrow(results[[1]])){
    to <- nrow(results[[1]])
  }
  plot(x=from:to, y=(results[[1]][from:to,1]), type="l",xla="time", ylab="number susceptibles", col="red",xlim=c(from,plot_to), lwd=1.5)
  for (i in 2:n) {
    lines(x=from:to, y=(results[[i]][from:to,1]), col="red")
  }
}

plot_single <- function(results, index, from=1, to=nrow(results[[index]])){
  plot_to <- to
  if(to > nrow(results[[index]])){
    to <- nrow(results[[index]])
  }
  plot(x=from:to, y=(results[[index]][from:to,1]), type="l",xla="time", ylab="number susceptibles", col="red",xlim=c(from,plot_to), lwd=1.5)
  plot(x=from:to, y=(results[[index]][from:to,2]+results[[index]][from:to,3]), type="l",xla="time", ylab="number infected", col="blue",xlim=c(from,plot_to),lwd=1.5)
  plot(x=from:to, y=(results[[index]][from:to,4]), type="l",xla="time", ylab="number recovered", col="yellow", xlim=c(from,plot_to),lwd=1.5)
}

################################################################
## UTIL CONTINUOUS CASE:
############################################################
#
# create_results_V2: generate list of matrices using simul-function over returned time[]-vector
#                    other params same as discrete case (see row 8)
#
# plot_X: same as discrete case, plots over time[] instead of rows, t0_infected sets time=0 at 
#         time when number of infectees==t0_infected
#
# print_endsOf_results: first and last rows 
# plot_infector_type: histograms of a and b over time for viewing distribution of cases
# print_interesting: totals over all epidemics in list (per type etc.)

create_results_V2 <- function(n=10,n_events, ta,ka,tb,kb,pa=0.5, S0,E0, ignore_small_epidemics=FALSE, small_frac = 0.33){
  results <- vector("list", n)
  MAX_ITER <- 50
  if(ignore_small_epidemics==FALSE){
    for(i in 1:n){
      results[[i]] <- simulation_varying_time(n_events=n_events,ta=ta,ka=ka,tb=tb,kb=kb,S0=S0,E0=E0,pa=pa)
    }
  }else{
    for(i in 1:MAX_ITER){
      if(n==0) break
      #ignore epidemics where less than small_frac infected during lifetime
      epidemic <- simulation_varying_time(n_events=n_events,ta=ta,ka=ka,tb=tb,kb=kb,S0=S0,E0=E0,pa=pa)
      if(epidemic[n_events,4]>S0*small_frac){
        results[[n]] <- epidemic
        n <- n-1
      } 
      #gc()
    }
  }
  return (Filter(Negate(is.null), results))
}

plot_susceptible_V2 <- function(results,n=length(results), to=nrow(results[[1]]), t0_infected=results[[1]][1,1] - 10, xlims = c(0,1*results[[1]][to,5])) {
  if(to > nrow(results[[1]])){
    to <- nrow(results[[1]])
  }
  t0 <- Position(function(x) x < t0_infected, results[[1]][,1])
  plot(x=results[[1]][t0:to,5]-results[[1]][t0,5], y=(results[[1]][t0:to,1]), type="l",xla="time", ylab="number susceptibles", col="red",xlim = xlims, ylim=c(0,t0_infected), lwd=1.5)
  for (i in 2:n) {
    t0 <- Position(function(x) x < t0_infected, results[[i]][,1])
    lines(x=results[[i]][t0:to,5]-results[[i]][t0,5], y=(results[[i]][t0:to,1]), col="red")
  }
}

plot_infected_V2 <- function(results,n=length(results), to=nrow(results[[1]]), t0_infected=10, xlims = c(0,1*results[[1]][to,5])) {
  if(to > nrow(results[[1]])){
    to <- nrow(results[[1]])
  }
  t0 <- Position(function(x) x > t0_infected, results[[1]][,2])
  plot(x=results[[1]][t0:to,5]-results[[1]][t0,5], y=(results[[1]][t0:to,2]+abs(results[[1]][t0:to,3])), type="l", xla="time", ylab="number infected", main="", xlim = xlims, ylim=c(0,results[[1]][1,1]), col="blue",lwd=1.5)
  for (i in 2:n) {
    t0 <-  Position(function(x) x > t0_infected, results[[i]][,2])
    lines(x=results[[i]][t0:to,5]-results[[i]][t0,5], y=(results[[i]][t0:to,2]+abs(results[[i]][t0:to,3])), col="blue")
  }
}

plot_recovered_V2 <- function(results,n=length(results), to=nrow(results[[1]]), t0_infected=10, xlims = c(0,1*results[[1]][to,5])) {
  if(to > nrow(results[[1]])){
    to <- nrow(results[[1]])
  }
  t0 <- Position(function(x) x > t0_infected, results[[1]][,4])
  plot(x=results[[1]][t0:to,5]-results[[1]][t0,5], y=(results[[1]][t0:to,4]), type="l",xla="time", ylab="number recovered", col="gold", xlim = xlims, ylim=c(t0_infected,results[[1]][1,1]),lwd=1.5)
  for (i in 2:n) {
    t0 <- Position(function(x) x > t0_infected, results[[i]][,4])
    lines(x=results[[i]][t0:to,5]-results[[i]][t0,5], y=(results[[i]][t0:to,4]), col="gold")
  }
}

plot_single_V2 <- function(results, index, from=1, to=nrow(results[[index]]), overlap = TRUE){
  if(overlap==TRUE){
    plot(x=(results[[index]][from:to,5]), y=(results[[index]][from:to,1]), type="l",xlab="time", ylab="number susceptibles", col="red", lwd=1.5, ylim = c(0,results[[index]][1,1]))
    lines(x=(results[[index]][from:to,5]), y=(results[[index]][from:to,2]+results[[index]][from:to,3]), type="l",xlab="time", ylab="number infected", col="blue",lwd=1.5)
    lines(x=(results[[index]][from:to,5]), y=(results[[index]][from:to,4]), type="l",xlab="time", ylab="number recovered", col="yellow",lwd=1.5)
  }else{
    plot(x=(results[[index]][from:to,5]), y=(results[[index]][from:to,1]), type="l",xlab="time", ylab="number susceptibles", col="red", lwd=1.5)
    plot(x=(results[[index]][from:to,5]), y=(results[[index]][from:to,2]+results[[index]][from:to,3]), type="l",xlab="time", ylab="number infected", col="blue",lwd=1.5)
    plot(x=(results[[index]][from:to,5]), y=(results[[index]][from:to,4]), type="l",xlab="time", ylab="number recovered", col="yellow",lwd=1.5)
  }
  
}

print_endsOf_results <- function(results, to=length(results)){
  for(i in 1: to){
    print(c("epidemic number", i))
    print(head(results[[i]]))
    print(tail(results[[i]]))
  }
}

plot_infector_type <- function(results,n=length(results), to=nrow(results[[1]]), n_breaks = 30) {
  par(mfrow=c(3,3))
  seq <- sample.int(n,9)
  for (i in seq) {
    p1 <- hist(results[[i]][,5][results[[i]][,3]==1], breaks = n_breaks, plot=FALSE)  # number of coughs of type a over time
    p2 <- hist(results[[i]][,5][results[[i]][,3]==-1], breaks = n_breaks, plot=FALSE)  #  number of coughs of type b over time 
    x_max <- max(p1$breaks, p2$breaks)
    y_max <-  max(p1$counts, p2$counts) 
    
    plot( p1, col=rgb(0,0,1,1/2), xlim = c(0,x_max), ylim = c(0,y_max), main = "type distribution over epidemic", xlab = "time", ylab = "coughs")  # first histogram
    plot( p2, col=rgb(1,0,0,1/2), add=T, )  # second
  }
  
  print(c(seq, "type a: blue", "type b: red"))
}

print_interesting <- function(results, n = length(results), last_row = nrow(results[[1]])){
  
  interesting <- matrix(nrow=n, ncol = 5)
  
  for(i in 1:n){
    # number infected by type a 
    interesting[i,1] <- -sum(diff(results[[i]][,1])[results[[i]][-1,3]==1]) 
    
    # number infected by b
    interesting[i,2] <- -sum(diff(results[[i]][,1])[results[[i]][-1,3]==-1])
    
    # total infected, should be sum of previous two
    # calcs using start and end values for verification
    interesting[i,3] <-results[[i]][1,1] - results[[i]][last_row, 1]
    
    # number of a and b individuals (i.e. nr coughs)
    # E0 more than infected due to initial infectees
    # E0 + interesting[i,3]= interesting[i,4] should hold (E0 = results[[i]][1,2])
    interesting[i,4] <- sum(results[[i]][,3]==1)
    interesting[i,5] <- sum(results[[i]][,3]==-1)
  }
  
  colnames(interesting) <- c("inf a", "inf b", "inf_tot", "na", "nb")
  print(interesting)
}


