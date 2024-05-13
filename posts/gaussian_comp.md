+++
titlepost = "Quadratic exponentials of Gaussian random vectors"
date = "2024"
abstract = "Computation of E[exp(q(X))] where q is quadratic and X is gaussian. "
+++

The goal of this note is to gather some elementary facts on integrals of the form, say, $\mathbb{E}[e^{\lambda X^2}]$ where $X$ is a Gaussian random variable. These kind of integrals arise in many situations: for instance, in the Laplace transform of chi-square distributions. I'll cover the one-dimensional case first, then the multi-dimensional case.

## The one-dimensional case

We recall the fundamental Gaussian integral, valid for $\lambda >0$:
\begin{equation}\label{0} \int_{-\infty}^{\infty} e^{-\lambda t^2/2}dt = \sqrt{\frac{2\pi}{\lambda}}. \end{equation}
@@important
Let $X \sim N(0,1)$. Then, for any real numbers $a,b,c$,  $\mathbb{E}[e^{\frac{aX^2+bX+c}{2}}] = +\infty$ if $a\geq 1$, and otherwise
\begin{equation}\label{1d}\mathbb{E}[e^{\frac{aX^2+bX+c}{2}}] = \frac{\exp\left(\frac{c}{2} + \frac{b^2}{8(1-a)}\right)}{\sqrt{1-a}}.\end{equation}
@@

@@proof
**Proof.**
Set $q(x) = ax^2+bx+c$. Then, $\mathbb{E}[e^{q(X)/2}]$ is equal to 
\begin{equation}\label{1} \frac{1}{\sqrt{2\pi}}\int e^{-\frac{t^2}{2} + \frac{at^2+bt+c}{2}}dt,\end{equation}
which obviously diverges iff $a\geq 1$. Otherwise, simple algebraic manipulations show that 
$$ \frac{(a-1)t^2}{2}+\frac{bt}{2}+\frac{c}{2} = -\frac{\gamma}{2}\left(t-\frac{b}{2\gamma}\right)^2  +\frac c 2 + \frac{b^2}{8\gamma}$$
where $\gamma = 1-a>0$. Plugging this into \eqref{1} yields
$$e^{c/2 + b^2/8\gamma}\int e^{-\frac{1}{2}\gamma\left(t-\frac{b}{2\gamma}\right)^2}dt$$
which, after changing variables $t-b/2\gamma$ into $s$, then using \eqref{0} and replacing $\gamma$ by its value $1-a$, gives exactly \eqref{1d}. 
@@

We now list a few consequences of this formula. 

**Laplace transform of a chi-square distribution**: $$\mathbb{E}[e^{-\lambda X^2}]=\frac{1}{\sqrt{1 + 2\lambda}}. $$
**Analytic continuation.** Take $b=c=0$ for simplicity. The function $1/\sqrt{1-z}$ is defined for any $z$ not in $[1,+\infty)$ if we use the principal branch of the Logarithm. But outside of this set, the formula remains valid, and thus we can compute $\mathbb{E}[e^{zX^2/2}] = (1 - z)^{-1/2}$ for any $z \in \mathbb{C}\setminus [1,+\infty)$. Of course, proving that $\mathbb{E}[e^{zX^2/2}]$ is holomorphic on this domain is a bit more delicate.

**Fresnel integral.** Taking $b=c=0$ and $a=1+2i$ (which is not in $[1,+\infty[$ as requested) we see that 
$$ \mathbb{E}[e^{aX^2 / 2}] = \frac{1}{\sqrt{2\pi}}\int e^{it^2}dt.$$
The value of the LHS was proven to be $1 / \sqrt{-2i} = (1+i)/2$. We thus get $ \int e^{it^2}dt = (1+i)\sqrt{\pi /2}$. 
In particular, we recover the famous [Fresnel integral](https://en.wikipedia.org/wiki/Fresnel_integral) 
$$\int_0^\infty \sin(t^2)dt = \int_0^\infty \cos(t^2)dt = \frac{\sqrt{\pi/2}}{2} = \sqrt{\frac{\pi}{8}}.$$



## The multi-dimensional case

For simplicity, in this case we'll only consider standard Gaussians. The general formula can nonetheless be derived using the same proof, see right after the proof. 

@@important

Let $X \sim N(0,I_d)$ and let $A$ be a real symmetric matrix. Then, $\mathbb{E}[e^{\frac{1}{2}\langle X, AX\rangle}]$ diverges if $\lambda_{\max}(A)\geq 1$, and otherwise 
$$\mathbb{E}[e^{\frac{1}{2}\langle X, AX\rangle}] = \sqrt{\det(I_d-A)^{-1/2}}.$$
@@

@@proof 
The proof is trivial once we have the one-dimensional case : since $A = UDU^*$ and $UX$ has the same distribution as $X$, we can write $\langle X, AX\rangle$ as a sum of $\lambda_i \xi_i^2$ where the $\lambda_i$ are the eigenvalues of $A$ (all of which are smaller than $1$ by assumption) and the $\xi_i$ are i.i.d. 
@@ 

**General formula.**
Now if $\mu$ was to be nonzero, one could write $X = \mu+Y$ with $Y \sim N(0,I_d)$, and then develop:
$$\langle X, AX\rangle = \langle \mu, A\mu\rangle + 2\langle A\mu, Y\rangle + \langle Y, AY\rangle.$$
Set $A = U^* DU$ and $Z = UY$. Then, $Z \sim N(0,I_d)$ and
$$\mathbb{E}[e^{\frac{1}{2}\langle X, AX\rangle}] = e^{\frac{1}{2}\langle \mu, A\mu\rangle}\mathbb{E}[e^{\frac{1}{2}(\langle Z, DZ\rangle+ 2\langle U^* A \mu, Z \rangle)}] = e^{\frac{1}{2}\langle \mu, A\mu\rangle}\prod_{i=1}^d \mathbb{E}[e^{\frac{\lambda_i}{2}Z_i^2 + 2b_i Z_i}]$$
where we introduced $b = U A \mu$. Using the first result, we get
$$\mathbb{E}[e^{\frac{1}{2}\langle X, AX\rangle}] = e^{\frac{1}{2}\langle \mu, A\mu\rangle}\prod_{i=1}^d \frac{e^{\frac{b_i^2}{8(1-\lambda_i)}}}{\sqrt{1-\lambda_i}}.$$

**Chi-square, again.** If $X \sim N(0,I_d)$, then $Y:=|X|^2 \sim \chi^2(d)$, and we recover the Laplace transform of a chi-square distribution $Y$ with $d$ degrees of freedom:
$$\mathbb{E}[e^{-\lambda Y}] = \left(\frac{1}{1+2\lambda}\right)^{\frac{d}{2}}.$$