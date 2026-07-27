+++
titlepost = "Flow models VI: equilibrium matching"
date = "March 2025"
abstract = "Getting the energy map"
+++

One of the particularities with flow matching methods is that they're inherently *out-of-equilibrium*. When solving the ODE $\dot{X}_t = v_t(X_t)$, we're not really minimizing a natural function; indeed, we *chose* to stop at a finite time horizon $t=1$, but in general we could very well continue after this time, leading to non-sensical results. Energy-Based Models, on the contrary, were known to be quite natural: EBMs are just a fancy name for classical likelihood learning. They consist, given a dataset $x_1, ..., x_n$ from $p$, in directly learning $p$ by parametrizing its log-likelihood: the **model** we're learning is $p_\theta(x) = e^{-U_\theta(x)}/Z_\theta$, where $Z_\theta = \int e^{-U_\theta}$ and $\theta$ are the parameters of the neural network. Sampling from an EBM is just sampling from a Gibbs density using any Monte-Carlo or Langevin method, until equilibrium is reached. 

How this training is done in practice is a vast topic and I won't cover it; however, right now in the second half of 2025, it seems to me that while EBMs represent a kind of *holy grail* from a theoretical point of view, they've always been suffering from very hard training difficulties. In spite of many techniques for scaling them, no EBM can rival diffusion-based models in the tasks of image or video generation. 

In a recent paper,  [the EqFM paper](https://arxiv.org/abs/2510.02300) by R. Wang and Y. Du introduced an interesting variation of flow matching, interpolating between FMs and EBMs. Suppose that we have an interpolation $$X_t = (1-t)\varepsilon + t X_1$$ where $X_1$ is drawn from the unknown distribution of interest, $\varepsilon$ is a Gaussian and $t$ is between 0 and 1.  

The Flow Matching objective consists in learning $\mathbb{E}[x-\varepsilon \mid X_t]$ by minimizing
$$\mathbb{E}[|v_t(X_t) - (X_1 - \varepsilon)|^2].$$
 It had been noted in many works that the ultimately, $v_t(x_t)$ should approximate $x-\varepsilon$ given $x_t$: but $x-\varepsilon$ does not depend on $t$. One could try to get rid of the "noise conditioning" induced by the dependency on $t$, and to learn a time-independent field $v(x)$ to approximate $\varepsilon - x$ without the need to know $t$ (a "blind denoiser" as sometimes read on the litterature), by minimizing the objective
 $$ \mathbb{E}[|v(X_t) - (X_1 - \varepsilon)|^2].$$
 That didn't work better. In the intriguing paper [Is Noise Conditioning Necessary for Denoising Generative Models?](https://arxiv.org/abs/2502.13129), the authors showed that getting rid of noise conditioning didn't result in really bad results, but but didn't result in any gains too. 
 
 ## EqFM
 
  Equilibrium Flow Matching tries to learn an energy function which vanishes at the true data points, i.e. 
 $$\nabla f(x_t) \approx (x - \varepsilon)\sigma_t$$
 where $\sigma_t$ is a function which should be zero when $t=1$. 
 Suppose that such a function exists and ...

Suppose that $\sigma_t = 1-t$. Indeed, in this case $X_t = X+\sigma_t(\varepsilon-X_1)$, and 
 $$\mathbb{E}[(x - \varepsilon)\sigma_t \mid X_t] = X_t - \mathbb{E}[X_1 \mid X_t]. $$
This is zero when $t=1$. 

problems : what's the energy ? does it converge to local zero-gradient points or to minima ?


 ## References

 [EqFM](https://arxiv.org/abs/2510.02300)
