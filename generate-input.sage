#
# In each genus from g=1 to gmax, generate files precisions-genus-g.in and
# periods-genus-g.in.
#
# The first line of precisions-genus-g.in is the number of precisions to
# consider, then one precision per line.
#
# The file periods-genus-g.in contain a matrix in the Siegel fundamental
# domain. The line number 2*i*g + 2*j (starting from 0) (resp. 2*i*g + 2*j + 1)
# contains the real (resp. imaginary) part of the coefficient tau_{i,j}. The
# imaginary part of tau is HKZ-reduced, and the coefficient tau_{0,0} belongs
# to the usual fundamental domain in genus 1.

gmax = 10
RR = RealDoubleField()

#Clean old input if present
for f in os.listdir("input"):
    if "placeholder" not in f:
        os.remove("input/"+f)

# Generate precisions
pmin = 64
pmax = 2^22
with open("input/precisions.in", "w") as f:
    p = pmin
    while p <= pmax:
        f.write("{}\n".format(p))
        p *= 2

#Generate matrices
for g in range(1, gmax+1):
    # Generate random real part
    re = Matrix(RR, g, g, lambda i,j: random() - 0.5)
    # Ensure that re is symmetric
    for i in range(g):
        for j in range(i):
            re[i,j] = re[j,i]
    # Take the generating matrix to be the identity except for the last vector
    # constructed following Lagarias, Lenstra, Schnorr, "Korkin-Zolotarev bases
    # and successive minima of a lattice and its reciprocal lattice", remark
    # 3.1.
    im = Matrix(RR, g, g)
    for j in range(g):
        im[j,j] = 1
    if g > 1:
        im[g-1,g-1] = sqrt(RR(3))/2
        for i in range(g-1):
            im[i,g-1] = 0.5
    im = im.transpose() * im
    # Ensure that im is exactly symmetric
    for i in range(g):
        for j in range(i):
            im[i,j] = im[j,i]
    # Write matrix
    with open("input/periods-genus-{}.in".format(g), "w") as f:
        for i in range(g):
            for j in range(g):
                f.write("{}\n".format(re[i,j]))
                f.write("{}\n".format(im[i,j]))
