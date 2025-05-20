theta-implementations: Experimenting with software packages for theta functions
=========================

This repository contains code to reproduce experiments from the paper [Fast
evaluation of Riemann theta functions in any dimension]() by Noam D. Elkies and
Jean Kieffer. We experiment with the following software:

- The Julia package [Theta.jl](https://github.com/chualynn/Theta.jl).
- Magma's [Theta](https://magma.maths.usyd.edu.au/magma/handbook/text/260) intrinsic.
- The Sagemath package [RiemannTheta](https://github.com/nbruin/RiemannTheta/tree/main).
- The summation algorithm implemented in
  [FLINT](https://github.com/flintlib/flint) as `acb_theta_sum`.
- The fast algorithm implemented in [FLINT](https://github.com/flintlib/flint)
  as `acb_theta_jet_notransform`.

We run two kinds of experiments:
- First, we fix a small precision of 64 bits, let the dimension $g$ vary from 1
  to 6, and measure how much time it takes to evaluate $\theta_{0,0}(0,\tau)$
  where $\tau$ is a representative element of the Siegel half space in
  dimension $g$.
- Second, we fix $1\leq g\leq 6$, and measure how much time it takes to
  evaluate $\theta_{0,0}(0,\tau)$ at growing binary precisions.

## Building packages



Installation of RiemannTheta:
sage --pip install RiemannTheta

Installation of abelfunctions:
Silence SAGE_ROOT = ... in setup.py
sage --pip install abelfunctions

Installation of Theta.jl:
Install Julia, add .../julia-(version)/bin to PATH
in Julia:
import Pkg
Pkg.add("Theta") (download from Internet repository)

Magma installation: nothing besides the regular software

Flint installation:
cd flint2
./configure [options]
make check
make install

Making data:
sage generate-input.sage
sage run-all.sage
sage plot.sage
