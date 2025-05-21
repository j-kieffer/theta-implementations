Theta-implementations: Experimenting with software packages for theta functions
=========================

This repository contains code to reproduce experiments from the paper [Fast
evaluation of Riemann theta functions in any dimension](). We experiment with
the following software:

- The Julia package [Theta.jl](https://github.com/chualynn/Theta.jl).
- Magma's [Theta](https://magma.maths.usyd.edu.au/magma/handbook/text/260) intrinsic.
- The Sagemath package [RiemannTheta](https://github.com/nbruin/RiemannTheta/tree/main).
- The summation algorithm implemented in
  [FLINT](https://github.com/flintlib/flint) as `acb_theta_sum`.
- The fast algorithm implemented in [FLINT](https://github.com/flintlib/flint)
  as `acb_theta_jet_notransform`.

We do not experiment with the
[abelfunctions](https://github.com/abelfunctions/abelfunctions/tree/master)
package: see the paper [Computing Theta Functions with
Julia](https://msp.org/jsag/2021/11-1/p05.xhtml) for experimental comparisons
between Theta.jl and abelfunctions. We thank Christian Klein for sharing with
us the Matlab code associated to the paper [Efficient computation of
multidimensional theta
functions](https://www.sciencedirect.com/science/article/pii/S0393044019300555),
which is not included here.

For each dimension $1\leq g\leq 10$, we sample a representative reduced element
$\tau$ in the Siegel upper half space, and measure how much time it takes to
evaluate $\theta_{0,0}(0,\tau)$ at growing binary precisions. Note Theta.jl
only supports low precision. If a given task takes more than 10 seconds to run,
then more difficult ones are not attempted.

## Building packages

- Installing Theta.jl: first [install Julia](https://julialang.org/install/). Then run

      import Pkg
      Pkg.add("Theta")

  These commands will install the latest version of Theta.jl. The experiments
  in the paper were run with Theta.jl v0.1.2.

- Installing Magma: just make sure that you have a working `magma` command
  in your system. The experiments in the paper were run with Magma v2.27-7.

- Installing RiemannTheta: first make sure that you have a working (and recent)
  `sage` command in your system, then refer to these [installation
  instructions](https://github.com/nbruin/RiemannTheta/tree/main#installation). It
  is possible to use the [precise version of the
  package](https://github.com/nbruin/RiemannTheta/tree/46835dc283fb99661f326ecd0727c9818272b5fd)
  that we used in the paper (v1.0.0). To do this, clone this repository, run

      git submodule update --init RiemannTheta
      cd RiemannTheta
      sage --python setup.py install --user

  and make sure `sage` is aware of were to find user-installed packages.

- Installing FLINT: clone this repository, run

      git submodule update --init flint
      cd flint

  then [build and install FLINT from
  source](https://github.com/flintlib/flint?tab=readme-ov-file#building-from-source)
  in that repository. Finally, compile the C file `run-flint.c` to produce
  `run-flint.exe` using something like

      gcc -I/path/to/include/flint run-flint.c -L/path/to/lib -lflint -o run-flint.exe

## Generating input data

To generate input data, run

    sage generate_input.sage

The file `generate_input.sage` specifies which precisions will be considered
(powers of 2 from 64 to $2^{20}$) and the shape of the matrix $\tau$ in each
dimension $g$.

## Running experiments

The commands

    julia run-Theta.jl
    magma run-magma.m
    sage run-RiemannTheta.sage
    sage run-flint.sage

actually perform the computations.

The results are placed in the folder `output` as several files with
self-explanatory names. Each file contains two columns expressing runtimes (in
seconds) in terms of $g$ or of the chosen binary precision.
