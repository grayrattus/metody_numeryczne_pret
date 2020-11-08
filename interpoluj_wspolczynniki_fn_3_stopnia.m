function yspline = interpoluj_wspolczynniki_fn_3_stopnia(ABCs, X, value)
    N = length(X);
    Num_eqns = N-1;
    for idx = 1:Num_eqns
        if value >= X(idx) && value <= X(idx + 1)
            row = 1 + (idx-1)*4;
            a = ABCs(row);
            b = ABCs(row+1);
            c = ABCs(row+2);
            d = ABCs(row+3);
            yspline = a*value^3 + b*value^2 + c*value + d;
            return;
        end
    end
    yspline = 0;
end