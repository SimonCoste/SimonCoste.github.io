+++
titlepost = "Flow models II: Score Matching Techniques"
date = "March 2025"
abstract = "Learning the score of a density from its samples and Tweedie's formula. "
+++

The *score* of a probability density $p$ is the gradient of its log-density: $\nabla \log p(x)$. This object is of paramount importance in many fields, like physics, statistics, and machine learning. In particular, it is needed if one needs to sample from the reverse SDE of a diffusion model. In this note, we survey the classical technique used for learning the score of a density from its samples: *score matching*.

\tableofcontents

## Vanilla Score Matching

**The Fisher Divergence**

The L2-distance between the scores of two probability densities is often called the *Fisher divergence*: 
$$ \mathrm{fisher}(\rho_1 \mid \rho_2) = \int \rho_1(x)|\nabla\log\rho_1(x) - \nabla\log\rho_2(x)|^2dx.$$
Since our goal is to learn $\nabla\log p(x)$, it is natural to choose a parametrized family of functions $s_\theta$ and to optimize $\theta$ so that the divergence 
$$\int p(x)|\nabla\log p(x) - s_\theta(x)|^2dx $$
is as small as possible. However, this optimization problem is intractable, due to the presence of the explicit form of $p$ inside the integral. This is where Score Matching techniques come into play. 

**The score matching trick**

Let $p$ be a smooth probability density function supported over $\mathbb{R}^d$ and let $X$ be a random variable with density $p$. The following elementary identity is due to [Hyvärinen, 2005](https://www.jmlr.org/papers/volume6/hyvarinen05a/hyvarinen05a.pdf); it is the basis for score matching estimation in statistics. 

@@important
Let $s : \mathbb{R}^d \to \mathbb{R}^d$ be any smooth function with sufficiently fast decay at $\infty$, and $X \sim p$. Then,
\begin{equation}\label{SM}
\mathbb{E}[\vert \nabla \log p(X) - s(X)\vert^2] = c + \mathbb{E}\left[|s(X)|^2 +  2 \nabla \cdot s(X)\right]
\end{equation}
where $c$ is a constant not depending on $s$. 
@@ 

@@proof
**Proof.** We start by expanding the square norm: 
\begin{align}\int p(x)|\nabla \log p(x) - s(x)|^2 dx &= \int p(x)|\nabla \log p(x)|^2 dx + \int p(x)|s(x)|^2 dx - 2\int  \nabla \log p(x)\cdot p(x)s(x) dx.
\end{align} 
The first term does not depend on $s$, it is our constant $c$. For the last term, we use $\nabla \log p = \nabla p / p$ then we use the integration-by-parts formula: 
$$2\int  \nabla \log p(x)\cdot p(x)s(x) dx = 2\int \nabla p(x) \cdot s(x) dx = -2 \int p(x)( \nabla \cdot s(x))dx$$
and the identity is proved. 
@@ 

The loss we want to minimize is thus
\begin{equation}\label{opt_theta} \theta \in \argmin_\theta \mathbb{E}[\vert \nabla \log p(X) - s_{\theta}(X)\vert^2] = \argmin_\theta \mathbb{E}[|s_{\theta}(X)|^2 + 2 \nabla \cdot (s_{\theta}(X))].\end{equation}
Practically, learning the score of a density $p$ from samples $x^1, \dots, x^n$ is done by minimizing the empirical version of the right-hand side of \eqref{SM}:
$$ \ell(\theta) = \frac{1}{n}\sum_{i=1}^n |s_{\theta}(x^i)|^2 + 2 \nabla \cdot (s_{\theta}(x^i)).$$

This looks computable… except it's not ideal.  Suppose we perform a gradient descent on $\theta$ to find the optimal $\theta$. Then at each gradient descent step, we need to evaluate $s_{\theta}$ as well as its divergence; *and then* compute the gradient in $\theta$ of the divergence in $x$, in other words to compute $\nabla_\theta \nabla_x \cdot s_\theta$. In high dimension, this can be too costly. 

## Tweedie's formula for denoising

### Denoising Score Matching

Fortunately, there is another way to perform score matching when $p_t$ is the distribution of a random variable with gaussian noise added, as in our setting. We'll present this result in a fairly abstract setting; we suppose that $p$ is a density function, and $q = p*g$ where $g$ is an other density. The following result is due to [Vincent, 2010](https://www.iro.umontreal.ca/~vincentp/Publications/smdae_techreport.pdf). 



@@important
**Denoising Score Matching Objective**

Let $s:\mathbb{R}^d \to \mathbb{R}^d$ be a smooth function. Let $X$ be a random variable with density $p$, and let $\varepsilon$ be an independent random variable with density $g$. We call $p_{\mathrm{noisy}}$ the distribution of $X_{\mathrm{noisy}}=X + \varepsilon$. Then, 
\begin{equation}\label{dsm}
\mathbb{E}[\vert \nabla \log p_{\mathrm{noisy}}(X+\varepsilon) - s(X+\varepsilon)\vert^2] = c + \mathbb{E}[|\nabla \log g(\varepsilon) - s(X+\varepsilon)|^2]
\end{equation}
where $c$ is a constant not depending on $s$. 
@@

@@proof
**Proof.** Note that $p_{\mathrm{noisy}} = p * g$. By expanding the square, we see that $ \mathbb{E}[\vert \nabla \log p_{\mathrm{noisy}}(X+\varepsilon) - s(X+\varepsilon)\vert^2]$ is equal to 
$$ c + \int p_{\mathrm{noisy}}(x)|s(x)|^2dx -2\int \nabla p_{\mathrm{noisy}}(x)\cdot s(x)dx.$$
Now by definition, $p_{\mathrm{noisy}}(x) = \int p(y)g(x-y)dy$, hence $\nabla p_{\mathrm{noisy}}(x) = \int p(y)\nabla g(x-y)dy$, and the last term above is equal to 
\begin{align} -2\int \int p(y)\nabla g(x-y)\cdot s(x)dxdy &= -2\int \int p(y)g(x-y)\nabla \log g(x-y)\cdot s(x)dydx\\
&= -2\mathbb{E}[\nabla \log g(\varepsilon)\cdot s(X + \varepsilon)].
\end{align}
But then, upon adding and subtracting the term $\mathbb{E}[|\nabla \log g(\varepsilon)|^2]$ which does not depend on $s$, we get another constant $c'$ such that
$$ \mathbb{E}[\vert \nabla \log p_{\mathrm{noisy}}(X) - s(X)\vert^2] = c' + \mathbb{E}[|\nabla \log g(\varepsilon) - s(X + \varepsilon)|^2].$$
@@ 

### Tweedie's formula 

It turns out that the Denoising Score Matching objective is just an avatar of a deep, not so-well-known result, called Tweedie's formula. Herbert Robbins is often credited with the first discovery of this formula in 1956 in the context of exponential (Poisson) distributions; a paper by Koichi Miyasawa (1961) was later rediscovered, with the first true appearance of the formula; Maurice Tweedie extended it, and Bradley Efron popularized it in [his excellent paper](https://efron.ckirby.su.domains/papers/2011TweediesFormula.pdf) on selection bias. 

@@deep 

**Tweedie's formulas**

Let $X$ be a random variable on $\mathbb{R}^d$ with density $p$, and let $\varepsilon$ be an independent random variable with distribution $N(0, \sigma^2 I_d)$. We note $p_{\sigma}$ the distribution of $Y = X + \varepsilon$. Then,
\begin{align}\label{tweedie-0}
&\nabla \log p_\sigma(y) = - \mathbb{E}\left[\left. \frac{\varepsilon}{\sigma^2} \right| Y\right]\\ 
&\nabla^2 \log p_\sigma(y) = -\frac{I_d}{\sigma^2} + \mathrm{Cov}\left(\left. \frac{\varepsilon}{\sigma^2} \right| Y\right).
\end{align}
These expressions are equivalent to the *noise prediction* formulas, 
\begin{align}\label{tweedie-1}
&\mathbb{E}[\varepsilon \mid Y] = - \sigma^2 \nabla \log p_\sigma(Y)\\
&\mathrm{Cov}(\varepsilon \mid Y) = \sigma^2 I_d + \sigma^4 \nabla^2 \log p_\sigma(Y).
\end{align} 
and to the *data prediction* or *denoising* formulas,
\begin{align}\label{tweedie}
&\mathbb{E}[X \mid Y] = Y + \sigma^2 \nabla \ln p_{\sigma}(Y)\\
&\mathrm{Cov}(X \mid Y) = \sigma^2 I_d + \sigma^4 \nabla^2 \log p_\sigma(Y).
\end{align}

Finally, the optimal denoising error (the Minimum Mean Squared Error) is given by 
\begin{equation}\label{tweedie-2}
\mathbb{E}[|X - \mathbb{E}[X \mid Y]|^2] = \mathrm{Tr}\left(\mathrm{Cov}(X \mid Y)\right) = \sigma^2 d + \sigma^4 \mathrm{Tr}\left(\nabla^2 \log p_\sigma(Y)\right).
\end{equation}

@@

The classical "Tweedie formula" is the first one in \eqref{tweedie}.
@@proof 

**Proof.** We simply compute $\nabla \log p_\sigma$ and $\nabla^2\log p_\sigma$ by differentiating under the integral sign. Indeed, 
$$\nabla \log p_\sigma(y) = \frac{\int \nabla_y \log p(x)g(y-x)dx}{p_\sigma(y)}.$$
Since $\nabla g(z) = -z/\sigma^2 g(z)$, the expression above is equal to 
\begin{equation}\label{p5}-\int \frac{y-x}{\sigma^2} \frac{p(x)g(y-x)}{p_\sigma(y)}dx.\end{equation}
The joint distribution of $(X, Y)$ is $p(x)g(y-x)$ and the conditional density of $X$ given $Y = y$ is 
$p(x|y) = p(x)g(y-x)/p_\sigma(y)$, hence the expression above is equal to $-\mathbb{E}[\varepsilon/\sigma^2 \mid Y]$ as requested. 

Now, by differentiating $\log p_\sigma$ twice, we get 
$$\nabla^2 \log p_\sigma(y) = \frac{\int \nabla^2 p(x)g(y-x)dx}{p_\sigma(y)} - \left(\nabla \log p_\sigma(y)\right)\left(\nabla \log p_\sigma(y)\right)^\top.$$
Since $\nabla^2 g(z) = -(\sigma^{-2}I_d -\sigma^{-4}zz^\top )g(z)$, we get 
$$\nabla^2 \log p_\sigma(y) = -\frac{\int [\sigma^{-2} I_d- \sigma^{-4}(y-x)(y-x)^\top ]  p(x)g(y-x)dx}{p_\sigma(y)} - \mathbb{E}\left[\frac{\varepsilon}{\sigma^2} \mid Y\right]\mathbb{E}\left[\frac{\varepsilon}{\sigma^2} \mid Y\right]^\top.$$
This is exactly $-\sigma^{-2}I_d + \sigma^{-4}\left(\mathbb{E}[\varepsilon\varepsilon^\top \mid Y] - \mathbb{E}[\varepsilon \mid Y]\mathbb{E}[\varepsilon \mid Y]^\top\right)$, or $-\sigma^{-2}I_d + \mathrm{Cov}(\varepsilon / \sigma^2 \mid Y)$.

The noise prediction formulas \eqref{tweedie-1} directly follow from \eqref{tweedie-0}. For the denoising formulas, we only have to note that since $Y = X + \varepsilon$, we have $\mathbb{E}[X \mid Y] = Y - \mathbb{E}[\varepsilon \mid Y]$ and $\mathrm{Cov}(X \mid Y) = \mathrm{Cov}(\varepsilon \mid Y)$.

@@

Since $Y$ is centered around $X$, the classical ("frequentist") estimate for $X$ given $Y$ is $Y$. Tweedie's formula corrects this estimate by adding a term accounting for the fact that $X$ is itself random: if $Y$ lands in a region where $X$ is unlikely to live in, then it is probable that the noise is responsible for this, and the estimate for $X$ needs to be adjusted. 

Now, what's the link between this and Denoising Score Matching ? The conditional expectation of any $X$ given $Z$ minimizes the $L^2$-distance, in the sense that $\mathbb{E}[X \mid Z] = f(Z)$ where $f$ minimizes $\mathbb{E}[|f(Z) - X|^2]$. Formula \eqref{tweedie} says that $\nabla \ln p_{\sigma}(y)$, the quantity we need to estimate, is nothing but the « best denoiser » up to a scaling $-\sigma^2$: 
$$ \nabla \ln p_{\sigma} \in \arg \min \mathbb{E}[|f(X + \varepsilon) - (-\varepsilon/\sigma^2)|^2].$$

I find this result to give some intuition on score matching and how to parametrize the network. 
- If $s(x)$ is « noise predictor » trained with the objective $\mathbb{E}[|s(X+\varepsilon) - \varepsilon|^2]$, then $-s(x)/\sigma^2$ is a proxy for $\nabla \ln p_{\mathrm{noisy}}$. **This is called « noise prediction » training**.  
- If $s(x)$ had rather been trained on a pure denoising objective $\mathbb{E}[|s(X+\varepsilon) - X|^2]$, then $x - s(x)$ is a noise predictor for $X$, hence $\sigma^{-2} (s(x) - x)$ is a proxy for $\nabla \ln p_{\mathrm{noisy}}$. **This is called « data prediction » training**, or simply **denoising training**. 

Both formulations are found in the litterature, as well as affine mixes of both. 


## Back to diffusions


Let us apply this to our setting. Remember that $p_t$ is the density of $\alpha_t X_0 + \varepsilon_t$ where $\varepsilon_t \sim \mathscr{N}(0,\bar{\sigma}_t^2)$, hence in this case $g(x) = (2\pi\bar{\sigma}_t^2)^{-d/2}e^{-|x|^2 / 2\bar{\sigma}_t^2}$ and $\nabla \log g(x) = - x / \bar{\sigma}^2_t$. 

**Data prediction model**

The « data prediction » (or denoising) parametrization of the neural network would minimize the objective 
$$ \int_0^T w(t)\mathbb{E}[|s_{\theta}(t, X_t) - \alpha_t X_0|^2]dt.$$

**Noise prediction model**

Alternatively, the « noise prediction » parametrization of the neural network would minimize the objective 
$$ \int_0^T w(t)\mathbb{E}[|s_{\theta}(t, X_t) -  \varepsilon|^2]dt$$
where I noted $\varepsilon$ instead of $X_1$ to emphasize we're predicting noise. 

Since we have access to samples $(x^i, \varepsilon^i, \tau^i)$ where $\tau \sim w$, we get the empirical version: 
\begin{equation}\label{empirical_loss}\hat{\ell}(\theta) = \frac{1}{n}\sum_{i=1}^n \left[|\varepsilon^i - s_\theta(\alpha_\tau x^i + \bar{\sigma}_\tau \varepsilon^i)|^2\right].\end{equation}
Up to the constants and the choice of the drift $\mu_t$ and variance $w_t$, this is *exactly* the loss function (14) from the [DDPM paper](https://arxiv.org/abs/2006.11239). 
Once this is done, the proxy for $\nabla \ln p_t$ would be 
$$\nabla \ln p_t(x) \approx \frac{x - s_{\theta}(t,x)}{\bar{\sigma}_t^2}.$$
Plugging this back into the SDE (DDPM) sampling formula, we get 
$$ dY_t = \mu_{T-t}Y_t + 2\frac{w^2_{T-t}}{\bar{\sigma}_{T-t}^2}(Y_t - s_{\theta}(T-t,Y_t))dt + \sqrt{2w_{T-t}}dB_t$$
or 
$$ dY_t = \left(\mu_{T-t} + 2\frac{w^2_{T-t}}{\bar{\sigma}_{T-t}^2}\right)Y_t - 2\frac{w^2_{T-t}}{\bar{\sigma}_{T-t}^2}s_{\theta}(T-t,Y_t)dt + \sqrt{2w_{T-t}}dB_t.$$


## Conclusion

We are now equipped with learning $\nabla \ln p_t$ when $p_t$ is the distribution of something like $\alpha_t X_0+\sigma_t \varepsilon$. The diffusion models we presented earlier provide such distributions given the drift and diffusion coefficients, $\mu_t$ and $\sigma_t$. But in general, we should be able to directly choose $\alpha$ and $\sigma$ without relying on the (intricate) maths behind the Fokker-Planck equation. This is where the [flow matching formulation](/posts/flowmatching/) enters the game. 


## References

[Hyvärinen's paper](https://www.jmlr.org/papers/volume6/hyvarinen05a/hyvarinen05a.pdf) on Score Matching. 

[Efron's paper](https://efron.ckirby.su.domains/papers/2011TweediesFormula.pdf) on Tweedie's formula - a gem in statistics. 

I didnt find a free version of Miyazawa's paper, *An empirical Bayes estimator of the mean of a normal population* published in Bull. Inst. Internat. Statist., 38:181–188, 1961.

