
function y = obliczanie_wielomianu(xp, a, x)
    if (x < xp(1))
        y=xp(1);
        return;
    end
    
    if (x > xp(end))
        y=xp(end);
        return;
    end
    
    y=0;
    for k=1:length(a)
        y = y + a(k) * x ^ (k - 1) ;
    end
end


