function y=interpolacja_funkcjami_sklejanymi(xp, yp, x)
    if (x < xp(1))
        y=xp(1);
        return;
    end
    
    if (x > xp(end))
        y=xp(end);
        return;
    end
    
    for i = 1:length(xp) - 1
        if x >= xp(i) && x <= xp(i + 1)
            break;
        end
    end

    A = [
         1 xp(i)
         1 xp(i + 1)
        ]
    b = [
        yp(i)
        yp(i + 1)
    ]

    a = A\b;

    y = a(1) + a(2) * x;
end
