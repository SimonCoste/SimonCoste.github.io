+++
titlepost = "Flow models V: consistency, flow maps and distillation"
date = "March 2025"
abstract = "Solving ODEs and SDEs is long. Can we directly learn the whole map?"
+++

Let us summarize what we've seen. Given two $p_0, p_1$, we found a way to define an ODE $\dot{X}_t = v_t(X_t)$ such that $X_0 \sim p_0$ and $X_1 \sim p_1$. Score-matching techniques allow us to learn $v_t$ from samples. Once this is done, we can sample from $p_1$ by solving the ODE. Alternatively, there is an SDE whose marginals are also $p_t$ and whose drift is related to $v_t$, so we could also sample by sampling from this SDE. 

In practice, we can't solve the ODE or SDE exactly, so we discretize it using, say, $N$ time steps $t_1 < \dotsb < t_N$, using schemes like Runge-Kutta for the ODE, or Euler-Maruyama for the SDE. But then, we need $N$ evaluations of the neural network that learnt $v_t$, which hinders a lot the speed of the sampling processes. As a result, big models like FLUX.1 can take a few tens of *seconds* (on a 40GB GPU) to sample a single image. 

@@important 

The ODE $\dot{X}_t = v_t(X_t)$ started at $x_0$ produces a *flow* $\Psi_t(x_0)$, which is the solution of the ODE at time $t$ starting at $x_0$. Is it possible to directly learn this flow map $\Psi_t$ with a single neural network? 

@@ 

## Flow map 

The ODE \begin{equation}\label{ODE}\dot{x}_t = v_t(x_t)\end{equation} started at $x_0 \sim p_0$ has density at time $t$ noted $p_t$. This probability path solves the continuity equation 
$$ \partial_t p_t = - \nabla \cdot (v_t p_t). $$

@@deep 

There is a unique map, called the **flow of the ODE** and noted $\Psi_{s,t}:\mathbb{R}^d \to \mathbb{R}^d$, such that for any two time steps $s,t$ one has 
$$\Psi_{s,t}(x_s) = x_t.$$
This map is the unique solution of the family of ODEs started at time $s$ at any point $x$: 
\begin{equation}\label{lagrange} \partial_t \Psi_{s,t}(x) = v_t(\Psi_{s,t}(x))\end{equation}
It satisfies the consistency condition $\Psi_{s,t}\circ \Psi_{r,s} = \Psi_{r,t}$, for any $r,s,t$. 
@@

@@proof 

**Proof.** Taking time-$t$ derivatives of the identity $\Psi_{s,t}(x_s) = x_t$ gives $\partial_t \Psi_{s,t}(x_s) = v_t(\Psi_{s,t}(x_s))$, which is \eqref{lagrange}. This is the ODE \eqref{ODE} with initial condition $x_s = \Psi_{s,s}(x_s)$. The uniqueness of the solution of ODEs gives the result. The consistency equation comes from the simple fact that $\Psi_{s,t}(\Psi_{r,s}(x_r)) = \Psi_{s,t}(x_s) = x_t = \Psi_{r,s}(x_r)$. Solving the ODE started at time $r$ at any point $x_r = x$ gives the general identity $\Psi_{s,t}(\Psi_{r,s}(x)) = \Psi_{r,t}(x)$.

@@ 

In short, $\Psi_{s,t}$ solves the ODE \eqref{ODE} with initial condition $x_s$. The trajectory started at $x_0$ can thus be expressed as $x_s = \Psi_{0,s}(x_0)$. In particular it can be used to travel back or forth along the trajectories, since $\Psi_{t,s} = \Psi_{s,t}^{-1}$.

It turns out that the flow map can be learnt directly from the knowledge of the velocity field $v_t$.  

@@deep 

The flow map $\Psi_{s,t}$ is the minimizer of the square loss
$$L(S) = \iint_0^1 | \partial_t S_{s,t}(x) - v_t(S_{s,t}(x))|^2 p_s(x) dx ds dt $$
among all maps $S_{s,t}:\mathbb{R}^d \to \mathbb{R}^d$ that are differentiable in $t$ and satisfy $S_{s,s}(x) = x$.

@@ 

@@proof 

**Proof.** It is an evidence that if $p_t(x)>0$ everywhere (which we implicitly assume), then the loss above is minimized (and equal to 0) only when $\partial_t S_{s,t} = v_t(S_{s,t})$, that is, when $S_{s,t}$ satisfies equation \eqref{lagrange}. Unicity in the preceding theorem implies that the minimizer is $\Psi_{s,t}$. 

@@

## References 

- [Consistency models](https://arxiv.org/abs/2303.01469)

- [Inductive Moment Matching](https://arxiv.org/pdf/2503.07565)

- [Flow Map Matching](https://arxiv.org/pdf/2406.07507)