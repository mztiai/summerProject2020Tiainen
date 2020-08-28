# summerProject2020Tiainen


## Introduction
This repository contains a simple simulation and some exploratory code to accompany theoretical results (elsewhere) regarding a Dirac-type epidemic. The two main parts are:
- 1 R-code for generating epidemics with different params and assumptions. All code was written in R, with some inspirations from iGraph and [2,3] (all in main folder) 
- 2 Matlab code (in /R0 stuff) for exploration of example 1.4.5. of [1], including functions and one example file for exploration 

## Running and technical details
The R-code uses only two nonstandard packages, the previously mentioned "iGraph" (which isn't needed for the functions and is only used in one part of the exploratory code) and "collections" (see https://randy3k.github.io/collections/index.html for more). The R version used was 3.6.1, but earlier versions could probably also suffice. Matlab was written in version R2020a, and uses the vpasolve-function from the Symbolic Math Toolbox™.

## R - MODEL EXPLANATION
We model the behaviour of an epidemic (alternatively epidemic events such as club visits etc.) by assuming a stochastic infectivity profile for individuals. That is, indiciduals belong to one of two types , with all infectivity focused on one point in time . Thus an infected individual remains infected for some time, after which they priduce all infections at the end of the infection after which they recover. There are both cases with a constant time, as well as a mean time with continuous time distributions included. Tihs is similar to behaviour of age-dependent branching processes, and was originally due to counterexamples in [1,4], which sought to show counterexamples to ordering of R0 given different heterogenities. 

The discrete cse with constant times is implemented as SEIR-type model with vectors of states. Every row consitutes one unit of time and we update the number of infected individuals at every time according to previously drawn infection times. Draws (when several infections occur simultaneously) are not considered as is, though they could be randomized or ties broken. The discrete case is moreseo a proof of concept/introduction.

The continuous time case considers an event based DES as in [3] appendix A . A priority queue is used to contain every event, namely the "coughs". At the time of infection in our model we know the person recovers so the recovery can automatically be uipdated. Thius contains a slight problem for plotting, since R only the adds one at the next time, but otherwise the state always holds. Otherwise we could also double the sizes of our return matrix w. recovery times added or use larger matrix and bin the events to simultaneous.

## R - PLOTTING AND UTILITY
The plotting and util functions contain plotting functions for both cases, as well as utility such as creating a given amount of epidemics, with definable epidemic level to discard (i.e. "discard epidemics that infect less than 1/2 of the population"). Othe print-functions for interesting things in the created epidemics are also included.

## R - ESTIMATION
Three estimators are implemented: one based on average number of infections per event, one based on the epidemic growth and one based on final size. The avg infections per event is perhaps least realistic as this information is hard to ascertain, but it also is a reliable check on the model. The epidemic growth is based on Diekmann et. al. section XXX (namely where a Dirac function is considered), the final size estimate also follows Diekmann et. al., although the actual proof follows from  work from Kermack and McKendrick where assuming that
1. the disease results in either immunity or death
2. all individuals initially susceptible
3. the population is closed
4. contacts occur according to the law of mass-action 
the final size is a limit of R0. Since in our homogenous population these hold. It turns out the final-size estimate remains a good approxcimation throughout almost all considered cases.

## R -PROBLEMS AND IMPROVEMENTS
- mentioned issues w. discrete and continuous case
- complexity, scalability, readability are definitely not optimal
- edge cases, no handling for improper inputs
- for loops instead of apply-type thinking as in R (but as is everything easier to move to another language if someone were to need that)
- possible theoretical errors, but these are no fault of the code
- redundant comments and memory usage

## MATLAB (in /R0 stuff)
The functions (with arguments) used are
- calcR0_N(pa,ka,pb,kb,k): calculates the R0 for the heterogenous case (see 1.4.5 in [1] or the rapport for calrification) w. given parameters
- plot_R0_over_ka(R0_H,kb,k,ka,to): plots the R0_N with R0_H,kb,k constant, with the changing ka input being in [ka,ka+to]
- R0_at_end(R0_H,kb,k,ka_end): calculates the ka+to value of plot_R0_over_ka()
- plotR0_N_over_R0_H(R0_H_input, kb, k, ka_end, to) plots the change in the heterogenous R0_N with a constant ka as R0_H grows 
The exploratory part contains example inputs that demonstrate behaviour, and the report contains technical details and mathematica analysis of the model (i.e. reasons for the limits and the behaviour) 


## SOURCES
1. Trapman Pieter, Ball Frank, Dhersin Jean-Stéphane, Tran Viet Chi, Wallinga Jacco and Britton Tom (2016) *Inferring R0 in emerging epidemics—the effect of common population structure is small*, J. R. Soc. Interface. 1320160288 http://doi.org/10.1098/rsif.2016.0288
2. Diekmann, O., Heesterbeek, H., & Britton, T. (2013).  *Mathematical Tools for Understanding Infectious Disease Dynamics*, PRINCETON; OXFORD: Princeton University Press.
3. Kiss I., Miller J., Simon P. (2017) *Mathematics of Epidemics on Networks: From Exact to Approximate Models*, Springer
4. Ball F., Pellis L., Trapman P. (2016), *Reproduction numbers for epidemic models with households and other social structures II: Comparisons and implications for vaccination*, Mathematical Biosciences, Volume 274, Pages 108-139, ISSN 0025-5564, https://doi.org/10.1016/j.mbs.2016.01.006.
