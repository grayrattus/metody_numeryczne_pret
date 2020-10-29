function a = interpolacja_vandermond(xp, yp, x)
    n = length(xp);
    A = zeros(n);
    b = zeros(n, 1);

    for w=1:n
        for k = 1:n
            A(w,k) = xp(w)^(k-1);
        end
        b(w) = yp(w);
    end
    
    a = A\b;
end


