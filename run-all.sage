
import subprocess
pkg = []

#Clean output folder
for f in os.listdir("output"):
    if "placeholder" not in f:
        os.remove("output/"+f)

#Remove/add packages easily.
if 1:
    pkg.append("RiemannTheta")
if 1:
    pkg.append("magma")
if 1:
    pkg.append("Theta.jl")

def run(p):
    print("Running experiments for {}: ".format(p))
    if p == "RiemannTheta":
        load("run-RiemannTheta.sage")
    if p == "Theta.jl":
        subprocess.run(["julia", "run-Theta.jl"])
    if p == "magma":
        subprocess.run(["magma", "run-magma.m"])

for p in pkg:
    run(p)
