+++
titlepost = "🏋🏼 Heavy tails I: extremes events and randomness"
date = "November 2023"
abstract = "A presentation of heavy tails, how they behave, and a short list of where they come from. "
+++

The famous Pareto principle states that, when many independent sources contribute to a quantitative phenomenon, roughly 80% of the total originates from 20% of the sources: 80% of the wealth is owned by (less than) 20% of the people, you wear the same 20% of your wardrobe 80% of the time, 20% of your efforts are responsible for 80% of your grades, 80% of your website traffic comes from 20% of your content, etc. 

This phenomenon mostly comes from a severe imbalance of the underlying probability distribution: for each sample, there is a not-so-small probability of this sample being unusually large. This is what we call **heavy tails**. In this post, we'll give a mathematical definition and a few examples. 


\toc 

## The tail distribution of a random variable

If $X$ is a random number, the tail of its distribution is the probability of $X$ taking large values: $G(x)=\mathbb{P}(X>x)$. Of course, this function is decreasing in $x$; the question is, *how fast*?


### Light tails

Some distributions from classical probability have tails which decrease quickly toward zero. It is the case for Gaussian random variables: a classical equivalent shows that if $X \sim \mathscr{N}(0,1)$, then when $x$ is very large[^1]
$$ \mathbb{P}(X>x) \sim \frac{e^{-x^2/2}}{x\sqrt{2\pi}}.$$
This probability is overwhelmingly small. For example,  $\mathbb{P}(X>5)$ is already smaller than $0.00001\%$. It means that if you draw $10000$ samples from $X$ the probability of having one of those samples greater than $5$ is approximately $0.3\%$. That's possible, but very rare. 

### Heavy tails

A distribution is heavy-tailed when $\mathbb{P}(X>x)$ does not decay as fast as $e^{-x^2}$ or even $e^{-x}$, but rather like inverses of polynomials: $1/x$ or $1/x^2$ for example. That's the case with the ratio of two standard Gaussian variables $X/Y$, whose density is $1/(\pi(1+x^2))$. For this distribution called *the Cauchy distribution*[^2], a direct computation gives
$$ \mathbb{P}(X>x) = \frac{1}{2} - \frac{\mathrm{arctan}(x)}{\pi} \sim \frac{1}{\pi x}. $$
This decays **very slowly**. For example $\mathbb{P}(X>5)\approx 1/5\pi \approx 6\%$, which means that if you draw as few as 100 samples from $X$ then you will see one of the samples larger than 5 with probability $99.8\%$. That's a very different behaviour than the preceding Gaussian example. 



Mathematically, we say that a distribution is heavy-tailed if $\mathbb{P}(X>x)$ is asymptotically comparable to $1/x^s$ for some $s$. By "asymptotically comparable", we mean that terms like $\log(x)$ should not count. There is a class of functions, called [*slowly varying*](https://en.wikipedia.org/wiki/Slowly_varying_function), encompassing this: they are all the functions which are essentially somewhere between constant and logarithmic. Just forget about this technical point: for the rest of the note, think of "regularly varying" as "almost constant". I will keep this denomination. 

@@important 
**Definition.** 
A distribution is heavy-tailed if there is an essentially constant function $c$ and an index $s>0$ such that 
\begin{equation}\label{def} \mathbb{P}(X>x) = \frac{c(x)}{x^s}.\end{equation}
@@

The same definition holds for $x\to -\infty$. 

### Densities

If $X$ has a density $f$, then one can generally see the heavy-tail of $X$ in the asymptotics of $f$. Roughly speaking, if for example $f(x) \approx c / x^{s+1}$ when $x$ is large, then $\mathbb{P}(X > x) \approx c\int_x^\infty x^{-s-1}dx = c' x^{-s}$, so $X$ is heavy-tailed with index $s$. Most of our following examples will have densities.  

### Log-scales

On the left, you see the two densities mentioned above: Gaussian and Cauchy. On classical plots like this, it is almost impossible to see if something is heavy-tailed or not. The orange curve seems to go to zero slower than the blue one, but at which rate? This is why, when it comes to heavy tails, log-scales on plots are ubiquitous. The plot on the middle is the same as the one on the left, but with a log-scale on the y-axis; and on the right, both axes have a log-scale. 

![](/posts/img/tails.png)

In fact, if $X$ has a density $f$, then discerning by bare visual inspection if $f(x)$ decays to zero rather polynomially or exponentially is almost impossible. But on a log-log scale,
- if $f(x)\approx c/x^r$ we have $\log f(x) \approx \log(c) - r \log(x)$: on a log-log plot, this is a linear relation ($y=ax+b$). 
- while if $f(x)$ is (say) exponential, $f(x) \approx ce^{-x^r}$, then $\log f(x) \approx \log(c) - x^r = \log(c) - e^{r\log (x)}$.  On a log-log plot, this is an exponential relation ($y = ae^{bx} + c$). 

This is why most plots you will see on this topic are on log-scales or log-log scales. 

### Examples of heavy-tailed distributions. 

Examples of heavy-tailed distributions include: the Cauchy distributions, the Pareto distributions, the Lévy distributions, the Weibull distributions, the Burr distributions, the log-normal distributions. In general, everything which has a density with polynomial decay. For example, the Burr distributions are 
$$f(x) = \frac{ckx^{c-1}}{(1+x^c)^{k+1}}.$$
The Pareto distribution is 
$$ f(x) = \frac{s\mathbf{1}_{x>1}}{x^{s+1}}.$$
 

## References


- The manual [Fundamentals of heavy tails](https://www.cambridge.org/core/books/fundamentals-of-heavy-tails/3B1A35A6E72551E50E4723A4785044EE) is simply the best book out there on heavy tails. 

- The book [Fooled by Randomness](https://en.wikipedia.org/wiki/Fooled_by_Randomness), written by the unsufferable Nassim Nicholas Taleb, is a very good book on maths, stats, life, risk, finance, and randomness. As always with Taleb, shining pieces of wisdom are mixed with bad faith and purely idiotic stupidities -- such books are the best books.  

- [This paper by M. Newman](https://arxiv.org/pdf/cond-mat/0412004.pdf) is a gold mine for heavy-tail examples. 

--- 

[^1] This estimate is very precise: the error is of order $e^{- x^2/2}/x^3$, so as long as $x$ is greater than $5$ it is smaller than $0.00000001$. 

[^2] Indeed, $\arctan(x) + \arctan(1/x) = \pi/2$ and when $t=1/x$ is close to zero $\arctan(t)\sim \pi/2 - 1/t$. 

