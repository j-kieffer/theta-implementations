
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

function run_at_prec(red, p, g)
    CC := ComplexField(p: Bits:=true);
    input := Sprintf("input/%o-genus-%o.in", red, g);
    tau := set_tau(CC, input, g);
    z := ZeroMatrix(CC, g, 1);
    char := ZeroMatrix(Integers(), 2*g, 1);
    
    t0 := Cputime();
    _ := Theta(char, z, tau);
    return Cputime(t0);
end function;

function run_all_precs(red, precs, g)
    output := Sprintf("output/magma-%o-genus-%o.out", red, g);
    ovw := true;
    for p in precs do
        r := run_at_prec(red, p, g);
        line := Sprintf("%o    %o", p, r);
        Write(output, line: Overwrite := ovw);
        ovw := false;
    end for;
    return true;
end function;

g := 1;
while true do
    try
        input := Sprintf("input/precisions-genus-%o.in", g);
        lines := Split(Read(input));
        printf "g = %o...\n", g;
        precs := [StringToInteger(x): x in lines[2..(#lines)]];
        _ := run_all_precs("lll", precs, g);
        _ := run_all_precs("hkz", precs, g);
        g +:= 1;
    catch e
        break;
    end try;
end while;

gmax := g-1;
output_hkz := "output/magma_lowprec_lll.out";
output_lll := "output/magma_lowprec_hkz.out";
ovw := true;
for g := 1 to gmax do
    t := run_at_prec("lll", 64, g);
    line := Sprintf("%o    %o", g, t);
    Write(output_lll, line: Overwrite := ovw);
    t := run_at_prec("hkz", 64, g);
    line := Sprintf("%o    %o", g, t);
    Write(output_hkz, line: Overwrite := ovw);
    ovw := false;
end for;
    
exit;
