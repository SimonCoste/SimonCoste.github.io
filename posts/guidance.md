+++
titlepost = "Flow Models IV: What is Classifier-Free Guidance?"
date = "March 2025"
abstract = "From unconditional to conditional generative models "
+++


Generative models are often presented as *unconditional models*, which means that they are trained to generate samples from a distribution $p$ on, say, $\mathbb{R}^d$. 

However, in practice, it is of paramount importance to generate *conditioned* distributions: we do not want to generate images out of the blue, but rather images fitting a description (called *prompt*), like an image of a dog wearing a hat or whatever. Formally, there is an underlying joint distribution $p(x, c)$ over couples where $x$ is a sample (images, text, sound, videos) and $c$ is a conditioning information: it can be a text description, a visual shape, a color palette, whatever. Our goal is to learn to sample $p(x \mid c)$, the distribution of $x$ conditioned on $c$. This is called « guidance »; it has been investigated since the beginning of generative models. 

The first papers on diffusions had a method for that called *classifier guidance*, but now it is always done using the **classifier-free guidance** (CFG) technique from [Ho and Salimans's paper](https://arxiv.org/abs/2207.12598), a crucial step in the development of generative models. 

CFG has been proved empirically to yield very good results, at least way better than the preceding approaches. However, it remains essentially a trick, and its theoretical understanding remains shaky in my opinion. 

### Diffusions redux

The noising path will be noted $p_t$, with $p_0$ the distribution we want to sample, and $p_T \approx N(0,I_d)$, the easy-to-sample distribution. The reverse path $q_t = p_{T-t}$ can be represented as the probability path of an SDE (DDPM sampling) or an ODE (DDIM sampling), both of which needing knowledge of the gradient of the log-density of $p_t$ at each time $t$, $\nabla_x \ln p_t(\cdot)$. This *score* is learnt by means of denoising score-matching and approximated by a neural network, say $s_t(\cdot)$. 

## Guidance

We now consider *joint* distributions of the form $p(x,c)$. During the noising process, we only inject noise in the sample $x$ and keep $c$ fixed; we note $p_t(x,c)$ for the joint distribution of $x$ and $c$ along the noising path. The unconditional marginal distribution of $x$ is 
$$p_t(x) = \int p_t(x,c) dc.$$
Bayes formula says that 
$$p_t(x \mid c) = \frac{p_t(c \mid x) p_t(x)}{ p_t(c)}.$$
The gradient of the log of this conditional distribution is therefore 
$$\nabla_x \ln p_t(x \mid c) = \nabla_x \ln p_t(c \mid x) + \nabla_x \ln p_t(x).$$
The second term here has already been learnt and approximated by $s_t$; if we want to sample from $t_t(\cdot \mid c)$, we thus need access to the first part. 

### Classifiers

Indeed, this first part can be seen as the gradient of a classifier: $p_t(c \mid x)$ is precisely the optimal classifier of a sample $x$. Consequently, if we have at our disposal *any* pretrained classifier of $x$, we can use it to guide the generation of $x$ along the noising path: to do so, simply replace the neural network $s_t$ by the « guided » version \begin{equation}\label{CG}s_t(x) + \nabla_x \ln p_t(c \mid x).\end{equation} This technique is called *classifier guidance*. Its main advantage is that once we have learnt the unconditional score $\nabla \ln p_t$, we can adapt this to conditional sampling using any classifier (and there are lots of open-source classifiers available for many problems). 

### Scaled guidance

Practitioners noted that using \eqref{CG} as it is could be impractical, and rescaling the classifier by a factor $\gamma$ could improve quality and diversity: 
$$ s_t(x) + \gamma \nabla_x \ln p_t(c \mid x).$$
Having a large $\gamma$ (say, larger than 1) « strengthens » the influence of the conditioning on $c$ along the generation. The intuition behind that is that the above function is the score of a distribution proportional to 
$$p_t(x)p_t(c \mid x)^\gamma.$$ 
The parameter $\gamma$ is akin to an inverse temperature in statistical physics; augmenting it "peaks" $p_t(c \mid x)$ around its modes, thus promoting adherence to the condition $c$.  

### Limitations

Unfortunately, this strategy needs to have a good classifier $p_t(c \mid x)$ that works even for large $t$, when the sample $x$ is extremely noisy. It can be extremely hard to extract classifying information from an image that is so noisy that it is almost a Gaussian: this is why plugging a pre-trained classifier is generally a bad idea. We would need to re-train a classifier explicitly on noisy data, with noise at different scales.  

## Classifier-free guidance

Classifier-free guidance takes a step back at this problem and also tries to learn the conditional distributions $p_t(x \mid c)$ during training, instead of just learning $p_t(x)$. 


The whole training process needs to be adapted. The neural network now has two inputs: the approximation of $p_t(x \mid c)$ is $s_t(x, c)$. Note that the space where $c$ lives can be extended with a dummy element $\varnothing$, so that $s_t(x, \varnothing)$ is just the approximation of the unconditional score $\nabla \ln p_t(x)$. In practice, this is done by choosing an « unconditional training proportion »  generally 10%; during training, 10% of the samples will be assigned the dummy label $\varnothing$, the rest are assigned the correct conditioning information $c$. This trick allows to learn at the same time the conditional distribution and the unconditional one. 

 Once this is done, Bayes' formula provides us (for free!) a classifier, since 
$$\nabla_x \ln p_t(c \mid x) = \nabla_x \ln p_t(x \mid c) - \nabla_x \ln p_t(x).$$
This is approximated by $s_t(x,y) - s_t(x, \varnothing)$. Using $\gamma$-guidance as before, the gradient used for the sampling path becomes $$s_t(x, \varnothing) + \gamma (s_t(x,c) - s_t(x, \varnothing))$$
which can be further simplified. 

@@deep 

**Classifier-Free Guidance** consists in using the *$\gamma$-rescaled score* at sampling: 
$$ (1 - \gamma)s_t(x, \varnothing) + \gamma s_t(x, c),$$
This score is an approximation of
\begin{equation}\label{CFG}(1-\gamma)\nabla_x \ln p_t(x) + \gamma \nabla_x \ln p_t(x \mid c). \end{equation}

@@

Experimentally, this technique allows a tradeoff between quality and variety: augmenting the CFG scale $\gamma$ from 0 to (say) 10 augments the variety of the conditional samples (measured by the Inception Score, IS), but reduces the perceptual quality (measured by the Fréchet Inception Distance, FID). 

## CFG with negative prompts

In practice, one does not always want only "conditioning information", but also "negative conditioning". This is what is called "negative prompting": people want to generate a picture of a cat, and certainly *not* a dog. Of course, in theory, if the prompt adherence is well learnt by the model, it would be sufficient to ask for the condition $c = \text{cat, no dog}$. But this often does not work[^1]. Splitting the "positive" and "negative" part of the prompts can sometimes improve things. In practice, if we want the generation to have $c$ (positive part) but not $d$ (negative part) this is done by replacing $s_t(x, \varnothing)$ by $s_t(x, d)$, so the velocity used in the sampling path is now

$$ (1 - \gamma)s_t(x, d) + \gamma s_t(x, c).$$

For example, with a $\gamma=2$ we get $2s_t(x, c) - s_t(x, d)$. Intuitively, this tells us to go even more in the conditioning direction $s_t(x, c)$, and also to flee from the negative conditioning direction $s_t(x, d)$ because we don't want to end in $d$. 

This was done for a long time in SDXL or SD3. However, the results seemed to suck: sometimes, adding a negative prompt (like `negative_prompt="text"` to generate images without text) resulted in *even more* text. The BlackForestLabs team, who spawned the FLUX models, pretended that their model was so good (and it is) that they no longer needed negative prompted, and just used vanilla CFG. I've not been convinced.  


## The gamma-powered distribution

A common intuition found in papers is that sampling from \eqref{CFG} amounts to sample from the score of the probability distribution proportional to
$$p_t(x)^{1-\gamma}p_t(x \mid c)^\gamma.$$
However, as examined in [Bradley and Nakkiran's paper](https://arxiv.org/pdf/2408.09000), this intuition is wrong. It would be true if $p_t(x)^\gamma p_t(x \mid c)^{1-\gamma}$ corresponded to the time-$t$ noising of the distribution $p_t(x)^\gamma p_t(x \mid c)^{1-\gamma}$, but that is mathematically not the case. 

In addition, if this score was the score of a valid diffusion process, choosing ODE sampling or SDE sampling should not matter too much, since both processes would have the same marginals. This is also mathematically wrong: it is very easy to check that in a Gaussian setting where $p(x \mid c) = N(c, 1)$ and $c \sim N(0, 1)$, a setting where we have access to the exact score $\nabla \ln p_t(x \mid c)$, the ODE and SDE samplings with $\gamma$-rescaling and conditioning on $c=0$ lead to radically different distributions: 
- for the ODE, it samples $N(0, 2^{-\gamma})$; 
- for the SDE, it samples $N(0, 1/\gamma)$. 
- The real distribution of $x$ given $c=0$ is $N(0, 1)$.

At the moment of writing of this post (march 25), it really remains unclear (at least, to me) what distribution is sampled using the CFG technique above. Something is lacking in our understanding of CFG.  


## How is guidance done for Flow Matching models ?

We simply replace the score $\nabla_x \ln p_t$ with the velocity field. 

In this case, we need to learn a « joint velocity field » $v_t(x,c)$: the entire ODE system is conditionnally on $c$. In practice, this means that the conditional flows/velocities are actually conditioned twice: one on the conditioning information $c$, and one on the final sample itself $X_1 \sim p_1(\cdot \mid c)$. Note that here again, $c$ can be a placeholder $\varnothing$ meaning that the flow is unconditional. Once the approximation $u^\theta_t(x,c)$ is learnt, we can mimick the strategy \eqref{CFG}: at sampling, we use the velocity 
$$ (1-\gamma) u^\theta_t(x, \varnothing) + \gamma u^\theta_t(x, c)$$
or, if we use negative prompting, 
$$ (1-\gamma) u^\theta_t(x, \mathrm{neg. cond.}) + \gamma u^\theta_t(x, c). $$




## References 

[Diffusion beat GANs](https://arxiv.org/pdf/2105.05233) really pushed forward classifier guidance. 

[Classifier-free diffusion  guidance](https://openreview.net/pdf?id=qw8AKxfybI) was the first paper to introduce CFG.

[CFG is a predictor-corrector](https://arxiv.org/pdf/2408.09000), a nice, recent (oct 25) review on CFG.

[What does guidance do ?](https://arxiv.org/pdf/2409.13074), another recent paper (sep 25) on the topic.

[^1]: From my own experience in image generation models, even extremely powerful models like FLUX.PRO have hard times adhering to "mixed prompts" with both positive and negative elements. 