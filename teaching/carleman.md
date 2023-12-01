@def title = "Probabilités mathématiques"
@def hascode = true


## Théorème de Carleman

L'objectif est de montrer que si une suite de variables $X_n$ est uniformément sous-gaussienne, c'est-à-dire s'il existe $C,c$ telles que pour tout $x$, 
$$\mathbb{P}(|X_n|>x)\leq Ce^{-cx^2}$$
alors la convergence en loi des $X_n$ et la convergence des moments sont équivalentes. 

Ce théorème (sous une forme plus forte) est dû à [Torsten Carleman](https://en.wikipedia.org/wiki/Torsten_Carleman), mathématicien suédois peu fréquentable. 

## Correction de l'exercice 12 du TD 7: le théorème de Carleman
\newcommand{\P}{\mathbb{P}}
\newcommand{\E}{\mathbb{E}}

On rappelle que si $X$ est positive alors 
\begin{equation}\label{1}\mathbb{E}X = \int_0^\infty \P(X>x)dx. \end{equation}

## a)

 En utilisant \eqref{1} on voit que 
\begin{align}\E|X_n|^k &= \int_0^\infty \P(|X_n|^k>x)dx \\ 
&= \int_0^\infty \P(|X_n|>x^{1/k})dx \\ 
&\leqslant \int_0^\infty Ce^{-cx^{2/k}}dx = A < \infty \end{align}
ce qui montre que les $X_n$ ont bien des moments à tous les ordres. 

Par ailleurs si l'on pose $f_n(x) = \P(|X_n|>x^{1/k}), f(x) = \P(|X|>x^{1/k})$ et $F_n(x) = \P(X_n \leqslant x), F(x) = \P(X\leqslant x)$ on voit que 

- sur $\mathbb{R}_+$ ces fonctions sont dominées par la fonction $Ce^{-x^{2/k}}$ qui est intégrable; 

- $f_n(x) = \P(X_n < -x^{1/k}) + \P(X_n > x^{1/k}) = \lim_{t\stackrel{<}{\to} -x^{1/k}}F_n(t) + 1 - F_n(x^{1/k})$. Or, comme $X_n$ converge en loi vers $X$, $F_n$ converge vers $F$ en tout point de continuité de $F$. Or, les points de discontinuité d'une fonction croissante sont au plus dénombrables, donc de mesure de Lebesgue nulle, donc $F_n \to F$ presque partout. On en déduit que $f_n \to f$ presque partout. 

Par le théorème de convergence dominée on a donc $\mathbb{E}|X_n|^k = \int_0^\infty f_n \to \int_0^\infty f = \mathbb{E}|X|^k$. De plus, comme $\E|X_n|^k \leqslant A$ pour tout $A$, on en déduit immédiatement que $\E|X|^k \leqslant A$ donc en plus, tous les moments de $X$ sont finis. 

Cela montre la convergence de tous les moments absolus, donc aussi de tous les moments d'ordre pair. Pour la convergence des moments impairs, on décompose en partie positive/négitave : $X_n = A_n - B_n$. En fait, $A_n = \sigma(X_n)$ avec $\sigma(x) = \max\{x,0\}$ et $\sigma$ est une fonction continue; or, si $X_n$ converge en loi, toutes les fonctions continues[^1] de $X_n$ aussi, donc $\sigma(X_n)$ converge en loi vers $\sigma(X)$ qui est la partie positive de $X$, et de même $B_n = X_n - \sigma(X_n)$ converge en loi vers la partie négative de $X$, notée $B$.  

Comme la partie positive et négative de $X_n$ sont également sous-gaussiennes avec les mêmes constantes, on applique ce qui a été vu plus haut; on en déduit que $\E[A^k_n] \to \mathbb{E}A^k$ et $\E B_n^k \to \E B^k$. Or, comme $k$ est impair, 
$$ \E X_n^k = \E [A_n^k - B_n^k]= \E[A_n^k] - \E[B_n^k] \to \E[A^k] - \E[B^k] = \E[X^k].  $$ 


## b)

### i) 

On a vu que comme les $X_n$ sont sous-gaussiennes, 

$$\E[|X_n|^{k+1}] \leqslant \int_0^\infty Ce^{-cx^{2/(k+1)}}dx. $$
En posant $y = cx^{2/(k+1)}$ cette borne devient 
\begin{equation}\label{2} Cc^{-(k+1)/2}\frac{k+1}{2} \int_0^\infty e^{-y}y^{(k-1)/2}dy = \frac{C(k+1)}{c^{k/2}\sqrt{c}2}\Gamma((k+1)/2) .\end{equation}
De plus la fonction $\Gamma$ vérifie la borne suivante: si $m\leqslant x < m+1$ avec $m$ entier alors par croissance $ \Gamma(x)\leq \Gamma(m+1) = m!\leq m^m\leq x^x$. Par conséquent \eqref{2} est plus petit que 
$$ \frac{C (k+1)}{c^{k/2}2\sqrt{c}}((k+1)/2)^{(k+1)/2}$$
et comme $(k+1)/2 \leq k$, tout ceci est plus petit que 
$$\frac{C}{2\sqrt{c}}\frac{k^{k/2 + 3/2}}{c^{k/2}}=  \frac{C}{2\sqrt{c}}(k/c)^{k/2} k^{3/2}$$
Par croissance comparée $k^{3/2} \leq (k/c)^{k/2}$ dès que $k$ est suffisamment grand, donc quitte à ajuster les constantes on voit qu'il existe $a$ tel que tout ceci est plus petit que $(ak)^{k/2}$ comme demandé. 

### ii) 

Par convergence dominée (pourquoi ?) on peut écrire que 
\begin{equation}\label{phi}\varphi_n(t) = \sum_{j=0}^\infty \frac{i^jt^j}{j!}\mathbb{E}X_n^j.\end{equation}
Par simplicité on ne regardera que les $t$ positifs, le cas négatif marche de la même manière. 

On coupe la somme à un $k$ entier et on borne brutalement le reste, qu'on notera $r=r(n,k,t)$: 
$$ |r(n,k,t)| \leq \sum_{j>k} \frac{t^{j+1}}{(j+1)!}(aj)^{j/2}.$$
On a $(j+1)!>j!$ et l'équivalent de Stirling dit que $j!>c j^j \sqrt{j}e^{-j}$. La constante ne jouant aucun rôle, on l'oublie (en fait cette inégalité est vraie pour tout $j$ pour $c=1$). Ainsi, le reste devient borné par 
\begin{align}
|r|&\leq \sum_{j>k}\frac{t[t \sqrt{a} \sqrt{j}]^j}{j^j \sqrt{j}e^{-j}}\\
&\leq t\sum_{j>k} \left(\frac{tae}{\sqrt{aj}}\right)^j \frac{1}{\sqrt{j}} \\
&\leq t\sum_{j>k} \rho_j^j 
\end{align}
où, à la dernière ligne, j'ai utilisé $1/\sqrt{j}\leq 1$ et j'ai posé $\rho_j = tae / \sqrt{ja}$. Dès que $k$ est plus grand que $4t^2 a e$ on voit que $\rho_j < \rho_k \times (1/2)^{j-k}$.  Par conséquent la borne ci-dessus devient plus petite que $t\rho_k^k (1 - 1/2)^{-1} = 2t\rho_k^k$ (série géométrique de raison 1/2). Or, 
$$ 2t\rho_k^k = 2t\left(\frac{tae}{\sqrt{ak}}\right)^k = t^{k+1}(ak)^{-k/2} (ae)^k = t^{k+1}(bk)^{-k/2}$$
où $b$ est une nouvelle constante, $b=1/ae^2$ (si on veut exactement l'énoncé de l'exercice, on met $(ae)^k$ dans la constante du $O(...)$. 

### iii) 

On fixe $t$ et $k$, on a 
$$ \varphi_n(t) = \sum_{j=0}^k \frac{i^jt^j}{j!}\mathbb{E}X_n^j + r(n,k,t). $$
 
Comme les $\E X_n^j$ convergent vers $\E X^j$,on voit que $\E X^{j+1}\leq (aj)^{j/2}$. L'analyse faite à la question ii) est donc encore valable pour $X$, en particulier 
$$ \varphi(t) = \sum_{j=0}^k \frac{i^jt^j}{j!}\E X^j + r'(k,t) $$
où $|r'(k,t)| \leq t^{k+1} (bk)^{-k/2}$. 

On en déduit que 
$$ |\varphi_n(t) - \varphi(t)| \leq \sum^k_0 \frac{t^j}{j!}|\E X_n^j - \E X^j| + |r| + |r'|.$$

Pour conclure, il faut faire attention à l'ordre dans lequel on prend les limites. On fixe d'abord $t$ et on choisit $\epsilon$. Comme $r$ et $r'$ tendent vers 0 quand $k\to \infty$ on choisit un $k$ très très grand pour que $|r| + |r'| \leq \epsilon/2$. Ensuite  on fait  $n\to \infty$ et le premier terme tend vers 0, donc il est plus petit que $\epsilon/2$. 

In fine, on obtient bien que $|\varphi_n(t) -  \varphi(t)| \to 0$, donc il y a convergence en loi.  


[^1] pas forcément bornées !