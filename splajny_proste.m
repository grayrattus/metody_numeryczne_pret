function wartosc = splajny_proste(rownoodlegle_x, rownoodlegle_y, pochodna_a, pochodna_b, x_arg, n, h)
    macierz = zeros(length(rownoodlegle_x) - 2, length(rownoodlegle_x));
    for i = 1:(length(rownoodlegle_x) - 2)
        macierz(i, i) = 1;
        macierz(i, i+1) = 4;
        macierz(i, i+2) = 1;
    end

    alpha = abs(pochodna_a);
    beta = abs(pochodna_b);

    rownanie_pierwszej_pochodnej = zeros(1,length(macierz));
    rownanie_pierwszej_pochodnej(1) = 4;
    rownanie_pierwszej_pochodnej(2) = 2;
    rownanie_drugiej_pochodnej = zeros(1,length(macierz));
    rownanie_drugiej_pochodnej(end - 1) = 2;
    rownanie_drugiej_pochodnej(end) = 4;

    macierz_z_pochodnymi = [
        rownanie_pierwszej_pochodnej
        macierz
        rownanie_drugiej_pochodnej
    ];

    macierz_b = zeros(1,length(macierz_z_pochodnymi));

    macierz_b(1) = rownoodlegle_y(1) + ((h / 3) * alpha);
    macierz_b(end) = rownoodlegle_y(end) - ((h / 3) * beta);

    for i=2:length(macierz_b) - 1
        macierz_b(i) = rownoodlegle_y(i);
    end

    wspolczynniki = macierz_z_pochodnymi \ transpose(macierz_b);
    wspolczynniki = [wspolczynniki(2) - (h/3) *alpha
        wspolczynniki
        wspolczynniki(end - 1) + (h/3) *beta];

    wartosc = oblicz_w_przedziale(rownoodlegle_x, wspolczynniki, x_arg, h);

    function suma = oblicz_w_przedziale(x_wejsciowe, wspolczynniki, x, h)
        suma = 0;
        wartosci_sklejane = [];
        X = [x_wejsciowe];
        for i = 1:3
            X = [X(1) - (h * i),X, X(end) + (h * i)];
        end
        for i = 3:length(X) - 2
            if x >= X(i - 2) && x <= X(i -1)
                wartosci_sklejane = [wartosci_sklejane, (x - X(i-2))^3];
                continue;
            end
            if x >= X(i - 1) && x <= X(i)
                wartosci_sklejane = [wartosci_sklejane, (x - X(i-2))^3 - 4*(x - X(i - 1))^3];
                continue;
            end
            if x >= X(i) && x <= X(i + 1)
                wartosci_sklejane = [wartosci_sklejane, (X(i+2) - x)^3-4*(X(i+1) - x)^3];
                continue;
            end
            if x >= X(i + 1) && x <= X(i + 2)
                wartosci_sklejane = [wartosci_sklejane, (X(i+2) - x)^3];
                continue;
            end
            if x <= X(i - 2) || x >= X(i + 2)
                wartosci_sklejane = [wartosci_sklejane, 0];
                continue;
            end
        end
        for i = 1:length(wspolczynniki)
            suma = suma + (wspolczynniki(i) * wartosci_sklejane(i))* 1/(h^3);
        end
    end
end