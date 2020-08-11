# summerProject2020Tiainen

TODO:
- write readme explanation for model, code, structure, references !!!HALF!!!
- fix comments (unnecessary and necessary additions, explanations at top for every file)
- check everything works (names, dependencies, later fixes, problems)
- no errors!
- exploratory code missing (existing discr, cont., and previous iGraph)
- plots?
- reproduce earlier results to check!

This repository contains code for a summer project concerning an epidemic model including two simulation codes, plotting and utility code, estimation, as well as exploratory ramblings. All code was written in R, with some inspirations from iGraph and BOOK regarding epidemic simulation, as well as Diekmann et. al. 

MODEL:
We model the behaviour of an epidemic (alternatively epidemic events such as club visits etc.) by assuming a stochastic infectivity profile for individuals. That is, indiciduals belong to one of two types , with all infectivity focused on one point in time . Thus an infected individual remains infected for some time, after which they priduce all infections at the end of the infection after which they recover. There are both cases with a constant time, as well as a mean time with continuous time distributions included. Tihs is similar to behaviour of age-dependent branching processes, and was originally due to counterexamples in Trapman et. al. and Ball et. al. (?), which sought to show counterexamples to ordering of R0 given different heterogenities. 

The discrete cse with constant times is implemented as SEIR-type model with vectors of states. Every row consitutes one unit of time and we update the number of infected individuals at every time according to previously drawn infection times. Draws are not considered (ATM!!!), though they could be randomized or ties broken better. The discrete case as moreseo a proof of concept/introduction so it should not be read into too much.

The continuou time case considers an event based DES as in BOOK. A priority queue is used to contain every event, namely the "coughs". At the time of infection in our model we know the person recovers so the recovery can automatically be uipdated. Thius contains a slight problem for plotting, since R only the adds one at the next time, but otherwise the state always holds. Otherwise we could aslo double the sizes of our return matrix w. recovery times added.

PLOTTING AND UTIL
The plotting and util functions contain plotting functions for both cases, as well as utility such as creating a given amount of epidemics, with definable epidemic level to discard (i.e. "discard epidemics that infect less than 1/2 of the population"). Othe print-functions for interesting things in the created epidemics are also included.

The plotting...
.
.
.

ESTIMATION
Three estimators are implemented: one based on average number of infections per event, one based on the epidemic growth and one based on final size. The avg infections per event is perhaps least realistic as this information is hard to ascertain, but it also is a reliable check on the model. The epidemic growth is based on Diekmann et. al. section XXX (namely where a Dirac function is considered), the final size estimate also follows Diekmann et. al., although the actual proof follows from  work from Kermack and McKendrick where assuming (SOURCE)
(i) the disease results in complete immunity or death, 
(ii) all individuals are equally susceptible, 
(iii) the disease is transmitted in a closed population, 
(iv) contacts occur according to the law of mass-action, 
(v) and the population is large enough to justify a deterministic analysis
the final size is a limit of R0. Since in our homogenous population these hold, it turns out the final-size estimate remains a good approxcimation throughout almost all considered cases.

PROBLEMS AND IMPROVEMENTS
- mentioned issues w. discrete and continuous case
- complexity, scalability, readibility
- edge cases, improper onputs
- visualization
- for loops onstead of apply-type thinking as in R (but as is easier to move to other code if someone were to need that)
- possible theoretical errors, but these are no fault of the code
- redundant comments and memory usage
