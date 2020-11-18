function r = ulepszony_euler(Tb, Tw, cb, A, mw, cw, h, mb, krok)
    y = [
        Tb,
        Tw
    ];
    yp = y(:, 1) + krok/2 * f(Tb, Tw, cb, A, mw, cw, h, mb);
    r = y(:, 1) + krok * f(yp(1), yp(2), cb, A, mw, cw, h, mb); 
end
