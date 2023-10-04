+++
titlepost = "Mouvement brownien I 📈 : avec une base d'ondelettes"
date = "Septembre 2023"
abstract = "Une généralisation de la construction de Paul Lévy: on construit un mouvement brownien continu en s'aidant d'une base orthonormale.  "
+++


Un mouvement brownien est une fonction réelle $B$ sur $[0,1]$, aléatoire, gaussienne (au sens où toutes les marginales sont conjointement gaussiennes), centrée, et de covariance $\mathbb{E}[B_s B_t] = \min(s,t)$. Le fait qu'une telle chose existe n'est pas une évidence et c'est un passage obligé de tous les cours de M2; la construction ci-dessous est relativement classique, c'est une généralisation de celle de Lévy. Elle a le mérite d'être assez visuelle et de donner directement une limite continue, alors que d'autres constructions (notamment la construction abstraite $L^2$) nécessitent de justifier la continuité en utilisant des résultats plus techniques comme le lemme de continuité de Kolmogorov. 

## Base d'ondelette

Soit $\varphi$ une *ondelette-mère*, c'est-à-dire une fonction continue dont le support est $[0,1]$, vérifiant
$$ \int \psi(x)dx = 0 \qquad \int |\psi(x)|^2 dx = 1.$$
Si cette ondelette possède certaines propriétés, il est possible de définir une base de $L^2(0,1)$ en variant l'échelle et la position de cette ondelette. Pour cela, on pose $\varphi_0 = 1, \varphi_1 = \psi$, et pour chaque échelle $j \geqslant 2$, 
$$ \varphi_{j,k}(x) = 2^{\frac{j-1}{2}}\psi(2^{j-1}x - k) \qquad \qquad k= 0, 1, 2, \dots, 2^{j-1}-1.$$
@@important
La famille des $(\varphi_{j,k})$ forme une base orthonormale de $L^2(0,1)$. 
@@
Les conditions garantissant ce résultat sont par exemple lisibles dans [le livre de Yves Meyer](https://books.google.fr/books/about/Wavelets_and_Operators_Volume_1.html?id=y5L5HVlh3ngC&redir_esc=y). Voici à quoi ressemblent quelques bases d'ondelettes usuelles: 

![](/posts/img/wavelets.png)




Maintenant, on se donne une famille $X_{j,k}$ de variables aléatoires gaussiennes standard indépendantes et on pose
$$ B_t^j = \sum_{k=0}^{2^{j-1}-1}X_{j,k}\int_0^t \varphi_{j,k}(x)dx.$$
Il faut interpréter $B^j$ comme la variation du mouvement brownien à l'échelle $2^{j}$. Le mouvement brownien est la somme de toutes ces variations, à savoir $B^0_t + B^1_t + \dots$. Évidemment, il faut vérifier que cette somme est bien définie. Les *primitives* des ondelettes, $\int_0^t \varphi_{j,k}(t){\rm d}t$, qui ressemblent à ceci: 

![](/posts/img/wavelet_integrated.png)

Les variables aléatoires $B^j_t$ pour $j=0, \dotsc, 8$ sont visibles à gauche ci-dessous et leur somme donne la fonction à droite, qui ressemble déjà beaucoup à un mouvement brownien: 
![](/posts/img/brownian.png)


@@deep 
**Théorème d'existence du mouvement brownien.**


La somme $B_t = \sum_{j=0}^{\infty} B^j_t$ est presque sûrement uniformément convergente sur $[0,1]$ et sa limite est un mouvement brownien. 
@@


### Un lemme préliminaire

On aura besoin du résultat suivant: $\mathbf{P}$-presque sûrement, pour toute échelle $j$ suffisamment grande on a 
\begin{equation}\label{evt} \max_{k\leqslant 2^{j-1}-1}|X_{j,k}| \leq j.\end{equation}
 

@@proof 
*Démonstration*. Une variable gaussienne standard vérifie $ \mathbb{P}(X>t) \leq e^{-t^2/2}$ pour tout $t>1$. En particulier si on note $A_j$ l'événement \eqref{evt}, la borne de l'union donne 
\begin{align}\mathbb{P}(\overline{A_j})\leqslant 2^{j-1}\mathbb{P}(X>j) \leq 2^{j-1}e^{-j^2/2}
\end{align}
et donc $\sum \mathbb{P}(\overline{A_j})<\infty$. Presque sûrement, seul un nombre fini de $\overline{A_j}$ est donc réalisée (Borel-Cantelli), ce qui montre le résultat.  
@@


Le résultat précédent dit que si $j$ est suffisamment grand,
$$ |B^j_t| \leq j \sum_{k=0}^{2^{j-1}-1} \left|\int_0^t \varphi_{j,k}(s)ds \right|.$$ 
L'ondelette $\varphi_{j,k}$ est nulle en dehors de l'intervalle $(i 2^{-j-1}, (i+1)2^{-j-1})$, et son intégrale est nulle. On en déduit que si $t$ n'est pas dans cet intervalle, alors
$$ \int_0^t\varphi_{j,k} = \int_{k2^{-j-1}}^{(k+1)2^{-j-1}} \varphi_{j,k} = 0.$$
Ainsi, dans la somme ci-dessus, seul le terme correspondant à l'intervalle dyadique contenant $t$ n'est pas nul, et on peut le borner très simplement : 
$$\left|\int_0^t \varphi_{j,k} \right| \leqslant \int |\varphi_{j,k}| = \frac{|\psi|_1}{2^{\frac{j-1}{2}}}$$ 
où la seconde égalité résulte d'un simple changement de variables $y = 2^{j-1}x$. 
De tout cela, on déduit que $|B^j_t| \leqslant c j 2^{-j/2}$ où $c=|\psi|_1 \sqrt{2}$ est une constante indépendante. Ceci étant vrai pour tout $t$, 
$$ \sup_{t\in[0,1]}\left| \sum_{j\geqslant J}B^j_t\right| \leq c \sum_{j\geq J}\frac{j}{2^{j/2}} \xrightarrow[J\to\infty]{} 0.$$
Cela montre bien que la série $\sum B^j_t$ est uniformément convergente dans l'espace de Banach $(\mathscr{C}[0,1], |\cdot|_{\infty})$; sa limite $B_t$ est donc une fonction continue. 

### La limite est un mouvement brownien

Pour vérifier que $B$ est un MB il suffit de vérifier que (1) c'est un processus gaussien (2) centré et (3) vérifiant $\mathbb{E}[B_t B_s] = \min(t,s)$. Comme toute limite de lois gaussiennes est elle-même gaussienne, le point (1) est vérifié. D'autre part, on peut écrire 
$$ B_t = \sum_{j=0}^\infty \sum_{k=0}^{2^{j-1}-1}X_{j,k}\int_0^t\varphi_{j,k}(x)dx$$
où la convergence est presque sûrement uniforme, donc les interversions de séries et d'intégrales ci-dessous sont justifiées: 
$$ \mathbb{E}B_t = \sum_{j=0}^\infty \sum_{k=0}^{2^{j-1}-1}\mathbb{E}[X_{j,k}]\int_0^t\varphi_{j,k}(x)dx = 0$$
ce qui justifie le point (2), et enfin pour (3):
\begin{align} \mathbb{E}[B_s B_t]& = \sum_{i=0}^\infty \sum_{j=0}^\infty \sum_{k=0}^{2^{j-1}-1}\sum_{\ell=0}^{2^{j-1}-1}\mathbb{E}X_{i,\ell}X_{j,k}\int_0^t\varphi_{j,k}(x)dx\int_0^t\varphi_{i,\ell}(x)dx \\
&= \sum_{i=0}^\infty \sum_{\ell=0}^{2^{j-1}-1}\int_0^t\varphi_{j,k}(x)dx\int_0^s\varphi_{i,\ell}(x)dx  \\
&= \sum_{i=0}^\infty \sum_{\ell=0}^{2^{j-1}-1} \langle \varphi_{i,\ell}, \mathbf{1}_{[0,t]}\rangle \langle \varphi_{i,\ell}, \mathbf{1}_{[0,s]}\rangle
\end{align}
où ces derniers produits scalaires sont dans $L^2(0,1)$. Comme $(\varphi_{i,\ell})$ est une base hilbertienne de cet espace, l'égalité de Parseval dit que le dernier terme est égal à 
$$\langle \mathbf{1}_{[0,t]}, \mathbf{1}_{[0,s]}\rangle = \int_0^{1}\mathbf{1}_{x\leqslant s}\mathbf{1}_{x\leqslant t}dx = \min(s,t).$$

### La construction de Paul Lévy 

Le choix de $\psi(x) = -1$ si $x \leq 1/2$ et $1$ si $x>1/2$ donne une famille $(\varphi_{j,k})$ appelée base de Haar. Elle correspond exactement à la construction géométrique utilisée par Paul Lévy, et exposée dans lui-même par exemple [ici](http://www.numdam.org/item/MSM_1954__126__1_0.pdf) : la démonstration est exactement celle ci-dessus, la formule (1) dont il est question étant simplement la loi du brownien à savoir 
$$ B_t - B_s = \sqrt{t-s}\xi$$
où $\xi$ est une gaussienne standard. 

![](/posts/img/levy1.png)

![](/posts/img/levy2.png)


## Références

- [le livre de Meyer](https://books.google.fr/books/about/Wavelets_and_Operators_Volume_1.html?id=y5L5HVlh3ngC&redir_esc=y)

- [une synthèse de Paul Lévy en personne sur le MB](http://www.numdam.org/item/MSM_1954__126__1_0.pdf)
