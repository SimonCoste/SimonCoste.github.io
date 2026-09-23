+++
titlepost = "Importance sampling ⚖️ "
date = "June 2023, reworked in 2026"
abstract = "On the sample size required to get a good approximation"
+++

*Sampling* refers to the generation of random variables following a certain probability distribution; for example if $F$ is a density on $\mathbb{R}^d$, we want to generate random variables which are independent and follow the distribution given by $F$, or we want to compute expectations like $\mathbb{E}[\varphi(X)]$ for some function $\varphi$, where $X \sim F$. In many cases, one does not fully knows $F$, but only that it is proportional to some function $f$, that is 
$$F(x) = \frac{f(x)}{Z_f} \qquad \text{where} \qquad Z_f = \int f(u)du,$$ 
and computing the normalizing constant $Z_f$ is intractable. 

There are many techniques that still allow to sample from $F$ in this case; the whole field of Monte-Carlo research consists in crafting stochastic systems (Markov Chains, diffusions) that converge toward samples from $F$. In this note I'm focusing on a simpler method, *importance sampling* (IS), also called *reweighting*, which allows to compute integrals like above, without sampling from $F$. We will see an insightful result by [Chatterjee and Diaconis](https://arxiv.org/pdf/1511.01437.pdf) on the number of samples required for IS to be sufficiently precise. 

## The basic idea of Importance Sampling

Let $G$ be another probability density, supposed easy to sample from. Throughout, $F,G$ denote the normalized densities and $f,g$ their unnormalized versions, so that $F = f/Z_f$ and $G = g/Z_g$. We will never use the exact values of $Z_f$ or $Z_g$. 

@@important
In the sequel, we will adopt the following notations. 
- Samples from $F$ are noted $X$ or $X_i$. The density $F$ is called the **target**.
- Samples from $G$ are noted $Y$ or $Y_i$. The density $G$ is called the **proposal.**
- The ratio of unnormalized densities will be denoted by $w(x) = f(x)/g(x)$.
- The ratio of the densities will be denoted by $W(x) = F(x)/G(x)$. 
@@

Then, for any function $\varphi$, 
\begin{align} \mathbb{E}[\varphi(Y)w(Y)] &=  \int \varphi(y)\frac{f(y)}{g(y)}G(y)dy \\
&= \frac{1}{Z_g}\int \varphi(y)f(y)dy \\ &= \frac{Z_f}{Z_g} \mathbb{E}[\varphi(X)]. 
\end{align}
Applying this formula to $\varphi \equiv 1$ yields  $\mathbb{E}[w(Y)] =Z_f/Z_g$. Consequently, 
$$\frac{ \mathbb{E}[\varphi(Y)w(Y)] }{ \mathbb{E}[w(Y)] } = \mathbb{E}[\varphi(X)].$$
This suggests the following method for approximating $\mathbb{E}[\varphi(X)]$ without computing $Z_f$ or $Z_g$. 

@@important **Importance Sampling.**
Let $Y_1, \dotsc, Y_n$ be iid with density $G$. Then, when $n\to\infty$, almost surely one has
\begin{equation}\label{Z} \frac{\sum_{i=1}^n w(Y_i)}{n} \to \frac{Z_f}{Z_g} \end{equation}
and
\begin{equation}\label{In} \frac{\sum_{i=1}^n w(Y_i) \varphi(Y_i)}{\sum_{i=1}^n w(Y_i)} \to \mathbb{E}[\varphi(X)]= \int \varphi(x)F(x)dx.\end{equation}
@@

@@proof
**Proof.** By the Law of Large Numbers, the LHS of \eqref{Z} converges towards $\mathbb{E}[w(Y)] = \int w(y)G(y)dy = Z_f/Z_g$. 

Also by the LLN, $\frac{\sum w(Y_i)\varphi(Y_i)}{n}$
converges towards $\mathbb{E}[\varphi(Y)w(Y)] = (Z_f/Z_g)\mathbb{E}[\varphi(X)]$. 

Take the ratio of the two to get \eqref{In}. 
@@
This technique explains the word *importance sampling*: the samples $Y_i$ are iid but their density is $G(y)$, not $F(y)$, and the weights correct the difference between the two. If some $y$ is very likely under $G$ but not so much under $F$ (meaning that $F(y)$ is close to zero but $G(y)$ is high), then this sample will be assigned a very small weight. 

## How good is this approximation? 

Unless $F$ and $G$ are already very close to each other, this estimator can be very bad. Let's look at the variance of the estimator $\hat{Z}$ given in \eqref{Z}: clearly $\mathbb{E}[\hat{Z}]=Z_f/Z_g$, hence
\begin{align} \mathrm{Var}(\hat{Z}) &= \frac{\int  G\frac{f^2}{g^2} - (Z_f/Z_g)^2}{n} \\
&= \frac{\int \frac{g}{Z_g} \frac{f^2}{g^2} - (Z_f/Z_g)^2}{n} \\
&= \frac{(Z_f/Z_g)\mathbb{E}[w(X)]-(Z_f/Z_g)^2}{n}.
\end{align}
The first term, especially $\mathbb{E}[w(X)]$, could be prohibitively big. Indeed, let us consider the following situation: our prior density is a Standard Gaussian $G(x) = e^{-x^2/2}/\sqrt{2\pi}$, and our target density is the same, but shifted by 10: $F(x) = e^{-(x-10)^2/2}/\sqrt{2\pi}$. Here both densities are normalized, so $Z_f=Z_g=1$ and $f=F$, $g=G$. But, 
\begin{align}\mathbb{E}[F(X)/G(X)] &= \frac{1}{\sqrt{2\pi}}\int e^{-\frac{(x-10)^2}{2}}e^{-\frac{(x-10)^2 }{ 2} + \frac{x^2}{2}}dx\\ &= \frac{1}{\sqrt{2\pi}}\int e^{- \frac{(x-20)^2}{2} + 100}dx \\&= e^{100}.\end{align}
That is too big. Having a low variance for $\hat{Z}$ would require having more than $e^{100}$ samples, which is impossible. And indeed, one can even find simple examples (exponential distributions) for which the variance is infinite. 

### The Effective Sample Size

Practically, a good indicator of the quality of our importance sampling is given by the *effective sample size*. 

Suppose you used $n$ samples $Y_i$ from $G$. If they were distributed exactly as $F$, that is if $g$ was proportional to $f$, we would have $w(Y_i) = Z_f/Z_g$ for all $Y_i$. In general $f$ is not proportional to $g$ hence that's not the case and one way to measure how far the samples we have are from $n$ samples of $F$, we set $\hat{\sigma}_n$ = the [empirical coefficient of variation](https://en.wikipedia.org/wiki/Coefficient_of_variation) of the $w(Y_i)$, and 
$$ \mathrm{ESS}(n) = \frac{n}{1 + \hat{\sigma}_n}.$$

### How to use the ESS ? 

Suppose that you use IS with a sample size of $n=1000$. If $\mathrm{ESS} \approx 1000$ then the weigths are almost constant and there's a good chance that our sampling is excellent. If it's small, say $\mathrm{ESS} \approx 100$, then it means that the quality of your IS estimator is the same as if you would have used 100 samples of the real distribution $F$. 

This method is a good *rule of thumb* to assess the quality of IS, but it's quite empirical. In general, what is the required number of samples when one wants to efficiently estimate a mean $\mathbb{E}[\varphi(X)]$ using importance sampling? 

## The number of samples required for IS

For any function $\varphi$, we will denote by 

$$J_n(\varphi) = \frac{\sum_{i=1}^n w(Y_i)\varphi(Y_i)}{\sum_{i=1}^n w(Y_i)}$$
the IS estimator of $\int F\varphi$.  We also note $I(\varphi) = \int \varphi(x)F(x)dx = \mathbb{E}[\varphi(X)]$ the integral and $|\varphi|^2_2 = \int \varphi(x)^2 F(x)dx$ the L2-norm relatively to the target $F$. 


Note that $J_n$ is unchanged if the weights $w=f/g$ are replaced by the normalized likelihood ratio $W = F/G$; in the sequel of this section we work with $W$, for which $\mathbb{E}[W(Y)]=1$. 

The Kullback-Leibler divergence is $$D = d_{\mathrm{KL}}(F\mid G) = \int F \log (F/G).$$ 
It is supposed to be $<\infty$. It can also be defined as $D=\mathbb{E}[\log W(X)]$. In general, concentration inequalities allow to bound how much $\log W(X)$ is concentrated around its mean $D$: depending on $F,G$, the deviation probability
\begin{equation}\epsilon(s)=\label{dev}\mathbb{P}(|\log W(X) - D| > s)\end{equation}
is a decreasing function of $s$ with $\epsilon(s)\to 0$. The error terms in the sequel will be expressed using this function $\epsilon$. For any positive $s$ we note $$\varepsilon(s) = (e^{-s/4} + 2\sqrt{\epsilon(s/2)})^{1/2}.$$







@@deep
**Theorem ([Chatterjee and Diaconis, 2015](https://arxiv.org/pdf/1511.01437.pdf)).**



*Positive part*. Suppose that $n=e^{D+s}$.  Then, for any $\varphi$ which is in $L^2(F)$,  
\begin{equation}\label{main}\mathbb{P}(|J_n(\varphi) - \mathbb{E}[\varphi(X)]|>4\varepsilon(s) |\varphi|_2)\leqslant 2\varepsilon(s).\end{equation}
*Negative part*. Conversely, suppose that $n=e^{D-s}$. We note $\hat{D}_n$ the IS estimator of the Kullback-Leibler divergence $\mathbb{E}[\log W(X)]$, i.e. $\varphi = \log W$. Then this estimator is bad, in the sense that $\hat{D}_n \leqslant D - s$ with a fixed probability, at least $1-\mathbb{P}(\log W(X) > D-s)$. 
@@


To summarize: if one has more than $e^{D}$ samples, then for every fixed $\varphi$ the probability of having $J_n(\varphi)$ close to $I(\varphi)$ is high. But if $n$ is smaller than $e^D$, then there might be functions such that with high probability, the estimator $J_n(\varphi)$ is far away from $I(\varphi)$. The original proof in the Chatterjee-Diaconis paper shows that the function $\varphi(x) = \mathbb{1}_{W(x)<\lambda}$ is itself hard to approximate, for some $\lambda$. That the KL itself is hard to estimate is due to El Houssain Chahboun, a young PhD student under the supervision of Pierre Jacob. The proof is entirely due to him!

**Uniform bounds.** Note that for a specific $\varphi$, it might very well be true that less than $e^D$ samples are needed. But $e^D$ is always enough. This asks for a natural question: how many samples do you need so that *every estimator of every $\varphi$* is simultaneously good? That is, could we control, for example, 
$$\sup_{\varphi \in \mathscr{F}}\left|J_n(\varphi) - I(\varphi)\right|$$
over a certain class $\mathscr{F}$? Well, if $\mathscr{F}$ is the set of all 1-Lipschitz functions, it turns out that this supremum is nothing more than the Wasserstein-1 distance between the target density $F$ and the « empirical weighted measure », namely 
$$\hat{F}_n = \sum_{i=1}^n w_i\delta_{Y_i}.$$
In [a recent work](https://arxiv.org/abs/2605.30055) with Michael Goldmann, we computed the asymptotics of $W_1(F, \hat{F}_n)$ as $n$ is large[^w1]. 

@@deep
**Wasserstein distances.** For $F,G$ compactly supported and bounded away from zero and $\infty$, we have $W_p^d(\hat{F}_n,F)\asymp n^{-p/d}\mathscr{C}_p(F\mid G)$, where 
$$\mathscr{C}_p(F\mid G) = \int F G^{-p/d}.$$
This is only valid in dimension $d\geqslant 3$. 
@@

So a good proxy for Chatterjee and Diaconis’ result would be that, to have a good approximation, we would need a number $n$ of samples at least comparable to $c^d$, where $c = \mathscr{C}_1(G\mid F)$. If $d$ is large, we can work further our approximation: 
\begin{align}
c^d 
&= \left(\int F e^{-\frac{1}{d}\log G}\right)^d \\
&\approx \left(\int F(1 - d^{-1}\log G)\right)^d \\
&\approx\left(1 - \frac{1}{d}\int F \log G\right)^d \\
&\approx e^{-\int F \log G}.
\end{align}
That is equal to $\exp(D - \int F\log F)$, which is not the $e^D$ of Chatterjee-Diaconis. The term $\int F\log F = -\mathrm{Entropy}(F)$ be very well be positive or negative. When it is very largely positive, it means that the entropy is largely negative and hence that $F$ is very concentrated. 


## Proof of the result 
The proof almost entirely relies on the following lemma, in which we have set $$I_n(\varphi)= \frac{\sum_{i=1}^n \varphi(Y_i)W(Y_i)}{n}.$$

@@important
**Lemma.** For any $\lambda >0$,
\begin{equation}\label{lem}\mathbb{E}[|I_n(\varphi) - I(\varphi)|] \leqslant |\varphi|_{2}\left(\sqrt{\frac{\lambda}{n}} + 2\mathbb{P}(W(X)>\lambda)\right). \end{equation}
@@

As noted earlier we have $\mathbb{E}[\log W(X)] = D$, hence it is natural to choose $\log \lambda$ at the same scale as $D$. We take $\lambda = e^{D + s/4}$. The ratio $\lambda/n$ becomes $e^{-s/4}$ and $\mathbb{P}(W(X)>\lambda)\leqslant \epsilon(s/4)$. Overall, the RHS of \label{lem} becomes equal to $ |\varphi|_2 \times \varepsilon(s)^2 $. 

We will prove this lemma later. From now on, let us prove the theorem. 

@@proof 
**Proof of the positive part.**
If $|I_n(1)-1|<\delta$ and $|I_n(\varphi) - I(\varphi)|<\delta'$ then we see that 
\begin{align}|J_n(\varphi) - I(\varphi)| &= |I_n(\varphi)/I_n(1) - I(\varphi)|\\&\leqslant \frac{|I_n(\varphi) - I(\varphi)| + |I(\varphi)||I_n(1)-1|}{|I_n(1)|} \\
&\leqslant \frac{\delta' + \delta |I(\varphi)|}{1-\delta} \end{align}
Now choose $\delta = \varepsilon(s)$ and $\delta' = |\varphi|_2 \varepsilon(s)$. Moreover, since $|I(\varphi)|\leqslant |\varphi|_2$ by the Cauchy-Schwarz inequality, we get that 
$$\frac{\delta' + \delta |I(\varphi)|}{1-\delta}\leqslant \frac{2\varepsilon(s)|\varphi|_2}{1 - \varepsilon(s)}. $$
In particular, if $\varepsilon(s)<1/2$, then
$$\mathbb{P}(|J_n(\varphi)  - I(\varphi)| > 4|\varphi|_2\varepsilon(s) )\leqslant \mathbb{P}(|I_n(1)-1|>\delta \text{ or } |I_n(\varphi) - I(\varphi)|>\delta').$$
We use the union bound and bound the probability of each event separately; to do that we apply Markov's inequality and the Lemma to the constant function $1$ and to the function $\varphi$. We get 
\begin{align}\label{events}
&\mathbb{P}(|I_n(1) - 1|>\delta) \leqslant \varepsilon(s)^2/\delta = \varepsilon(s), \\ &\mathbb{P}(|I_n(\varphi) - I(\varphi)|>\delta') \leqslant |\varphi|_2 \varepsilon(s)^2/\delta' = \varepsilon(s).\end{align}
Hence by the union bound the probability is at most $2\varepsilon(s)$, which is the claim.
@@

@@proof 
**Proof of the negative part.** A small remark to begin: we note $$w_i  = \frac{W(Y_i) }{\sum_{j=1}^n W(Y_j)}$$ for the normalized importance weights. They are positive and sum to 1. Consequently, for any numbers $t_i$, if $\sum w_i t_i$ is greater than $T$ then at least one of the $t_i$ is greater than $T$. 

When trying to estimate the KL with importance sampling, we set
$$\hat{D}_n = \sum_{i=1}^n w_i \log W(Y_i)$$
where $W = F/G$. Then, by the remark above, 
\begin{align}\mathbb{P}(\hat{D}_n > D-s)&\leqslant  \mathbb{P}(\exists i : \log W(Y_i) > D-s)\\
&\leqslant n\mathbb{P}(\log W(Y) > D-s).
\end{align}
Now we bound this probability using Markov’s inequality. We have
\begin{align}
\mathbb{P}(\log W(Y) > D-s) &= \int_{W(y)>e^{D-s}} G(y)\, dy\\
&\leqslant e^{-D+s}\int_{W(y)>e^{D-s}} W(y)\, G(y)\, dy \\
&= e^{-D+s}\mathbb{P}(\log W(X)>D-s).
\end{align}
To summarize, if $n=e^{D-s}$ we showed that $$\mathbb{P}(\hat{D}_n > D - s)\leqslant \mathbb{P}(\log W(X) > D-s),$$
hence $\hat{D}_n \leqslant D-s$ with probability at least $1-\mathbb{P}(\log W(X) > D-s)$.
@@

### Proof of the Lemma

Set $\psi = \varphi \mathbb{1}_{W\leqslant \lambda}$. Then, 
$$ |I_n(\varphi) - I(\varphi) |\leqslant | I_n(\varphi) - I_n(\psi) |+| I_n(\psi) - I(\psi)| + |I(\psi) - I(\varphi)| = A+B+C$$

**-- Term $C$** is equal to $\int F(x)\varphi(x)\mathbb{1}_{W(x)> \lambda}dx$. By the Cauchy-Schwarz inequality it is smaller than 
\begin{equation}\label{p:2} \sqrt{\int \varphi(x)^2 F(x)dx \times \mathbb{P}(W(X)> \lambda)} = |\varphi|_{2}\sqrt{\mathbb{P}(W(X)> \lambda)}.\end{equation}
**-- Term $B$** is smaller than $ \frac{1}{n}\sum W(Y_i)|\varphi(Y_i)| \mathbb{1}_{W(Y_i)>\lambda}$ hence its expectation is smaller than $\mathbb{E}[W(Y)|\varphi(Y)|\mathbb{1}_{W(Y)>\lambda}] = \mathbb{E}[\varphi(X)\mathbb{1}_{W(X)>\lambda}]$ and we use the same trick as \eqref{p:2}. 

**-- Term $A$** is bounded as follows: 
\begin{align}
\mathbb{E}[|I_n(\psi) - I(\psi)|]&\leqslant  \sqrt{\mathbb{E}[|I_n(\psi) - I(\psi)|^2]} = \sqrt{\mathrm{Var}(I_n(\psi))}\\
&\leqslant\sqrt{\frac{\int \psi(y)^2W(y)^2G(y)dy}{n} }\\
&\leqslant \sqrt{ \frac{\int_{W(y)\leqslant \lambda} \varphi(y)^2 W(y) F(y) dy}{n}}\\
&\leqslant \sqrt{\lambda \frac{\int \varphi(y)^2 F(y) dy}{n} } = \sqrt{\lambda |\varphi|^2_{2}/n}.\\
\end{align}
We gather the three bounds and get \eqref{lem}. 



# Reference

- [The paper](https://arxiv.org/pdf/1511.01437.pdf) by Chatterjee and Diaconis, with a very nice application to an old remark by Knuth on self-avoiding walks. 

- [A nice paper on the Effective Sample Size](https://www2.stat.duke.edu/~scs/Courses/Stat376/Papers/ConvergeRates/LiuMetropolized1996.pdf) by Jun S Liu, with a theoretical justification on why the ESS is significant and a comparison with other sampling techniques. 

- Two papers on the sample size of IS, [here](https://arxiv.org/pdf/1608.08814) and [there](https://arxiv.org/pdf/2009.10831) by Daniel Sanz-Alonso, especially on the $\chi^2$-divergence. 


[^w1]: actually we computed the asymptotics for every $p\geqslant 1$. 
