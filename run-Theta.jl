#
# Run experiments using the Theta.jl package.
#

using Theta

f_lll = open("output/Theta.jl_lowprec_lll.out", "w")
f_hkz = open("output/Theta.jl_lowprec_hkz.out", "w")

function run_at_prec(red, prec, g)
    return 0
end
    
g = 1
while true
    try
        f_in = open("input/precisions-genus-$g.in", "r")
        print("g = $g...\n")
        prec = 64
        t = run_at_prec("lll", prec, g)
        write(f_lll, "$g    $t\n")
        t = run_at_prec("hkz", prec, g)
        write(f_hkz, "$g    $t\n")
        global g += 1
    catch LoadError
        break
    end
end

close(f_lll)
close(f_hkz)
