#
# Run experiments using the RiemannTheta package.
#

from riemann_theta.riemann_theta import RiemannTheta
import time

def set_tau(tau, filename):
    g = tau.ncols()
    I = tau.parent().base_ring().0
    with open(filename, 'r') as f:
        lines = [l.strip("\n") for l in f.readlines()]
        for i in range(g):
            for j in range(g):
                tau[i,j] = CC(lines[2*i*g+2*j]) + CC(lines[2*i*g+2*j+1])*I

def run_at_prec(red, p, g):
    CC = ComplexField(p)
    tau = Matrix(CC, g, g)
    set_tau(tau, "input/{}-genus-{}.in".format(red, g))
    charspace = GF(2)^(2*g)
    a_list = [charspace.gens()[i] for i in [0..g-1]]
    a_list = [charspace(a) for a in span(a_list)]

    start = time.perf_counter()
    RT = RiemannTheta(tau)
    for c in a_list:
        RT(char=c)
    t = time.perf_counter() - start        
    return t

def run_all_precs(red, precs, g):
    with open("output/RiemannTheta-{}-genus-{}.out".format(red, g), 'w') as f:
        for p in precs:
            res = run_at_prec(red, p, g)
            f.write("{}    {}\n".format(p, res))

g = 1
while True:
    try:
        with open("input/precisions-genus-{}.in".format(g), 'r') as f:
            print("g = {}...".format(g))
            precs = [ZZ(p) for p in f.readlines()[1:]]
            run_all_precs("lll", precs, g)
            run_all_precs("hkz", precs, g)            
        g += 1
    except FileNotFoundError:
        break
