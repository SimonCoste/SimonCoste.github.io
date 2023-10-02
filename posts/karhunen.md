+++
titlepost = "Mouvement brownien dans une base orthonormale"
date = "Septembre 2023"
abstract = "Construction de Karhunen-Loève"
+++

Un mouvement brownien est une fonction réelle $B$ sur $[0,1]$, aléatoire, gaussienne (au sens où toutes les marginales sont conjointement gaussiennes), centrée, et de covariance $\mathbb{E}[B_s B_t] = \min(s,t)$. Dans XXX j'ai expliqué comment on pouvait construire un mouvement brownien en s'aidant d'une base orthonormale; pour résumer, si $(\varphi_n)$ est une base orthonormale de $L^2$ bien choisie, alors la série 
$$ B_t = \sum_{n=0}^\infty X_n \int_0^t \varphi_n(u)\mathrm{d}u$$
converge presque sûrement et c'est un mouvement brownien. Lorsque $\varphi_n$ est la base de Haar, on retombe exactement sur la construction de Paul Lévy. Le problème de cette construction, c'est qu'elle ne donne pas la décomposition de $B$ dans cette base! En effet, même si les fonctions $\varphi_n$ forment une base, les fonctions 
$$ t\mapsto \int_0^t \varphi_n(u)\mathrm{d}u$$
n'en forment pas une en général. Pourtant, comme $B$ est une fonction continue et a fortiori $L^2$, elle possède des coefficients dans cette base: on doit pouvoir écrire 
$$ B_t = \sum_n Y_n \varphi_n(t)$$
où $Y_n = \langle B, \varphi_n\rangle$. Le problème, c'est que ces $(Y_n)$ ne sont maintenant plus indépendants… On aimerait quand même bien pouvoir spécifier un mouvement brownien directement dans une base d'ondelettes. C'est ce que fait la décomposition de Karhunen-Loève. 

## 

On veut construire un processus gaussien centré avec fonction de covariance $\mathbb{E}[B_s B_t] = K(s,t)$. Dans le cas du mouvement brownien, $K(s,t) = s\wedge t$, mais la construction fonctionne pour tous les noyaux. 

@@important
Si $K \in L^2$, il existe une base $(e_n)$ et des nombres positifs $\lambda_n$ tels que 
$$ K(s,t) = \sum_{n=0}^\infty \lambda_n e_n(x)e_n(y)$$
et tels que $\sum \lambda_n = |K|_2 <\infty$. 

Les $(e_n), (\lambda_n)$ sont les valeurs propres et fonctions propres associées à l'opérateur à noyau $f\mapsto K*f$ où $$K*f(s) = \int K(s,t)f(t)dt,$$
c'est-à-dire qu'elles vérifient les équations propres 
$$ \lambda_n e_n(t) = \int_0^1 K(s,t)e_n(t){\rm d}t.$$ 
@@

Il suffit alors de poser 
\begin{equation}
B_t = \sum_{n=0}^\infty X_n \sqrt{\lambda_n} e_n(t)
\end{equation}
pour obtenir un processus gaussien de covariance $K$. Cette construction s'appelle *construction de Karhunen-Loève*. 

@@proof **Démonstration.** On remarque déjà que $\mathbb{E}\sum X_n^2 \lambda_n = \sum \lambda_n = |K|_2 < \infty$, donc la somme est finie presque sûrement et $B$ est bien défini. Le fait qu'il soit centré est évident. Pour sa covariance, on a 
$$ \mathbb{E}B_t B_s = \sum_{n,m}\sqrt{\lambda_n \lambda_m}\mathbb{E}[X_n X_m] e_n(s)e_m(t) = \sum \lambda_n e_n(s)e_n(t) = K(s,t).$$

Cela répond donc au problème. 
@@

Évidemment, toute la difficulté consiste à calculer la base qui diagonalise l'opérateur à noyau $f \mapsto K * f$. 

## Calcul dans le cas du brownien 

On cherche les valeurs propres et fonctions propres de l'opérateur intégral 
$$ f\in L^2 \mapsto K \star f: s \mapsto \int K(s,t)f(t)\mathrm{d}t = \int_0^1 (s\wedge t) f(t){\rm d}t,$$
c'est-à-dire un couple $\lambda,\phi$ tel que 
$$\lambda \phi(s) = s\int_0^s\phi(t){\rm d}t + \int_s^1 t \phi(t){\rm d}t = \int_0^s t \phi(t)dt + s\int_s^1 \phi(t)dt.$$ 
Si cette identité est vraie et si l'on suppose $\phi$ deux fois dérivable, on obtient les équations 
$$ \lambda \phi'(s) = s \phi(s) + \int_s^1 \phi(t)dt - s \phi(s) = \int_s^1 \phi(t)dt$$
puis en re-dérivant
$$ \lambda \phi''(s) = -\phi(s)$$
donc $\phi$ est un sinus ou un cosinus avec fréquence $\sqrt{\lambda}$. On voit déjà que $\lambda$ ne peut pas être nul. Comme manifestement XXX implique que $\phi(0) = 0$, c'est un sinus: $\phi(s) = c_\lambda\sin(\sqrt{\lambda}s)$ pour une constante $c_\lambda$. On peut déterminer cette dernière par normalisation puisque $\int |\phi|^2 = 1$. L'orthogonalité implique aussi que 
$$ \int_0^1 \sin(\sqrt{\lambda}s)\sin(\sqrt{\mu}s)ds = 0$$

La solution est donnée par 
$$ \lambda_n = \frac{1}{\left(\left(n-\frac{1}{2}\right)\pi\right)^2} \qquad n\in \mathbb{N}^*$$
et les fonctions propres sont
$$ \varphi_n(t) = \sqrt{2}\sin\left(\left(n-\frac{1}{2}\right)\pi t\right).$$
On obtient donc 
$$B_t = \sum_{n=1}^\infty \frac{\sqrt{2}X_n}{\left(n-\frac{1}{2}\right)\pi}\sin\left(\left(n-\frac{1}{2}\right)\pi t\right) $$
où les $(X_n)$ sont des gaussiennes standard iid. 