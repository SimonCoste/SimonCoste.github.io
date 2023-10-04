+++
titlepost = "Mouvement brownien II 📈📈: représentation de Karhunen-Loève"
date = "Octobre 2023"
abstract = "Cette fois on construit un mouvement brownien directement dans une base orthonormale et pas implicitement comme dans la construction de Paul Lévy. "
+++

Un mouvement brownien est une fonction réelle $B$ sur $[0,1]$, aléatoire, gaussienne (au sens où toutes les marginales sont conjointement gaussiennes), centrée, et de covariance $\mathbb{E}[B_s B_t] = \min(s,t)$. Dans [cette note](/posts/brownian/) j'ai expliqué comment on pouvait construire un mouvement brownien en s'aidant d'une base orthonormale; pour résumer, si $(\varphi_n)$ est une base orthonormale de $L^2$ bien choisie, alors la série 
$$ B_t = \sum_{n=0}^\infty X_n \int_0^t \varphi_n(u)\mathrm{d}u$$
converge uniformément (ps) et c'est un mouvement brownien. Lorsque $(\varphi_n)$ est la base de Haar, on retombe exactement sur la construction de Paul Lévy. **Le problème de cette construction, c'est qu'elle ne donne pas la décomposition de $B$ dans cette base!** En effet, même si les fonctions $(\varphi_n)$ forment une base, les fonctions 
$$ t\mapsto \int_0^t \varphi_n(u)\mathrm{d}u$$
n'en forment pas une en général. Pourtant, comme $B$ est une fonction continue et a fortiori $L^2$, on doit pouvoir écrire 
$$ B_t = \sum_n Y_n \varphi_n(t)$$
où $Y_n = \langle B, \varphi_n\rangle$. Le problème est que dans la construction de Lévy les $(Y_n)$ ne sont pas iid et que leur calcul nécessite de déterminer les produits scalaires entre $\varphi_n$ et $\int_0^t \varphi_n(s)\mathrm{d}s$, ce qui n'est pas évident. On aimerait donc spécifier n'importe quel processus gaussien directement par ses coefficients dans une base orthonormale. C'est ce que fait la décomposition de Karhunen-Loève, qui dans le cas du mouvement brownien donne la représentation suivante: 

@@important
Soit $(\xi_n)$ une suite de gaussiennes standard iid. La série suivante converge au sens $L^2$ vers un mouvement brownien: 
$$B_t = \sum_{n=1}^\infty  \xi_n \frac{\sqrt{2}}{\left(n+\frac{1}{2}\right)\pi}\sin\left(\left(n+\frac{1}{2}\right)\pi t\right) $$
@@ 
La construction est en fait valable pour n'importe quelle fonction de covariance $K(s,t)$; la base en question et les nombres qui apparaissent dans la somme vont dépendre de $K$. Ceux ci-dessus sont adaptés à la covariance du brownien, $K(s,t) = s\wedge t$. 

Michel Loève (1907 - 1979), d'origine palestitienne, a eu pour directeur de thèse Paul Lévy. Kari Karhunen (1915 - 1992) était finlandais et avait eu Nevanlinna comme directeur de thèse. 

## Décomposition de Karhunen-Loève

### Théorème de Mercer

La clé est le résultat suivant, un pur produit d'analyse fonctionnelle dû à [James Mercer](https://en.wikipedia.org/wiki/James_Mercer_(mathematician)) en 1909. 

On dit qu'une fonction $K : [0,1]^2 \to \mathbb{R}$ est un noyau positif si elle est symétrique, continue, et si pour tous $x_1, \dotsc, x_n \in [0,1]$ la matrice $(K(x_i, x_j))$ est définie positive. 

@@deep
Si $K$ est un noyau positif, il existe une base orthonormale $(e_n)$ de $L^2$ et des nombres positifs $\lambda_n$ tels que $\sum \lambda_n <\infty$ et
\begin{equation}\label{mercer}K(s,t) = \sum_{n=0}^\infty \lambda_n e_n(x)e_n(y)\end{equation}
où cette série converge uniformément sur $[0,1]^2$. 

Les $(\lambda_n), (e_n)$ sont les valeurs propres et fonctions propres associées à l'opérateur à noyau $f\mapsto K \star f$ où $$K \star f(s) = \int_0^1 K(s,t)f(t){\rm d}t. $$
Autrement dit, les fonctions propres et valeurs propres se trouvent en résolvant les équations 
$$ \lambda_n e_n(t) = \int_0^1 K(s,t)e_n(t){\rm d}t.$$ 
@@

J'ai écrit une démonstration [dans cette note](/posts/mercer/). L'idée générale simple si l'on connaît un peu de théorie spectrale : l'égalité  \eqref{mercer} est vraie au sens $L^2$ et il suffit de lui donner un sens pour tout $x,y$, ce qui est une conséquence de la continuité de $K$. 

### Représentation des processus gaussiens

Soit $K$ un noyau comme dans le théorème ci-dessus. On cherche un processus gaussien centré de covariance $K$; on pose
\begin{equation}
X_t = \sum_{n=0}^\infty \xi_n \sqrt{\lambda_n} e_n(t)
\end{equation}
où les $e_n, \lambda_n$ sont les fonctions propres et valeurs propres de l'opérateur de noyau $K$ comme dans le théorème de Mercer. Cette construction répond au problème; elle s'appelle *construction de Karhunen-Loève*. 

@@proof **Démonstration.** On remarque déjà que $\mathbb{E}\sum \xi_n^2 \lambda_n = \sum \lambda_n < \infty$, donc la somme est finie presque sûrement et $B$ est bien défini (série absolument convergente dans $L^2$). Le fait que $X$ soit centré est évident. Pour la covariance, on a 
$$ \mathbb{E}X_t X_s = \sum_{n,m}\sqrt{\lambda_n \lambda_m}\mathbb{E}[\xi_n \xi_m] e_n(s)e_m(t) = \sum \lambda_n e_n(s)e_n(t) = K(s,t).$$

Cela répond donc au problème. 
@@

Évidemment, toute la difficulté consiste à calculer la base qui diagonalise l'opérateur à noyau $f \mapsto K \star f$. 

## Calcul dans le cas du brownien 

On veut diagonaliser l'opérateur intégral $f\in L^2 \mapsto K \star f$ où 
$$ (K\star f)(s)= \int K(s,t)f(t)\mathrm{d}t = \int_0^1 (s\wedge t) f(t){\rm d}t = \int_0^s t f(t){\rm d}t + s\int_s^1 f(t){\rm d}t. $$
On cherche donc un couple $\lambda \in \mathbb{R}$,$\phi \in L^2$ tel que $\lambda \phi = K\star \phi$, c'est-à-dire
\begin{equation}\label{eq1}\lambda \phi(s) = \int_0^s t \phi(t)dt + s\int_s^1 \phi(t)dt.\end{equation}
Si cette identité est vraie et alors on voit vite que $\phi$ est deux fois dérivable, et en dérivant on obtient
$$ \lambda \phi'(s) = s \phi(s) + \int_s^1 \phi(t)dt - s \phi(s) = \int_s^1 \phi(t)dt$$
puis en re-dérivant
$$ \lambda \phi''(s) = -\phi(s).$$
Les solutions $\phi$ sont donc des combinaisons linéaires de $\sin$ et $\cos$ avec fréquence $1/\sqrt{\lambda}$. On voit aussi que $\lambda$ ne peut pas être nul. Comme manifestement \eqref{eq1} implique que $\phi(0) = 0$, il n'y a pas de cosinus: $\phi(s) = c \sin(s/\sqrt{\lambda})$ pour une constante $c$. D'autre part on voit que $\phi'(1) = 0$ soit $\cos(1/\sqrt{\lambda})=0$ et donc $1/\sqrt{\lambda} = 1/2\pi + n\pi$ pour un certain entier $n$, que l'on peut prendre positif ou nul car le sinus est symétrique. On en déduit que 
$$ \phi(s) = c \sin\left(s \pi \left(\frac{1}{2} + n\right)\right)$$
et on vérifie facilement que $\int_0^1 \sin(s\pi(1/2 + n))^2 {\rm d}s = 1/2$ donc $c = \sqrt{2}$ pour que $\phi$ soit normalisée. On se convaincra facilement que la famille 
$$ \left(  \sqrt{2}\sin\left(s \pi \left(\frac{1}{2} + n\right)\right)\right)_{n \in \mathbb{N}}$$
forme une base orthonormale de $L^2$ qui diagonalise l'opérateur de noyau $K$, avec les valeurs propres associées
$$ \lambda_n = \frac{1}{\left(\left(n + \frac{1}{2}\right)\pi\right)^2} \qquad (n\in \mathbb{N}).$$

La représentation de Karhunen-Loève nous donne donc
$$B_t = \sum_{n=1}^\infty \xi_n \frac{\sqrt{2}}{\left(n+\frac{1}{2}\right)\pi}\sin\left(\left(n+\frac{1}{2}\right)\pi t\right) $$
où les $(\xi_n)$ sont des gaussiennes standard iid. Cette série converge au sens $L^2$ mais on pourrait vérifier qu'elle converge aussi presque sûrement. 

## Remarque générale 

Le [théorème de Sturm-Liouville](https://fr.wikipedia.org/wiki/Th%C3%A9orie_de_Sturm-Liouville) dit que pour toute fonction continue $Q$, il existe une base de $L^2$ composée de fonctions $\mathscr{C}^2$, disons $u_n$, et des nombres positifs distincts $\lambda_n$ qui tendent vers l'infini, tels que $u_n(0)=u_n(1)=0$ et 
$$-u''_n + Qu_n = \lambda_n u_n.$$
Ces fonctions sont en fait les fonctions propres de l'opérateur de noyau $K(x,y) = C a(x \wedge y)b(x \vee y)$ où $a,b$ sont deux solutions de $u'' + Qu = 0$ avec des conditions initiales bien choisies pour qu'elles soient orthogonales, et $C$ est une constante. Dans le cas ci-dessus on a $Q=0$ et les conditions initiales donnent $a(x)=x$ et $b(x)=-x$; la constante $C$ est en fait égale à $-1$ et donc on trouve bien $K(x,y) = x \wedge y$   .