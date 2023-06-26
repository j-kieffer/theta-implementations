
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
def plot_lowprec(red):
    packages = ["Theta.jl", "RiemannTheta", "abelfunctions"]
    for pkg in packages:
        g, t = read_data("output/{}_lowprec_{}.out".format(pkg, red))
        plt.plot(g, t, label = pkg)
        plt.xticks(g)
    plt.grid(color = '0.9')
    plt.legend()
    plt.xlabel("Genus")
    plt.ylabel("Time (s)")
    plt.title("Low-precision computations")
    plt.savefig("plots/lowprec_{}.png".format(red))
    plt.close()

plot_lowprec("lll")
plot_lowprec("hkz")

# Plot the high-precision data
def plot_highprec(g, red):
    packages = ["RiemannTheta"]
    for pkg in packages:
        p, t = read_data("output/{}-{}-genus-{}.out".format(pkg, red, g))
        plt.plot(p, t, label = pkg)
    plt.grid(color = '0.9')
    plt.legend()
    plt.xlabel("Precision")
    plt.ylabel("Time (s)")
    plt.title("High-precision computations in genus {}".format(g))
    plt.savefig("plots/highprec-{}-genus-{}.png".format(red, g))
    plt.close()        

g = 1
while True:
    try:
       plot_highprec(g, "lll")
       plot_highprec(g, "hkz")
       g += 1
    except FileNotFoundError:
        break

