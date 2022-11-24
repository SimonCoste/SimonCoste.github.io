+++
titlepost = "Distributions unimodales"
date = "Novembre 2022"
abstract = "Intéressant. "
+++

On pose $F(x) = \mathbb{P}(X \leqslant x)$. Soit $n>0$. On note $F_\delta$ l'unique fonction continue et linéaire par morceaux telle que pour tout $m \in \mathbb{Z}$, on a $F(m\delta ) = F_\delta(m\delta)$, autrement dit $F$ et $F_n$ coïncident aux points $0, \pm \delta, \pm 2\delta, \pm 3\delta, $ et ainsi de suite. Formellement, si $x$ est compris entre $m\delta$ et $(m+1)\delta$, alors 
\begin{align}F_m(x) &= F(m\delta) + \frac{(F((m+1)\delta) - F(m\delta)}{\delta}\times (x-m\delta ) \\
&= a_m + x b_m
\end{align}
où $a_m = F(m\delta) + m\delta (F(m\delta) - F((m+1)\delta))/\delta$ et $b_m = (F((m+1)\delta) + F(m\delta)) / \delta$.

Cette fonction est une fonction de répartition : elle est croissante, elle vaut $0$ en $-\infty$ et $1$ en $+\infty$. Elle est unimodale. 

Maintenant, soit $D$ une variable aléatoire discrète à valeurs dans $\delta \mathbb{Z}$, qui prend la valeur $\delta n$ avec probabilité $p_n$. Soit $U$ une variable uniforme entre 0 et 1, indépendante de $D$. On note $P_n = \sum_{k\leqslant n}p_k$. Soit $x$ un nombre positif. On suppose que $n\delta < x < (n+1)\delta $. Alors,
\begin{align}
\mathbb{P}(DU \leqslant x) &= \mathbb{P}(D \leqslant n\delta) + \mathbb{P}(D \geqslant (n+1)\delta, U \leqslant x / A)\\
&= \sum_{k\leqslant n}p_k + \sum_{k\geqslant n+1}p_k \frac{x}{k\delta}\\
    &= P_n + x \sum_{k\geqslant n+1}\frac{p_k}{k\delta}\\
\end{align}
