#
# Run experiments using the Theta.jl package.
#

using Theta

f_out = open("output/Theta.jl_lowprec.out", "w")

function set_tau_genus_1(tau, filename)
    f = open(filename, "r")
    lines = readlines(f)
    tau[1] = parse(ComplexF64, lines[1]) + parse(ComplexF64, lines[2])*im
    close(f)
end

function set_tau(tau, filename, g)
    f = open(filename, "r")
    lines = readlines(f)
    for i = 1:g
        for j = 1:g
            real_part = parse(ComplexF64, lines[2*(i-1)*g+2*(j-1)+1])
            imag_part = parse(ComplexF64, lines[2*(i-1)*g+2*(j-1)+2])
            tau[i,j] = real_part + imag_part*im
        end
    end
    close(f)
end

function run_at_prec(prec, g)
    if g == 1
        tau = Vector{ComplexF64}(undef, g)
        set_tau_genus_1(tau, "input/periods-genus-1.in")
    else
        tau = Matrix{ComplexF64}(undef, g, g)
        set_tau(tau, "input/periods-genus-$g.in", g)
    end
    z = Vector{ComplexF64}(undef, g)
    for i = 1:g
        z[i] = 0
    end

    t = 0
    total = 0
    nbtries = 1
    while total < 1
        total = time()
        #for a = 0:(2^g-1)
        a = 0
        for k = 1:nbtries
            M = RiemannMatrix(tau)
            theta(z, M) #, char=[digits(a, base=2, pad=g), digits(0, base=2, pad=g)])
        end
        total = time() - total
        t = total / nbtries
        nbtries *= 4
    end
    return t
end

# Dry run so that julia can compile everything
# run_at_prec(64, 1);
run_at_prec(64, 2);

global g = 2
while true
    try
        print("g = $g...\n")
        prec = 64
        local t = run_at_prec(prec, g)
        write(f_out, "$g    $t\n")
        if t > 10
            break
        end
        global g += 1
    catch LoadError
        break
    end
end

close(f_out)
