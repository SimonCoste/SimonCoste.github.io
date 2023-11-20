+++
titlepost = "Kesten's theorem on affine recursions"
date = "November 2023"
abstract = "The solutions of the distributional equation X = AX+B can have heavy tails: a sketch of proof, plus a presentation of the Renewal theorem. "
+++

### Motivation: ARCH models

In 2003, [Robert F. Engle](https://en.wikipedia.org/wiki/Robert_F._Engle) won the Nobel prize in economy for his innovative methods in time-series analysis; to put it sharply, Engle introduced ARCH models into economics. In his [seminal 1982 paper](http://www.econ.uiuc.edu/~econ508/Papers/engle82.pdf)  (30k+ citations), he wanted to model the time-series $(y_t)$ representing the inflation in the UK. Most previous models used a simple autoregressive model of the form $y_{t+1} = \alpha y_t + \varepsilon_t$, where $\varepsilon_t$ is an external Gaussian noise with variance $\sigma^2$ and $\alpha<1$ a "forgetting" parameter. The problem with these models is that the variance of the inflation at time $t+1$ knowing the inflation at time $t$, that is $\mathrm{Var}(y_{t+1}|y_t)$, is simply the variance of $\mathrm{Var}(\varepsilon_t)=\sigma^2$, which does not depend on $y_t$. 

Engle wanted a model where the conditional variance would depend on $y_t$: there are good reasons to think that volatility is sticky. The model he came up with (equations (1)-(3) in his paper) is simply 
\begin{align}\label{garch0}
&y_{t+1} = \varepsilon_t \times \sqrt{\alpha + \beta y_t^2} .
\end{align}
In other words, the variance of $y_{t+1}$ given $y_t$ is $\alpha + \beta y_t^2$. This is the simplest of Auto-Regressive Conditionally Heteroscedastic (ARCH) models. Upon squaring everything in \eqref{garch0}, the equation becomes \begin{equation}\label{garch}y_{t+1}^2 = \alpha \varepsilon^2_t + \beta \varepsilon_t^2 y_t^2.\end{equation} 

This is a linear recursion in $y_t^2$. In the paper, Engle introduced a few variations and crafted statistical methods to estimate the parameters and their significance. 



@@important
A central question in this way of modelling things is: **how does $y_n$ behave in the long term?** 
Does $y_n$ stay stable, can it take extremely large values (crises, shocks and crashes), and if so, at which frequency? 
@@ 



If $y_t^2$ converges in distribution towards a random variable $Y$, then \eqref{garch} shows that $Y$ and $\alpha \varepsilon^2 + \beta \varepsilon^2 Y$ must have the same probability distribution, where $\varepsilon$ is an $\mathscr{N}(0,\sigma^2)$, independent of $Y$. This is an instance of a very general kind of equations, called *affine distributional equations*: they are equations of the form $$Y \stackrel{\mathrm{law}}{=} AY+B$$ where $A,B$ are random variables independent of $Y$. It turns out that these equations are generally impossible to solve. However, a theorem of Harry Kesten states, perhaps not so intuitively, that the law of any solution must have a heavy tail: in contrast with, say, Gaussian distributions, for which taking extremely large values (« shocks ») has an exponentially small probability, heavy-tailed distributions can take large values with *polynomially small* probability, which is… not so rare at all! 


Here is a small simulation over $10^6$ periods of time and parameters $\alpha=0.1, \beta=1, \sigma = 0.1$. The histogram indicates that $y(t)$ seems to have heavy tails, that is, the probability of observing a unusually large value is polynomially small (and not exponentially small). 




![](/posts/img/arch.png)


@@deep 
This is one of Kesten's most famous results, [published in 1973 in Acta Mathematica](https://scholar.google.com/scholar_lookup?title=Random%20difference%20equations%20and%20renewal%20theory%20for%20products%20of%20random%20matrices&publication_year=1973&author=H.%20Kesten). 

![](/posts/img/kesten_article.png)


@@ 

## Kesten's theorems

From now on, we'll study the solutions of the equation
\begin{equation}\label{rec}
X \stackrel{\mathrm{law}}{=} AX+B
\end{equation}
where $X$ is a random variable over $\mathbb{R}^d$, $A$ is a random matrix and $B$ a random vector, both independent of $X$. The goal is to present Kesten's theorem, which states that on certain conditions on $A$ and $B$, the solution $X$ must have heavy tails; that is, $\mathbb{P}(X>x)$ decreases polynomially fast, and not exponentially fast as for Gaussian variables. This result is somehow mind-blowing in its precision, since we have access to the exact tail exponent. 

A full, rigorous proof would be packed with technicalities; I'll only show a simili-proof in dimension $1$, which, although not being complete, was sufficiently clear and idea-driven to convince me that Kesten's result holds. I'm also including a simili-proof of the Renewal theorem, which might be of independent interest. 

### One-dimensional case

For simplicity, we restrict to the case where $A,B$ are independant and have a density with respect to the Lebesgue measure. In general, it is not obvious that solutions to \eqref{rec} exist, but a former result by Kesten states that it is the case if $\mathbb{E}[\ln |A|]<\infty$. 
@@deep 
**Kesten's theorem (1973).**

(i) Assume that $A>0$ almost surely and that there is an $s>0$ such that \begin{align}\label{condition}&\mathbb{E}[|A|^s]=1, &&\mathbb{E}[|A|^s (\ln |A|)_+]<\infty, &&\mathbb{E}[|B|^s]<1.\end{align}
Then, there are two constants $c_\pm$ such that when $x\to \infty$, 
\begin{align}&\mathbb{P}(X>x)\sim c_+ x^{-s},&&&\mathbb{P}(X<-x) \sim c_- x^{-s}.\end{align}
(ii) The same result holds if $A$ can take positive and negative values, and in this case $c_+ = c_-$. 
@@

### Sketch of proof in the 1d case

I'll only sketch the proof ideas in the subcase of (i) where in addition, $B$ is nonnegative. In this case, we can safely assume that $X$ is nonnegative by conditionning over the set $\{X>0\}$. We set $f(x) = e^{sx}\mathbb{P}(X > e^x)$; our final goal is to prove that $f(x)$ converges towards some constant when $x\to+\infty$, the $-\infty$ case being identical. 

The recursion \eqref{rec} shows that $f(x) = e^{sx}\mathbb{P}(AX + B > e^x)$. However, if $x$ is very large, we could guess that $\mathbb{P}(AX + B > e^x)$ is close to $\mathbb{P}(AX > e^x)$. This is the origin of the **first trick** of the proof, which is to artificially write  
\begin{align} f(x) &= e^{sx}(\mathbb{P}(AX+B>e^x) - \mathbb{P}(AX>e^x)) + e^{sx}\mathbb{P}(AX>e^x). \end{align}
Let us note $g$ the first term on the right: $$g(x)=e^{sx}(\mathbb{P}(AX+B>e^x) - \mathbb{P}(AX>e^x)).$$ For the second term, we can express it in terms of $f$ by using $\mathbb{E}[A^s]=1$:
\begin{align}  e^{sx}\mathbb{P}(X>e^{x - \ln A}) &=  \mathbb{E}[A^s e^{s(x-\ln(A))}\mathbf{1}_{X>e^{x - \ln A}}]. 
\end{align}
Now, here comes the **second trick**: the change of measure. We assumed that $\mathbb{E}[A^s]=1$, hence we can define a probability distribution by $\mathbb{E}_s[\varphi] = \mathbb{E}[A^s \varphi]$, and the expression above becomes $\mathbb{E}_s[f(x- \ln A)]$. 
Overall, we obtain that $f$ is a solution of the following equation: 
@@important
\begin{equation}\label{renewal}\forall x \geqslant 0, \qquad f(x) = g(x) + \mathbb{E}_s[f(x - \ln A)].\end{equation}
@@
If $\mu_s$ is the density of $\log A$ under the measure $\mathbb{P}_s$, this equation becomes $f(x) = g(x) + f\star \mu(x)$ where $\star$ denotes the convolution operator. Such equations are called *convolution equations* and they can be studied using classical probability theory. The main result of Renewal Theory, exposed later below, shows that 
- **if $g$ is  « directly Riemann integrable »**; 
- and if $\mathbb{E}_s[\ln A]>0$, which is the same thing as $\mathbb{E}[A^s \ln(A)]>0$;
then there is only one solution to this equation, and more crucially it satisfies 
$$\lim_{x\to \infty}f(x) = \frac{\int_0^\infty g(u)du}{\mathbb{E}_s[\ln A]} = \frac{\int_0^\infty g(u)du}{\mathbb{E}[A^s \ln A]}=:c.$$
If $\mathbb{E}[A^s \ln A]>0$, as we assumed, then $c>0$, because $g$ is a nonzero positive function so its integral is nonzero. Consequently, 
$$ \lim_{x\to \infty}e^{sx}\mathbb{P}(X>e^x) = c.$$
This is equivalent to $\mathbb{P}(X>x) \sim cx^{-s}$, as requested. There is, however, a serious catch: to apply the main Renewal theorem we need to check the two conditions listed above. The second one is nothing but an assumption. However, the first one needs $g$ to be "directly Riemann integrable", which is indeed very difficult to check. I won't do this part *at all*[^1]. 

### Multi-dimensional case

In the multi-dimensional case, a similar theorem holds. One can find in the litterature a host of different settings regarding the random matrix $A$ and the random vector $B$; for simplicity I'll stick to the case where $A$ is positive definite almost surely, $B$ has all entries nonnegative almost surely, and $A,B$ have densities with respect to the Lebesgue measure. The multi-dimensional analogue of $\mathbb{E}[|A|^s]$ will now be 
\begin{align}h(a) = \lim_{n\to\infty}\mathbb{E}[\ln \Vert A_1 \times ... \times A_n \Vert^a]^\frac{1}{n}\end{align}
where $\Vert M \Vert$ is the operator norm. We also introduce the Lyapounov exponent, which is the equivalent of $\mathbb{E}[\ln |A|]$:
$$ \gamma = \lim_{n\to \infty}\frac{1}{n}\mathbb{E}[\ln \Vert A \Vert].$$

@@deep 
**Kesten's theorem in any dimension.** 
Assume that $\gamma<0$ and that there is an $s>0$ such that 
\begin{align}&h(s)=1, && \mathbb{E}[\Vert A \Vert^s (\ln \Vert A \Vert)_+]<\infty, && \mathbb{E}[|B|^s]<\infty.\end{align} Then, solutions of \eqref{rec} exist, and $X$ is heavy-tailed in any direction; in other words, for any nonzero $u\in \mathbb{R}^n$, there is a constant $c(u)>0$ such that 
$$ \mathbb{P}(\langle u, X\rangle > x) \sim c(u)x^{-s}.$$
@@
The proof is much more technical without any new ideas. 

## Renewal theory in less than one page

Let $\mu$ be a continuous probability distribution on $\mathbb{R}_+$. Our goal is to show how *renewal theory* can be used to study convolution equations, represent their solutions with a probabilistic model, and draw consequences on their asymptotic behaviour. We are interested in finding $f$ such that
\begin{equation}\label{conveq}f(x) = g(x) + \int f(x-u) \mu(du)\end{equation}
where $g$ is some function. Noting $f\star \mu(x) = \int f(x-u)\mu(du)$, we recognize a convolution between the function $f$ and the measure $\mu$, and the equation is simply $f - \mu \star f = g$. Upon noting $U$ a random variable with distribution $\mu$, we can also represent this equation as 
$$ f(x) = g(x) + \mathbb{E}[f(x-U)].$$
But if this equation is satisfied for some $f$, then plugging it into $f(x-U)$ yields
\begin{align}f(x) &= g(x) + \mathbb{E}[g(x-U) + \mathbb{E}[g(x - U - U')]] \\ 
&= g(x) + \mathbb{E}[g(x-U)] + \mathbb{E}[g(x - U - U')] + \mathbb{E}[g(x-U-U'-U'')]
\end{align}
and so on, with $U,U',U''...$ iid copies of $U$. The following theorem follows by iterating this trick infinitely. 
@@important
**Representation theorem.** Let $U_i$ be iid random variables with distribution $\mu$, and let $S_0=0$ and $S_n = U_1 + \dotsb + U_n$ be the associated random walk. Then, if $g$ is either nonnegative the unique solution of \eqref{conveq} is given by 
\begin{equation}\label{sol}f(x) = \mathbb{E}\left[ \sum_{n=0}^\infty g(x-S_n)\right].
\end{equation} 
@@ 

The name "renewal process" comes from the fact that the $S_n$ are considered as occurence times of events. The $U_i$ are thus waiting times between the events. Renewal theory is interested in processes like $N_t= $ the number of events before time $t$.  
@@proof
**Proof of the representation theorem.**
First, note that \eqref{sol} is well-defined since $g$ is nonnegative. It can possibly be $\infty$. Now, for unicity, we consider another solution $f'$ of \eqref{conveq}; the difference $\delta = f-f'$ is a solution of $\delta = \delta \star \mu$. But then the Laplace transforms would satisfy $\hat\delta = \hat\delta \hat\mu = \hat\delta \hat\mu^2 = ... = \hat\delta (\hat\mu)^n$ and so on. This is not possible: since $\hat \mu(x) = \int_0^\infty e^{-xu}\mu(du)<1$ (as long as $x>0$ and $\mu$ is diffuse) we would have $\hat\delta (x) = 0$ for any $x>0$. 
@@ 
It is quite rare that the representation theorem yields the explicit solution $f$. One would need to compute the expectation of the series, which is most cases can be tedious. But this representation gives access to the whole toolbox of limit theorems in probability, and in particular, laws of large numbers, which translate into exact asymptotics for $f$. That's the **key renewal theorem**. 
@@deep 
**Renewal theorem I (Blackwell's version).** For any $a>0$, 
\begin{equation}\label{I}\lim_{x\to \infty}\mathbb{E}[N_{t+a}] - \mathbb{E}[N_t]  = \frac{a}{\mathbb{E}[U]}.\end{equation}
**Renewal theorem II (Ultimate version).** If $g$ is « directly Riemann integrable », then the solution of \eqref{conveq} satisfies 
\begin{equation}\label{rt}\lim_{x\to\infty}f(x) = \frac{\int_0^\infty g(u)du}{\mathbb{E}[U]}\end{equation}
where $U$ has distribution $\mu$. 
@@ 

- « Directly Riemann integrable » is the true equivalent of « Riemann integrable », but for functions defined over $\mathbb{R}$ or the half-line. It states that the Riemann sums *over the whole domain* (they are indeed series, not sums, in contrast with the classical definition) converge toward the same limit.  
- The intuition is pretty clear. In Blackwell's version, $\mathbb{E}[N_{t+a} - N_t]$ is nothing but the number of $S_n$ in the interval $[t,t+a]$. If the size of each jump is roughly $\mathbb{E}[U]$ then the number of jumps in this interval should be proportional to the length of the interval divided by $\mathbb{E}[U]$; Blackwell's theorem says that this is true when $t\to\infty$. Note that in this case $g=\mathbf{1}_[-a,0]$ and $\int g(u)du = a$. 
- By linearity, Blackwell's version extends to \eqref{rt} at least for piecewise constant functions with bounded support. To extend to wider functions, a limiting argument is needed, and this is where direct Riemann integrability comes into play. 
- We can very well have $\mathbb{E}[U] = \infty$ in this theorem but for simplicity I'll stick to the finite case. 
- The theorem is also valid when $U$ is not necessarily positive, but on the condition that $\mathbb{E}[U]>0$. This version is due to [Athreya et al. (1978)](https://projecteuclid.org/journals/annals-of-probability/volume-6/issue-5/Limit-Theorems-for-Semi-Markov-Processes-and-Renewal-Theory-for/10.1214/aop/1176995429.full). 
- A full, readable proof can be found in [Asmussen's book](https://link.springer.com/book/10.1007/b97236). I'll probably write a note on this topic, some day. 

## References 



- [Kesten's original paper](https://scholar.google.com/scholar_lookup?title=Random%20difference%20equations%20and%20renewal%20theory%20for%20products%20of%20random%20matrices&publication_year=1973&author=H.%20Kesten), really hard to read. 

- [Goldie's paper](https://projecteuclid.org/journals/annals-of-applied-probability/volume-1/issue-1/Implicit-Renewal-Theory-and-Tails-of-Solutions-of-Random-Equations/10.1214/aoap/1177005985.full), which both simplified and generalized Kesten's proof (the proof in this note is Goldie's). Hard to read too.

- [ARCH models by Engle](http://www.econ.uiuc.edu/~econ508/Papers/engle82.pdf). 

- [An excellent book on the topic](https://www.google.com/search?q=buraczewski+damek&oq=buraczewski+damek&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQLhhA0gEINDI1NWowajGoAgCwAgA&sourceid=chrome&ie=UTF-8) by Buraczewski, Damek and Mikosch. This is where I learned the proof of Kesten's theorem. It's very well written. 

- [Another excellent book with a chapter on the Renewal Theorem](https://link.springer.com/book/10.1007/b97236), by Asmussen. 


[^1]: indeed, there's a catch. It is not possible to directly prove that $g$ is directly Riemann integrable. Instead, what Goldie did is that he mollified the problem by convoluting $g$ with a mollifier $\rho_\delta$, proved the equivalent for this version, then sent $\delta$ to zero. 