+++
titlepost = "Heavy-tailed distributions: how they appear"
date = "November 2023"
abstract = "A survey of different mechanisms that are responsible for heavy tails. "
+++



Heavy tails are ubiquitous in statistical modelling, however there are a few mechanisms giving birth to them. Here is a non-comprehensive list. 

## Simple transformations 

Suppose that $X$ is a random variable with a continuous density $f$ with $f(0)=0$. Then, $1/X$ will be heavy tailed. 

## Random recursions 

[Kesten's theorem](/posts/kesten/) is an absolute gem in mathematics and probability. Roughly speaking, it says that if a series of random numbers is defined by the recursion $X_{t+1} = A_t X_t + B_t$ where $A_t, B_t$ are random variables independent of $X_n$, then the limit of $X_t$ has a heavy tail with index $s$ given by the equation $\mathbb{E}[|A|^s]=1$. 

## Maxima of random variables 

The [Fisher-Tippett-Gnedenko](https://en.wikipedia.org/wiki/Fisher%E2%80%93Tippett%E2%80%93Gnedenko_theorem) theorem says that if $X_i$ are iid random variables and if there are numbers $a_n, b_n$ such that $a_n^{-1}(\max(X_1, \dotsc, X_n) - b_n)$ converges in distribution, then either the limit is a Gumbel distribution, or it is heavy-tailed (Weibull or Fréchet). 

Extremes of random walks are usually heavy-tailed, which is not so surprising given Kesten's theorem. 

## Non-exponential random growth: log-normality, Gibrat's law

Log-normal distributions can arise in financial models; under the hypothesis that returns follow a drifted Brownian motion, Ito's formula says that the price at time $T$ follows a log-normal distribution. More generally, if a time-varying quantity $X_t$ has a growth rate which does not depend on $X_t$, then it is heavy-tailed: for example if $X_{t+1} = (1+ r_t)X_t$ with the $r_t$ being iid, then $X_t = \prod (1 + r_s) = e^{\ln(1+r_1) + \dotsc + \ln(1+r_t)} \approx e^{\sum r_s}$ which by the CLT is approximately $e^{t\xi}$ with $\xi \sim \mathscr{N}(\mathbb{E}r, \mathrm{Var}(r))$, which is log-normal. 


## Zipf

[Zipf's law](https://en.wikipedia.org/wiki/Zipf%27s_law) is one of the most famous heavy-tailed distributions "from the real world". 

## Scale-free networks

Real-world graphs often have heavy-tailed degree sequences. A very beautiful explanation of this phenomenon lies in the famous scale-free property of preferential attachment mechanisms. In PA models, new elements (people, requests, molecules) arrive at each time step; when a new element arrives, it connects to (say) $m$ older elements, but it favors elements which alrealy have many connections. [Remco van der Hofstadts's book](https://www.win.tue.nl/~rhofstad/NotesRGCN.pdf) has a whole chapter explaining why the degree of elements in such a model are asymptotically heavy-tailed. 



[Newman's paper](https://www.cs.cornell.edu/courses/cs6241/2019sp/readings/Newman-2005-distributions.pdf)

## The 80-20 rule

##

