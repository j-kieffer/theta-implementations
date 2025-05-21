#
# Run experiments using the RiemannTheta package.
#

from riemann_theta.riemann_theta import RiemannTheta
import time
import cypari2

pari = cypari2.Pari()
pari.allocatemem(2^32)

def set_tau(tau, filename):
    g = tau.ncols()
    I = tau.parent().base_ring().0
    with open(filename, 'r') as f:
        lines = [l.strip("\n") for l in f.readlines()]
        for i in range(g):
            for j in range(g):
                tau[i,j] = CC(lines[2*i*g+2*j]) + CC(lines[2*i*g+2*j+1])*I

def run_at_prec(p, g):
    CC = ComplexField(p)
    tau = Matrix(CC, g, g)
    set_tau(tau, "input/periods-genus-{}.in".format(g))
    charspace = GF(2)^(2*g)
    a_list = [charspace.gens()[i] for i in [0..g-1]]
    a_list = [charspace(a) for a in span(a_list)]

    total = 0.
    t = 0.
    nbtries = 1
    while total < 1:
        start = time.perf_counter()
        for k in range(nbtries):
            RT = RiemannTheta(tau)
            _ = RT(char=charspace(0))
        total = time.perf_counter() - start
        t = total/nbtries
        nbtries *= 4
    return t

def run_all_precs(precs, g):
    with open("output/RiemannTheta-genus-{}.out".format(g), 'w') as f:
        for p in precs:
            print("    p = {}...".format(p))
            res = run_at_prec(p, g)
            f.write("{}    {}\n".format(p, res))
            if res > 10:
                return p
    return True

with open("input/precisions.in", 'r') as f:
    precs = [ZZ(p) for p in f.readlines()]

g = 1
while True:
    try:
        print("g = {}...".format(g))
        p = run_all_precs(precs, g)
        g += 1
        if p == 64:
            break
    except FileNotFoundError:
        break
