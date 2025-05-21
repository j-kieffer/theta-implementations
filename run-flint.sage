#
# Run experiments using FLINT
#

import subprocess

def run_all_precs(precs, g):
    with open("./input/periods-genus-{}.in".format(g)) as f:
        print("Using fast algorithm:")
    p1 = 0
    p2 = 0
    with open("output/FLINT-fast-genus-{}.out".format(g), "w") as f:
        for p in precs:
            print("    p = {}...".format(p))
            run = subprocess.run(["./run-flint.exe", "{}".format(g), "./input/periods-genus-{}.in".format(g),
                                  "{}".format(p), "0"], capture_output=True, text=True)
            f.write("{}    {}\n".format(p, run.stdout))
            if run.stdout == "FAIL" or RR(run.stdout) > 10:
                p1 = p
                break
    print("Using summation:")
    with open("output/FLINT-sum-genus-{}.out".format(g), "w") as f:
        for p in precs:
            print("    p = {}...".format(p))
            run = subprocess.run(["./run-flint.exe", "{}".format(g), "./input/periods-genus-{}.in".format(g),
                                  "{}".format(p), "1"], capture_output=True, text=True)
            f.write("{}    {}\n".format(p, run.stdout))
            if run.stdout == "FAIL" or RR(run.stdout) > 10:
                p2 = p
                break
    p = max(p1, p2)
    if p == 0:
        return True
    else:
        return p

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
