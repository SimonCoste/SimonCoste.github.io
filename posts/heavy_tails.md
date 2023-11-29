+++
titlepost = "The law of small numbers: what are heavy-tailed distributions?"
date = "November 2023"
abstract = "A presentation of heavy tails, how they behave, and how to estimate them using Hill's estimator. "
+++

If $X$ is a random number, the tail of its distribution is the probability of $X$ taking large values: $G(x)=\mathbb{P}(X>x)$. Of course, this function is decreasing in $x$. Extreme value theory and large deviation theory are the areas of statistics and probability studying how fast $G$ decreases with $x$, and studying distributions where $G$ decays very slowly, meaning that $X$ could take very large values with non-negligible probability. For a long time, these heavy-tailed distributions were an *angle mort* of applied mathematics; they are, however, responsible for exceptional but catastrophic events. 

\toc 

## The tail distribution of a random variable

### Light tails

Some distributions from classical probability have tails which decrease quickly toward zero. It is the case for Gaussian random variables: a classical equivalent shows that if $X \sim \mathscr{N}(0,1)$, then when $x$ is very large[^1]
$$ \mathbb{P}(X>x) \sim \frac{e^{-x^2/2}}{x\sqrt{2\pi}}.$$
This probability is overwhelmingly small. For example,  $\mathbb{P}(X>5)$ is already smaller than $0.00001\%$. It means that if you draw $10000$ samples from $X$ the probability of having one of those samples greater than $5$ is approximately $0.3\%$. That's possible, but very rare. 

### Heavy tails

A distribution is heavy-tailed when $\mathbb{P}(X>x)$ does not decay as fast as $e^{-x^2}$ or even $e^{-x}$, but rather like inverses of polynomials: $1/x$ or $1/x^2$ for example. That's the case with the ratio of two standard Gaussian variables $X/Y$, whose density is $1/(\pi(1+x^2))$. For this distribution called *the Cauchy distribution*[^2], a direct computation gives
$$ \mathbb{P}(X>x) = \frac{1}{2} - \frac{\mathrm{arctan}(x)}{\pi} \sim \frac{1}{\pi x}. $$
This decays **very slowly**. For example $\mathbb{P}(X>5)\approx 1/5\pi \approx 6\%$, which means that if you draw as few as 100 samples from $X$ then you will see one of the samples larger than 5 with probability $99.8\%$. That's a very different behaviour than the preceding Gaussian example. 

![](/posts/img/tails.png)


Mathematically, we say that a distribution is heavy-tailed if $\mathbb{P}(X>x)$ is asymptotically comparable to $1/x^s$ for some $s$. By "asymptotically comparable", we mean that terms like $\log(x)$ should not count. There is a class of functions, called [*slowly varying*](https://en.wikipedia.org/wiki/Slowly_varying_function), encompassing this: they are all the functions which are essentially somewhere between constant and logarithmic. Just forget about this technical point: for the rest of the note, think of "regularly varying" as "almost constant". I will keep this denomination. 

@@important 
**Definition.** 
A distribution is heavy-tailed if there is an essentially constant function $c$ and an index $s>0$ such that 
\begin{equation}\label{def} \mathbb{P}(X>x) = \frac{c(x)}{x^s}.\end{equation}
@@

The same definition holds for $x\to -\infty$. For distributions having a density $f$, if $f(x) \sim x^{-s-1}$ when $x$ is large, then it is heavy tailed with index $s$. 

Examples of heavy-tailed distributions include: the Cauchy distributions, the Pareto distributions, the Lévy distributions, the Weibull distributions, the Burr distributions, the log-normal distributions. In general, everything which has a density with polynomial decay. For example, the Burr distributions are 
$$f(x) = \frac{ckx^{c-1}}{(1+x^c)^{k+1}}.$$
The Pareto distribution is 
$$ f(x) = \frac{s\mathbf{1}_{x>1}}{x^{s+1}}.$$

## How do we estimate the tail index?

Suppose you have samples from a random phenomenon, $X_1, \dotsc, X_n$. How do you convince yourself that they come from a heavy-tailed distribution, and how do you estimate the index $s$? This is not an easy task. For example, look at the three histograms below. Which ones are heavy-tailed? What's the index?

![](/posts/img/histo_tail.png)

### Histogram 

In a histogram, we count the number of observations on small bins, say $[k\varepsilon, (k+1)\varepsilon]$. The proportion of observations in any bin $[k\varepsilon,(k+1)\varepsilon]$ should be $G((k+1)\varepsilon) - G(k\varepsilon) \approx G'(k\varepsilon) \varepsilon\approx \varepsilon/(k\varepsilon)^{s+1}$. The tails of the histogram should thus decay like $k^{-s-1}$. We can also use this idea to estimate $s$: suppose that $p(k)$ is the height of the bin $[k\varepsilon, (k+1)\varepsilon]$. Then we should have $p(k)\approx c/k^{s+1}$ and so $\log p(k) \approx c - (s+1) \log(k)$. With a linear regression of $\log p(k)$ on $\log(k)$ we get an estimate for $s+1$. 

EXAMPLE

### Rank plot

There is a better way: instead of drawing histograms, one might draw "rank plots": for every $k\varepsilon$, plot the number of observations larger than $k\varepsilon$. These plots are less sensitive to noise in the observations. Again, we can use this idea to estimate the tail-index $s$. Indeed, if $Q(k)$ is the proportion of observations greater than $k\varepsilon$, then we should have $Q(k) \approx G(k\varepsilon) \approx c/(k\varepsilon)^s$, or $\log Q(k) \approx \mathrm{cst} - s \log(k)$. A linear regression would  give another estimate, directly for $s$.   

![](/posts/img/rank_plot.png)

That's better, but still not very convincing. 

### MLE on a Pareto model

If we suspect that the $X_i$ were generated from a specific parametric family of densities (Pareto, Weibull, etc.), we can try to estimate the tail-index using methods from classical parametric statistics, like Maximum Likelihood. Suppose we know that the $X_i$ come from a Pareto distribution, whose density is $f_s(x) = sx^{-s-1}$ over $[1,\infty[$. The likelihood of the observations is then 
$$\ell(s) = \sum_{i=1}^n \ln(s) - (s+1)\ln(x_i)$$
which is maximized when $n/s = \sum \ln (x_i)$. Consequently, the MLE estimator for $s$ is: 
@@important 
$$\hat{s} = \frac{1}{\frac{1}{n}\sum_{i=1}^n \ln(x_i)}.$$
@@
If the $X_i$ were truly generated by a Pareto model, this estimator has good properties: it is consistent and asymptotically Gaussian, indeed $\sqrt{n}(\hat{s} - s)$ is approximately $\mathscr{N}(0,s^2)$ when $n$ is large. This opens the door to statistical significance tests. 

For the three datasets showed earlier, the MLE estimators are: 

```
| 0.86      | 1.13       | 1.07      | 
```


### Censoring

But what if my data are *not* Pareto-distributed? A possible approach goes as follows. Suppose that the $X_i$ follow some heavy-tailed distribution with density $f$ and that $f(x)\sim cx^{-s-1}$ for some constant $c$. Then it means that, for large $x$, the density $f$ is almost the same as a Pareto. Hence, we could simply forget about the $X_i$ which are too small and only keep the large ones above some threshold $M$ (after all, they are the ones responsible for the tail behaviour), then apply the MLE estimator. This is called *censorship*; typically, if $N$ is the number of observations above the chosen threshold, then 
\begin{equation}\label{censored} \hat{s}_{\mathrm{censored}} = \frac{1}{\frac{1}{N}\sum_{i=1}^n \mathbf{1}_{X_i > M}\ln(X_i/M)}.\end{equation}
This estimator is bad. Indeed, 
- it is biased and/or not consistent for many models[^3]. 
- It is extremely sensitive to the choice of the threshold $M$. 

To avoid these pitfalls, the idea is to play with various levels of censorship $M$; that is, to choose a threshold $M_n$ which grows larger with $n$. This leads to the Hill estimator. 

### Hill's estimator

![](/posts/img/hill.png)

What would be the best choice for $M$ in \eqref{censored}? First, we note that $\hat{s}_M$ undergoes discontinuous changes when $M$ becomes equal to one of the $X_i$, since in this case one term is added to the sum and the number of indices such that $X_k > M$ is incremented by 1. It is thus natural to replace $M$ with the largest samples, say $X_{(1)}, X_{(2)}…$ where $X_{(1)}>…>X_{(n)}$ are the ordered samples:
@@important
\begin{equation}\label{h}
\hat{s}_k = \frac{1}{\frac{1}{k}\sum_{i=k}^n \ln(X_{(i)}/X_{(k)})}.
\end{equation}
@@
Here, $k$ is the number of $X_i$ larger than $X_{(k)}$, so \eqref{h} fits the definition of the censored estimator \eqref{censored} with $M = X_{(k)}$. The crucial difference with \eqref{censored} is that the threshold is now *random*. 

We still have to explain how to choose $k$. It turns out that many choices are possible, and they depend on $n$, as stated by the following essential theorem. 

@@deep **Hill's estimator is consistent.**
Set $k=k_n$, and suppose that $k_n / n \to 0$ and $k_n \to \infty$. If the $X_i$ are iid samples from a heavy-tailed distribution with index $s$ in the general sense of \eqref{def}, then $\hat{s}_{k_n}$ converges in probability towards $s$. 

@@ 

@@proof **Proof in the case of Pareto random variables.**
If the $X_i$ have the Pareto density $\mathbf{1}_{[1,\infty[}sx^{-s-1}$, then it is easy to check that $E_i = \ln(X_i)$ are Exponential random variables with rate $s$. The distribution of the ordered tuple $(\ln(X_{(1)}), \dotsc, \ln(X_{(n)}))$ is thus the distribution of $(E_{(1)}, \dotsc, E_{(n)})$.  This distribution has a very nice representation due to the exponential density. Indeed, for any test function $\varphi$, 
\begin{align*}
\mathbb{E}[\varphi(E_{(1)}, \dotsc, E_{(n)})]&= \sum_{\sigma}\mathbb{E}[\varphi(E_{\sigma(1)}, \dotsc, E_{\sigma(n)})\mathbf{1}_{E_{\sigma(1)}>\dotsb > E_{\sigma(n)}}]\\
&= \sum_\sigma \int_{x_1>\dotsb>x_n} \varphi(x_1, \dotsc, x_n)e^{-sx_1 - \dotsb - sx_n}dx_1\dots dx_n \\ 
&= \sum_\sigma \int_{u_1>0, \dotsc, u_n>0} \varphi(u_n + \dotsb + u_1, \dotsc, u_{n-1} + u_n, u_n)e^{-su_n - (su_n + su_{n-1}) - \dotsc -(su_n + \dotsb + su_1)}du_1… du_n \\
&= n! \int_{u_1>0, \dotsc, u_n>0} \varphi(u_n + \dotsb + u_1, \dotsc, u_{n-1} + u_n, u_n)e^{-ns u_n - (n-1) su_{n-1} - \dotsc - su_1}du_1… du_n \\
&= \mathbb{E}[\varphi(F_n + \dotsb + F_1, \dotsc, F_{n-1} + F_n, F_n)]
\end{align*}
where the $F_i$ are independent exponential random variables, $F_i \sim \mathscr{E}(si)$. Moreover, if $E \sim \mathscr{E}(s)$ then $E/\lambda \sim \mathscr{E}(s\lambda)$: since the $E_i$ are all iid we thus have $F_i \stackrel{\mathrm{law}}{=}E_{i}/i$. In the end, we proved that 
$$(E_{(1)}, \dotsc, E_{(n)}) \stackrel{\mathrm{law}}{=}\left( \sum_{i=1}^{n}\frac{E_i}{i}, \dotsc, \frac{E_{n-1}}{n-1} + \frac{E_{n}}{n}, \frac{E_n}{n},  \right), $$
in other words $E_{(i)}$ has the same distribution as $\sum_{j=i}^n E_j/j$. 
As a consequence, 
\begin{align*}
\frac{1}{k}\sum_{i=1}^k \ln(X_{(i)}/X_{(k)}) &= \frac{1}{k}\sum_{i=1}^k E_{(i)} - E_{(k)} \stackrel{\mathrm{law}}{=}\frac{1}{k}\sum_{i=1}^k \sum_{j=i+1}^{n} \frac{E_j}{j} = \frac{1}{k}\sum_{j=1}^{k-1}E_j.
\end{align*}
As long as $k=k_n \to \infty$, this is the empirical mean of $\mathscr{E}(s)$ random variables, and it converges towards their common mean $1/s$ as requested. Note that with this representation, we can also infer a CLT. 

**Proof in the general case.** It is rougly the same idea, but with more technicalities coming from the properties of slowly varying functions. To give the sketch, if $F$ is the cdf of the law of the $X_i$, then we can write $X_i = F^{-1}(U_i)$ where the $U_i$ are uniform on $[0,1]$. It turns out that if $F$ satisfies \eqref{def}, then its inverse can be written as $F^{-1}(u) = (1-u)^{-1/s}\ell(1/(1-u))$ -- this is a difficult result due to Karamata. Then, $\log F^{-1}(X_i)$ can be represented as 
$$ s^{-1}\log 1/U_i + \log \ell(1/U_i).$$
The first term is precisely an $\mathscr{E}(s)$ random variable, hence the analysis of the Pareto case holds. Then, we must show that the second term, when summed over $i=1, \dotsc, k$, does not contribute. This is again a consequence of slow variation. 
@@

Typically, $k_n $ could be $ \lfloor \ln n \rfloor$ or $\lfloor \sqrt{n}\rfloor$ or even $\lfloor (\log \log \log n)^2\rfloor$. That leaves many possible choices. In practice, instead of picking one such $k$, statisticians prefer plotting $\hat{s}_k$ for all the possible $k$ and observe the general shape of the plot of $k\mapsto \hat{s}_k$, which is called **Hill's plot**. Of course, Hill's theorem above says that most of the information on $s$ is contained in a small region at the beginning of the plot, a region where $k$ is small with respect to $n$ (ie $k/n \to 0$), but not too small (ie $k\to\infty$). It often happens that the Hill plot is almost constant on this small region, which can be seen for example in the second plot. 

![](/posts/img/hill_plots.png)

There's a whole science for reading Hill plots. 

It turns out that the three datasets I created for this post are as follows: 
- the first one is an exponential distribution with parameter $1/3$. It has a light tail. 
- the second one is a Pareto distribution with index $s=3$. 
- the third one is (the absolute of) a Cauchy distribution, therefore its index is $s=1$. 

## How heavy tails appear

Heavy tails are ubiquitous in statistical modelling, however there are a few mechanisms giving birth to them. Here is a non-comprehensive list. 

- [Kesten's theorem](/posts/kesten/) is an absolute gem in mathematics and probability. Roughly speaking, it says that if a series of random numbers is defined by the recursion $X_{t+1} = A_t X_t + B_t$ where $A_t, B_t$ are random variables independent of $X_n$, then the limit of $X_t$ has a heavy tail with index $s$ given by the equation $\mathbb{E}[|A|^s]=1$. 
- Maxima of random variables. The [Fisher-Tippett-Gnedenko](https://en.wikipedia.org/wiki/Fisher%E2%80%93Tippett%E2%80%93Gnedenko_theorem) theorem says that if $X_i$ are iid random variables and if there are numbers $a_n, b_n$ such that $a_n^{-1}(\max(X_1, \dotsc, X_n) - b_n)$ converges in distribution, then either the limit is a Gumbel distribution, or it is heavy-tailed (Weibull or Fréchet). 
- Extremes of random walks are usually heavy-tailed, which is not so surprising given Kesten's theorem. 
- Log-normal distributions can arise in financial models; under the hypothesis that returns follow a drifted Brownian motion, Ito's formula says that the price at time $T$ follows a log-normal distribution. More generally, if a time-varying quantity $X_t$ has a growth rate which does not depend on $X_t$, then it is heavy-tailed: for example if $X_{t+1} = (1+ r_t)X_t$ with the $r_t$ being iid, then $X_t = \prod (1 + r_s) = e^{\ln(1+r_1) + \dotsc + \ln(1+r_t)} \approx e^{\sum r_s}$ which by the CLT is approximately $e^{t\xi}$ with $\xi \sim \mathscr{N}(\mathbb{E}r, \mathrm{Var}(r))$, which is log-normal. 
- Student's distribution, ubiquitous in classical statistics, is heavy-tailed. 
- [Zipf's law](https://en.wikipedia.org/wiki/Zipf%27s_law) is one of the most famous heavy-tailed distributions "from the real world". 

## References

- [Hill's estimator](https://projecteuclid.org/journals/annals-of-statistics/volume-3/issue-5/A-Simple-General-Approach-to-Inference-About-the-Tail-of/10.1214/aos/1176343247.full). Hill's PhD-grandfather was Wald.

- The manual [Fundamentals of heavy tails](https://www.cambridge.org/core/books/fundamentals-of-heavy-tails/3B1A35A6E72551E50E4723A4785044EE) is simply the best book out there on heavy tails. 

- The book [Fooled by Randomness](https://en.wikipedia.org/wiki/Fooled_by_Randomness), written by the unsufferable Nassim Nicholas Taleb, is a very good book on maths, stats, life, risk, finance, and randomness. As always with Taleb, shining pieces of wisdom are mixed with bad faith and purely idiotic stupidities -- such books are the best books.  

[^1] This estimate is very precise: the error is of order $e^{- x^2/2}/x^3$, so as long as $x$ is greater than $5$ it is smaller than $0.00000001$. 

[^2] Indeed, $\arctan(x) + \arctan(1/x) = \pi/2$ and when $t=1/x$ is close to zero $\arctan(t)\sim \pi/2 - 1/t$. 

[^3] It is easy to see that if the $X_i$ come from a mixture of two Pareto distributions with different parameters $s_1, s_2$, then the censored MLE estimator will not converge towards the true tail index wich is $\min\{s_1, s_2\}$. 