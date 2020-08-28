# Exploratory code - examples and demo
## Discrete case: rows 5 to 124
## Continuous case: rows 125 to end

## DISCRETE CASE

# Effect of changing ka,kb params on the epidemic,
results_aa <-create_results(n=10,time=144,ta=3,ka=2,tb=8,kb=0.5,S0=100,E0=1)
results_ab <-create_results(n=10,time=144,ta=3,ka=2,tb=8,kb=1,S0=100,E0=1)
results_ac <-create_results(n=10,time=144,ta=3,ka=2,tb=8,kb=1.5,S0=100,E0=1)

results_ba <-create_results(n=10,time=144,ta=3,ka=3,tb=8,kb=0.5,S0=100,E0=1)
results_bb <-create_results(n=10,time=144,ta=3,ka=3,tb=8,kb=1,S0=100,E0=1)
results_bc <-create_results(n=10,time=144,ta=3,ka=3,tb=8,kb=1.5,S0=100,E0=1)

results_ca <-create_results(n=10,time=144,ta=3,ka=4,tb=8,kb=0.5,S0=100,E0=1)
results_cb <-create_results(n=10,time=144,ta=3,ka=4,tb=8,kb=1,S0=100,E0=1)
results_cc <-create_results(n=10,time=144,ta=3,ka=4,tb=8,kb=1.5,S0=100,E0=1)

## plotting:
plot_infected(results = results_aa)
plot_infected(results = results_ab)
plot_infected(results = results_ac)

plot_infected(results = results_ba)
plot_infected(results = results_bb)
plot_infected(results = results_bc)

plot_infected(results = results_ca)
plot_infected(results = results_cb)
plot_infected(results = results_cc)


# Compare to Igraph epidemic on complete graph:
sm2 <- sir(make_full_graph(100, directed = FALSE, loops = FALSE), beta=0.5,gamma=0.5)

par(mfrow=c(2,3))
plot(sm2,comp = c("NS"))
plot(sm2,comp = c("NI"))
plot(sm2,comp = c("NR"))
plot_susceptible(results = results_aa)
plot_infected(results = results_aa)
plot_recovered(results = results_aa)


# Test larger epidemics 

## create epidemics w. no zero epidemics:

increasing <- create_results(n=20,time=144,ta=5,ka=4,tb=6,kb=1,S0=1000,E0=1, ignore_small_epidemics = TRUE)
exploding <- create_results(n=20,time=144,ta=3,ka=10,tb=8,kb=3,S0=1000,E0=1, ignore_small_epidemics = TRUE)
slowly_increasing <- create_results(n=20,time=144,ta=3,ka=2.5,tb=8,kb=1.5,S0=1000,E0=1, ignore_small_epidemics = TRUE)
slower_increasing <- create_results(n=20,time=250,ta=8,ka=2.5,tb=12,kb=1.5,S0=1000,E0=1, ignore_small_epidemics = TRUE)

# Accuracy of estimation:

## R_0 theoretical: 2
compare_R0(slowly_increasing, est_window = 4,ta=3,ka=2.5,tb=8,kb=1.5)
estimate_R0_final_size(slowly_increasing)
## effect of window size:
estimate_R0_growth(slowly_increasing, T_G=((8+3)/2+1), est_window = 5, cutoff = 25)
estimate_R0_growth(slowly_increasing, T_G=((8+3)/2+1), est_window = 21, cutoff = 25)
estimate_R0_growth(slowly_increasing, T_G=((8+3)/2+1), est_window = 5, cutoff = 50)
estimate_R0_growth(slowly_increasing, T_G=((8+3)/2+1), est_window = 21, cutoff = 50)

## R_0 theoretical: 2
compare_R0(slower_increasing, est_window = 5,ta=8,ka=2.5,tb=12,kb=1.5)
estimate_R0_final_size(slower_increasing)

## R_0 theoretical: 2.5
compare_R0(increasing,est_window = 5,ta=5,ka=4,tb=6,kb=1)
estimate_R0_final_size(increasing)
estimate_R0_growth(increasing, T_G=((8+3)/2+1), est_window = 7, cutoff = 25)
#estimate_R0_growth(increasing, T_G=((8+3)/2+1), est_window = 21, cutoff = 25)
estimate_R0_growth(increasing, T_G=((8+3)/2+1), est_window = 5, cutoff = 35)
estimate_R0_growth(increasing, T_G=((8+3)/2+1), est_window = 8, cutoff = 50)

## R_0 theoretical: 6.5
compare_R0(exploding, est_window = 5, ta=3,ka=10,tb=8,kb=3)
estimate_R0_final_size(exploding)
mean(estimate_R0_final_size(exploding)[estimate_R0_final_size(exploding)<Inf])
estimate_R0(exploding, est_window = 5)
estimate_R0_growth(exploding, T_G=((8+3)/2+1), est_window = 5, cutoff = 25)
estimate_R0_growth(exploding, T_G=((8+3)/2+1), est_window = 8, cutoff = 50)

## Plotting the accuracy:
# slowly
plot(estimate_R0(slowly_increasing, est_window = 5), ylim=c(0,4),pch=15,col="yellow", main="Slowly increasing", ylab="estimate of R0")
abline(h=2.0, col="blue")
points(estimate_R0_final_size(slowly_increasing),pch=16,col="orange")
points(estimate_R0_growth(slowly_increasing, T_G=((8+3)/2+1), est_window = 5, cutoff = 50),pch=2,col="red")
points(estimate_R0_growth(slowly_increasing, T_G=((8+3)/2+1), est_window = 25, cutoff = 25),pch=17,col="red")
legend("bottomleft", legend=c("infection estimate", "final size estimate", "growth estimate - 50","growth estimate - 25"), pch=c(16,16,2,17),col=c("yellow", "orange", "red", "red"))
# 9, 20, 30

# slower 
plot(estimate_R0(slower_increasing, est_window = 5), ylim=c(0,4),pch=15,col="yellow", main="slower increasing", ylab="estimate of R0")
abline(h=2.0, col="blue")
points(estimate_R0_final_size(slower_increasing),pch=16,col="orange")
points(estimate_R0_growth(slower_increasing, T_G=((8+12)/2+1), est_window = 5, cutoff = 50),pch=2,col="red")
points(estimate_R0_growth(slower_increasing, T_G=((8+12)/2+1), est_window = 25, cutoff = 25),pch=17,col="red")
legend("bottomleft", legend=c("infection estimate", "final size estimate", "growth estimate - 50","growth estimate - 25"), pch=c(16,16,2,17),col=c("yellow", "orange", "red", "red"))
# 10, 28, 30

# normal
plot(estimate_R0(increasing, est_window = 5), ylim=c(0,5),pch=15,col="yellow", main="Normal increasing", ylab="estimate of R0")
abline(h=2.5, col="blue")
points(estimate_R0_final_size(increasing),pch=16,col="orange")
points(estimate_R0_growth(increasing, T_G=((8+3)/2+1), est_window = 5, cutoff = 50),pch=2,col="red")
points(estimate_R0_growth(increasing, T_G=((8+3)/2+1), est_window = 25, cutoff = 25),pch=17,col="red")
legend("bottomleft", legend=c("infection estimate", "final size estimate", "growth estimate - 50","growth estimate - 25"), pch=c(16,16,2,17),col=c("yellow", "orange", "red", "red"))

#5, 11, 20

# explosive
plot(estimate_R0(exploding, est_window = 5), ylim=c(0,13),pch=15,col="yellow", main="Exploding", ylab="estimate of R0")
abline(h=6.5, col="blue")
points(estimate_R0_final_size(exploding),pch=16,col="orange")
points(estimate_R0_growth(exploding, T_G=((8+3)/2+1), est_window = 5, cutoff = 50),pch=2,col="red")
points(estimate_R0_growth(exploding, T_G=((8+3)/2+1), est_window = 25, cutoff = 25),pch=17,col="red")
legend("topleft", legend=c("infection estimate", "final size estimate", "growth estimate - 50","growth estimate - 25"), pch=c(16,16,2,17),col=c("yellow", "orange", "red", "red"))
# 5, 5 , 11


##################################
#################################
###########CONTINUOUS############
#################################

##############
### PLOTTING ###
##############

# Changing dist_a and dist_b allows very different epidemics:
# these have type b according to the naming
testing_V2 <- create_results_V2(n=10,2100,1,6,3,1,S0=2000,E0=3, ignore_small_epidemics = TRUE, small_frac = 0.25)
testing_V2_extreme <- create_results_V2(n=10,2100,1,6,3,1,S0=2000,E0=3, ignore_small_epidemics = TRUE, small_frac = 0.25)
testing_V2_normal <- create_results_V2(n=10,2100,1,6,3,1,S0=2000,E0=3, ignore_small_epidemics = TRUE, small_frac = 0.25)
testing_V2_both_exp <- create_results_V2(n=10,2100,1,6,3,1,S0=2000,E0=3, ignore_small_epidemics = TRUE, small_frac = 0.25)

# plotting all:
par(mfrow=c(3,4))

plot_susceptible_V2(testing_V2, t0_infected = 2000-20)
plot_susceptible_V2(testing_V2_extreme, t0_infected = 2000-20)
plot_susceptible_V2(testing_V2_normal, t0_infected = 2000-20)
plot_susceptible_V2(testing_V2_both_exp, t0_infected = 2000-20)


plot_infected_V2(testing_V2, t0_infected = 20)
plot_infected_V2(testing_V2_extreme, t0_infected = 20)
plot_infected_V2(testing_V2_normal, t0_infected = 20)
plot_infected_V2(testing_V2_both_exp, t0_infected = 20)

plot_recovered_V2(testing_V2, t0_infected = 20)
plot_recovered_V2(testing_V2_extreme, t0_infected = 20)
plot_recovered_V2(testing_V2_normal, t0_infected = 20)
plot_recovered_V2(testing_V2_both_exp, t0_infected = 20)

plot_infector_type(testing_V2, n_breaks=50)
plot_infector_type(testing_V2_extreme, n_breaks=50)
plot_infector_type(testing_V2_normal, n_breaks=50)
plot_infector_type(testing_V2_both_exp, n_breaks=50)

#prints head and tail of full matrix list
print_endsOf_results(testing_V2_both_exp)

# ESTIMATION
#
#
# COMPARISON - R0 should be 3.5 in theoretical case (weighted average)
# avg coughs estimate for all epidemics :
mean(estimate_R0_V2(testing_V2,cutoff=20, est_time=1))
mean(estimate_R0_V2(testing_V2_extreme,cutoff=20, est_time=1))
mean(estimate_R0_V2(testing_V2_normal,cutoff=20, est_time=1))
estimate_R0_V2(testing_V2_both_exp,cutoff=20, est_time=1)

# growth based estimates:
# for playing around with parameters
estimate_R0_growth_V2(testing_V2, est_time = 1, cutoff=200 ,T_G=2)
estimate_R0_growth_V2(testing_V2, est_time = 3, cutoff = 200 ,T_G=2) 
mean(estimate_R0_growth_V2(testing_V2, est_time = 2.5, cutoff = 250 ,T_G=2))

estimate_R0_growth_V2(testing_V2_extreme, est_time = 1, cutoff=200 ,T_G=2)
estimate_R0_growth_V2(testing_V2_extreme, est_time = 2.5, cutoff = 200 ,T_G=2)

estimate_R0_growth_V2(testing_V2_normal, est_time = 1, cutoff=250 ,T_G=2)
estimate_R0_growth_V2(testing_V2_normal, est_time = 3, cutoff = 250 ,T_G=2)

estimate_R0_growth_V2(testing_V2_both_exp, est_time = 1, cutoff=250 ,T_G=2)
estimate_R0_growth_V2(testing_V2_both_exp, est_time = 3, cutoff = 250 ,T_G=2)

# problem: how to find good T_G and est_time a priori?

# final size estimates:
estimate_R0_final_size(testing_V2)
mean(estimate_R0_final_size(testing_V2))

estimate_R0_final_size(testing_V2_extreme)
mean(estimate_R0_final_size(testing_V2_extreme))

estimate_R0_final_size(testing_V2_normal)
mean(estimate_R0_final_size(testing_V2_normal))

estimate_R0_final_size(testing_V2_both_exp)
mean(estimate_R0_final_size(testing_V2_both_exp))

# shows other information about the epidemic (how many type a/b, how many infected by a/b etc.)
print_interesting(testing_V2)
print_interesting(testing_V2_extreme)
print_interesting(testing_V2_normal)
print_interesting(testing_V2_both_exp)

# SUPERSPREADER-behaviour:
#
#
#
#
#

testing_V2_critical <- create_results_V2(n=10,4100,ta=7,ka=50,tb=0.5,kb=1.25,S0=4000,E0=5, pa=0.1,ignore_small_epidemics = TRUE, small_frac = 0.33)

# OTHER INPUTS:

## prolonged epidemic w. severe underestimation:
## (n=10,4100,ta=7,ka=75,tb=0.5,kb=1.25,S0=4000,E0=5, pa=0.1,ignore_small_epidemics = TRUE, small_frac = 0.33)
## ta dist runif(1,3,ta-3), tb rexp(1,1/tb)

## fast epidemic w. high kb:
## (n=10,7100,ta=7,ka=50,tb=0.5,kb=4,S0=7000,E0=5, pa=0.1,ignore_small_epidemics = TRUE, small_frac = 0.33)
## ta runif(1,1,2*ta-1)

##other slow epidemic:
## (n=10,7100,ta=7,ka=75,tb=0.5,kb=1.25,S0=7000,E0=5, pa=0.1,ignore_small_epidemics = TRUE, small_frac = 0.33)
## ta runif ,1,2*ta-1, tb exp, runif(1,3,ta-3) gives even longer wind down and worse estimator performance

## local beheviour? ka high -> occasionally locally explosive (see ka high kb slightly higher than 1)
## targeting ka population suffices to decrease R0

# estimating superspreaders
estimate_R0_final_size(testing_V2_critical)
mean(estimate_R0_final_size(testing_V2_critical))

estimate_R0_growth_V2(testing_V2_critical, cutoff=500, est_time = 1, T_G=0.75)
estimate_R0_V2(testing_V2_critical, cutoff=400, est_time = 4)

# final size generally good - if enough population to give acc. picture
# size and rate estimators perform poorly in radical cases (esp. ta uniform with no small values)
# "worse" R0 possible with same time dist if kb sizeable enough -> more explosive epidemic
# even if this is worse the final size should remain similar? demands impractical population size?

# by worse I mean (1st and 2nd example above)
#> 0.1*75+0.9*1.25
#[1] 8.625
#> 0.1*50+0.9*4
#[1] 8.6
# R0 in the 2nd case is "smaller", but the growth is quicker and dies out faster - effects on final size
# shouldn't exist. The estimation based on growth can still obviously not return the same answer for both