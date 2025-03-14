+++
titlepost = "Flow models II: Score Matching Techniques"
date = "March 2025"
abstract = "Old-school methods for learning the score of a density from its samples. "
+++

Let $p$ be any smooth probability density function. Its *score* is the gradient of its log-density: $\nabla \log p(x)$. This object is of paramount importance in many fields, like physics, statistics, and machine learning. In particular, it is the key to sample from $p$ using the Langevin dynamics, and we've seen it to be the key when reversing diffusion processes. In this note, we survey the classical technique used for learning the score of a density from its samples: *score matching*.

## The Fisher divergence

The L2-distance between the scores of two probability densities is often called the *Fisher divergence*: 
$$ \mathrm{fisher}(\rho_1 \mid \rho_2) = \int \rho_1(x)|\nabla\log\rho_1(x) - \nabla\log\rho_2(x)|^2dx.$$
Since our goal is to learn $\nabla\log p(x)$, it is natural to choose a parametrized family of functions $s_\theta$ and to optimize $\theta$ so that the divergence 
$$\int p(x)|\nabla\log p(x) - s_\theta(x)|^2dx $$
is as small as possible. However, this optimization problem is intractable, due to the presence of the explicit form of $p$ inside the integral. This is where Score Matching techniques come into play. 

### Vanilla score matching

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

Practically, learning the score of a density $p$ from samples $x^1, \dots, x^n$ is done by minimizing the empirical version of the right-hand side of \eqref{SM}:
\begin{equation}\label{opt_theta} \theta \in \argmin_\theta \mathbb{E}[\vert \nabla \log p(X) - s_{\theta}(X)\vert^2] = \argmin_\theta \mathbb{E}[|s_{\theta}(X)|^2 + 2 \nabla \cdot (s_{\theta}(X))].\end{equation}
When one has access to samples $x^i$, a proxy of this loss is given by its empirical version:
$$ \ell(\theta) = \frac{1}{n}\sum_{i=1}^n |s_{\theta}(x^i)|^2 + 2 \nabla \cdot (s_{\theta}(x^i)).$$

### How do we empirically optimize \eqref{opt_theta} in the context of diffusion models? 

In the context of diffusion models, we have a whole family of densities $p_t$ and we want to learn the score for every $t \in [0,T]$. 

1) First, we need not solve this optimization problem for every $t$. We could obviously discretize $[0,T]$ with $t_1, \dots, t_N$ and only solve for $\theta_{t_i}$ independently,  but it is actually smarter and cheaper to approximate the whole function $(t,x) \to \nabla \log p_t(x)$ by a single neural network (a U-net, in general). That is, we use a parametrized family $s_\theta(t,x)$. This enforces a form of time-continuity which seems natural. Now, since we want to aggregate the losses at each time, we solve the following problem: 
\begin{equation}\label{20}\argmin_\theta \int_0^T w(t)\mathbb{E}[|s_{\theta}(t, X_t)|^2 + 2 \nabla \cdot (s_{\theta}(t, X_t))]dt\end{equation} where $w(t)$ is a weighting function (for example, $w(t)$ can be higher for $t\approx 0$, since we don't really care about approximating $p_T$ as precisely as $p_0$). 

1) In the preceding formulation we cannot exactly compute the expectation with respect to $p_t$, but we can approximate it with our samples $x_t^i$. Additionnaly, we need to approximate the integral, for instance we can discretize the time steps with $t_0=0 < t_1 < \dots < t_N = T$. Our objective function becomes
$$ \ell(\theta) =\frac{1}{n}\sum_{t \in \{t_0, \dots, t_N\}} w(t)\sum_{i=1}^n |s_{\theta}(t, x_t^i)|^2 + 2 \nabla\cdot(s_{\theta}(t, x_t^i))$$
which looks computable… except it's not ideal.  Suppose we perform a gradient descent on $\theta$ to find the optimal $\theta$ for time $t$. Then at each gradient descent step, we need to evaluate $s_{\theta}$ as well as its divergence; *and then* compute the gradient in $\theta$ of the divergence in $x$, in other words to compute $\nabla_\theta \nabla_x \cdot s_\theta$. In high dimension, this can be too costly. 

### Denoising Score Matching

Fortunately, there is another way to perform score matching when $p_t$ is the distribution of a random variable with gaussian noise added, as in our setting. We'll present this result in a fairly abstract setting; we suppose that $p$ is a density function, and $q = p*g$ where $g$ is an other density. The following result is due to [Vincent, 2010](https://www.iro.umontreal.ca/~vincentp/Publications/smdae_techreport.pdf). 



@@important
**Denoising Score Matching Objective**

Let $s:\mathbb{R}^d \to \mathbb{R}^d$ be a smooth function. Let $X$ be a random variable with density $p$, $\varepsilon$ an independent random variable with density $g$, and $X_\varepsilon = X + \varepsilon$, whose density is $p_g = p * g$. Then, 
\begin{equation}\label{dsm}
\mathbb{E}[\vert \nabla \log p_g(X_\varepsilon) - s(X_\varepsilon)\vert^2] = c + \mathbb{E}[|\nabla \log g(\varepsilon) - s(X_\varepsilon)|^2]
\end{equation}
where $c$ is a constant not depending on $s$. 
@@

@@proof
**Proof.** By the same computation as for vanilla score matching, we have 
$$ \mathbb{E}[\vert \nabla \log p_g(X_\varepsilon) - s(X_\varepsilon)\vert^2] = c + \int p_g(x)|s(x)|^2dx -2\int \nabla p_g(x)\cdot s(x)dx.$$
Now by definition, $p_g(x) = \int p(y)g(x-y)dy$, hence $\nabla p_g(x) = \int p(y)\nabla g(x-y)dy$, and the last term above is equal to 
\begin{align} -2\int \int p(y)\nabla g(x-y)\cdot s(x)dxdy &= -2\int \int p(y)g(x-y)\nabla \log g(x-y)\cdot s(x)dydx\\
&= -2\mathbb{E}[\nabla \log g(\varepsilon)\cdot s(X + \varepsilon)].
\end{align}
This last term is equal to $-2\mathbb{E}[\nabla \log g(\varepsilon)\cdot s(X_\varepsilon)]$. But then, upon adding and subtracting the term $\mathbb{E}[|\nabla \log g(\varepsilon)|^2]$ which does not depend on $s$, we get another constant $c'$ such that
$$ \mathbb{E}[\vert \nabla \log p_g(X) - s(X)\vert^2] = c' + \mathbb{E}[|\nabla \log g(\varepsilon) - s(X + \varepsilon)|^2].$$
@@ 


Now, this Denoising Score Matching loss does not involve any computation of a « double gradient » like $\nabla_\theta \nabla_x \cdot s_\theta$. 

Let us apply this to our setting. Remember that $p_t$ is the density of $e^{-\mu_t}X_0 + \varepsilon_t$ where $\varepsilon_t \sim \mathscr{N}(0,\bar{\sigma}_t^2)$, hence in this case $g(x) = (2\pi\bar{\sigma}_t^2)^{-d/2}e^{-|x|^2 / 2\bar{\sigma}_t^2}$ and $\nabla \log g(x) = - x / \bar{\sigma}^2_t$. The objective in \eqref{20} becomes
$$ \argmin_\theta \int_0^T w(t)\mathbb{E}\left[\left|-\frac{\varepsilon_t}{\bar{\sigma}_t^2} - s_\theta(t, e^{-\mu_t}X_0 + \varepsilon_t) \right|^2\right]dt.$$
This can be further simplified. Indeed, let us slightly change the parametrization and use $r_\theta(t,x) = -\bar{\sigma}_t s_\theta(t,x)$. Then,  
$$ \argmin_\theta \int_0^T \frac{w(t)}{\bar{\sigma}_t}\mathbb{E}\left[\left|\xi - r_\theta(t, e^{-\mu_t}X_0 + \bar{\sigma}_t \xi) \right|^2\right]dt.$$
Intuitively, the neural network $r_\theta$ tries to guess the scaled noise $\xi$ from the observation of $X_t$. 

