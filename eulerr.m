function r = eulerr(Tb, Tw, cb, A, mw, cw, h, mb, krok)
    y = [
        Tb,
        Tw
    ];
    r = y(:,1) + krok * f(Tb, Tw, cb, A, mw, cw, h, mb);
end