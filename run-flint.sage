#
# Run experiments using FLINT
#

import subprocess

def run_all_precs(precs, g):
    print("Using fast algorithm:")
    with open("output/FLINT-fast-genus-{}.out".format(g), "w") as f:
        for p in precs:
            print("    p = {}...".format(p))
            run = subprocess.run(["./run-flint.exe", "{}".format(g), "./input/periods-genus-{}.in".format(g),
                                  "{}".format(p), "0"], capture_output=True, text=True)
            f.write("{}    {}\n".format(g, run.stdout))
            if RR(run.stdout) > 10:
                break
    print("Using summation:")
    with open("output/FLINT-sum-genus-{}.out".format(g), "w") as f:
        for p in precs:
            print("    p = {}...".format(p))
            run = subprocess.run(["./run-flint.exe", "{}".format(g), "./input/periods-genus-{}.in".format(g),
                                  "{}".format(p), "1"], capture_output=True, text=True)
            f.write("{}    {}\n".format(g, run.stdout))
            if RR(run.stdout) > 10:
                break

with open("input/precisions.in", 'r') as f:
    precs = [ZZ(p) for p in f.readlines()]

g = 1
while True:
    try:
        print("g = {}...".format(g))
        run_all_precs(precs, g)
        g += 1
    except FileNotFoundError:
        break

gmax = g-1
with open("output/FLINT_lowprec.out", 'w') as f:
    for g in [1..gmax]:
        run = subprocess.run(["./run-flint.exe", "{}".format(g), "./input/periods-genus-{}.in".format(g),
                              "64", "1"], capture_output=True, text=True)
        f.write("{}    {}\n".format(g, run.stdout))
        if RR(run.stdout) > 10:
            break
