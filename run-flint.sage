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
    print("Using summation:")
    with open("output/FLINT-sum-genus-{}.out".format(g), "w") as f:
        for p in precs:
            print("    p = {}...".format(p))
            run = subprocess.run(["./run-flint.exe", "{}".format(g), "./input/periods-genus-{}.in".format(g),
                                  "{}".format(p), "1"], capture_output=True, text=True)
            f.write("{}    {}\n".format(g, run.stdout))

g = 1
while True:
    try:
        with open("input/precisions-genus-{}.in".format(g), 'r') as f:
            print("g = {}...".format(g))
            precs = [ZZ(p) for p in f.readlines()[1:]]
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
