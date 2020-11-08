function zad1()
    % wykresy_dla_tabeli();
    % wykresy_dla_tabeli_z_ruchomym_h();
    % obliczanie_calki_simpsonem();
    % wykresy_modelu_aproksymujacego();
    % wykresy_dla_tabeli_z_ruchomym_h_dla_roznego_stopnia_wielomianu();
    newton_raphson();
end

function newton_raphson()
    y=[ 1200
        25 ];
    krok=0.001;
    zadany_czas=7;
    t=0:krok:zadany_czas;

    Tb=y(1);
    Tw=y(2);
    cb=3.85; % pojemnośc cieplna metalu pręta
    A=0.0109; % powierzchnia pręta
    cw=4.1813; % pojemność cieplna 
    h=78; % współczynnik przewodnictwa cieplnego
    mb=0.25; % masa pręta
    
    temperatury=[1200];
    masy_wody=[0];
    mw=0;
    wymagana_temperatura=125;
    for j = 1:1:inf
        mw = mw + 0.1;
        temperatura=0;
        for i = 1:length(t)-1
            obliczone=y(:,i) + krok * f(t(i), y(1,i), y(2,i), cb, A, mw, cw, h, mb);
            temperatura=obliczone(1);
            y(:,i+1)=obliczone;
        end
        temperatury = [temperatury temperatura];
        masy_wody = [masy_wody mw];
        if (temperatura <= wymagana_temperatura) 
            break
        end
    end
        
    fig=figure('Renderer', 'painters', 'Position', [10 10 1920 1080])
    plot(masy_wody, temperatury, 'o');
    title(sprintf('Wykres temperatur dla zmiany w masie wody. Wymagany czas schłodzenia: %d s \n do temperatury: %d z ostateczną masą wody: %0.3f ',zadany_czas, wymagana_temperatura, masy_wody(length(masy_wody))));
    xlabel('Czas [s]');
    ylabel('Temperatura [stopnie celsiusza]');
    legend('Temperatura pręta');
    saveas(fig,sprintf('NewtonRaphson.png'));

    hold off;
    close;
end

function wartosc_calki = obliczanie_calki_simpsonem
    deltaT=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
    hMatrix=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];

    a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,5);
    ABCs = oblicz_wspolczynniki_fn_sklejanych_3_stopnia(deltaT, hMatrix);

    function y = oblicz_abs_roznice(X)
        y = abs( obliczanie_wielomianu(deltaT, a, X) - interpoluj_wspolczynniki_fn_3_stopnia(ABCs, deltaT, X));
    end

    wartosc_calki = calkowanie_numeryczne_parabol(-1500, 2000, 100, @oblicz_abs_roznice); 
end

function wykresy_dla_tabeli_z_ruchomym_h_dla_roznego_stopnia_wielomianu()
    bledy=[];
    for j=1:1:7
        deltaT=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
        hMatrix=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];
        di = -1500:0.1:2000;
        dl = [];

        a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,j);
        for i=1:length(di)
            dl(i) = obliczanie_wielomianu(deltaT, a, di(i));
        end

        hold on;
        plot(deltaT, hMatrix, 'o', di, dl);

        sum = 0;
        for k=1:length(deltaT) 
            sum = sum + (hMatrix(k) - obliczanie_wielomianu(deltaT, a, deltaT(k)))^2
        end
        bledy = [bledy, sqrt(sum)/(length(deltaT)+1)];
    end
    bledy
end

function wykresy_modelu_aproksymujacego()
    deltaT=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
    hMatrix=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];

    a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,3);

    Tb0 = [1200, 800, 1100, 1200, 800, 1100, 1100, 1100, 1100, 1100];
    Tw0 = [25, 25, 70, 25, 25, 70, 70, 70, 70, 70];
    Mw = [2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 5, 10, 2.5, 2.5];
    czasy = [3, 3, 3, 5, 5, 2, 2, 2, 4, 5];
    Tbk = [107.7, 79.1, 142.1, 105.7, 78.2, 150.1, 116.6, 99.1, 141.2, 140.9];
    Twk = [105.1, 78.0, 139.1, 105.5, 78.1, 138.2, 105.1, 88.1, 139.8, 140.1];

    for nr_pomiaru = 1:length(Tb0)
        krok=0.1;
        t = 0:krok:czasy(nr_pomiaru);
        y=[
            Tb0(nr_pomiaru)
            Tw0(nr_pomiaru)
        ];

        cb=3.85; % pojemnośc cieplna metalu pręta
        A=0.0109; % powierzchnia pręta
        cw=4.1813; % pojemność cieplna 
        mb=0.2; % masa pręta

        fig=figure('Renderer', 'painters', 'Position', [10 10 1920 1080])
        hold on;
        plot(t, y(1,:), t, y(2,:));

        for i = 1:length(t)-1
            h_od_delta_T = y(1,i) - y(2,1);
            ruchomy_h = obliczanie_wielomianu(deltaT, a, h_od_delta_T);

            y(:,i+1)=ulepszony_euler(t(i), y(1,i), y(2,i), cb, A, Mw(nr_pomiaru), cw, ruchomy_h, mb, krok);
        end

        plot(t, y(1,:), t, y(2,:));

        h=160; % współczynnik przewodnictwa cieplnego
        for i = 1:length(t)-1
            y(:,i+1)=ulepszony_euler(t(i), y(1,i), y(2,i), cb, A, Mw(nr_pomiaru), cw, h, mb, krok);
        end

        plot(t, y(1,:), t, y(2,:));
        title(sprintf('Metoda najmniejszych kwadratów \n Wykres dla Tb0(%d),Tw0(%d),czasu(%0.0f),Mw(%d),krok(%0.3f)',Tb0(nr_pomiaru), Tw0(nr_pomiaru),czasy(nr_pomiaru), Mw(nr_pomiaru), krok));
        xlabel('Czas [s]');
        ylabel('Temperatura [stopnie celsiusza]');
        legend('Ruchome h: Temperatura pręta', 'Ruchome h: Temperatura wody', 'Stałe h: Temperatura pręta','Stałe h: Temperatura wody');
        saveas(fig,sprintf('Najmniejsze_kwadraty%d.png',nr_pomiaru));

        hold off;
        close;
    end

end

function wykresy_dla_tabeli_z_ruchomym_h()
    deltaT=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
    hMatrix=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];

    % a=aproksymacja_wyklad(deltaT, h,6);

    di = -1500:0.1:2000;
    dl = [];

    a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,5);

    cb=3.85; % pojemnośc cieplna metalu pręta
    A=0.0109; % powierzchnia pręta
    cw=4.1813; % pojemność cieplna 
    h=160; % współczynnik przewodnictwa cieplnego
    mb=0.2; % masa pręta

    for i=1:length(di)
        dl(i) = obliczanie_wielomianu(deltaT, a, di(i));
    end

    fig=figure('Renderer', 'painters', 'Position', [10 10 1920 1080])
    hold on;
    plot(deltaT, hMatrix, 'o', di, dl);
    ABCs = oblicz_wspolczynniki_fn_sklejanych_3_stopnia(deltaT, hMatrix);
    for i=1:length(di)
        dl(i) = interpoluj_wspolczynniki_fn_3_stopnia(ABCs, deltaT, di(i));
    end
    plot(di, dl, 'b');

    title(sprintf('Wykres dla współczynnika przewodnictwa cieplnego'));
    xlabel('DeltaT[stopnie Cel]');
    ylabel('h[W*m^-2]');
    legend('Charakterystyka pomiarowa', 'Aproksymacja najmniejszych kwadratów', 'Interpolacja funkcjami sklejanymi 3 stopnia');
    saveas(fig,sprintf('Charakterystyka_ruchomego_h.png'));

    hold off;
    close;
end

function wykresy_dla_tabeli()
    Tb0 = [1200, 800, 1100, 1200, 800, 1100, 1100, 1100, 1100, 1100];
    Tw0 = [25, 25, 70, 25, 25, 70, 70, 70, 70, 70];
    Mw = [2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 5, 10, 2.5, 2.5];
    czasy = [3, 3, 3, 5, 5, 2, 2, 2, 4, 5];
    Tbk = [107.7, 79.1, 142.1, 105.7, 78.2, 150.1, 116.6, 99.1, 141.2, 140.9];
    Twk = [105.1, 78.0, 139.1, 105.5, 78.1, 138.2, 105.1, 88.1, 139.8, 140.1];

    for nr_pomiaru = 1:length(Tb0)
        krok=0.1;
        t = 0:krok:czasy(nr_pomiaru);
        y=[
            Tb0(nr_pomiaru)
            Tw0(nr_pomiaru)
        ];

        cb=3.85; % pojemnośc cieplna metalu pręta
        A=0.0109; % powierzchnia pręta
        cw=4.1813; % pojemność cieplna 
        h=160; % współczynnik przewodnictwa cieplnego
        mb=0.2; % masa pręta

        for i = 1:length(t)-1
            y(:,i+1)=euler(t(i), y(1,i), y(2,i), cb, A, Mw(nr_pomiaru), cw, h, mb, krok);
        end

        ostatni_wynik = y(:,length(y));
        
        blad_Tb = blad_wzgledny(Tbk(nr_pomiaru), ostatni_wynik(1));
        blad_Tw = blad_wzgledny(Twk(nr_pomiaru), ostatni_wynik(2));

        fig=figure('Renderer', 'painters', 'Position', [10 10 1920 1080])
        hold on;
        plot(t, y(1,:), t, y(2,:));

        for i = 1:length(t)-1
            y(:,i+1)=ulepszony_euler(t(i), y(1,i), y(2,i), cb, A, Mw(nr_pomiaru), cw, h, mb, krok);
        end

        ostatni_wynik = y(:,length(y));
        
        blad_Tb = blad_wzgledny(Tbk(nr_pomiaru), ostatni_wynik(1));
        blad_Tw = blad_wzgledny(Twk(nr_pomiaru), ostatni_wynik(2));

        plot(t, y(1,:), t, y(2,:));
        title(sprintf('Wykres dla Tb0(%d),Tw0(%d),czasu(%0.0f),Mw(%d),krok(%0.3f),blądTb(%0.3f),blądTk(%0.3f)',Tb0(nr_pomiaru), Tw0(nr_pomiaru),czasy(nr_pomiaru), Mw(nr_pomiaru), krok, blad_Tb, blad_Tw));
        xlabel('Czas [s]');
        ylabel('Temperatura [stopnie celsiusza]');
        legend('Euler: Temperatura pręta','Euler: Temperatura wody', 'Ulepszony Euler: Temperatura pręta', 'Ulepszony Euler: Temperatura wody');
        saveas(fig,sprintf('Pomiar_%d.png',nr_pomiaru));

        hold off;
        close;
    end
end

function r = euler(t, Tb, Tw, cb, A, mw, cw, h, mb, krok)
    y = [
        Tb,
        Tw
    ]
    r = y(:,1) + krok * f(t, Tb, Tw, cb, A, mw, cw, h, mb);
end

function r = ulepszony_euler(t, Tb, Tw, cb, A, mw, cw, h, mb, krok)
    y = [
        Tb,
        Tw
    ]
    yp = y(:, 1) + krok/2 * f(t, Tb, Tw, cb, A, mw, cw, h, mb);
    r = y(:, 1) + krok * f(t, yp(1), yp(2), cb, A, mw, cw, h, mb); 
end

% Temperatura początkowa pręta powinna miec 1200 stopni C
% Temperatura oleju chłodzącego powinna mieć 25 stopni C

function dy = f(t, Tb, Tw, cb, A, mw, cw, h, mb)
    dy=[
        ((Tw-Tb)*h*A)/(mb*cb)
        ((Tb-Tw)*h*A)/(mw*cw)
        ];    
end