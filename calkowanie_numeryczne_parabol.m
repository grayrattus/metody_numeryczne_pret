function y = calkowanie_numeryczne_parabol(a, b, n, f)
    h = (b - a) / n;
    y = f(a) + f(b);

    for  i = 1:n-1
        if (mod(i,2))
            y = y + 4 * f(i * h);
        else
            y = y + 2 * f(i * h);
        end
    end

    y = h * y / 3;
end