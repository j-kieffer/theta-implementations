//
// Run experiments using Magma's Theta instrinsic
//

function set_tau(CC, filename, g)
    I := CC.1;
    values := Split(Read(filename));
    tau := ZeroMatrix(CC, g, g);
    for i := 1 to g do
        for j := 1 to g do
            evstr := Sprintf("(%o) + (%o)*I", values[2*(i-1)*g + 2*(j-1) + 1],
                             values[2*(i-1)*g + 2*(j-1) + 2]);
            tau[i,j] := eval(evstr);
        end for;
    end for;
    return tau;
end function;

function run_at_prec(p, g)
    CC := ComplexField(p: Bits:=true);
    input := Sprintf("input/periods-genus-%o.in", g);
    tau := set_tau(CC, input, g);
    z := ZeroMatrix(CC, g, 1);
    char := ZeroMatrix(Integers(), 2*g, 1);

    // Magma's timer is imprecise for small amounts.
    nb_tries := 1;
    total := 0;
    t := 0;
    while (total lt 1) do
        t0 := Cputime();
        for k := 1 to nb_tries do
            _ := Theta(char, z, tau);
        end for;
        total := Cputime(t0);
        t := total/nb_tries;
        nb_tries *:= 4;
    end while;
    return t;
end function;

function run_all_precs(precs, g)
    output := Sprintf("output/magma-genus-%o.out", g);
    ovw := true;
    for p in precs do
        printf "    p = %o...\n", p;
        r := run_at_prec(p, g);
        line := Sprintf("%o    %.9o", p, r);
        Write(output, line: Overwrite := ovw);
        if r gt 10 then
            return p;
        end if;
        ovw := false;
    end for;
    return true;
end function;

lines := Split(Read("input/precisions.in"));
precs := [StringToInteger(x): x in lines];

g := 1;
while true do
    try
        printf "g = %o...\n", g;
        p := run_all_precs(precs, g);
        g +:= 1;
        if p eq 64 then
            break;
        end if;
    catch e
        break;
    end try;
end while;

exit;
