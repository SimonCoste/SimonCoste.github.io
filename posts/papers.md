+++
titlepost = "Maths & ML Gems"
date = "2024"
abstract = "My personal curated list of old and recent outstanding papers in applied mathematics. "
+++

This is a list of wonderful papers in machine learning, reflecting my own tastes and interests. 

## Theoretical Stats/ML/DL
- [Least Squares Quantization in PCM](http://mlsp.cs.cmu.edu/courses/fall2010/class14/lloyd.pdf) by Stuart P Lloyd (1982 but he got the method twenty years earlier). Definition of Lloyd's algorithm for k-means clustering. 
- [The James-Stein paradox in estimation](http://www.stat.yale.edu/~hz68/619/Stein-1961.pdf) by Jamest and Stein, 1961. Sometimes, Maximum-likelihood is not the best estimator, even in a L2 world. 
- [Generalized Procrustes analysis](https://link.springer.com/article/10.1007/BF02291478) by Gower (1975)
- [Universal approximation theorem](https://link.springer.com/article/10.1007/BF02551274) by Cybenko (1989)
- [Compressed sensing paper](https://arxiv.org/pdf/math/0409186.pdf) by Candès, Romberg, and Tao (2006).
- [Scale Mixtures of Gaussians and the Stastistics of Natural Images](https://proceedings.neurips.cc/paper_files/paper/1999/file/6a5dfac4be1502501489fc0f5a24b667-Paper.pdf) by Wainwright and Simoncelli (1999).
- [Probabilistic PCA](https://www.di.ens.fr/~fbach/courses/fall2010/Bishop_Tipping_1999_Probabilistic_PCA.pdf) by Tipping and Bishop (1999). Lightweight generative model. 
- [Annealed importance sampling](https://link.springer.com/content/pdf/10.1023/A:1008923215028.pdf) by Radford Neal (2001). 
- [A computational approach to edge detection](https://ieeexplore.ieee.org/document/4767851) by John Canny (1986)
- [The Sparse PCA paper](https://hastie.su.domains/Papers/spc_jcgs.pdf) by Zou, Hastie, Tibshirani (2006).
- [The BBP transition](https://arxiv.org/abs/math/0403022) by Baik, Ben Arous, and Péché (2004). Probably the most important paper in random matrix theory. 
- [On spectral clustering](https://proceedings.neurips.cc/paper/2001/file/801272ee79cfde7fa5960571fee36b9b-Paper.pdf) by Ng, Jordan and Weiss (2001).
- [Hyvärinen's Score Matching paper](https://www.jmlr.org/papers/volume6/hyvarinen05a/hyvarinen05a.pdf) in 2005. 
- [Exact Matrix Completion via Convex Optimization](https://dl.acm.org/doi/pdf/10.1145/2184319.2184343) by Candes and Recht (2009). Matrix completion via optimization.
- [Matrix completion from a few entries](https://arxiv.org/pdf/0901.3150.pdf) by Keshavan, Montanari and Oh (2009). Matrix completion from SVD tresholding is (was ?) the go-to method for sparse matric completion. 
- [Adaptive mixtures of experts](https://www.cs.toronto.edu/~hinton/absps/jjnh91.pdf) by Jacobs et al. Introduces the famous MoE method. 
- [The NTK paper](https://arxiv.org/abs/1806.07572) by Jacot, Gabriel and Hongler (2018).
- [Density estimation by dual ascent of the log-likelihood](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=0XfFckgAAAAJ&citation_for_view=0XfFckgAAAAJ:L8Ckcad2t8MC) by Tabak and Vanden-Eijnden (2010), first definition of coupling layers for normalizing flows. 
- [Implicit regularization in deep networks](https://www.jmlr.org/papers/volume22/20-410/20-410.pdf) by Martin and Mahonney (2021). On the training dynamics of the hessian spectrum of DNNs. 
- [Edge of Stability paper](https://arxiv.org/abs/2103.00065) by Cohen et al. 
- [A U-turn on double descent](https://arxiv.org/abs/2310.18988) by Curth et al. 
  
- [Emergence of scaling in random networks](https://arxiv.org/pdf/cond-mat/9910332), the original paper by Barabasi and Albert (1999)
- [Error in high-dimensional GLMs](https://www.pnas.org/doi/full/10.1073/pnas.1802705116?doi=10.1073/pnas.1802705116) by Barbier et al. (2018)
- [Spectral algorithms for clustering](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.108.188701) by Nadakuditi and Newman, .from an RMT perspective
- [Spectral redemption in clustering sparse networks](https://www.pnas.org/doi/pdf/10.1073/pnas.1312486110) by Krzkala et al. (2013): classical versions of spectral clustering are failing for sparse graphs, but the authors show that a simple modification of the Laplacian matrix can lead to a successful clustering.
- [On Estimation of a Probability Density Function and Mode](https://projecteuclid.org/journals/annals-of-mathematical-statistics/volume-33/issue-3/On-Estimation-of-a-Probability-Density-Function-and-Mode/10.1214/aoms/1177704472.full), the famous kernel density estimation paper by Parzen (1962)
- [Power laws, Pareto distributions and Zipf’s law](https://arxiv.org/pdf/cond-mat/0412004.pdf), the survey by Newman on heavy-tails
- [Best subset or Lasso](https://www.stat.cmu.edu/~ryantibs/papers/bestsubset.pdf), by Hastie, Tibshirani and Friedman (2017)
- [Smoothing by spline functions](https://tlakoba.w3.uvm.edu/AppliedUGMath/auxpaper_Reinsch_1967.pdf), one of the seminal papers on spline smoothing, by Reinsh (1967)
- [Spline smoothing is almost kernel smoothing](https://sites.stat.washington.edu/courses/stat527/s14/readings/Silverman_Annals_1984.pdf), a striking paper by Silverman (1984), and [its generalization](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8611353) by Ong, Milanfar and Getreuer (2019). Global optimization problems (such as interpolation) can be approximated by local operations (kernel smoothing).
- [Tweediess formula and selection bias](https://efron.ckirby.su.domains/papers/2011TweediesFormula.pdf), a landmark paper by Bradley Efron. Tweedie's formula is key to many techniques in statistics, including diffusion-based generative models.  
  
## Deep Learning techniques and architectures

- [The ADAM optimizer](https://arxiv.org/abs/1412.6980) by Kingma and Ba (2014).
- [The BatchNorm paper](https://arxiv.org/abs/1502.03167) by Ioffe and Szegedy (2015).
- [The LayerNorm paper](https://arxiv.org/pdf/1607.06450) by Ba et al. (2016).
- [The Dropout paper](https://jmlr.org/papers/volume15/srivastava14a/srivastava14a.pdf) by Srivastava et al. (2014).
- [The AlexNet paper](https://proceedings.neurips.cc/paper/2012/file/c399862d3b9d6b76c8436e924a68c45b-Paper.pdf) by Krizhevsky, Sutskever, and Hinton (2012).
- [Normalizing flows](https://proceedings.mlr.press/v37/rezende15.pdf) by Rezende and Mohamed (2015). They're not so popular now, but the paper is really a gem. 
- [Invariant and equivariant graph networks](https://arxiv.org/pdf/1812.09902.pdf) by Maron et al. (2019). They compute the dimension of invariant and equivariant linear layers and study GNN expressivity. 
- [The original paper introducing generative diffusion models](https://arxiv.org/abs/1503.03585), by Sohl-Dickstein et al (2015)
- [The second paper of diffusions](https://arxiv.org/abs/2011.13456) by Song et al (2020)
- [The Stable Diffusion paper](https://openaccess.thecvf.com/content/CVPR2022/papers/Rombach_High-Resolution_Image_Synthesis_With_Latent_Diffusion_Models_CVPR_2022_paper.pdf) by Rombach et al (2021)
- [The Neural ODE paper](https://arxiv.org/abs/1806.07366) by Chen et al. (2018)
- [Attention is all you need](https://arxiv.org/abs/1706.03762), 2017. This paper changed the world.
- [Flow matching](https://arxiv.org/abs/2210.02747) by Lipman et al, 2022, the most elegant generalization of diffusion models. 
- [The data-driven Schrödinger bridge](https://onlinelibrary.wiley.com/doi/pdf/10.1002/cpa.21975) by Pavon, Tabak and Trigila (2021)
- [Language models are few-shot learners](https://proceedings.neurips.cc/paper_files/paper/2020/file/1457c0d6bfcb4967418bfb8ac142f64a-Paper.pdf) on LLM scaling laws
- [The Wasserstein GAN paper](https://proceedings.mlr.press/v70/arjovsky17a/arjovsky17a.pdf) by Arzovsky, Chintala and Bottou (2017)
- [YOLO](https://arxiv.org/abs/1506.02640), now at its 11th version!
- [Deep learning for symbolic mathematics](https://arxiv.org/pdf/1912.01412.pdf) by Lample and Charton (2019)
-  [The Convmixer paper](https://arxiv.org/abs/2201.09792): fitting a big convolutional network in a tweet.
-  [An image is worth 16x16 words](https://arxiv.org/abs/2010.11929), the original Vision Transformer paper by Dosovitskiy et al. (2020). The paper that started the revolution of transformers in computer vision.
- [Image Segmentation as rendering](https://arxiv.org/pdf/1912.08193)
- [Per-Pixel Classification is Not All You Need for Semantic Segmentation](https://arxiv.org/pdf/2107.06278)
- [Segment Anything](https://arxiv.org/pdf/2304.02643), the original paper on segmentation by Kirillov et al. (2023) which really pushed the field forward.

