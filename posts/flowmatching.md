+++
titlepost = "Flow matching"
date = "March 2025"
abstract = "A small mathematical summary on flow matching and generator matching. "
+++



## Flow matching

Consider the simple ODE started from a random point and driven by the **velocity field** $v_t$. 
$$\dot{X}_t = v_t(X_t), \qquad X_0 \sim p_0$$
We note $p_t$ the probability density of $X_t$ : this **probability path** gives a connection between the initial distribution $p_0$ and the final distribution $p_1$ of the random variable $X_1$. It satisfies the continuity equation, also called transport equation: 
$$ \partial_t p_t(x) = - \nabla \cdot (v_t(x) p_t(x)).$$
It is is also associated with a **flow**: since the whole path $t\mapsto X_t$ is deterministic as long as we know $X_0$, we can write $X_t$ as a deterministic function of $X_0$. 


In general, there is no simple expression for the distribution $p_1$ at the end of the path. The goal of **flow matching** is to find a velocity field $v_t$ that generates a given probability path $p_t$ which starts at $p_0$ (typically, a simple distribution like a Gaussian) and ends at $p_1$ (typically, a complex distribution). 

### Conditional flows

Let $(X_0, X_1)$ be a couple of random variables sampled from $p_0$ and $p_1$. We can easily define flows and velocities that transport $X_0$ to $X_1$. A very simple way of doing so is to simply write 
\begin{equation}\label{toosimple}X_t = (1-t)X_0 + tX_1.\end{equation}
This can be written in terms of a family of flows noted $\psi_t^y(x) = (1-t)x + ty$. Clearly, the flow $\psi_t^{X_1}$ transports any sample $X_0 \sim p_0$ to $X_1$. 
This flow will be called « **conditional flow** » since it will always end in $X_1$, that is: $\psi_1(x\mid y) = y$. We can also compute the **conditional velocity field** that generates this flow:
\begin{equation}\label{condvelo}v_t(x \mid X_1) = \dot \psi_t \left((\psi_t^{-1}(x \mid X_1) \mid X_1 \right).\end{equation}
It is easily checked that the ODE $\dot X_t = v_t(X_t \mid X_1)$ with initial condition $X_0 = x$ has solution $X_t = \psi_t(x \mid X_1)$. We will note $p_t(\cdot \mid X_1)$ the density of this solution (which depends on $X_1$), and call it the **conditional path**.

Suppose now that we average these conditional flows over the distribution of the endpoint $X_1\sim p_1$. This is going to be called the **annealed flow**, and it is defined by $\psi_t(x) = \mathbb{E}[\psi_t(x \mid X_1)]$. Since $\psi_1(x \mid X_1) = X_1$, this annealed flow has the right property: it bridges any starting point to a sample $X_1 \sim p_1$. But what is the velocity field that generates this annealed flow? In general, it not the annealing of $v_t(\cdot \mid X_1)$, but rather its *conditional average*. We will note $$p_t(x) = \int p_t(x \mid x_1)p_1(x_1)dx_1 = \mathbb{E}[p_t(x \mid X_1)]$$ the **annealed probability path**, ie the density of the annealed path.  

@@deep

The velocity field 
\begin{equation}\label{vt}v_t(x)= \int_{\mathbb{R}^d} v_t(x \mid x_1)\frac{p_t(x \mid x_1)p_1(x_1)}{p_t(x)}dx_1\end{equation}
generates the annealed flow $p_t$. 

@@

Since $p_t(x\mid x_1)p_1(x_1)$ is actually the joint density of $X_t$ and $X_1$, the formula \eqref{vt} is exactly 
$$v_t(x) = \mathbb{E}[v_t(x \mid X_1) \mid X_t = x].$$

@@proof 

**Proof.** Differentiating $p_t$ in $t$ yields 
$$\partial_t p_t(x) = \int p_1(x_1) \partial_t p_t(x\mid x_1) dx_1.$$
Since the conditional probability path $p_t(\cdot \mid x_1)$ satisfies the continuity equation with the flow $v_t(\cdot \mid X_1)$, the RHS is equal to 
$$ - \int p_1(x_1)\nabla \cdot [v_t(x\mid x_1) p_t(x \mid x_1)] dx_1 .$$
Swapping the divergence and the integral, this is also 
$$ - \nabla \cdot \int p_1(x_1) v_t(x \mid x_1) p_t(x \mid x_1) dx_1. $$
We artificially add $p_t(x)$ and we get 
$$ -\nabla \cdot \left[\int v_t(x \mid x_1)\frac{p_t(x \mid x_1)p_1(x_1)}{p_t(x)}dx_1 \times p_t(x)\right]$$
which is exactly $-\nabla \cdot (v_t p_t)(x)$, thus proving that the annealed flow $p_t$ satisfies the continuity equation with the velocity field $v_t$.
@@

## Examples of conditional flows

The flow \eqref{toosimple} is a very simple example of a conditional flow: it is a straight line going from $X_0$ to $X_1$. We can still keep the linearity but modulate it using conditional flows like 
$$ \sigma_t(x_1)x + \mu_t(x_1)$$
where $\sigma_t(\cdot)$ is a scalar function satisfying $\sigma_0(x) = 1$ and $\mu_t$ is a vector function satisfying $\mu_1(x) = x$ and $\mu_0(x) = 0$. If everything here is time-differentiable, then \eqref{condvelo} immediately gives the conditional velocity field. We first need to inverse the flow : if $x = \sigma_t(x_1)x_0 + \mu_t(x_1)$ then $x_0 = (x - \mu_t(x_1)) / \sigma_t(x_1)$. Consequently, the conditional velocity field is

$$v_t(x \mid x_1) = \frac{\dot{\sigma}_t(x_1)}{\sigma_t(x_1)}(x - \mu_t(x_1)) + \dot{\mu}_t(x_1).$$

When $X_0$ is a standard Gaussian, then this $X_t$ has distribution $N(\mu_t(x_1), \sigma_t(x_1)^2 I_d)$, hence the name **conditional Gaussian flow**.

## Learning the flow 

Let $u^\theta$ be any parametric function (typically, a neural network). We would like to learn the velocity field $v_t$ by minimizing a simple loss function, like 
$$L_\star(\theta) = \int_0^1 \mathbb{E}[|u_t^\theta(X_t) - v_t(X_t)|^2]dt = \mathbb{E}[|u_\tau^\theta(X_\tau) - v_\tau(X_\tau)|^2]$$
where $\tau$ is a uniform distribution over $[0,1]$. Unfortunately, even with \eqref{vt}, this is intractable, since we do not know how to compute $p_t$ for instance. Fortunately, this loss has the same minimizers as a tractable loss. 

@@deep 

$L$ has the same minimizers as the **conditional flow matching** loss, 
\begin{equation}\label{CFM}L(\theta) = \mathbb{E}[|u^\theta_\tau(X_\tau) - v_\tau(X_\tau \mid X_1)|^2].\end{equation}

@@ 

@@proof 

**Proof.** We can ignore the fact that $\tau$ is random and replace it with a fixed $t$, then integrate over $[0,1]$. 

Start by developing the square in $L_\star(\theta)$ to get
\begin{equation}\label{proof_cfm}\mathbb{E}|v_\tau(X_t)|^2 + \mathbb{E}|u_t^\theta(X_t)|^2 - 2\mathbb{E}\langle v_\tau(X_t), u_t^\theta(X_t)\rangle.\end{equation}
The first term is a constant with respect to $\theta$. Let us examine the last term, which thanks to \eqref{vt} is equal to
$$ -2\mathbb{E}\int_{\mathbb{R}^d} \langle v_t(X_t \mid x_1), u^\theta_t(X_t) \rangle \frac{p_t(X_t \mid x_1)p_1(x_1)}{p_t(X_t)} dx_1.$$
Writing the expectation as an integral over $x$ with density $p_t(x)$, we can simplify this into:
$$ -2\int \int \langle v_t(x \mid x_1), u^\theta_t(x) \rangle p_t(x \mid x_1)p_1(x_1)dx_1 dx.$$
That is exactly 
$$-2\mathbb{E}\langle v_t(X_t \mid X_1), u_t^\theta(X_t)\rangle.$$
Plug this back in \eqref{proof_cfm}, add then substract $\mathbb{E}[|v_t(X_t \mid X_1)|^2]$, and conclude that 
$$ L_\star(\theta) = \mathrm{constant} + \mathbb{E}[|u_t^\theta(X_t) - v_t(X_t \mid X_1)|^2] + \mathbb{E}[|v_t(X_t \mid X_1)|^2].$$
The last term is (again!) a constant with respect to $\theta$, so finally we get $L_\star(\theta) = L(\theta) + \mathrm{constants}$. 

@@ 


Everything is now tractable. We can 
- sample batches from $\tau, X_1, X_\tau$, 
- compute $v_t^{X_1}(x)$ because we typically have access to this quantity, 
- compute the discrepancy $|u^\theta(X_t) - v_t^{X_1}(X_t)|^2$ for all samples in the batch, 
- backpropagate the gradient of this discrepancy to update $\theta$.


It is remarkable that when the conditional velocity field comes from a conditional flow as in \eqref{condvelo}, then the conditional flow matching loss \eqref{CFM} features the term 
$$v_t(X_t \mid X_1) = \dot{\psi}_t(\psi_t^{-1}(X_t \mid X_1) \mid X_1) = \dot{\psi}_t(X_0 \mid X_1),$$
the last identity coming from the fact that $X_t = \psi_t(X_0 \mid X_1)$. Hence, the loss becomes 
$$L(\theta) = \mathbb{E}[|u^\theta_\tau(X_\tau) - \dot{\psi}_\tau(X_0 \mid X_1)|^2].$$



## References 

[The original Flow Matching paper](https://arxiv.org/abs/2210.02747) by Lipman et al.

[META's excellent survey of Flow Matching](https://ai.meta.com/research/publications/flow-matching-guide-and-code/) by Lipman and coauthors. 
