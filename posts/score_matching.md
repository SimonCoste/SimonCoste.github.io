+++
titlepost = "Flow models II: Score Matching Techniques"
date = "March 2025"
abstract = "Learning the score of a density from its samples and Tweedie's formula. "
+++

Let $p$ be any smooth probability density function. Its *score* is the gradient of its log-density: $\nabla \log p(x)$. This object is of paramount importance in many fields, like physics, statistics, and machine learning. In particular, it is the key to sample from $p$ using the Langevin dynamics, and we've seen it to be the key when reversing diffusion processes. In this note, we survey the classical technique used for learning the score of a density from its samples: *score matching*.

\tableofcontents

## The Fisher divergence

The L2-distance between the scores of two probability densities is often called the *Fisher divergence*: 
$$ \mathrm{fisher}(\rho_1 \mid \rho_2) = \int \rho_1(x)|\nabla\log\rho_1(x) - \nabla\log\rho_2(x)|^2dx.$$
Since our goal is to learn $\nabla\log p(x)$, it is natural to choose a parametrized family of functions $s_\theta$ and to optimize $\theta$ so that the divergence 
$$\int p(x)|\nabla\log p(x) - s_\theta(x)|^2dx $$
is as small as possible. However, this optimization problem is intractable, due to the presence of the explicit form of $p$ inside the integral. This is where Score Matching techniques come into play. 

## Vanilla score matching

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

### How do we empirically optimize \eqref{opt_theta} in the context of diffusion models? 

In the context of diffusion models, we have a whole family of densities $p_t$ and we want to learn the score for every $t \in [0,T]$. 

1) First, we need not solve this optimization problem for every $t$. We could obviously discretize $[0,T]$ with $t_1, \dots, t_N$ and only solve for $\theta_{t_i}$ independently,  but it is actually smarter and cheaper to approximate the whole function $(t,x) \to \nabla \log p_t(x)$ by a single neural network (a U-net, in general). That is, we use a parametrized family $s_\theta(t,x)$. This enforces a form of time-continuity which seems natural. Now, since we want to aggregate the losses at each time, we solve the following problem: 
\begin{equation}\label{20}\argmin_\theta \int_0^T w(t)\mathbb{E}[|s_{\theta}(t, X_t)|^2 + 2 \nabla \cdot (s_{\theta}(t, X_t))]dt\end{equation} where $w(t)$ is a weighting function (for example, $w(t)$ can be higher for $t\approx 0$, since we don't really care about approximating $p_T$ as precisely as $p_0$). 

1) In the preceding formulation we cannot exactly compute the expectation with respect to $p_t$, but we can approximate it with our samples $x_t^i$. Additionnaly, we need to approximate the integral, for instance we can discretize the time steps with $t_0=0 < t_1 < \dots < t_N = T$. Our objective function becomes
$$ \ell(\theta) =\frac{1}{n}\sum_{t \in \{t_0, \dots, t_N\}} w(t)\sum_{i=1}^n |s_{\theta}(t, x_t^i)|^2 + 2 \nabla\cdot(s_{\theta}(t, x_t^i))$$
which looks computable… except it's not ideal.  Suppose we perform a gradient descent on $\theta$ to find the optimal $\theta$ for time $t$. Then at each gradient descent step, we need to evaluate $s_{\theta}$ as well as its divergence; *and then* compute the gradient in $\theta$ of the divergence in $x$, in other words to compute $\nabla_\theta \nabla_x \cdot s_\theta$. In high dimension, this can be too costly. 

## Noisy samples: denoising score matching and Tweedie's formula 

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

It turns out that the Denoising Score Matching objective is just an avatar of a deep, not so-well-known result, called Tweedie's formula. Herbert Robbins is often credited with the first discovery of this formula in the context of exponential (Poisson) distributions; Maurice Tweedie extended it, and Bradley Efron popularized it in [his excellent paper](https://efron.ckirby.su.domains/papers/2011TweediesFormula.pdf) on selection bias. 

@@deep 

**Tweedie's formula**

Let $X$ be a random variable with density $p$, and let $\varepsilon$ be an independent random variable with distribution $N(0, \sigma^2)$. We still note $p_{\mathrm{noisy}}$ the distribution of $X_{\mathrm{noisy}} = X + \varepsilon$. Then,
\begin{equation}\label{tweedie}
\mathbb{E}[X \mid X_{\mathrm{noisy}}] = X_{\mathrm{noisy}} + \sigma^2 \nabla \ln p_{\mathrm{noisy}}(X_{\mathrm{noisy}}).
\end{equation}
Equivalently, 
\begin{equation}\label{tweedie2}
\mathbb{E}\left[\left. \varepsilon  \right| X_{\mathrm{noisy}}\right] = -\sigma^2 \nabla \ln p_{\mathrm{noisy}}(X_{\mathrm{noisy}}).
\end{equation}
@@

@@proof 

**Proof.** The joint distribution of $(X, X_{\mathrm{noisy}})$ is $p(x)g(z-x)$, hence the conditional expectation of $X$ given $X_{\mathrm{noisy}} = z$ is
$$\frac{\int x p(x)g(z-x)dx}{q(z)} = z -  \frac{\int  (z-x)g(z-x)p(x)dx}{p_{\mathrm{noisy}}(z)}.$$
Note that $p_{\mathrm{noisy}}(z) = \int p(x)g(z-x)dx$. 
Now, since $g$ is the density of $N(0,\sigma^2 I_d)$, we have $\nabla g(x) = -x/\sigma^2 g(x)$, and the term above is equal to
$$z +\sigma^2  \frac{\int  \nabla_z g(z-x)p(x)dx}{p_{\mathrm{noisy}}(z)} = z + \sigma^2 \nabla_z \ln \int g(z-x)p(x)dx$$
which is the desired result. For the second formula, just note that $X_{\mathrm{noisy}} = \mathbb{E}[X_{\mathrm{noisy}}|X_{\mathrm{noisy}}] = \mathbb{E}[X \mid X_{\mathrm{noisy}}] + \mathbb{E}[\varepsilon \mid X_{\mathrm{noisy}}]$ then simplify.
@@

Since $X_{\mathrm{noisy}}$ is centered around $X$, the classical ("frequentist") estimate for $X$ given $X_{\mathrm{noisy}}$ is $X_{\mathrm{noisy}}$. Tweedie's formula corrects this estimate by adding a term accounting for the fact that $X$ is itself random: for instance, if $X_{\mathrm{noisy}}$ lands in a region where $X$ is extremely unlikely to live in, then it is probable that the noise is responsible for this, and the estimate for $X$.  

Now, what's the link between this and Denoising Score Matching ? Well, the conditional expectation of any $X$ given $Z$ minimizes the $L^2$-distance, in the sense that $\mathbb{E}[X \mid Z] = f(Z)$ where $f$ minimizes $\mathbb{E}[|f(Z) - X|^2]$. Formula \eqref{tweedie2} says that $\nabla \ln p_{\mathrm{noisy}}$, the quantity we need to estimate, is nothing but the « best denoiser » up to a scaling $-\sigma^2$: 
$$ \nabla \ln p_{\mathrm{noisy}} \in \arg \min \mathbb{E}[|f(X + \varepsilon) - (-\varepsilon/\sigma^2)|^2].$$
Replacing $f$ with a neural network, we exactly find the Denoising Score Matching objective in \eqref{dsm}.

I find this result to give some intuition on score matching and how to parametrize the network. 
- If $s(x)$ is « noise predictor » trained with the objective $\mathbb{E}[|s(X+\varepsilon) - \varepsilon|^2]$, then $-s(x)/\sigma^2$ is a proxy for $\nabla \ln p_{\mathrm{noisy}}$. **This is called « noise prediction » training**.  
- If $s(x)$ had rather been trained on a pure denoising objective $\mathbb{E}[|s(X+\varepsilon) - X|^2]$, then $x - s(x)$ is a noise predictor for $X$, hence $\sigma^{-2} (s(x) - x)$ is a proxy for $\nabla \ln p_{\mathrm{noisy}}$. **This is called « data prediction » training**, or simply **denoising training**. 

Both formulations are found in the litterature, as well as affine mixes of both. 


## Back to diffusions


Let us apply this to our setting. Remember that $p_t$ is the density of $e^{-\nu_t}X_0 + \varepsilon_t$ where $\varepsilon_t \sim \mathscr{N}(0,\bar{\sigma}_t^2)$, hence in this case $g(x) = (2\pi\bar{\sigma}_t^2)^{-d/2}e^{-|x|^2 / 2\bar{\sigma}_t^2}$ and $\nabla \log g(x) = - x / \bar{\sigma}^2_t$. The « pure denoising » parametrization of the neural network would minimize the objective 
$$ \int_0^T w(t)\mathbb{E}[|s_{\theta}(t, X_t) - e^{-\nu_t} X_0|^2]dt.$$
Once this is done, the proxy for $\nabla \ln p_t$ would be 
$$\nabla \ln p_t(x) \approx \frac{x - s_{\theta}(t,x)}{\bar{\sigma}_t^2}.$$
Plugging this back into the SDE (DDPM) sampling formula, we get 
$$ dY_t = \alpha_{T-t}Y_t + 2\frac{\sigma^2_{T-t}}{\bar{\sigma}_{T-t}^2}(Y_t - s_{\theta}(T-t,Y_t))dt + \sqrt{2\sigma_{T-t}}dB_t$$
or 
$$ dY_t = \left(\alpha_{T-t} + 2\frac{\sigma^2_{T-t}}{\bar{\sigma}_{T-t}^2}\right)Y_t - 2\frac{\sigma^2_{T-t}}{\bar{\sigma}_{T-t}^2}s_{\theta}(T-t,Y_t)dt + \sqrt{2\sigma_{T-t}}dB_t.$$



## References

[Hyvärinen's paper](https://www.jmlr.org/papers/volume6/hyvarinen05a/hyvarinen05a.pdf) on Score Matching. 

[Efron's paper](https://efron.ckirby.su.domains/papers/2011TweediesFormula.pdf) on Tweedie's formula - a gem in statistics. 

