#
# Run experiments using the abelfunctions package.
#

import numpy as np
from abelfunctions import RiemannTheta
import time

def set_tau(tau, filename, g):
    I = 1.0j
    with open(filename, 'r') as f:
        lines = [l.strip("\n") for l in f.readlines()]
        for i in range(g):
            for j in range(g):
                v = float(lines[2*i*g+2*j]) + float(lines[2*i*g+2*j+1])*I
                tau[i,j] = v

def run_at_prec(red, p, g):
    tau = np.zeros((g,g),dtype=complex)
    set_tau(tau, "input/{}-genus-{}.in".format(red, g), g)
    z = [0. for i in [1..g]]

    start = time.perf_counter()
    RiemannTheta(z, tau)
    t = time.perf_counter() - start
    return t

g = 1
with open("output/abelfunctions_lowprec_lll.out", 'w') as f_lll:
    with open("output/abelfunctions_lowprec_hkz.out", 'w') as f_hkz:
        while True:
            try:
                with open("input/precisions-genus-{}.in".format(g), 'r') as f:
                    print("g = {}...".format(g))
                    prec = 64 #low-precision only
                    t = run_at_prec("lll", prec, g)
                    f_lll.write("{}    {}\n".format(g, t))
                    t = run_at_prec("hkz", prec, g)
                    f_hkz.write("{}    {}\n".format(g, t))
                g += 1
            except FileNotFoundError:
                break
