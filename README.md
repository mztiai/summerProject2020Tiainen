# summerProject2020Tiainen

TODO:
- [x] write readme explanation for model, code, structure, references (ref and clarifcation)
- [x] fix comments (unnecessary and necessary additions, explanations at top for every file)
  - cont OK
  - est OK
  - disc OK
  - util OK
- []  check everything works (names, dependencies, later fixes, problems)
- [] no errors!
- [] exploratory code missing (existing discr, cont., and previous iGraph)
- [] plots?
- [] reproduce earlier results to check!

## Introduction
This repository contains code for a summer project concerning an epidemic model including two simulation codes, plotting and utility code, estimation, as well as exploratory ramblings. All code was written in R, with some inspirations from iGraph and [2,3]

## Running and technical details
.
.
.

## MODEL EXPLANATION
We model the behaviour of an epidemic (alternatively epidemic events such as club visits etc.) by assuming a stochastic infectivity profile for individuals. That is, indiciduals belong to one of two types , with all infectivity focused on one point in time . Thus an infected individual remains infected for some time, after which they priduce all infections at the end of the infection after which they recover. There are both cases with a constant time, as well as a mean time with continuous time distributions included. Tihs is similar to behaviour of age-dependent branching processes, and was originally due to counterexamples in [1,4], which sought to show counterexamples to ordering of R0 given different heterogenities. 

The discrete cse with constant times is implemented as SEIR-type model with vectors of states. Every row consitutes one unit of time and we update the number of infected individuals at every time according to previously drawn infection times. Draws (when several infections occur simultaneously) are not considered as is, though they could be randomized or ties broken. The discrete case is moreseo a proof of concept/introduction.

The continuous time case considers an event based DES as in [3] appendix A . A priority queue is used to contain every event, namely the "coughs". At the time of infection in our model we know the person recovers so the recovery can automatically be uipdated. Thius contains a slight problem for plotting, since R only the adds one at the next time, but otherwise the state always holds. Otherwise we could also double the sizes of our return matrix w. recovery times added or use larger matrix and bin the events to simultaneous.

## PLOTTING AND UTILITY
The plotting and util functions contain plotting functions for both cases, as well as utility such as creating a given amount of epidemics, with definable epidemic level to discard (i.e. "discard epidemics that infect less than 1/2 of the population"). Othe print-functions for interesting things in the created epidemics are also included.

## ESTIMATION
Three estimators are implemented: one based on average number of infections per event, one based on the epidemic growth and one based on final size. The avg infections per event is perhaps least realistic as this information is hard to ascertain, but it also is a reliable check on the model. The epidemic growth is based on Diekmann et. al. section XXX (namely where a Dirac function is considered), the final size estimate also follows Diekmann et. al., although the actual proof follows from  work from Kermack and McKendrick where assuming that
1. the disease results in either immunity or death
2. all individuals initially susceptible
3. the population is closed
4. contacts occur according to the law of mass-action 
the final size is a limit of R0. Since in our homogenous population these hold. It turns out the final-size estimate remains a good approxcimation throughout almost all considered cases.

## PROBLEMS AND IMPROVEMENTS
- mentioned issues w. discrete and continuous case
- complexity, scalability, readibility
- edge cases, improper onputs
- visualization
- for loops onstead of apply-type thinking as in R (but as is easier to move to other code if someone were to need that)
- possible theoretical errors, but these are no fault of the code
- redundant comments and memory usage

## SOURCES
1. Trapman Pieter, Ball Frank, Dhersin Jean-Stéphane, Tran Viet Chi, Wallinga Jacco and Britton Tom (2016) *Inferring R0 in emerging epidemics—the effect of common population structure is small*, J. R. Soc. Interface. 1320160288 http://doi.org/10.1098/rsif.2016.0288
2. Diekmann, O., Heesterbeek, H., & Britton, T. (2013).  *Mathematical Tools for Understanding Infectious Disease Dynamics*, PRINCETON; OXFORD: Princeton University Press.
3. Kiss I., Miller J., Simon P. (2017) *Mathematics of Epidemics on Networks: From Exact to Approximate Models*, Springer
4. Ball F., Pellis L., Trapman P. (2016), *Reproduction numbers for epidemic models with households and other social structures II: Comparisons and implications for vaccination*, Mathematical Biosciences, Volume 274, Pages 108-139, ISSN 0025-5564, https://doi.org/10.1016/j.mbs.2016.01.006.
