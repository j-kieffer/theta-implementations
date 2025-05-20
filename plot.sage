
import matplotlib.pyplot as plt
import numpy as np

# Read data from file: each line should be x, y separated by spaces, and x is integral.
def read_data(filename):
    with open(filename) as f:
        lines = f.readlines()
        n = len(lines)
        x = np.arange(0,n)
        y = np.zeros(n)
        for i in [0..(n-1)]:
            data = [t for t in lines[i].split(" ") if t != ""]
            assert len(data) == 2
            x[i] = int(data[0])
            y[i] = float(data[1])
    return x, y

# Plot the low-precision data
def plot_lowprec():
    packages = ["Theta.jl", "RiemannTheta", "magma"]
    for pkg in packages:
        g, t = read_data("output/{}_lowprec.out".format(pkg))
        t = np.log(t + 10^(-3))
        plt.plot(g, t, label = pkg)
        plt.xticks(g)
    plt.grid(color = '0.9')
    plt.legend()
    plt.xlabel("Genus")
    plt.ylabel("Log(Time/1s)")
    plt.title("Low-precision computations")
    plt.savefig("plots/lowprec.png")
    plt.close()

plot_lowprec()

# Plot the high-precision data
def plot_highprec(g):
    packages = ["RiemannTheta", "magma"]
    for pkg in packages:
        p, t = read_data("output/{}-genus-{}.out".format(pkg, g))
        plt.plot(p, t, label = pkg)
    plt.grid(color = '0.9')
    plt.legend()
    plt.xlabel("Precision")
    plt.ylabel("Time (s)")
    plt.title("High-precision computations in genus {}".format(g))
    plt.savefig("plots/highprec-genus-{}.png".format(g))
    plt.close()

g = 1
while True:
    try:
       plot_highprec(g)
       g += 1
    except FileNotFoundError:
        break

