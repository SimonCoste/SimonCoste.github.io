+++
titlepost = "Flow models III: Flow Matching"
date = "March 2025"
abstract = "Flow straight, flow fast: velocity is everything. "
+++

In the preceding notes, we've seen how [diffusion models](/posts/diffusion.md) are trained and sampled from and we've seen how the score function $\nabla \ln p_t$ is efficiently learnt using [score matching](/posts/score_matching.md). However, since their inception, diffusion models felt a little bit weird for various reasons. 
- First, they did not « really » bridge $p_0$ with $N(0,I_d)$. They bridge $p_0$ with $p_T$ which is only approximately $N(0,I_d)$. This is absolutely not important practically, but from a theoretical point of view, it is a bit unsatisfactory. There should be a way to bridge $p_0$ with $N(0,I_d)$  **exactly** in finite time. 
- Second, the design of a diffusion feels a little bit clunky. How do we choose the drift and diffusion coefficients $\mu_t, w_t$? In the end, it looks that the coefficients $\alpha_t, \sigma_t$ such that $x_t$ has the same law as $\alpha_t x_0 + \sigma_t \varepsilon$ are the ones who matter, so why note directly choose them?
- Finally, this ODE/SDE duality is a bit confusing. In the end, the SDE formulation is not really useful since we are only interested in the marginals $p_t$, and the ODE sampling feels really simpler. There was a time when it was not clear why SDEs seem to work better (while there was absolutely no theoretical reason for that).

For these reasons, the community has been looking for a new model that would be more intuitive, more flexible, and more powerful, able to bridge any two distributions in finite time, with deterministic (ODE) sampling. In the end, it turns out that Flow-Matching is **almost entirely equivalent** to diffusion score mathching, except that the presentation and the way we're doing things is slightly different -- but way more flexible. 

\tableofcontents

## Flow matching

Let $(X_0, X_1)$ be a couple of random variables sampled from $p_0$ and $p_1$. Actually, they can even be dependent: we only impose that their marginal distributions are $p_0$ and $p_1$, so we note $\pi$ their joint distribution and we suppose that $\int \pi(x,y)dx = p_1(y)$ and $\int \pi(x,y)dy = p_0(x)$. From a probabilistic perspective, $(X_0, X_1)$ can be **any coupling** between $p_0, p_1$. 

**Conditional and annealed flows**

@@important 

Suppose that there is a smooth function $\varphi : (t, x, y) \to \varphi_t(x,y)$ such that $\varphi_0(x,y) = x$ and $\varphi_1(x,y)=y$. This provides a connection between $p_0$ and $p_1$ by defining random variables 
$$X_t = \varphi_t(X_0, X_1).$$
This connection is called the **conditional flow** of the system. We note $p_t$ the density of $X_t$. 

@@ 

@@deep 

**The flow comes from an ODE.** The probability path $p_t$ satisfies the continuity equation $\partial_t p_t = -\nabla \cdot (v_t p_t)$ where \begin{equation}\label{velocity}v_t(x) = \mathbb{E}[\dot{X_t}| X_t = x].\end{equation} In other words, $X_t$ has the same marginals as the ODE system
\begin{equation}\label{ode_x}\dot{x}_t = v_t(x_t), \qquad x_0 \sim p_0.\end{equation}

@@ 

We emphasize the fact that $X_t$ does not satisfy \label{ode_x} in general. The main point is that $X_t$ (the conditional flow) and $x_t$ (the unconditional, or **annealed flow**, defined by the ODE) have the same marginals $p_t$. This is more or less what happened for diffusions, where the SDE and ODE paths had the same marginals but not the same distribution. 

@@proof 

**Proof.** We follow the proofs in the Stochastic Interpolant paper. The Fourier transform of $p_t$ is $\hat{p}_t(\xi) = \mathbb{E}[e^{i \langle \xi,  X_t\rangle}]$. Differentiating in $t$ yields $\partial_t \hat{p}_t(\xi) = \widehat{\partial_t p}(\xi)$ since time-differentiation and Fourier transform commute. On the other hand, by passing $\partial_t$ inside the expectation and conditioning on $X_t$, we get 
\begin{align}
\widehat{\partial_t p_t}(\xi) &= \mathbb{E}[i\xi \dot{X}_t e^{i\langle\xi, X_t\rangle}]\\ 
&=\mathbb{E}[i\xi e^{i\langle\xi, X_t\rangle}\mathbb{E}[\dot{X}_t\mid X_t]]\\ 
&=\mathbb{E}[i\xi e^{i\langle\xi, X_t\rangle} v_t(X_t)] \\ 
&= \int p_t(x)v_t(x) \nabla_x e^{i\langle \xi, x \rangle}dx.
\end{align} 

Also, since $\nabla_x e^{i\langle \xi, x\rangle} = i\xi e^{i\langle \xi, x\rangle}$, the last integral is equal to
$$-\int \nabla_x \cdot [v_t(x)p_t(x)] e^{i\langle \xi, x\rangle}dx = \widehat{-\nabla \cdot v_tp_t}(\xi). $$
Since the Fourier transform is injective, we get $\partial_t p_t = -\nabla \cdot v_t p_t$.

@@ 

The joint distribution of $X_t$ and $X_1$ is given by $\pi(x_0, x_1)p_t(x \mid x_0, x_1)$. Consequently, the conditional distribution of $X_t$ given $X_1$ is $\pi(x_0, x_1)p_t(x \mid x_0, x_1) / p_t(x)$, where $p_t(x)$ is the marginal density of $X_t$.
Formally, we can thus write the velocity field as the following integral: 

$$v_t(x) = \int_{\mathbb{R}^d} \dot{\varphi}_t(x_0, x_1)\frac{p_t(x \mid x_0, x_1)\pi(x_0, x_1)}{p_t(x)}dx_0dx_1.$$
This is the formula appearing in Lipman's paper.

**Sampling the probability path.**

Sampling $X_t$ is easy when we have at our disposal samples $X_0, X_1$ from $p_0, p_1$. But when we have only one of them, say $X_0$, we cannot use this formula, so we have to sample the ODE $\dot{x}_t = v_t(x_t)$ started at $X_0$: but this would need knowledge of $v_t$. That is not directly doable, since its expression needs knowledge of $p_t$. However, the $L^2$ loss $\mathbb{E}[|s(X_t) - v_t(X_t)|^2]$ can efficiently be minimized without knowing $v_t$. 

**Learning the velocity**

@@deep

**Flow Matching Loss.** 

Let $s$ be any function. Then, 
$$\mathbb{E}[|s(X_t) - v_t(X_t)|^2] = \mathbb{E}[|s(X_t) - \dot{X}_t|^2] + c,$$
where $c = \mathbb{E}[|\dot{X}_t|^2] - \mathbb{E}[|v_t(X_t)|^2]$ is a constant with respect to $s$. 

@@

The practical consequence is that if $s^\theta$ is smoothly parametrized by $\theta$, then the $L^2$-loss
$$L_\star(\theta) = \mathbb{E}[|s^\theta(X_t) - v_t(X_t)|^2]$$
and the Flow-Matching loss 
$$L(\theta) = \mathbb{E}[|s^\theta(X_t) - \dot{X}_t|^2]$$
have the same gradients and the same minimizers. 


@@proof

**Proof.** Develop the square: 
\begin{align}\mathbb{E}[|s(X_t) - v_t(X_t)|^2] &= \mathbb{E}[|s(X_t)|^2] + \mathbb{E}[|v_t(X_t)|^2] - 2\mathbb{E}[\langle s(X_t), v_t(X_t)\rangle]. \\
\end{align}
The last term is equal to 
$$\mathbb{E}[\langle s(X_t), \mathbb{E}[\dot{X}_t \mid X_t]\rangle].$$
Since averages commute with any linear operator, we can write this as $\mathbb{E}[\mathbb{E}[ \langle s(X_t), \dot{X}_t \rangle \mid X_t]]$, then we can decondition and get $\mathbb{E}[\langle s(X_t), \dot{X}_t\rangle]$. Going back to the first line, adding and subtracting $\mathbb{E}[|\dot{X} t|^2]$, we get 
\begin{align}\mathbb{E}[|s(X_t) - v_t(X_t)|^2] &= \mathbb{E}[|s(X_t)|^2] + \mathbb{E}[|v_t(X_t)|^2] - 2\mathbb{E}[\langle s(X_t), \dot{X}_t\rangle] + \mathbb{E}[|\dot{X}_t|^2] - \mathbb{E}[|\dot{X}_t|^2]. \\
&= \mathbb{E}[|s(X_t) - \dot{X}_t|^2] + \mathbb{E}[|\dot{X}_t|^2] - \mathbb{E}[|v_t(X_t)|^2].
\end{align}
The last two terms are constants with respect to $s$. 

@@




Everything is now tractable. In practice, to learn $v_t$ we use a parametrized family of smooth functions $s^\theta_t$ and we minimize $L$ for "any" time $t$: we 
- sample batches from $X_0, X_1$ from the coupling $\pi$; 
- sample random times $\tau$ in $[0, 1]$ using a distribution $g$ which can be uniform or not; 
- we compute the conditional flows $X_\tau$ and the conditional velocities $\dot{X}_t$ for all the samples of the batch; 
- we compute the discrepancy $|s^\theta_\tau(X_\tau) - \dot{X}_t|^2$ for all samples of the batch, 
- we backpropagate the gradient of this discrepancy to update $\theta$.



## Design of conditional flows

Now that everything is set, we have to design an efficient conditional flow $\varphi_t$. 

### Linear flows

The simplest (and, indeed, very powerful) flow is the linear one, $\varphi_t(x,y) = \alpha_t x + \sigma_t y$, giving 
\begin{equation}\label{linearflow}X_t = \alpha_t X_0 + \sigma_t X_1.\end{equation}
where $\alpha, \sigma$ are differentiable and satisfy $\alpha_0 = \sigma_1 = 1$ and $\alpha_1 = \sigma_0 = 0$. 
The trajectories are straight lines going from $X_0$ to $X_1$ at a velocity given by 
\begin{equation}\label{linearvelo}\dot{X}_t = \dot{\alpha}_t X_0 + \dot{\sigma}_t X_1.\end{equation}
In the simplest setting $\alpha_t  =1-t$ and $\sigma_t = t$, the velocity is constant, $\dot{X}_t = X_1 - X_0$, so that the flow-matching loss minimizes $\mathbb{E}[|s(X_t) - (X_1 - X_0)|^2]$. 

### "Gaussian" flows 


In practice, the goal of (most) generative models is to sample from $p_0$, which leaves open the choice for $p_1$. The natural choice goes for simplicity, with $p_1 = N(0, I_d)$. In this case, noting $\varepsilon$ instead of $X_1$, the marginals of \eqref{linearflow} are exactly the ones we found for the noising process in diffusions. The conditional velocity $v_t(x) = \mathbb{E}[\dot{X}_t \mid X_t=x]$ is simply
$$v_t(x) = \dot{\alpha_t}\mathbb{E}[X_0 \mid X_t=x]+\dot{\sigma_t}\mathbb{E}[\varepsilon \mid X_t = x].$$
Tweedie's formula, as seen in the [preceding note on score matching](/posts/score_matching/), gives 
@@important 

\begin{equation}\label{velocity_gaussian}v_t(x) = \frac{\dot{\alpha}_t}{\alpha_t}x + \sigma_t^2 \nabla \ln p_t(x)\left[ \frac{\dot{\alpha}_t}{\alpha_t} - \frac{\dot{\sigma}_t}{\sigma_t} \right].\end{equation}

@@ 

Note that $\dot{\alpha}_t/\alpha_t - \dot{\sigma}_t/\sigma_t$ is equal to $\dot{\lambda}_t/2$, which is half the time-derivative of the lof-SNR (signel-to-noise) ratio $\lambda_t = \ln(\alpha_t^2/\sigma_t^2)$. 

@@proof 

**Proof.** 
Tweedie's denoising formula says that since $p_t$ is the distribution of $\alpha_t X_0$ noised by $\sigma_t \varepsilon \sim N(0, \sigma_t^2 I_d)$, then 
$$\mathbb{E}[\varepsilon \mid X_t] = \frac{\mathbb{E}[\sigma_t \varepsilon \mid X_t]}{\sigma_t} = -\sigma_t \nabla \ln p_t(X_t).$$
Similarly, 
$$\mathbb{E}[X_0 \mid X_t] = \frac{X_t + \sigma_t^2\nabla \ln p_t(X_t)}{\alpha_t}.$$
Gathering the two yields the formula. 
@@ 

Formula \eqref{velocity_gaussian} tells us (once again!) that the only thing that matters given the choice of $\alpha_t, \sigma_t$ is the knowledge of the score $\nabla \ln p_t$. How this score was learnt is actually a secondary problem: we don't care if the learning was done in a diffusion framework or whatever. When we have it, we can plug it in \eqref{velocity_gaussian} and sample. 

By carefully looking at the derivations, we can see that there are one-to-one linear connections between 

- $\nabla \ln p_t$ (the score)
- $\mathbb{E}[\varepsilon \mid X_t]$ (the denoising model)
- $\mathbb{E}[X_0 \mid X_t]$ (the data prediction model)
- $v_t$ (the velocity model). 
Only one of them needs to be learned, and we can convert it into the three others. If one wants to use a pretrained model for sampling, one thus needs to keep track of *how the model was learned*: is it a score, a denoiser, a data predictor or a velocity? 

We close this part with an important note: given a score model for $\nabla \ln p_t$, regardless of how it is formulated and trained, using it to sample from the flow $\dot{x}_t = v_t(x_t)$ or to sample from the DDIM ODE in diffusion models is **exactly the same**. 

### Optimal transport flows 

There is room for the choice of the connection $\varphi_t$; among these choices, some of them should be better than the others. The choice of one of these connections provides a velocity field $v_t$ transporting samples from $p_0$ to samples from $p_1$. Consider all the possibles fields $u_t$ such that the solutions of the ODE $\dot{x}_t = -u_(x_t)$ started at $x_0 \sim p_0$ and at $x_1 \sim p_1$. The best possible one should minimize the **total kinetic energy**, 
$$\mathbb{E}\int_0^1 |u_t(x_t)|^2dt$$
where the expection is over $p_0$. 
This problem is widely studied and can be solved: it is quite intuitive that the optimal flows are straight lines, so the optimal velocity fields are constants, and indeed the flows are given by $u^\star_t(x) = x+t(\phi(x)-x)$ where $\varphi$ is Brenier's potentiel, the unique (under some conditions) map $\phi : \mathbb{R}^d \to \mathbb{R}^d$ such that $\phi(X_0)$ has distribution $p_1$ and which minimizes the square transport distance $\mathbb{E}[|x - \varphi(x)|^2]$. Of course, computing $\phi$ is in general intractable. 

This solves the **unconditional** OT problem, and we need **conditional** flows. One nice trick goes as follows: using Jensen's inequality and de-conditioning, we can write 
\begin{align}\mathbb{E}\int_0^1 |v_t(X_t)|^2 dt &= \mathbb{E}\int_0^1 |\mathbb{E}[\dot{X}_t \mid X_t]|^2 dt \\
&\leqslant \mathbb{E}\int_0^1 \mathbb{E}[|\dot{X}_t|^2 \mid X_t] dt \\
&= \mathbb{E}\int_0^1 \mathbb{E}[|\dot{X}_t|^2] dt \\
&= \mathbb{E}\int_0^1 |\dot{X}_t|^2 dt. 
\end{align}
This last bound is the expected kinetic energy of the conditional flow over the boundary distributions $X_0 \sim p_0, X_1 \sim p_1$. For each realization $X_0, X_1$, we can try to find the optimal transport map $\gamma_t$ which minimizes $\int_0^1 |\dot\gamma_t|^2 dt$ subject to the boundary conditions $\gamma_0 = X_0$ and $\gamma_1 = X_1$. The solution is obvisouly the straight line $\gamma_t = x_0 + t(x_1 - x_0)$ (this can be found formally using the Euler-Lagrange conditions). 


The conclusion of these considerations is as follows. 

@@deep 

The conditional linear flow $X_t = (1-t)X_0 + tX_1$ is a minimizer of **a bound on the Kinetic Energy among all the flows transporting $p_0$ to $p_1$**.

@@ 

 It might not be a minimizer of the Kinetic Energy itself, but it is a good starting point. In any ways, it is important to keep in mind that **flowing straight between two points** is absolutely not the same as **flowing straight between two distributions**. 

## Conclusion

Up to now, we've seen how flow matching reformulates and simplifies diffusion sampling. There remains a problem: in practive, to sample from these models, we need to solve an ODE or a SDE, which in practive is done by discretizing time and using a scheme like Euler or Runge-Kutta. But for every time step, this needs a feedforward evaluation of a neural network. Most schemes need 50 time steps, which is why sampling from diffusions can be long. 

[Consistency models](/posts/consistency/) try to directly learn the *flow* $\varphi_t$ and not the velocity $v_t$ - and yes, the naming should have been *velocity matching* from the beginning. 

## References 

The three seminal papers who found (independently) the Flow Matching formulation of generative diffusion models are 

- [The original Flow Matching paper](https://arxiv.org/abs/2210.02747) by Lipman et al.

- The [Probability flow for FP](https://arxiv.org/pdf/2206.04642.pdf) and its rewriting [Stochastic interpolants](https://arxiv.org/abs/2303.08797) by Albergo, Boffi and Vanden-Eijnden.

- The [Rectified Flow](https://arxiv.org/pdf/2209.03003.pdf) paper by Liu, Gong and Liu. 

I find the *stochastic interpolant* formulation way cleaner and nicer than Lipman's one. 

Since then, there were many surveys on the topics. I pretty much like [META's excellent survey of Flow Matching](https://ai.meta.com/research/publications/flow-matching-guide-and-code/) by Lipman and coauthors, for its depths and variety. There is also  this [nice blog post on the topic](https://dl.heeere.com/conditional-flow-matching/blog/conditional-flow-matching/) by Mathurin Massias and others, and [this very recent one](https://diffusionflow.github.io/) by people at DeepMind, clarifying the link between diffusions and FM. 


[These excellent slides](https://bamos.github.io/presentations/2024.transport-between-distributions-over-distributions.pdf) by Brandon Amos present a history of the topic and how we evolved from diffusions to flows through neural ODEs and normalizing flows. 

[Training FM « at scale »](https://arxiv.org/pdf/2403.03206), by the Stability team, who in my knowledge were the first ones to scale FM training. They later produced the FLUX family of models. 

[Brenier's theorem](https://www.ceremade.dauphine.fr/~carlier/Brenier91.pdf), a little bit mathy. 
