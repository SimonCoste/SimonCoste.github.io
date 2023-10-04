+++
titlepost = "Théorème de Mercer et Kernel Trick"
date = "Octobre 2023"
abstract = "Le théorème de représentation des noyaux positifs"
+++

Soit $K : [0,1]^2 \to \mathbb{R}$ une fonction continue symétrique. Dans [cette note](/posts/karhunen/) on a montré comment construire un processus stochastique gaussien de fonction de covariance $K$, c'est-à-dire une fonction aléatoire $X : [0,1] \to \mathbb{R}$ dont toutes les marginales sont des gaussiennes centrées et telle que $\mathbb{E}[X_s X_t] = K(s,t)$. On a utilisé un théorème général, dit de Mercer, qui explique que $K$ se diagonalise dans une base orthonormale. Dans cette note on donne les grandes lignes d'une démonstration. 

Pour toute fonction $f\in L^2$ on pose 
$$ (K \star f)(x) = \int_0^1 K(x,y)f(y){\rm d}y.$$
et on notera $A_K$ l'opérateur $f \mapsto K \star f$. On voit vite que si $K$ est une fonction $L^2$, alors $A_K$ est un opérateur linéaire borné symétrique, et même compact si $K$ est continu. Le théorème de décomposition des opérateurs bornés sur des espaces de Hilbert dit alors qu'il existe une base orthonormale $(e_n)$ de $L^2$ et des réels $\lambda_n$ tels que 
\begin{equation}\label{AK} A_K f = \sum \lambda_n \langle e_n, f\rangle e_n.\end{equation}
La convergence de cette somme est au sens $L^2$ et les $e_n$ sont des fonctions $L^2$, donc on ne peut pas donner de sens direct à $e_n(x)$ par exemple. Cependant, si l'on pouvait évaluer \eqref{AK} en n'importe quel point on aurait 
$$ K(x,y) = \langle \delta_x, A_K \delta_y\rangle  = \sum \lambda_n \langle \delta_x, e_n\rangle \langle \delta_y, e_n\rangle = \sum \lambda_n e_n(x)e_n(y).$$
Le théorème de Mercer dit essentiellement que c'est vrai lorsque $K$ est un noyau positif. 
@@important
On dit qu'une fonction $K : [0,1]^2 \to \mathbb{R}$ est un noyau positif si elle est continue et si pour tous $x_1, \dotsc, x_n \in [0,1]$ la matrice $(K(x_i, x_j))$ est définie positive. 
@@ 

@@deep

**Théorème de Mercer (1909).**

Si $K$ est un noyau positif, il existe une base orthonormale $(e_n)$ de $L^2$ composée de fonctions continues, et des nombres positifs $\lambda_n$ tels que $\sum \lambda_n <\infty$ et
\begin{equation}\label{main} K(x,y) = \sum_{n=0}^\infty \lambda_n e_n(x)e_n(y)\end{equation}
où cette série converge uniformément sur $[0,1]^2$. 

Les $\varphi_n, \lambda_n$ se trouvent en résolvant les équations aux valeurs propres
$$ \lambda_n e_n(x) = \int_0^1 K(x,y)e_n(y){\rm d}y.$$ 
@@

On verra une démonstration très détaillée dans [le livre de Barry Simon](https://www.ams.org/publications/authors/books/postpub/simon), partie 4 théorème 3.11.9. Cependant l'idée est élémentaire si l'on connaît un peu de théorie spectrale des opérateurs. 

## Démonstration 


**1.** Si un noyau $K$ est positif alors l'opérateur associé $A_K$ est positif au sens des opérateurs, c'est-à-dire que $\langle f, A_K f\rangle \geqslant 0$ pour toute fonction $f$. Pour le voir il suffit de prendre une suite de $U_i$ iid uniformes sur $[0,1]$, une version de la loi des grands nombres dit que 
$$0 \leqslant \frac{1}{n^2} \sum_{i,j} f(U_i)f(U_j)K(U_i, U_j)\to \mathbb{E}[f(U)f(U')K(U,U')] = \int f(x)f(y)K(x,y)dxdy = \langle f, A_K f\rangle$$
où $U,U'$ sont iid uniformes sur $[0,1]$. 

**2.** Pour toute fonction $f \in L^2$, le théorème de convergence dominée et la continuité de $f$ entraînement que $K\star f$ est continue. On en déduit que si $K\star e_n = \lambda_n e_n$, alors comme $K\star e_n$ est continue $e_n$ l'est aussi, donc $e_n(x)$ a un sens pour tout $x$. De plus le point précédent implique que $\lambda_n = \langle e_n, A_K e_n\rangle \geqslant 0$ donc les valeurs propres sont positives ou nulles. 


**3.** Par l'inégalité de Cauchy-Schwarz, pour tous $x,y$ on a 
\begin{equation}\label{p1}
\left| \sum_{i=n}^m \lambda_i e_i(x)e_i(y)\right| \leqslant \left| \sum_{i=n}^m \lambda_i e_i(x)^2 \right|\times \left| \sum_{i=n}^m \lambda_i e_i(y)^2\right|.
\end{equation}

**4.** La série $\sum \lambda_n e_n^2$ est uniformément convergente sur $[0,1]$. C'est le coeur de la démonstration. 

@@proof 
*Démonstration*. 
La suite de fonctions $F_n(x) = \sum_{i=0}^n \lambda_i e_i(x)^2$ est une suite croissante de fonctions continues sur un compact (la croissance vient de la positivité des valeurs propres). Le [théorème de Dini](https://fr.wikipedia.org/wiki/Th%C3%A9or%C3%A8mes_de_Dini#:~:text=Premier%20th%C3%A9or%C3%A8me%20de%20Dini,-Le%20premier%20th%C3%A9or%C3%A8me&text=Th%C3%A9or%C3%A8me%20%E2%80%94%20La%20convergence%20simple%20d,continue%20implique%20sa%20convergence%20uniforme.) dit que si la série converge ponctuellement pour tout $x$, alors elle converge uniformément en $x$ : il suffit donc de vérifier la convergence ponctuelle.  Pour cela on fixe $x$ et on va approcher $\delta_x$ par une fonction $L^2$, typiquement 
$$ \psi_\epsilon(y) = \frac{\mathbf{1}_{|y-x|<\epsilon}}{2\epsilon}.$$

Lorsque $\epsilon \to 0$, une application du théorème de convergence dominée et de la continuité de $K$ et des $e_n$ entraîne que 
- $\langle \psi_\epsilon, K \star \psi_\epsilon \rangle \to K(x,x)$, 
- $\langle \psi_\epsilon, e_n \rangle \to e_n(x)$. 
De plus \eqref{AK} implique 
$$ \langle \psi_\epsilon, K \star \psi_\epsilon \rangle = \sum_{i=0}^\infty \lambda_i \langle \psi_\epsilon, e_i\rangle^2 \geqslant \sum_{i=0}^n \lambda_i \langle \psi_\epsilon, e_i\rangle^2.$$
On passe à la limite $\epsilon \to 0$ et on trouve que $K(x,x) \geqslant F_n(x)$, donc la suite $(F_n(x))$ est croissante bornée et elle converge presque sûrement. 
@@

**5.** On a montré que le membre de droite de \eqref{p1} converge uniformément à la fois en $x$ et en $y$, donc la limite 
$$ \sum \lambda_n e_n(x)e_n(y)$$
est une fonction continue sur $[0,1]^2$, disons $H$. Il suffit maintenant de vérifier qu'elle coïncide avec $K$. 

@@proof 
*Démonstration.*
On fixe $x$. La fonction $y\mapsto K(x,y)$ est dans $L^2$ donc on peut la décomposer dans la base des $e_n$, 
$$K(x,\cdot) = \sum e_n(\cdot) \langle K(x,\cdot ), e_n\rangle = \sum e_n(\cdot ) \lambda_n e_n(x) = H(x,\cdot)$$
où la convergence est au sens $L^2$. Pour tout $x$ on a donc l'égalité $K(x,\cdot) = H(x,\cdot)$ dans $L^2$, donc presque partout, donc partout car ces fonctions sont continues. 

@@ 

# Kernel trick

Le théorème de Mercer est vrai avec la même démonstration pour tout noyau $K$ défini sur $X^2$ où $X$ est un espace métrique compact. La définition de la positivité reste la même. Maintenant, si l'on note $\Phi$ l'application 
$$ \Phi(x) = (e_n(x))_n$$
alors on voit que $\Phi$ envoie (isométriquement !) l'espace $X$ vers l'espace $\mathscr{H} = \ell^2(\mathbb{N})$ muni du produit scalaire 
$$ \langle u, v\rangle = \sum \lambda_n u_n v_n$$
et on a l'identité 
$$ K(x,y) = \langle \Phi(x), \Phi(y)\rangle.$$
En pratique, de nombreux algorithmes de traitement de données procèdent de la façon suivante : 
- d'abord, on transforme des données $x_i$ en des "features" $\Phi(x_i)$. Souvent, $\Phi$ est hautement non linéaire et peut être composé, par exemple, de polynômes en $x$. 
- ensuite on utilise un algorithme linéaire (classification, régression) sur les données $x'_i = \Phi(x_i)$. Typiquement, ces algorithmes (comme la régression linéaire) nécessitent le calcul de matrices de Gram de la forme $(\langle x'_i, x'_j\rangle)$. 

Plutôt que d'avoir à calculer les features $x'_i$, qui peuvent avoir une dimension gigantesque, le théorème de Mercer dit que pour accéder à la matrice de Gram il suffit de calculer les $K(x_i, x_j)$. Le calcul des features n'est pas nécessaire. La fonction $\Phi$ n'a même pas à être connue. 