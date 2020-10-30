function a=aproksymacja_wyklad(xp, yp, n)
    A = zeros(n);
    b = zeros(n, 1);

    for w=1:n
        for k = 1:n
            s = 0;
            for i=1:length(xp)
                s = s + xp(i) ^ (w + k - 2)
            end
            A(w,k) = s;
        end
        s = 0;
        for i=1:length(xp)
            s = s + yp(i) * xp(i) ^ (w - 1); 
        end
        b(w) = s
    end

    a = A\b;
end

