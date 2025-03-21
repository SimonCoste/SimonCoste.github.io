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

## Learning the flow map 

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


Now, suppose that we have at our disposal a diffusion model or a flow matching model. By parametrizing a family of functions $S_{s,t}$, with a neural network, we can minimize the loss $L(S)$. Since $v_t$ is already a neural network, this is a kind of distillation, where we train a  neural network to mimic the behavior of another neural network. In  the end, we obtain a proxy $S_{s,t}$ of the flow map $\Psi_{s,t}$.

## Few-steps sampling

The learnt flow map $S$ can be used in various ways to sample from $p_1$. 
- for super fast sampling, we can directly sample $x_0 \sim p_0$ and apply $S_{0,1}(x_0)$ to get a sample from $p_1$. Indeed, the first « flow map learning » method did directly learn $S_{0,t}$ for all $t$ and was called **consistency distillation**. However, it can happen that this map is not accurate: it is quite intuitive that learning how to go from $s$ to $s + \Delta s$ is easier than going directly from $0$ to $1$, so it can happen that $S_{0,1}$ is not very accurate.
- One can trade speed for accuracy by using the full flow map for a few time steps: typically, using $S_{0.66, 1} \circ S_{0.33, 0.66} \circ S_{0, 0.33}$. This needs two more feedforward passes but the resulting $x_1$ is probably closer to the real solution of \eqref{ODE} started at $x_0$. 

## References 

Although present earlier in the litterature, the first paper to systematically distillate diffusion models was the [Consistency models](https://arxiv.org/abs/2303.01469) paper. The [Flow Map Matching](https://arxiv.org/pdf/2406.07507) interprets it and generalizes it in the stochastic interpolant framework, which is the one I follow here. Very recently, the [Inductive Moment Matching](https://arxiv.org/pdf/2503.07565) technique was designed to be even more efficient. 

