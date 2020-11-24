function wspolczynniki = splajny_proste()
    % Y=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
    % X=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];

    % kwadraty_wspolczynniki=aproksymacja_najmniejszych_kwadratow(Y,X,5);

    ilosc_wartosci = 3;
    n = 2*(ilosc_wartosci-2) + 2;
    rownoodlegle_y = [];
    % a = -1500;
    % b = 2000;
    a = 0;
    b = 5;
    h = (b - a) / n;

    for i = 1:n
        rownoodlegle_x(i) = a + (i -1) * h;
        % rownoodlegle_y(i) = obliczanie_wielomianu(Y, kwadraty_wspolczynniki, rownoodlegle_x(i));
        rownoodlegle_y(i) = funkcja(rownoodlegle_x(i));
    end

    hold on;
    plot(rownoodlegle_x, rownoodlegle_y);

    alpha = oblicz_pochodna_lewa(a);
    beta = oblicz_pochodna_prawa(b);

    rownanie_pierwszej_pochodnej = zeros(1,n);
    rownanie_pierwszej_pochodnej(1) = 4;
    rownanie_pierwszej_pochodnej(2) = 2;
    rownanie_drugiej_pochodnej = zeros(1,n)
    rownanie_drugiej_pochodnej(n - 1) = 2;
    rownanie_drugiej_pochodnej(n) = 4;

    macierz = (zeros(n -2 , n - 2));
    for i = 1:(n - 2)
        macierz(i, i) = 1;
        macierz(i, i+1) = 4;
        macierz(i, i+2) = 1;
    end

    macierz_z_pochodnymi = [
        rownanie_pierwszej_pochodnej
        macierz
        rownanie_drugiej_pochodnej
    ];

    macierz_b = zeros(1,n);

    macierz_b(1) = rownoodlegle_y(1) - (h / 3) * alpha;
    macierz_b(n) = rownoodlegle_y(n) + (h / 3) * beta;

    for i=2:(n - 1)
        macierz_b(i) = rownoodlegle_y(i);
    end

    wspolczynniki = macierz_z_pochodnymi / macierz_b;
    wspolczynniki = []

    test_y = [];
    test_x = -1500:0.01:2000;

    for i = 1:length(test_x)
        test_y(i) = interpoluj_wspolczynniki_fn_3_stopnia(wspolczynniki, Y,  test_x(i));
    end

    plot(test_x, test_y);
    hold off;

    function y = funkcja(x)
        y = x + cos(2 * x);
    end
    function y = oblicz_pochodna_prawa(x) 
        krok = 0.00001;
        y = (funkcja(x - krok) - funkcja(x)) / krok;
    end

    function y = oblicz_pochodna_lewa(x) 
        krok = 0.00001;
        y = (funkcja(x + krok) - funkcja(x)) / krok;
    end

    % function y = oblicz_pochodna_prawa(x) 
    %     krok = 0.001;
    %     y = (obliczanie_wielomianu(Y, kwadraty_wspolczynniki, x - krok) - obliczanie_wielomianu(X, kwadraty_wspolczynniki, x)) / krok;
    % end

    % function y = oblicz_pochodna_lewa(x) 
    %     krok = 0.001;
    %     y = (obliczanie_wielomianu(Y, kwadraty_wspolczynniki, x + krok) - obliczanie_wielomianu(X, kwadraty_wspolczynniki, x)) / krok;
    % end

    % plot(0:0.001:5, funkcja(0:0.001:5));
end