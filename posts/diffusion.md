+++
titlepost = "Flow models I: Diffusion models"
date = "March 2023"
abstract = "Add noise to stuff, then remove it. "
+++


These series of notes focus on diffusion-based generative models, like the celebrated Denoising Diffusion Probabilistic Models; they contain the material I regularly present as lectures in some working groups for mathematicians or math graduate students, so the style is tailored for this audience. In particular, everything is fitted into the continuous-time framework (which is not exactly how it is done in practice). 

A special attention is given to the differences between ODE sampling and SDE sampling. The analysis of the time evolution of the densities $p_t$ is done using only Fokker-Planck Equations or Transport Equations.  

\tableofcontents

## The problem 

Let $p$ be a probability density on $\mathbb{R}^d$. The goal of generative modelling is twofold: given samples $x^1, \dotsc, x^n$ from $p$, we want to estimate $p$ and generate new samples from $p$. 

Many methods were designed for tackling these challenges: Energy-Based Models, Normalizing Flows and the famous Neural ODEs, vanilla Score-Matching, GANs. Each has its limitations: for example, EBMs are challenging to train, NFs lack expressivity and SM fails to capture multimodal distributions. Diffusion models, and their successors flow-based models, offer sufficient flexibility to partially overcome these limitations. Their ability to be guided towards conditional generations using Classifier-Free Guidance is also a major advantage, and will be reviewed in the [third note](/posts/guidance) of the series.


### Stochastic interpolation

Diffusion models fall into the framework of [stochastic interpolants](https://arxiv.org/abs/2303.08797). The idea is to continuously transform the density $p$ into another easy-to-sample density $\pi$ (often called *the target*), while also transforming the samples $x^i$ from $p$ into samples from $\pi$; and then, to reverse the process: that is, to generate a sample from $\pi$, and to inverse the transformation to get a new sample from $p$. In other words, we seek a path $(p_t: t\in [0,T])$ with $p_0=p$ and $p_T=q$, such that generating samples $x_t \sim p_t$ is doable. 

The success of *diffusion models* came from the realization that some stochastic processes, such as Ornstein-Uhlenbeck processes that connect $p_0$ with a distribution $p_T$ very close to pure noise $\mathscr{N}(0,I)$, can be reversed when the *score function* $\nabla \log p_t$ is available at each time $t$. Although unknown, this score can efficiently be learnt using statistical procedures called *score matching*. 


## Original formulation: Gaussian noising process and its inversion

### Time-Reversal of diffusions

Let $(t,x)\to f_t(x)$ and $t\to \sigma_t$ be two smooth functions. Consider the stochastic differential equation
\begin{align}\label{SDE}& dX_t = f_t(X_t)dt + \sqrt{2\sigma_t ^2}dB_t, \\ & X_0 \sim p\end{align}
where $dB_t$ denotes integration with respect to a Brownian motion. Under mild conditions on $f$, an almost-surely continuous stochastic process satisfying this SDE exists. Let $p_t$ be the probability density of $X_t$; it is a non-trivial fact that this process [can be reversed in time](https://www.sciencedirect.com/science/article/pii/0304414982900515). More precisely, the following SDE is exactly the time-reversal of \eqref{SDE}:
\begin{align}\label{bsde} & dY_t = -\left(  f_t(Y_t)+ 2\sigma_t^2 \nabla \log p_t(Y_t) \right)dt + \sqrt{2\sigma_t^2}dB_t \\ & Y_T \sim p_T.
\end{align}

@@deep 

**Theorem (Anderson, 1982)**. The law of the stochastic process $(Y_t)_{t \in [0,T]}$ is the same as the law of $(X_{T-t})_{t \in [0,T]}$. 

@@ 

While this theorem is not easy to prove, we will later check using the Fokker-Planck equation that the *marginals* $p_{T-t}$ of the process $X_{T-t}$ are indeed the same as the marginals $q_{T-t}$ of the process $Y_t$.


![](/posts/img/score_based_dog.png)



Sampling paths from the reverse SDE \eqref{bsde} needs access to $\nabla \log p_t$. The key point of diffusion-like methods is that this quantity can be estimated.

### Working out the Ornstein-Uhlenbeck process


For simple functions $f$, the process \eqref{SDE} has an explicit representation.  Here we focus on the case where $f_t(x) = -\alpha_t x$ for some function $\alpha$, that is
\begin{equation}\label{ou}
dX_t = -\mu_t X_t + \sqrt{2w_t^2}dB_t.
\end{equation}
@@important
Define $\alpha_t = e^{-A_t}$ where $A_t =\int_0^t \mu_s ds$. Then, the solution of \eqref{ou} is given by the following stochastic process: 
\begin{equation}\label{sde_sol} X_t  = \alpha_t X_0 + \sqrt{2}\int_0^t e^{A_s-A_t} w_s dB_s.\end{equation}
In particular, noting $$\bar{\sigma}_t^2 = 2\int_0^t e^{-2\int_s^t \mu_u du}w_s^2 ds$$ we have 
$$ X_t \stackrel{\mathrm{law}}{=} \alpha_t X_0 + \bar{\sigma}_t \varepsilon$$
where $\varepsilon \sim \mathscr{N}(0,1)$.
@@

In the pure Orstein-Uhlenbeck case where $w_t = w$ and $\mu_t = 1$, we get $\alpha_t = e^{-t}$ and $X_t = e^{-t}X_0 + \mathscr{N}(0,1 - e^{-2t})$. 

@@proof 
**Proof of \eqref{sde_sol}.** We set $F(x,t) = xe^{A_t}$ and $Y_t = F(X_t, t) = X_t e^{A_t}$; it turns out that $Y_t$ satisfies a nicer SDE. Since $\Delta_x f = 0$, $\partial_t f(x,t) = xe^{A_t}\mu_t$ and $\nabla_x f(x,t) = e^{A_t}$, [Itô's formula](https://en.wikipedia.org/wiki/It%C3%B4%27s_lemma) says that 
\begin{align}dY_t &= \partial_tF(t,X_t)dt + \nabla_x F(t,X_t)dX_t + \frac{2w_t^2}{2}\Delta_x F(t,X_t)dt \\
&= X_te^{A_t}\mu_tdt + e^{A_t} dX_t \\
&= \sqrt{2w_t^2 e^{2A_t}}dB_t.
\end{align}
Consequently, $Y_t = Y_0 + \int_0^t \sqrt{2w_s^2e^{2A_s}}dB_s$ and the result holds when we multiply everything by $e^{-A_t}$.

The second term in \eqref{sde_sol} reduces to a Wiener Integral; it is a centered Gaussian with variance $2\int_0^t e^{2(A_s-A_t)}w_s^2 ds$, hence 
\begin{equation}\label{pt} X_t \stackrel{\mathrm{law}}{=} e^{-A_t}X_0 + \mathscr{N}\left(0, 2\int_0^t e^{2A_s - 2A_t}w_s^2 ds\right).\end{equation}
@@ 



A consequence of the preceding result is that when the variance $\bar{\sigma}_t^2$ is big compared to $\alpha_t$, then the distribution of $X_t$ is well-approximated by $\mathscr{N}(0,\bar{\sigma}_t^2)$. Indeed, for $\mu_t = w_t = 1$, we have $\alpha_T = e^{-T}$ and $\bar{\sigma}_T = \sqrt{1 - e^{-2T}} \approx 1$ if $T$ is sufficiently large, like $T>10$.

### The Fokker-Planck point of view

It has recently been recognized that the Ornstein-Uhlenbeck representation of $p_t$ as in \eqref{SDE}, as well as the stochastic process \eqref{BSDE} that has the same marginals as $p_t$, are not necessarily unique or special. Instead, what matters are two key features: (i) $p_t$ provides a path connecting $p$ and $p_T\approx N(0,I)$, and (ii) its marginals are easy to sample. There are other processes besides \eqref{SDE} that have $p_t$ as their marginals, and that can also be reversed. The crucial point is that $p_t$ is a solution of the [Fokker-Planck equation](https://en.wikipedia.org/wiki/Fokker%E2%80%93Planck_equation): 
@@important
\begin{equation}\label{FP} \partial_t p_t(x) = \Delta (w_t^2 p_t(x)) - \nabla \cdot (f_t(x)p_t(x)).\end{equation}
@@

Just to settle the notations once and for all: $\nabla$ is the gradient, and for a function $\rho : \mathbb{R}^d \to \mathbb{R}^d$, $\nabla \cdot \rho(x)$ stands for the divergence, that is $\sum_{i=1}^d \partial_{x_i} \rho(x_1, \dotsc, x_d)$, and $\nabla \cdot \nabla = \Delta = \sum_{i=1}^d \partial^2_{x_i}$ is the Laplacian.  


@@proof 

**Proof (informal).** For a compactly supported smooth test function $\varphi$, we have $\partial_t \mathbb{E}[\varphi(X_t)] = \int \varphi(x)\partial_t p_t(x)dx$. On the other hand, this quantity is also equal to $\mathbb{E}[d\varphi(X_t)]$. Itô's formula says that $d\varphi(X_t) = \nabla \varphi(X_t) \cdot dX_t + \frac{1}{2}\Delta \varphi(X_t)dt$, which is also equal to $\nabla \varphi(X_t)f_t(X_t) + M_t + \frac{1}{2}\Delta \varphi(X_t)dt$, where $M_t$ is a Brownian martingale started at 0, whose exapectation is thus 0. Gathering everything, we see that $\mathbb{E}[d\varphi(X_t)]$ is also equal to $\mathbb{E}[\nabla \varphi(X_t) \cdot f_t(X_t)dt + \frac{1}{2}\Delta \varphi(X_t)dt]$, that is
$$ \int \nabla\varphi(x)\cdot f_t(x) p_t(x)dx + \frac{1}{2}\int\Delta \varphi(x)w_t^2 p_t(x) dx.$$
One integration by parts on the first integral, and two on the second, lead to the expression
$$ \int \varphi(x) \left[-\nabla \cdot (p_t(x)f_t(x)) + \frac{w_t^2}{2}\Delta p_t(x)\right]dx. $$
Comparing this with the first expression for $\partial_t \mathbb{E}[\varphi(X_t)]$ gives the result.
@@ 


Importantly, equation \eqref{FP} can be recast as a transport equation: with a **velocity field** defined as $$v_t(x) = w_t^2 \nabla \log p_t(x) - f_t(x),$$ the equation \eqref{FP} is equivalent to
@@important
\begin{equation}\label{TE} \partial_t p_t(x) = \nabla \cdot (v_t(x)p_t(x)).\end{equation}
@@ 

@@proof 
**Proof.** $\nabla \cdot v_t(x)p_t(x) = \nabla\cdot (w_t^2\nabla \log p_t(x))p_t(x) - \nabla\cdot f_t(x)p_t(x)= w_t^2 \nabla\cdot \nabla p_t(x) - \nabla\cdot f_t(x)p_t(x)$, and since $\nabla\cdot\nabla = \Delta$, this is equal to $w_t^2 \Delta p_t(x) - \nabla \cdot f_t(x)p_t(x) = \partial_t p_t(x). $
@@

### An associated ODE 

Equations like \eqref{TE} are called *transport equations* or *continuity equations*. They come from simple ODEs; that is, there is a *deterministic* process with the same marginals as \eqref{SDE}. 
@@important
Let $x(t)$ be the solution of the differential equation with random initial condition
\begin{equation}\label{ode}x'(t) = -v_t(x(t))\qquad \qquad x(0) =X_0.\end{equation}
Then the probability density of $x(t)$ satisfies \eqref{TE}, hence it is equal to $p_t$. 
@@


@@proof
**Proof.** Let $p_t$ be the probability density of $x(t)$ and let $\varphi$ be any smooth, compactly supported test function. Then, $\mathbb{E}[\varphi(x(t))] = \int p_t(x)\varphi(x)dx$, so by derivation under the integral, 
\begin{align}\int \partial_t p_t(x)\varphi(x)dx = \partial_t \mathbb{E}[\varphi(x(t))]&= \mathbb{E}[\nabla\varphi(x(t))x'(t)]\\
&= -\int \nabla \varphi(x)v_t(x)p_t(x)dx = \int \varphi(x) \nabla \cdot (v_t(x)p_t(x))dx
\end{align}
where the last line uses the multidimensional integration by parts formula. 
@@ 

Up to now, we proved that there are two continuous random processes having the same marginal probability density at time $t$: a smooth one provided by $x(t)$, the solution of the ODE, and a continuous but not differentiable one, $X_t$, provided by the solution of the SDE. 

![](/posts/img/diff.svg)

### Time-reversal of Transport Equations and Fokker-Planck equations

\newcommand{\pbt}{p^{\mathrm{b}}_t}
\newcommand{\vbt}{v^{\mathrm{b}}_t}
\newcommand{\wbt}{w^{\mathrm{b}}_t}


We now have various processes $x(t), X_t$ starting at a density $p_0$ and evolving towards a density $p_T \approx \pi = \mathscr{N}(0,I)$. Can these processes be reversed in time? The answer is *yes* for both of them. We'll start by reversing their associated equations. From now on, we will note $p^{\mathrm{b}}_t$ the time-reversal of $p_t$, that is: $$p^{\mathrm{b}}_t(x) = p_{T-t}(x).$$ 

@@important
The density $\pbt$ solves the *backward* Transport Equation: 
\begin{equation}\label{BTE}\partial \pbt(x)= \nabla \cdot \vbt(x) \pbt(x) \end{equation}
where $$\vbt(x) = -v_t(x) = -w_{T-t}^2 \nabla \log p_t(x) - \mu_{T-t} x.$$
@@ 
@@important
The density $\pbt$ also solves the *backward* Fokker-Planck Equation: 
\begin{equation}\label{BFP}\partial \pbt(x) =w_{T-t}^2 \Delta \pbt(x) - \nabla \cdot u_t^{\mathrm{b}}(x)\pbt(x)\end{equation}
where $$u^{\mathrm{b}}_t(x) = 2w_{T-t}^2 \nabla \log \pbt(x) + \mu_{T-t} x.$$ 
@@ 

@@proof
**Proof.** Noting $\dot{p}_t(x)$ the time derivative of $t\mapsto p_t(x)$ at time $t$, we immediately see that $\partial_t \pbt(x) = -\dot{p}_{T-t}(x)$ and the rest is a mere verification. 
@@

Of course, these two equations are the same, but they represent the time-evolution of the density of two different random processes. As explained before, the Transport version \eqref{BTE} represents the time-evolution of the density of the ODE system 
\begin{align}\label{BODE}& y'(t) = -\vbt(y(t)) \\ & y(0) \sim p_T\end{align} 
while the Fokker-Planck version \eqref{BFP} represents the time-evolution of the SDE system
\begin{align}\label{BSDE2}&dY_t = u^{\mathrm{b}}_t(Y_t)dt + \sqrt{2w_{T-t}^2}dB_t \\ & Y_0 \sim p_T.\end{align}

Both of these two processes can be sampled using a range of ODE and SDE solvers, the simplest of which being the Euler scheme and the Euler-Maruyama scheme. However, this requires access to the functions $\vbt$ and $\wbt$, which in turn depend on the unknown score $\nabla \log p_t$. Fortunately, $\nabla \log p_t$ can efficiently be *estimated* due to two factors. 

1) **First: we have samples from $p_t$**. Remember that our only information about $p$ is a collection $x^1, \dotsc, x^n$ of samples. Thanks to the representation \eqref{pt}, we can represent $x^i_t = \alpha_t x^i + \bar{\sigma}_t \xi^i$ with $\xi^i \sim \mathscr{N}(0,I)$ are samples from $p_t$. They are extremely easy to access, since we only need to generate iid standard Gaussian variables $\xi^i$. 

2) **Second: score matching.** If $p$ is a probability density and $x^i$ are samples from $p$, estimating $\nabla \log p$ (called *score*) has been thoroughly examined and is fairly doable, a technique known as *score matching*. 


## Methods for learning the score

Learning the *score* $\nabla_x \ln p(x)$ of a probability density $p$ is a well-known problem in statistics, and is somehow orthogonal to the world of generative flow models. I gathered the main ideas in [the next note on flow matching and Tweedie-s formula](/posts/score_matching). In short, it turns out that training a neural network $s(t,x)$ to *denoise* $X_t$ (that is, to remove the added noise $\varepsilon_t$, where $X_t = \alpha_t X_0 + \varepsilon_t$) with the loss $\mathbb{E}[|s(t,X_t) - \varepsilon_t|^2]$ directly leads to an estimator of the score, 
$$\nabla \ln p_t(x) \approx -\frac{s(t,x)}{\bar{\sigma}_t^2}.$$

## Generative models: training and sampling

Let us wrap everything up in this section. 

### Training: learning the score

@@important
**The Denoising Diffusion Score Matching loss**

Let $\tau$ be a random time on $[0,T]$ with density proportional to $w(t)$; let $\xi$ be a standard Gaussian random variable. The **denoising diffusion** theoretical objective is
\begin{equation}
\ell(\theta) =  \mathbb{E}\left[\frac{1}{\bar{\sigma}_\tau}\left|\xi - s_\theta(\tau, \alpha_\tau X_0 + \bar{\sigma}_\tau \xi )\right|^2\right].
\end{equation}
@@

Since we have access to samples $(x^i, \xi^i, \tau^i)$ (at the cost of generating iid samples $\xi^i$ from a standard Gaussian and $\tau^i$ uniform over $[0,T]$), we get the empirical version: 
\begin{equation}\label{empirical_loss}\hat{\ell}(\theta) = \frac{1}{n}\sum_{i=1}^n \left[\frac{1}{\bar{\sigma}_\tau}|\xi^i - s_\theta(\alpha_\tau x^i + \bar{\sigma}_\tau \xi^i)|^2\right].\end{equation}
Up to the constants and the choice of the drift $\mu_t$ and variance $w_t$, this is *exactly* the loss function (14) from the [DDPM paper](https://arxiv.org/abs/2006.11239). 

### Choice of architecture

In practice, for image generations, the go-to choice for the architecture of $s_\theta$ was first chosen to be a [U-net](https://twitter.com/marc_lelarge/status/1632708387589832705), a special kind of convolutional neural networks with a downsampling phase, an upsampling phase, and skip-connections in between. After 2023 it seemed that everyone switched to pure-transformers models, following the landmark [DiT paper](https://arxiv.org/abs/2212.09748) from Peebles and Xie. 


### Sampling


Once the algorithm has converged to $\theta$, we get $s_\theta(t,x)$ which is a proxy for $\nabla \log p_t(x)$ (we absorbed the constant $\bar{\sigma}_t^2$ into the definition of $s$). Now, we simply plug this expression in the functions $\vbt$ if we want to solve the ODE \eqref{BODE} or $\wbt$ if we want to solve the SDE \eqref{BSDE2}. 

\newcommand{\hbt}{\hat{v}^{\mathrm{b}}_t}
\newcommand{\hwbt}{\hat{u}^{\mathrm{b}}_t}


- The **ODE sampler (DDIM)** solves $ y'(t) = -\hbt(y(t))$ started at $y(0) \sim \mathscr{N}(0,I)$, 
where $\hbt(x) = -w_{T-t}^2 s_\theta(T-t,x) - \mu_{T-t} x$. 
- The **SDE sampler (DDPM)** solves $dY_t = \hwbt(Y_t)dt + \sqrt{2w_t^2}dB_t$ started at $Y_0 \sim \mathscr{N}(0,I)$, where $\hwbt(x) = 2w_{T-t}^2 s_\theta(T-t,x) + \mu_{T-t} x$. 


\newcommand{\qo}{q^{\mathrm{ode}}_t}
\newcommand{\qs}{q^{\mathrm{sde}}_t}
We must stress a subtle fact. Equations \eqref{FP} and \eqref{TE}, or their backward counterparts, are exactly the same equation accounting for $p_t$. But since now we replaced $\nabla \log p_t$ by its *approximation* $s_\theta$, this is no longer the case for our two samplers: their probability densities are not the same. In fact, let us note $\qo,\qs$ the densities of $y(t)$ and $Y_{t}$; the first one solves a Transport Equation, the second one a Fokker-Planck equation, and these two equations are different. 
@@important 
**Backward Equations for the samplers**
\begin{equation}\label{TE-a}\partial_t \qo(x) = \nabla \cdot \hbt(x)\qo(x)\qquad \qquad q_0^{\mathrm{ode}} = \pi \end{equation}
\begin{equation}\label{FP-a}\partial_t \qs(x) = \nabla \cdot [w_{T-t}^2\nabla \log \qs(x) - \hwbt(x)]\qs(x) \qquad \qquad q_0^{\mathrm{sde}} = \pi \end{equation}
@@
Importantly, the velocity $w_{T-t}^2\nabla \log \qs(x) - \hwbt(x)$ is in general *not equal* to the velocity $\hbt(x)$. They would be equal only in the case $s_\theta(t,x) = \nabla \log p_t(x)$. 
@@proof 
**Proof.** Since $y(t)$ is an ODE, it directly satisfies the transport equation with velocity $\hbt$. Since $Y_t$ is an SDE, it satisfies the Fokker-Planck equation associated with the drift $\hwbt$, which in turn can be transformed in the transport equation shown above. 
@@ 

## Design choices for $\mu_t$ and $w_t$

We recall that the SDE equation is given by 
$$ dX_t = -\mu_t X_t dt + \sqrt{2w_t^2}dB_t.$$
We showed that the solution of this equation at time $t$ has the same distribution as $\alpha_t X_t + \bar{\sigma}_t \varepsilon$ where $\varepsilon \sim \mathscr{N}(0,1)$. Here, the $\alpha_t, \bar{\sigma}_t$ are related to $\mu_t, w_t$ by 
$$ \alpha_t = \exp\left\lbrace -\int_0^t \mu_s ds \right\rbrace$$
$$\bar{\sigma}_t^2 = 2\int_0^t e^{-2\int_s^t \mu_u du}w_s^2 ds. $$
Considerable work has been done (mostly experimentally) to find good functions $\mu_t,w_t$. Some choices seem to stand out. 

### Variance Exploding path

The VE path takes $\mu_t = 0$ (that is, no drift) and $w_t$ a continuous, increasing function over $[0,1)$, such that $\sigma_0 = 0$ and $\sigma_1 = +\infty$; typically, $w_t = (1-t)^{-1}$. This gives parameters 
$$\alpha_t = 1, \qquad \bar{\sigma}_t^2 = 2\int_0^t w_s^2 ds = 2\int_0^t (1-s)^{-2}ds = 2\frac{t}{1-t}.$$



### Variance-Preserving path

The VP takes $w_t = \sqrt{\mu_t}$. In this case we see that in this case, $\alpha_t = e^{-\int_0^t \mu_s ds}$ and 
$$ \bar{\sigma}_t^2 = 2\int_0^t e^{-2\int_s^t \mu_u du}\mu_s ds = 1 - e^{-2\int_0^t \mu_s ds}.$$
The name « variance preserving » comes from the fact that the element-wise variance of $X_t = \alpha_t X_0 + \bar{\sigma}_t \varepsilon$ is exactly $\alpha_t^2 + \bar{\sigma}_t^2$, which in this case is equal to 1 (we supposed without loss of generality that $X_0$ had been standardized to have element-wise variance 1). 


### The **pure Ornstein-Uhlenbeck** path 

The OU path takes $w_t = \mu_t = 1$, so that in this case we've already seen that
$$ \alpha_t = e^{-t}, \qquad \bar{\sigma}_t^2 = 1 - e^{-2t}.$$
This is not used in practice and is more for theoretical purposes. 


### Toward Flow Matching

The design choice for a diffusion reduces to the drift and diffusion coefficients $\mu_t, w_t$. These choices restrict the actual variances $\alpha_t, \bar{\sigma}_t$. But there might be a way **to directly choose $\alpha_t, \bar{\sigma}_t$** and specify paths having distribution $\alpha_t X_0 + \bar{\sigma}_t \varepsilon$. Typically, we would like to choose 
$$ \alpha_t = \cos(\pi t / 2), \qquad \bar{\sigma}_t^2 = \sin(\pi t /2).$$
Of course we could find $\mu_t, w_t$ to solve these equations, but this is weird. 
This decoupling is done through stochastic interpolation and will be reviewed in the [third note](/posts/flow_matching) of the series.

## A variational bound for the SDE sampler

Let $s : [0,T]\times \mathbb{R}^d \to \mathbb{R}^d$ be a smooth function, meant as a proxy for $\nabla \log p_t$. Our goal is to quantify the difference between the sampled densities $\qo, \qs$ and $\pbt=p_{T-t}$. It turns out that controlling the Fisher divergence $\mathbb{E}[|\nabla \log p_t(X) - s(t,X)|^2]$ results in a bound for $\mathrm{kl}(p \mid q_T^{\mathrm{sde}})$, but not for $\mathrm{kl}(p \mid q_T^{\mathrm{ode}})$. 

### Small recap on notations 
The true density is $\pbt = p_{T-t}$, it satisfies the backward equation \eqref{BTE}: 
$$ \partial_t \pbt(x) = \nabla \cdot \vbt(x)\pbt(x)\qquad \qquad \vbt(x) = -w_{T-t}^2\nabla \log \pbt(x) - \mu_{T-t}x.$$
The density of the generative process is $\qs$, but we'll simply note $q_t$. It satisfies the backward equation \eqref{FP-a}
$$\partial_t q_t(x) = \nabla\cdot u_t(x)q_t(x)$$ where $$ u_t(x) = w_{T-t}^2\nabla \log q_t(x) - 2w_{T-t}^2s(t,x) - \mu_{T-t}x. $$
The original distribution we want to sample is $p = p_0 = p^{\mathrm{b}}_T$, and the output distribution of our SDE sampler is $q^{\mathrm{sde}}_T = q_T$. Finally, the distribution $p_T = p_0^{\mathrm{b}}$ is approximated with $\pi$ (in practice, $\mathscr{N}(0,I)$).  

The KL divergence between densities $\rho_1, \rho_2$ is $$ \mathrm{kl}(\rho_1 \mid \rho_2) = \int \rho_2(x)\log(\rho_2(x)/ \rho_1(x))dx.$$

### A variational lower-bound

This theorem restricts to the case where the weights $w(t)$ are constant, and for simplicity, they are set to 1. 


@@important 
**Variational lower-bound for score-based diffusion models with SDE sampler**

\begin{equation}\label{vlb}
\mathrm{kl}(p \mid q_T^{\mathrm{sde}}) \leqslant \mathrm{kl}(p_T \mid \pi) +\int_0^T w^2_{t}  \mathbb{E}[ |\nabla \log p_t(X_t) - s(t,X_t)\vert^2 ] dt. 
\end{equation}
@@

The original proof can be found in [this paper](https://arxiv.org/abs/2101.09258) and uses the Girsanov theorem applied to the SDE representations \eqref{SDE}-\eqref{BSDE} of the forward/backward process. This is utterly complicated and is too dependent on the SDE representation. The proof presented below only needs the Fokker-Planck equation and is done directly at the level of probability densities. 


The following lemma is interesting on its own since it gives an exact expression for the KL divergence between transport equations. 
@@important 
\begin{equation}\label{36}\frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) = w^2_{T-t} \int \pbt(x) \nabla \log\left(\frac{\pbt(x)}{q_t(x)}\right) \cdot \left(u_t(x)- \vbt(x) \right)dx\end{equation}
@@
In our case with the specific shape assumed by $u_t, \vbt$, we get the following bound:
@@important
\begin{align}\label{37}\frac{d}{dt}\mathrm{kl}(p_t \mid q_t) \leqslant w^2_{T-t}\int \pbt(x) |s(t,x) - \nabla \log \pbt(x) |^2 dx \end{align}

@@

@@proof
 The proofs of \eqref{vlb}-\eqref{36}-\eqref{37} are only based on elementary manipulations of time-evolution equations. 

**Proof of \eqref{36}.**

A small differentiation shows that  $ \frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) $ is equal to $$\int \nabla \cdot (\vbt(x)\pbt(x))\log(\pbt(x)/q_t(x))dx + \int \pbt(x)\frac{\nabla \cdot (\vbt(x)\pbt(x))}{\pbt(x)}dx - \int \pbt(x)\frac{\nabla \cdot (u_t(x)q_t(x))}{q_t(x)} dx.$$
By an integration by parts, the first term is also equal to $-\int \pbt(x)\vbt(x)\cdot \nabla \log(\pbt(x)/q_t(x))dx$. For the second term, it is clearly zero. Finally, for the last one, 
\begin{align}
- \int \pbt(x)\frac{\nabla \cdot (u_t(x)q_t(x))}{q_t(x)} dx &= \int \nabla (\pbt(x)/q_t(x)) \cdot u_t(x)q_t(x)dx \\
&= \int \nabla \log(\pbt(x)/q_t(x))\cdot u_t(x)\pbt(x)dx.
\end{align}

**Proof of \eqref{37}.**
We recall that $$u_t(x) = w^2_{T-t}\nabla \log q_t(x) - 2w^2_{T-t}s(t,x) - \mu_{T-t}x$$ and $$\vbt(x) = -w^2_{T-t}\nabla \log \pbt(x) - \mu_{T-t}x,$$ so that
\begin{align}  u_t - \vbt &= w^2_{T-t}\nabla \log q_t - 2w^2_{T-t}s + w^2_{T-t}\nabla \log \pbt\\ &= w^2_{T-t} \left( \nabla \log q_t - \nabla \log \pbt + 2 (\nabla \log \pbt - s) \right).\end{align}
We momentarily note $a = \nabla \log \pbt(x)$ and $b = \nabla \log q_t(x)$ and $s=s(t,x)$. Then, \eqref{36} shows that
\begin{align} \frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) &=  \sigma^2_{T-t}\int \pbt(x)(a - b)\cdot ((b-a) + 2(s - a))dx\\
&= - w^2_{T-t}\int p_t(x)|a-b|^2 dx + 2 w^2_{T-t}\int p_t(x)(a-b)\cdot (s-a)dx.
\end{align}
We now use the classical inequality $2(x\cdot y) \leqslant  |x|^2  + |y|^2$; we get
$$ \frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) \leqslant w^2_{T-t} \int \pbt(x)|s(t,x) - \nabla\log \pbt(x)|^2dx.$$

**Proof of \eqref{vlb}.**

Now, we simply write
\begin{align}\label{integ} \mathrm{kl}(p^{\mathrm{b}}_T \mid q^{\mathrm{sde}}_T) - \mathrm{kl}(p^{\mathrm{b}}_0 \mid q_0^{\mathrm{sde}}) &= \int_0^T \frac{d}{dt}\mathrm{kl}(\pbt \mid q_t) dt 
\end{align}
and plug \eqref{37} inside the RHS. Here $q_0 = \pi$ and $p^{\mathrm{b}}_T= p$, hence the result. 

@@

### What about the ODE ?

It turns out that the ODE solver, whose density is $\qo$, does not have such a nice upper bound. In fact, since $\qo$ solves a Transport Equation, we can still use \eqref{36} but with $u_t$ replaced with $\hat{v}^{\mathrm{b}}_t$, and integrate in $t$ just as in \eqref{integ}. We have 
\begin{align}\hbt(x) - \vbt(x) &= \nabla \log \pbt(x)-s(t,x) \\
&= \nabla \log \pbt(x) - \nabla\log q_t(x) + \nabla\log q_t(x) - s(t,x).
\end{align}
Using the Cauchy-Schwarz inequality, we could obtain the following upper bound. 
@@important
\begin{align}
\mathrm{kl}(p \mid q_T^{\mathrm{ode}}) - \mathrm{kl}(p_T \mid \pi) &\leqslant \int_0^T \int p_t(x)\left|\nabla\log p_t(x) - \nabla\log q_t(x)\right|^2 +  p_t(x)\left|\nabla \log q_t(x) - s(t,x)\right|^2 dx dt\\
&\leqslant \int_0^T \mathbb{E}\left[|\nabla\log p_t(X_t) - \nabla\log q_t(X_t)|^2 + |\nabla\log q_t(X_t) - s(t,X_t)|^2\right]dt.  
\end{align}
@@
There is a significant difference between the score matching objective function and the SDE version. Minimizing the former does not minimize the upper bound, whereas the latter does. This disparity is due to the Fisher divergence, which does not provide control over the KL divergence between the solutions of two transport equations. However, it does regulate the KL divergence between the solutions of the associated Fokker-Planck equations, thanks to the presence of a diffusive term. This could be one of the reasons for the lower performance of ODE solvers that was observed by early experimenters in the field. However, more recent works (see the references just below) seemed to challenge this idea. With different dynamics than the Ornstein-Uhlenbeck one, deterministic sampling techniques like ODEs seem now to outperform the stochastic one. A complete understanding of these phenomena is not available yet; the outstanding paper on [stochastic interpolants](https://arxiv.org/abs/2303.08797) proposes a remarkable framework towards this task (and inspired most of the analysis in this note). 





## References

### On diffusion models

[The original paper on diffusion models](https://arxiv.org/abs/1503.03585)

[DDPM](https://arxiv.org/abs/2006.11239) (seminal paper for image generation)

[Diffusion beat GANs](https://arxiv.org/abs/2105.05233) (pushing diffusions well beyond the SOTA)

[Variational perspective on Diffusions](https://openreview.net/forum?id=bXehDYUjjXi) or [arxiv](https://arxiv.org/abs/2106.02808) (the analytical SDE approach)

[Maximum likelihood training of Diffusions](https://arxiv.org/abs/2101.09258) (proofs of the variational lower-bound)

[Probability flow for FP](https://arxiv.org/pdf/2206.04642.pdf), containing the proof of the variational lower-bound for the FP equation.


