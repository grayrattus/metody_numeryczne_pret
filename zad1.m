function zad1()
    wielkosc_wykresu=[10 10 800 600];
    deltaT=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
    hMatrix=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];

    Tb0 = [1200, 800, 1100, 1200, 800, 1100, 1100, 1100, 1100, 1100];
    Tw0 = [25, 25, 70, 25, 25, 70, 70, 70, 70, 70];
    Mw = [2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 5, 10, 2.5, 2.5];
    czasy = [3, 3, 3, 5, 5, 2, 2, 2, 4, 5];
    Tbk = [107.7, 79.1, 142.1, 105.7, 78.2, 150.1, 116.6, 99.1, 141.2, 140.9];
    Twk = [105.1, 78.0, 139.1, 105.5, 78.1, 138.2, 105.1, 88.1, 139.8, 140.1];

    wykresy_dla_tabeli(0.1);
    wykresy_dla_tabeli(0.01);
    wykresy_dla_tabeli(0.001);
    wykresy_dla_tabeli_z_ruchomym_h();
    wykresy_dla_tabeli_z_ruchomym_h_dla_roznego_stopnia_wielomianu(5);
    wykresy_dla_tabeli_z_ruchomym_h_dla_roznego_stopnia_wielomianu(8);
    obliczanie_calki_simpsonem();
    wykresy_modelu_aproksymujacego();
    newton_raphson();

    function newton_raphson()
        krok=0.01;
        zadany_czas=0.7;
        t=0:krok:zadany_czas;

        cb=0.29; % pojemnośc cieplna metalu pręta
        A=0.0109; % powierzchnia pręta
        cw=4.1813; % pojemność cieplna 
        mb=0.25; % masa pręta
        
        temperatury=[1200];
        masy_wody=[0];
        mw=0;
        wymagana_temperatura=125;
        ABCs = oblicz_wspolczynniki_fn_sklejanych_3_stopnia(deltaT, hMatrix);
        for j = 1:1:inf
            y=[ 1200
                25 ];
            mw = mw + 0.01;
            temperatura=0;
            for i = 1:length(t)-1
                h_sklejanych_3_stopnia = interpoluj_wspolczynniki_fn_3_stopnia(ABCs, deltaT, y(1,i) - y(2,i));
                obliczone=ulepszony_euler(y(1,i), y(2,i), cb, A, mw, cw, h_sklejanych_3_stopnia, mb, krok);
                temperatura=obliczone(1);
                y(:,i+1)=obliczone;
            end
            temperatury = [temperatury temperatura];
            masy_wody = [masy_wody mw];

            temperatura
            if (temperatura <= wymagana_temperatura) 
                break
            end
        end
            
        fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
        plot(masy_wody, temperatury, 'o');
        title(sprintf('Wykres temperatur dla zmiany w masie wody\nWymagany czas schlodzenia: %0.3f s \n do temperatury: %d $[^\\circ C]$ z ostateczna masa wody: %0.3f [kg] ',zadany_czas, wymagana_temperatura, masy_wody(length(masy_wody))), 'interpreter', 'latex');
        annotation('textbox',[.15 .1 .8 .8],'interpreter', 'latex', 'String',{
            sprintf('$cb(%0.3f)[\\frac{J}{kg*K}]$', cb),
            sprintf('$A(%0.5f)[m^2]$', A),
            sprintf('$cw(%0.5f)[\\frac{J}{kg*K}]$', cw),
            sprintf('$mb(%0.2f)[kg]$', mb),
        },'EdgeColor','none');
        xlabel('Masa wody[kg]','interpreter', 'latex');
        ylabel('$Temperatura\:preta[^\circ C]$','interpreter', 'latex');
        legend('Temperatura pręta');
        saveas(fig,sprintf('NewtonRaphson.png'));

        hold off;
        close;
    end

    function wartosc_calki = obliczanie_calki_simpsonem
        a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,5);
        ABCs = oblicz_wspolczynniki_fn_sklejanych_3_stopnia(deltaT, hMatrix);
        di = -1500:0.1:2000;
        wartosci_kwadratow = []
        wartosci_sklejanych = []

        function y = oblicz_abs_roznice(X)
            y = abs( obliczanie_wielomianu(deltaT, a, X) - interpoluj_wspolczynniki_fn_3_stopnia(ABCs, deltaT, X));
        end

        wartosc_calki = calkowanie_numeryczne_parabol(-1500, 2000, 100, @oblicz_abs_roznice) / 3500; 

        fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
        hold on;
        for i=1:length(di)
            wartosci_kwadratow(i) = obliczanie_wielomianu(deltaT, a, di(i));
            wartosci_sklejanych(i) = interpoluj_wspolczynniki_fn_3_stopnia(ABCs, deltaT, di(i));
        end
        plot(di, wartosci_kwadratow, 'b', di, wartosci_sklejanych, 'r');

        title(sprintf('Całka metodą simpsona pomiędzy funkcjami sklejanmi 3 stopnia a metodą kwadratów. \n Wartość całki: %.3f', wartosc_calki));
        shade(di,wartosci_kwadratow, di, wartosci_sklejanych, 'FillType', [1, 2; 2, 1]);
        xlabel('$\Delta T[^\circ C]$','interpreter', 'latex');
        ylabel('$h[W*m^{-2}]$','interpreter', 'latex');
        legend('Metoda kwadratów', 'Funkcje sklejane 3 stopnia');
        saveas(fig,sprintf('Metoda_simpsona.png'));

        hold off;
        close;
    end

    function wykresy_dla_tabeli_z_ruchomym_h_dla_roznego_stopnia_wielomianu(stopnie_wielomianu)
        bledy=[];
        fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
        labele_wielomianu = {'Wartości z eksperymentu'};
        headery_bledow = {};
        plot(deltaT, hMatrix, 'o');
        for j=1:1:stopnie_wielomianu
            di = -1500:0.1:2000;
            dl = [];

            a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,j);
            for i=1:length(di)
                dl(i) = obliczanie_wielomianu(deltaT, a, di(i));
            end

            hold on;
            plot(di, dl);

            sum = 0;
            for k=1:length(deltaT) 
                sum = sum + (hMatrix(k) - obliczanie_wielomianu(deltaT, a, deltaT(k)))^2
            end
            bledy = [bledy, sqrt(sum)/(length(deltaT)+1)];
            labele_wielomianu{end+1} = sprintf('Wielomian stopnia %d', j);
            headery_bledow{end+1} = sprintf('p(%d)', j);
        end
        legend(labele_wielomianu);
        title(sprintf('Wykres aproksymacji najmniejszych kwadratów dla różnych stopni wielomianów'));
        xlabel('$\Delta T[^\circ C]$','interpreter', 'latex');
        ylabel('$h[W*m^{-2}]$','interpreter', 'latex');
        saveas(fig,sprintf('Stopnie_wielomianu_%d.png',stopnie_wielomianu));
        hold off;

        macierz_do_zapisania = [
            bledy
        ]
        macierz_do_zapisania = round(macierz_do_zapisania, 5);

        writecell(headery_bledow, sprintf('bledy_stopni_wielomianow_%d.csv', stopnie_wielomianu));
        writematrix(macierz_do_zapisania, sprintf('bledy_stopni_wielomianow_%d.csv',stopnie_wielomianu), 'WriteMode', 'append');

        close;
        bledy
    end

    function wykresy_modelu_aproksymujacego()
        a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,5);
        ABCs = oblicz_wspolczynniki_fn_sklejanych_3_stopnia(deltaT, hMatrix);

        h=160; % współczynnik przewodnictwa cieplnego

        for nr_pomiaru = 1:length(Tb0)
            krok=0.1;
            t = 0:krok:czasy(nr_pomiaru);
            y_stale_h=[
                Tb0(nr_pomiaru)
                Tw0(nr_pomiaru)
            ];
            y_kwadraty=[
                Tb0(nr_pomiaru)
                Tw0(nr_pomiaru)
            ];
            y_funkcje_3_stopnia=[
                Tb0(nr_pomiaru)
                Tw0(nr_pomiaru)
            ];
            y_funkcje_1_stopnia=[
                Tb0(nr_pomiaru)
                Tw0(nr_pomiaru)
            ];

            cb=3.85; % pojemnośc cieplna metalu pręta
            A=0.0109; % powierzchnia pręta
            cw=4.1813; % pojemność cieplna 
            mb=0.2; % masa pręta

            fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
            hold on;

            for i = 1:length(t)-1
                h_kwadratow = obliczanie_wielomianu(deltaT, a, y_kwadraty(1,i) - y_kwadraty(2,i));
                h_sklejanych_3_stopnia = interpoluj_wspolczynniki_fn_3_stopnia(ABCs, deltaT, y_funkcje_3_stopnia(1,i) - y_funkcje_3_stopnia(2,i));
                h_sklejanych_1_stopnia = interpolacja_funkcjami_sklejanymi(deltaT, hMatrix, y_funkcje_1_stopnia(1,i) - y_funkcje_1_stopnia(2,i));

                y_kwadraty(:,i+1)=ulepszony_euler(y_kwadraty(1,i), y_kwadraty(2,i), cb, A, Mw(nr_pomiaru), cw, h_kwadratow, mb, krok);
                y_funkcje_3_stopnia(:,i+1)=ulepszony_euler(y_funkcje_3_stopnia(1,i), y_funkcje_3_stopnia(2,i), cb, A, Mw(nr_pomiaru), cw, h_sklejanych_3_stopnia, mb, krok);
                y_funkcje_1_stopnia(:,i+1)=ulepszony_euler(y_funkcje_1_stopnia(1,i), y_funkcje_1_stopnia(2,i), cb, A, Mw(nr_pomiaru), cw, h_sklejanych_1_stopnia, mb, krok);
                y_stale_h(:,i+1)=ulepszony_euler(y_stale_h(1,i), y_stale_h(2,i), cb, A, Mw(nr_pomiaru), cw, h, mb, krok);
            end

            plot(t, y_kwadraty(1,:), t, y_kwadraty(2,:), t, y_funkcje_3_stopnia(1,:), t, y_funkcje_3_stopnia(2,:), t, y_funkcje_1_stopnia(1,:), t, y_funkcje_1_stopnia(2,:), t, y_stale_h(1, :), t, y_stale_h(2,:));

            title(sprintf('$Wykres\\:dla\\:Tb0(%d)[^\\circ C],Tw0(%d)[^\\circ C],czasu(%0.0f)[s],Mw(%0.1f)[kg],krok(%0.3f)$',Tb0(nr_pomiaru), Tw0(nr_pomiaru),czasy(nr_pomiaru), Mw(nr_pomiaru), krok), 'interpreter', 'latex');
            annotation('textbox',[.15 .1 .8 .8],'interpreter', 'latex', 'String',{
                sprintf('$cb(%0.3f)[\\frac{J}{kg*K}]$', cb),
                sprintf('$A(%0.5f)[m^2]$', A),
                sprintf('$cw(%0.5f)[\\frac{J}{kg*K}]$', cw),
                sprintf('$mb(%0.2f)[kg]$', mb),
            },'EdgeColor','none');
            xlabel('Czas[s]');
            ylabel('$Temperatura[^\circ C]$','interpreter', 'latex');
            legenda={
                'Temp Pręta Najmniejsze kwadraty'
                'Temp Oleju Najmniejsze kwadraty'
                'Temp Pręta Funkcje sklejane 3 stopnia'
                'Temp Oleju Funkcje sklejane 3 stopnia'
                'Temp Pręta Funkcje sklejane 1 stopnia'
                'Temp Oleju Funkcje sklejane 1 stopnia'
                'Temp Pręta stałe h'
                'Temp Oleju stałe h'
            }
            legend(legenda);
            saveas(fig,sprintf('modele_aproksymujace_%d.png',nr_pomiaru));

            hold off;
            close;
        end
    end

    function wykresy_dla_tabeli_z_ruchomym_h()
        di = -1500:0.1:2000;
        dl = [];

        a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,5);

        for i=1:length(di)
            dl(i) = obliczanie_wielomianu(deltaT, a, di(i));
        end

        fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu);
        hold on;
        plot(deltaT, hMatrix, 'o', di, dl);
        ABCs = oblicz_wspolczynniki_fn_sklejanych_3_stopnia(deltaT, hMatrix);
        for i=1:length(di)
            dl(i) = interpoluj_wspolczynniki_fn_3_stopnia(ABCs, deltaT, di(i));
        end
        plot(di, dl, 'b');

        for i=1:length(di)
            dl(i) = interpolacja_funkcjami_sklejanymi(deltaT, hMatrix, di(i));
        end
        plot(di, dl, 'g');

        title(sprintf('Wykres dla współczynnika przewodnictwa cieplnego'));
        xlabel('$\Delta T[^\circ C]$','interpreter', 'latex');
        ylabel('$h[W*m^{-2}]$','interpreter', 'latex');
        legend('Charakterystyka pomiarowa', 'Aproksymacja najmniejszych kwadratów', 'Interpolacja funkcjami sklejanymi 3 stopnia', 'Interpolacja funkcjami 1 stopnia');
        saveas(fig,sprintf('Charakterystyka_ruchomego_h.png'));

        hold off;
        close;
    end

    function wykresy_dla_tabeli(krok)
        bledy_euler_Tb = [];
        bledy_euler_Tw = [];

        bledy_ulepszony_euler_Tw = [];
        bledy_ulepszony_euler_Tb = [];
        for nr_pomiaru = 1:length(Tb0)
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
                y(:,i+1)=euler(y(1,i), y(2,i), cb, A, Mw(nr_pomiaru), cw, h, mb, krok);
            end

            ostatni_wynik = y(:,length(y));
            
            bledy_euler_Tb = [bledy_euler_Tb, blad_wzgledny(Tbk(nr_pomiaru), ostatni_wynik(1))];
            bledy_euler_Tw = [bledy_euler_Tw, blad_wzgledny(Twk(nr_pomiaru), ostatni_wynik(2))];

            fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
            hold on;
            plot(t, y(1,:), t, y(2,:));

            for i = 1:length(t)-1
                y(:,i+1)=ulepszony_euler(y(1,i), y(2,i), cb, A, Mw(nr_pomiaru), cw, h, mb, krok);
            end

            ostatni_wynik = y(:,length(y));
            
            bledy_ulepszony_euler_Tb = [bledy_ulepszony_euler_Tb, blad_wzgledny(Tbk(nr_pomiaru), ostatni_wynik(1))];
            bledy_ulepszony_euler_Tw = [bledy_ulepszony_euler_Tw , blad_wzgledny(Twk(nr_pomiaru), ostatni_wynik(2))];

            plot(t, y(1,:), t, y(2,:));
            annotation('textbox',[.15 .1 .8 .8],'interpreter', 'latex', 'String',{
                sprintf('$cb(%0.3f)[\\frac{J}{kg*K}]$', cb),
                sprintf('$A(%0.5f)[m^2]$', A),
                sprintf('$cw(%0.5f)[\\frac{J}{kg*K}]$', cw),
                sprintf('$h(%0.2f)[W*m^{-2}]$', h),
                sprintf('$mb(%0.2f)[kg]$', mb),
            },'EdgeColor','none')
            title(sprintf('$Wykres\\:dla\\:Tb0(%d)[^\\circ C],Tw0(%d)[^\\circ C],czasu(%0.0f)[s],Mw(%0.1f)[kg],krok(%0.3f)$',Tb0(nr_pomiaru), Tw0(nr_pomiaru),czasy(nr_pomiaru), Mw(nr_pomiaru), krok), 'interpreter', 'latex');
            xlabel('Czas[s]');
            ylabel('$Temperatura[^\circ C]$','interpreter', 'latex');
            legend('Euler: Temperatura pręta','Euler: Temperatura wody', 'Ulepszony Euler: Temperatura pręta', 'Ulepszony Euler: Temperatura wody');
            saveas(fig,sprintf('Pomiar_%d_krok_%d.png',nr_pomiaru, krok * 1000));

            hold off;
            close;
        end

        headery = {'Tb0', 'Tw0', 'Mw', 'czasy', 'Tbk', 'Twk', 'eETb', 'eETw', 'eEUTw', 'eEUTb'};

        macierz_do_zapisania = [
            Tb0' Tw0' Mw' czasy' Tbk' Twk' bledy_euler_Tb' bledy_euler_Tw' bledy_ulepszony_euler_Tw' bledy_ulepszony_euler_Tb'
        ]
        macierz_do_zapisania = round(macierz_do_zapisania, 3);

        writecell(headery, sprintf('zad1_dane_krok_%d.csv', krok*1000));
        writematrix(macierz_do_zapisania, sprintf('zad1_dane_krok_%d.csv', krok*1000), 'WriteMode', 'append');
    end

    function r = euler(Tb, Tw, cb, A, mw, cw, h, mb, krok)
        y = [
            Tb,
            Tw
        ];
        r = y(:,1) + krok * f(Tb, Tw, cb, A, mw, cw, h, mb);
    end

end