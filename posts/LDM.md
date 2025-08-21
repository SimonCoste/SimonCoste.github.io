+++
titlepost = "Flow Models V: Latent Diffusion"
date = "September 2025"
abstract = "Diffusing in latent spaces is way more efficient. "
+++

This is currently being written - as of Aug 21, 2025

Path-based generative models can be applied to any kind of continuous data. If one wants to generate HD images, then they are applied to the $\mathbb{R}^{3 \times 1024 \times 1024}$ space. The velocity field or score function would then be a function mapping a 3-million space to itself. That's almost impossible to do efficiently, even with our modern computing power. Indeed, one of the most impressive leaps of diffusion models (at least for image generation) was the very simple idea to diffuse noise in a latent space. This idea was introduced in the [LDM paper](...); this post, not really mathematical, gives a small account on how the latent spaces are chosen and what are the implications of working on these spaces. 

## LDM: simple autoencoders

## Bye-Bye U-NETS: Deeper Compression enables DiT scaling

## The SANA madness