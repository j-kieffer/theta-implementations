# 
# In each genus from g=1 to gmax, generate files precisions-genus-g.in,
# lll-genus-g.in and hkz-genus-g.in.
# 
# The first line of precisions-genus-g.in is the number of precisions to
# consider, then one precision per line.
# 
# Both lll-genus-g.in and hkz-genus-g.in contain a matrix in the Siegel
# fundamental domain. The line number 2*i*g + 2*j (starting from 0)
# (resp. 2*i*g + 2*j + 1) contains the real (resp. imaginary) part of the
# coefficient tau_{i,j}. The imaginary part of tau is LLL-reduced
# (resp. HKZ-reduced), and the coefficient tau_{0,0} belongs to the usual
# fundamental domain in genus 1.

gmax = 6
RR = RealDoubleField()

#Clean old input if present
for f in os.listdir("input"):
    if "placeholder" not in f:
        os.remove("input/"+f)

#Generate new input
for g in range(1, gmax+1):
    # Generate precisions
    if (g == 1):
        pmin = 64
        pmax = 2^12
        pstep = 256
    elif (g == 2):
        pmin = 64
        pmax = 2^11
        pstep = 64
    elif (g == 3):
        pmin = 64
        pmax = 2^10
        pstep = 64
    else:
        pmin = 64
        pmax = 64
        pstep = 1
    nb = (pmax - pmin)/pstep + 1
    with open("input/precisions-genus-{}.in".format(g), "w") as f:
        f.write("{}\n".format(nb))
        for p in range(pmin, pmax+1, pstep):
            f.write("{}\n".format(p))

#Generate matrices
for g in range(1, gmax+1):
    # Generate random real part
    re = Matrix(RR, g, g, lambda i,j: random() - 0.5)
    # Ensure that re is symmetric
    for i in range(g):
        for j in range(i):
            re[i,j] = re[j,i]
    
    # In the HKZ case, take the generating matrix to be the identity except for
    # the last vector constructed following Lagarias, Lenstra, Schnorr,
    # "Korkin-Zolotarev bases and successive minima of a lattice and its
    # reciprocal lattice", remark 3.1.
    im = Matrix(RR, g, g)
    for j in range(g):
        im[j,j] = 1
    if g > 1:
        im[g-1,g-1] = sqrt(RR(3))/2
        for i in range(g-1):
            im[i,g-1] = random() - 0.5
    im = im.transpose() * im
    # Ensure that im is exactly symmetric
    for i in range(g):
        for j in range(i):
            im[i,j] = im[j,i]
    # Write HKZ
    with open("input/hkz-genus-{}.in".format(g), "w") as f:
        for i in range(g):
            for j in range(g):
                f.write("{}\n".format(re[i,j]))
                f.write("{}\n".format(im[i,j]))
    
    # In the LLL case, generate the coefficients mu_{i,j} first, then reduce
    # the norms of the Gram-Schmidt vectors accordingly
    mu = Matrix(RR, g, g)
    im = Matrix(RR, g, g)
    delta = 0.99
    for j in range(g):
        im[j,j] = 1
        for i in range(j):
            mu[i,j] = random() - 0.5
            im[i,j] = mu[i,j]
    for j in range(1,g):
        c = sqrt(delta - mu[j-1,j]^2)
        for k in range(g):
            for l in range(j,g):
                im[k,l] *= c
    im = im.transpose() * im
    # Ensure that im is exactly symmetric
    for i in range(g):
        for j in range(i):
            im[i,j] = im[j,i]
    # Write LLL
    with open("input/lll-genus-{}.in".format(g), "w") as f:
        for i in range(g):
            for j in range(g):
                f.write("{}\n".format(re[i,j]))
                f.write("{}\n".format(im[i,j]))
    
