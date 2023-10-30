+++
titlepost = "Gradient descent II: stochastic gradient descent for convex functions"
date = "October 2023"
abstract = "Stochastic Gradient Descent over strongly convex functions nearly behaves like gradient descent. "
+++

We are now interested in the minimization of a function $f$ assuming a very specific shape, namely 
$$ f(x) = \frac{1}{n}\sum_{i=1}^m f_i(x)$$
where the $f_i : \mathbb{R}^d \to \mathbb{R}$ are convex functions. This situation arises in many machine learning algorithms where we wish to minimize an empirical loss.

If $i$ is a uniformly chosen index in $\{1, \dotsc, d\}$, then the random variable $f_i(x)$ is an unbiased estimator of $f(x)$. This is the key to *stochastic gradient descent algorithms*: instead of going in the direction of the full gradient $\nabla f(x)$, which would require to evaluate the $d$ gradients $\nabla f_i(x)$ to get $\nabla f(x)$, we go in the direction of the partial gradient $\nabla f_i(x)$. This kind of methods fall within the framework defined long ago by [Robbins and Monro](https://en.wikipedia.org/wiki/Stochastic_approximation) and there is a vast litterature on the topic. However, it turns out that convexity-type assumptions on the $f_i$ already yield reasonnable convergence results; the results are similar to the [classical gradient descent result](/posts/gradient/). 

@@important
We recall that $f$ is $\eta$-strongly convex and $M$-smooth if 
\begin{equation}\label{convex} \langle \nabla f(x), y-x \rangle +  \frac{\eta}{2}|x-y|^2 \leqslant f(y) - f(x) \leqslant \langle \nabla f(x), y-x \rangle +  \frac{M}{2}|x-y|^2. \end{equation}
@@ 

In the sequel we will suppose that all the $f_i$ are $\eta$-strongly convex and $M$-smooth and it is easy to check that in this case, so is $f$. We will denote by $x$ the unique minimizer of $f$. At this point, $\nabla f(x)=0$. 

For all $n$, we set $i_n \sim \mathrm{Unif}\{1,\dotsc, d\}$. The SGD is given by the updates
$$ x_{n+1} = x_n - \varepsilon_n \nabla f_{i_n}(x_n).$$

@@deep
If all the $f_i$ are $\eta$-strongly convex and $M$-smooth, and if the step size $\varepsilon$ is smaller than $1/2M$, then
$$ \mathbb{E}[|x_n - x|^2] \leqslant (1 - \varepsilon \eta)^n |x_0 - x|^2 + \frac{2\varepsilon}{\eta}\sigma$$
where $\sigma$ is the *local variance of $f$ around the minimum*: 
$$\sigma = \mathbb{E}_{j \sim \mathrm{Unif}\{1, \dotsc, d\}}[|\nabla f_j(x)|^2].  $$
@@

What comes out of this theorem, compared with the [non-stochastic gradient descent](/posts/gradient/), is the $2\varepsilon\sigma / \eta$ term. Indeed, there can be no general convergence result for SGD since, even when $x_n = x$, the dynamics does not stop because there is no reason for $\nabla f_i(x)$ to be zero. However, the theorem says that eventually, $x_n$ stays within distance roughly $2\varepsilon / \eta$ of the minimizer $x$. 

## Proof 

By developing the square norm $|x_{n+1} - x|^2 = |x_{n+1} - x_n + x_n - x|^2$, we get
\begin{align}
|x_{n+1} - x|^2 = |x_n - x|^2 - 2\varepsilon\langle x_n - x, \nabla f_{i_n}(x_n)\rangle + \varepsilon^2 | \nabla f_{i_n}(x_n)|^2. 
\end{align}
Let us take expectations conditionnally on $x_n$; for simplicity we note $\mathbb{E}_n$ for the conditional expectation given all the information before timestep $n$. We have
$$\mathbb{E}_n[|x_{n+1} - x|^2 ]= |x_n - x|^2 - 2\varepsilon\langle x_n - x, \mathbb{E}_n[\nabla f_{i_n}(x_n)]\rangle + \varepsilon^2 \mathbb{E}_n[| \nabla f_{i_n}(x_n)|^2]. $$
 Since $\nabla f_{i_n}(x)$ is an unbiased estimator of $\nabla f_{i_n}(x)$, the term in the middle is equal to $-2\varepsilon\langle x_n - x, \nabla f(x_n)\rangle$. By \eqref{convex} applied to $x=x_n$ and $y = x$ (that's the same argument as for gradient descent).  
 $$ -2\varepsilon \langle \nabla f(x_n), x_n - x \rangle \leqslant 2\varepsilon(f(x) - f(x_n)) - \varepsilon\eta|x_n - x|^2$$
and we now have 
$$\mathbb{E}_n[|x_{n+1} - x|^2 ]\leqslant (1 - \varepsilon \eta) |x_n - x|^2 + z_n $$
where
 $$ z_n = - 2\varepsilon (f(x_n) - f(x)) + \varepsilon^2 \mathbb{E}_n[|\nabla f_{i_n}(x_n)|^2].$$ 
Bounding $z_n$ is not directly accessible due to the inherent randomness of the problem. However, we can bound $\mathbb{E}[z_n]$. The key technical lemma will be the following: 

@@important
For any $j$ uniform over $[d]$ and any $y$, 
\begin{equation}\label{main_lemma}
 \mathbb{E}[|\nabla f_j(y)|^2 ] \leqslant  4 M (f(y) - f(x)) + 2\sigma .
\end{equation}
@@ 

Now we can finish the proof of the main theorem: indeed, directly plugging this estimate into the definition of $\mathbb{E}[z_n]$ yields 
$$\mathbb{E}[z_n] \leqslant 2 \varepsilon^2 \sigma + \mathbb{E}[f(x_n) - f(x)]\times \left(4\varepsilon^2 M  - 2\varepsilon \right) $$
and since we took $\varepsilon < 1/2M$, we finally get $\mathbb{E}[z_n] \leqslant 2\varepsilon^2 \sigma$ and 
$$ \mathbb{E}[|x_{n+1} - x|^2] \leqslant (1 - \varepsilon \eta)\mathbb{E}[|x_n - x|^2] + 2\varepsilon^2 \sigma.$$

This is a classical recursion of the form $u_{n+1} \leqslant a u_n + b$. An easy recursion yields $ u_n \leqslant b(1-a^n)/(1-a) + a^n u_0  $, hence 
$$ \mathbb{E}[|x_n - x|^2] \leqslant\frac{2\varepsilon}{\eta}\sigma   + (1 - \eta \varepsilon)^n \mathbb{E}[|x_0 - x|^2] . $$

## Proof of the Lemma

Pick any $y$ and random index $j$ uniform over $[d]$. Then $|\nabla f_j(y)| \leqslant |\nabla f_j (y) - \nabla f_j(x)| + |\nabla f_j(x)|$. Using $(a+b)^2 \leqslant 2a^2 + 2b^2$ then averaging we get 
\begin{equation}\label{au2}\mathbb{E}|\nabla f_j(y)|^2 \leqslant 2\mathbb{E}|\nabla f_j (y) - \nabla f_j(x)|^2 + 2\mathbb{E}|\nabla f_j(x)|^2.\end{equation}
Since $\mathbb{E}\nabla f_i(x) = \nabla f(x) = 0$, the second term is $2\sigma_\star(f)$, giving the second term in \eqref{main_lemma}. Now, we have to bound the first term. This will come as a consequence of strong convexity and smoothness. 


@@important
**Lemma.** Any convex $M$-smooth function $g$ satisfies
\begin{equation}\label{au}
 g(x) - g(y) \leqslant \langle \nabla g(x), x-y\rangle  - \frac{1}{2M}|\nabla g(y) - \nabla g(x)|^2.
\end{equation}
@@ 

@@proof 
**Proof.** 
Indeed, let $x,y,z$ be any points; introducing $g(z)$ we have $g(x)-g(y) = g(x) - g(z) + g(z) - g(y)$. 

- The first term is smaller than $\langle \nabla g(x), x-z\rangle$ just by mere convexity. 
- By smoothness, $g(z) - g(y) \leqslant \langle \nabla g(y), z-y\rangle + M|z-y|^2/2$. 

We thus have 
$$g(x) - g(y) \leqslant  \langle \nabla g(x), x-z\rangle + \langle \nabla g(y), z-y\rangle + M|z-y|^2/2$$
and this upper bound is quadratic in $z$ so it's readily minimized; the minimum is attained at the point
$$z = y - \frac{\nabla g(y) - \nabla g(x)}{M}$$
and the corresponding value of the upper bound is \eqref{au}. 
@@

Apply the lemma to $g = f_j$: 
$$ |\nabla f_j(y) - \nabla f_j(x)|^2 \leqslant 2M(f_j(y) - f_j(x))  + 2M \langle \nabla f_j(x), x-y\rangle.$$
We now average over the random index $j$; the average of the upper bound is 
$$ 2M (f(y) - f(x)) + 2M \langle \nabla f(x), x-y\rangle = 2M(f(y) - f(x))$$
since $\nabla f(x) = 0$. Plugging this in \eqref{au2} gives \eqref{main_lemma}. 

# References

This proof was shamefully extracted from [the magnificient survey](https://arxiv.org/pdf/2301.11235.pdf) on gradient descent algorithms by Gower and Garrigos. 