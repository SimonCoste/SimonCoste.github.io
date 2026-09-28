+++
titlepost = "Importance sampling ⚖️ "
date = "June 2023, reworked in 2026"
abstract = "On the sample size required to get a good approximation"
+++

*Sampling* refers to the generation of random variables following a certain probability distribution; for example if $F$ is a density on $\mathbb{R}^d$, we want to generate random variables which are independent and follow the distribution given by $F$, or we want to compute expectations like 
$$\mathbb{E}_{X \sim F}[\varphi(X)] = \int \varphi(x)F(x)dx$$ for some function $\varphi$. In many cases, one does not fully knows $F$, but only that it is proportional to some function $f$, that is 
$$F(x) = \frac{f(x)}{Z_f} \qquad \text{where} \qquad Z_f = \int f(u)du,$$ 
and computing the normalizing constant $Z_f$ is intractable. 

There are many techniques that still allow to sample from $F$ in this case; the whole field of Monte-Carlo research consists in crafting stochastic systems (Markov Chains, diffusions) that converge toward samples from $F$. In this note I'm focusing on a simpler method, *importance sampling* (IS), also called *reweighting*, which allows to compute integrals like above, without sampling from $F$. 

**Plan of the note**.
- First, I define IS and give examples.
- Second, I introduce a usefull metric called the Effective Sample Size. Statisticians know this stuff very well. 
- Then I explain see how much compute you need to use IS efficiently: first with a result by [Chatterjee and Diaconis](https://arxiv.org/pdf/1511.01437.pdf) for estimating a specific integral, then a result on Wasserstein distances for estimating simultaneously every integral. 
- There's a small section of "useful" diagnostics for IS estimators. 
- And then there's the proof of the Chatterjee-Diaconis result.  

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
\begin{equation}\label{In} \frac{\frac{1}{n}\sum_{i=1}^n w(Y_i) \varphi(Y_i)}{\frac{1}{n}\sum_{i=1}^n w(Y_i)} \to \mathbb{E}[\varphi(X)]= \int \varphi(x)F(x)dx.\end{equation}
@@

@@proof
**Proof.** By the Law of Large Numbers, the LHS of \eqref{Z} converges towards $\mathbb{E}[w(Y)] = \int w(y)G(y)dy = Z_f/Z_g$. 

Also by the LLN, $\frac{\sum _{i=1}^n w(Y_i)\varphi(Y_i)}{n}$
converges towards $\mathbb{E}[\varphi(Y)w(Y)] = (Z_f/Z_g)\mathbb{E}[\varphi(X)]$. 

Take the ratio of the two to get \eqref{In}. 
@@

- This technique explains the word *importance sampling*: the samples $Y_i$ are iid but their density is $G(y)$, not $F(y)$, and the weights correct the difference between the two. 
- The estimator in \eqref{In} is sometimes called Self-Normalized Importance Sampling (SNIS), because of the normalization term $\hat{Z}_n = (w_1+\dotsb + w_n)/n$. 
- If some $y$ is very likely under $G$ but not so much under $F$ (meaning that $F(y)$ is close to zero but $G(y)$ is high), then this sample will be assigned a very small weight. 
- It is very common that $w(x)$ has an exponential form, typically $w(x) = e^{v(x)-u(x)}$ for some functions $v$ and $u$. In this case you better estimate $\ln Z_f/Z_g$ with $\log \hat{Z}_n$ with the [log-sum-exp trick](https://en.wikipedia.org/wiki/LogSumExp) to avoid numerical instabilities. 

## How good is this approximation? 

Unless $F$ and $G$ are already very close to each other, this estimator can be very bad. Let's look at the variance of the estimator $\hat{Z}$ given in \eqref{Z}: clearly $\mathbb{E}[\hat{Z}]=Z_f/Z_g$, hence
\begin{align} \mathrm{Var}(\hat{Z}) &= \frac{\int  G\frac{f^2}{g^2} - (Z_f/Z_g)^2}{n} \\
&= \frac{\int \frac{g}{Z_g} \frac{f^2}{g^2} - (Z_f/Z_g)^2}{n} \\
&= \frac{(Z_f/Z_g)\mathbb{E}[w(X)]-(Z_f/Z_g)^2}{n}.
\end{align}
The first term, especially $\mathbb{E}[w(X)]$, could be prohibitively big. Indeed, let us consider the following situation: our prior density is a Standard Gaussian $G(x) = e^{-x^2/2}/\sqrt{2\pi}$, and our target density is the same, but shifted by 10: $F(x) = e^{-(x-10)^2/2}/\sqrt{2\pi}$. Here both densities are normalized, so $Z_f=Z_g=1$ and $f=F$, $g=G$. But, 
\begin{align}\mathbb{E}[F(X)/G(X)] &= \frac{1}{\sqrt{2\pi}}\int e^{-\frac{(x-10)^2}{2}}e^{-\frac{(x-10)^2 }{ 2} + \frac{x^2}{2}}dx\\ &= \frac{1}{\sqrt{2\pi}}\int e^{- \frac{(x-20)^2}{2} + 100}dx \\&= e^{100}.\end{align}
That is too big. Having a low variance for $\hat{Z}$ would require having more than $e^{100}$ samples, which is impossible. And indeed, one can even find simple examples (exponential distributions) for which the variance is infinite. 

## The Effective Sample Size

Practically, a good indicator of the quality of our importance sampling is given by the *effective sample size*. 

For the moment, let us note $\bar{w}_i$ the normalized weights, 
$$\bar{w}_i = \frac{w(y_i)}{\sum_{i=1}^n w(y_i)}.$$
The SNIS estimation of $\int \varphi F$ is $$J_n = \sum \bar{w}_i \varphi(y_i).$$ Suppose for a moment that you are in the ideal case where your proposal distribution $G$ is equal to $F$, and you have $m$ samples $y_i$. Then, $\bar{w}_i = 1/m$. The variance of ${J}_m$ in this case is simply
\begin{equation}\label{eq:v1}\frac{\sigma^2}{m}\end{equation}
where $\sigma^2 = \mathrm{Var}(\varphi(Y))$. Now go back to the case where you have $n$ samples $Y_i$ from a proposal distribution $G$. Forget an instant that the $\bar{w}_i$ are random, and treat them like fixed weights. Yes, I know they're not, but imagine. Then the variance of $J_n$ should be
\begin{equation}\label{eq:v2}\sum_{i=1}\bar{w}_i^2 \mathrm{Var}(\varphi(Y)) = |\bar{w}|_2^2 \sigma^2.\end{equation}
That's actually a good approximation of the variance of $J_n$. But then, what is the number of "real" samples from $F$ that would give the same variance? Just solve \eqref{eq:v1} = \eqref{eq:v2} and you get the **Effective Sample Size**, 
\begin{equation}\label{eq:ESS}n_* = \frac{1}{\sum_{i=1}^n \bar{w}_i}.\end{equation}
Other equivalent forms are sometimes seen in the litterature (e.g. in Kong's seminal paper[^kong]). 
An ESS of $n_*=100$ with a real sample size of 1000 says that your 1000 samples will get you the same precision as 100 real samples. Ultimately, if one real sample from $F$ costs 1€, then the real price of your $n$ fake samples from another distribution $G$ would be $n_*$€. And we always have $n_* \leqslant n$, of course.  

In general, if you have a decent "precision metric" to evaluate an estimator, you can compute a generalized notion of sample size: just compute the metric on your $n$ samples, and then compute the number $m$ of real samples which would give the same metric. 

In practice, the ESS is not really used to assess the quality of an estimator, but rather to take decisions on when to resample or not. It is often used in sequential settings, where one can monitor the ESS along time and decide to resample the proposals when the ESS collapses. 

However, Empirical Sample Sizes often do not tell the whole story, and are not very informative on the precision of an estimator, but rather on the relative precision compared to other estimators. Concretely, they do not tell you if your $n$ samples are really enough to estimate $\int \varphi F$.


## The number of samples required for IS

For any function $\varphi$, we will denote by 
$$J_n(\varphi) = \frac{\sum_{i=1}^n w(Y_i)\varphi(Y_i)}{\sum_{i=1}^n w(Y_i)}$$
the IS estimator of the target integral $\int F\varphi$, which will be noted $I(\varphi)$. 


Note that $J_n$ is unchanged if the weights $w=f/g$ are replaced by the normalized likelihood ratio $W = F/G$; in the sequel of this section we work with $W$, for which $\mathbb{E}[W(Y)]=1$. 

### The Informational sample size

The Kullback-Leibler divergence from $F$ towards $G$ is $$D = d_{\mathrm{KL}}(F\mid G) = \int F \log (F/G).$$ 
It is supposed to be $<\infty$. It can also be defined as $D=\mathbb{E}[\log W(X)]$. In general, concentration inequalities allow to bound how much $\log W(X)$ is concentrated around its mean $D$: depending on $F,G$, the deviation probability
\begin{equation}\epsilon(s)=\label{dev}\mathbb{P}(|\log W(X) - D| > s)\end{equation}
is a decreasing function of $s$ with $\epsilon(s)\to 0$. The error terms in the sequel will be expressed using this function $\epsilon$. For any positive $s$ we note $$\varepsilon(s) = (e^{-s/4} + 2\sqrt{\epsilon(s/2)})^{1/2}$$
and finally we also note $|\varphi|^2_2 = \int \varphi(x)^2 F(x)dx$ the L2-norm relatively to the target $F$. 







@@deep
**Theorem ([Chatterjee and Diaconis, 2015](https://arxiv.org/pdf/1511.01437.pdf)).**



**Positive part**. Suppose that $n=e^{D+s}$.  

Then, for any $\varphi$ which is in $L^2(F)$,  
\begin{equation}\label{main}\mathbb{P}(|J_n(\varphi) - \mathbb{E}[\varphi(X)]|>4\varepsilon(s) |\varphi|_2)\leqslant 2\varepsilon(s).\end{equation}
**Negative part**. Conversely, suppose that $n=e^{D-s}$. 

We note $\hat{D}_n$ the IS estimator of the Kullback-Leibler divergence $D$. Then this estimator is bad, in the sense that $\hat{D}_n \leqslant D - s$ with a fixed positive probability, at least greater than $1-\mathbb{P}(\log W(X) > D-s)$. 
@@


To summarize: if one has more than $e^{D}$ samples, then for every fixed $\varphi$ the probability of having $J_n(\varphi)$ close to $I(\varphi)$ is high. But if $n$ is smaller than $e^D$, then there might be functions such that with high probability, the estimator $J_n(\varphi)$ is far away from $I(\varphi)$. The original proof in the Chatterjee-Diaconis paper shows that the function $\varphi(x) = \mathbb{1}_{W(x)<\lambda}$ is itself hard to approximate, for some $\lambda$. That the KL itself is hard to estimate is due to [El Houssain Chahboun](https://elhoussainechahboun.com/about), a PhD student under the supervision of Pierre Jacob. The proof is entirely due to him!



**Uniform bounds.** Note that for a specific $\varphi$, it might very well be true that less than $e^D$ samples are needed. But $e^D$ is always enough. This asks for a natural question: how many samples do you need so that *every estimator of every $\varphi$* is simultaneously good? That is, could we control
$$\sup_{\varphi \in \mathscr{F}}\left|J_n(\varphi) - I(\varphi)\right|$$
over a certain class $\mathscr{F}$? 

### The Wasserstein sample size

If $\mathscr{F}$ is the set of all 1-Lipschitz functions, it turns out that this supremum is nothing more than the Wasserstein-1 distance between the target density $F$ and the « empirical self-normalized weighted measure », namely 
$$\hat{F}_n = \sum_{i=1}^n \bar{w}_i\delta_{Y_i}$$
where $\bar{w}_i = w(Y_i) / (w(Y_1)+\dotsb + w(Y_n))$ are the self-normalized weights. 
In [a recent work](https://arxiv.org/abs/2605.30055) with Michael Goldmann, we computed the asymptotics of $W_1(F, \hat{F}_n)$ as $n$ is large[^w1]. 

@@deep
**Wasserstein asymptotics.** For $F,G$ compactly supported and bounded away from zero and $\infty$, we have $$\mathbb{E}[W_p^p(\hat{F}_n,F)]\asymp n^{-p/d}\int F G^{-p/d}.$$
@@


- Here, $\asymp$ means that the LHS is between $c_1 \times LHS$ and $c_2 \times LHS$, for some unknosn absolute constants $c_1 \leqslant c_2$. However, in the $p=2$ case, it is known that $c_1=c_2$, so that the result is actually a true limit. 
- You can safely remove the $\mathbb{E}$. We didn't include it in the paper we all you have to check is a concentration bound. It's safe. 

**Consequence on the sample size.** Using this asymptotic, a good proxy for Chatterjee and Diaconis’ study would be that, to have a good approximation, we would need a number $n$ of samples at least comparable to $c^d$, where $c = \int F G^{-p/d}$. If $d$ is large, we can work further our approximation: 
\begin{align}
c^d 
&= \left(\int F e^{-\frac{1}{d}\log G}\right)^d \\
&\approx \left(\int F(1 - d^{-1}\log G)\right)^d \\
&\approx\left(1 - \frac{1}{d}\int F \log G\right)^d \\
&\approx e^{-\int F \log G}.
\end{align}
The entropy of $F$ is $E = -\int F \log F$; therefore, the term above is also equal to $\exp(D - \int F\log F)= \exp(D+E)$, which is not the $e^D$ of Chatterjee-Diaconis. What happens here is not 100% clear for me, but here is my take: 
- **Low entropy means less samples are needed.** If $E$ is very low, then $F$ is very concentrated; ultimately one can think of $F$ as almost a Dirac located at a point, say $0$. Then, all the integrals $\int \varphi F$ are either $0$ (if the support of $\varphi$ avoids zero) or $\approx \varphi(0)$. If there is a proposal point close to 0, then ALL the integrals will be well approximated. Hence the need for less points. 
- **High entropy means more samples are needed.** If $E$ is high then $F$ is more uniform on its support. But then, will high probability there will be a (random) zone in the domain where there is a lack of points, and the functions supported on this zone will be badly approximated. Hence the need for more points. 

## Diagnoses


As explained in the ESS section, a prominent question in the theory of IS is: how can we craft diagnostic metrics of an estimator, that indicate whether the estimator is good or bad? 

A priori, the two results given above could give an answer: we have to check if $n$ is greater than, for example, $e^D$. We do not know $D$ but we could still estimate it using IS, with
\begin{equation}\label{eq:IS_DKL}\hat{D}_n = \frac{\sum w(Y_i)\log w(Y_i)}{\sum w(Y_i)} - \log \hat{Z}_n.\end{equation}
Then declare your IS estimator to be good is $n > e^{\hat{D}_n}$. 

 This is dommed to fail. As Chatterjee and Diaconis explain, "*any diagnostic criterion that is itself dependent on the accuracy of an estimate obtained by importance sampling, is unlikely to be effective as a measure of the efficacy of importance sampling*". Id est, the second point of the theorem tells you that estimating $D$ with \eqref{eq:IS_DKL} is already a bad idea, so don't use it to estimate if $n$ is large enough. 

That's the point of the ESS: it is self-contained, in that you only need the weights $w(y_i)$ to compute the diagnostic criterion. But the ESS itself is a weak criterion, in that there is no connection between the variance of $w$ and $e^D$. This is why Chatterjee and Diaconis favor another criterion, which is simply the $L^\infty / L^1$ ratio, 
$$Q_n = \frac{\max w(y_i)}{\sum w(y_i)}.$$
They have convincing but incomplete heuristics on this diagnostic quantity. I will, at some point, expose them here. 


## Proof of the Chatterjee-Diaconis sample size

The proof relies on the following lemma, in which we have set $$I_n(\varphi)= \frac{\sum_{i=1}^n \varphi(Y_i)W(Y_i)}{n}.$$

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

- Cool blog posts by Statisticians on the ESS: [Sebastian Nowozin](https://www.nowozin.net/sebastian/blog/effective-sample-size-in-importance-sampling.html), [Alex Smola](https://alex.smola.org/posts/40-effective-sample-size/)


[^w1]: actually we computed the asymptotics for every $p\geqslant 1$. 

[^kong]: Typically the equivalent expressions are $\frac{n}{1+\hat\sigma}$ where $\sigma$ is the empirical std of the normalized weights. 
