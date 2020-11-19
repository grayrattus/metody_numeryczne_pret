function wartosc_spline = interpoluj_wspolczynniki_fn_3_stopnia(wspolczynniki, X, y)
    ilosc_wartosci = length(X);
    ilosc_rownan = ilosc_wartosci-1;
    for i = 1:ilosc_rownan
        if y >= X(i) && y <= X(i + 1)
            wiersz = 1 + (i-1)*4;
            a = wspolczynniki(wiersz);
            b = wspolczynniki(wiersz+1);
            c = wspolczynniki(wiersz+2);
            d = wspolczynniki(wiersz+3);
            wartosc_spline = a*y^3 + b*y^2 + c*y + d;
            return;
        end
    end
    wartosc_spline = 0;
end