function symulator
    wielkosc_wykresu=[10 10 800 600];
    krok_czasu = 0.05;
    czas_symulacji = 1800;
    ilosc_pretow_do_schlodzenia = 10000;

    deltaT=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
    hMatrix=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];
    
    minimalna_masa_zbiornika = 0.13;
    maksymalna_masa_zbiornika = 50;

    czas_wymiany_zbiornika = 30;
    czas_wymiany_preta = 5;
    a_masa_zbiornika = minimalna_masa_zbiornika;
    b_masa_zbiornika = maksymalna_masa_zbiornika;
    

    temperatura_gdy_zaczac_chlodzic_zbiornik = 80;

    domyslna_temperatura_preta = 1200;
    domyslna_temperatura_oleju = 25;

    minimalna_ilosc_zbiornikow = 1;
    maksymalna_ilosc_zbiornikow = 50;
    a_ilosc_zbiornikow = minimalna_ilosc_zbiornikow;
    b_ilosc_zbiornikow = maksymalna_ilosc_zbiornikow;

    temperatura_do_jakiej_chlodzic_prety = 120;

    a=aproksymacja_najmniejszych_kwadratow(deltaT, hMatrix,5);

    cb=0.29; % pojemnośc cieplna metalu pręta
    A=0.0109; % powierzchnia pręta
    cw=4.1813; % pojemność cieplna 
    mb=0.2; % masa pręta

    poprzedni_koszt = 9999999999999999;

    dane_o_kosztach = [];

    poprzednia_masa_pretow = 0;
    ograniczaja_zbiorniki = 0;
    for j = 1:inf
        temperatura_preta = domyslna_temperatura_preta;
        pozostala_ilosc_pretow = ilosc_pretow_do_schlodzenia;
        wymiana_preta_czas = 0;
        masa_bisekcji = (a_masa_zbiornika + b_masa_zbiornika) / 2;
        ilosc_zbiornikow = round((a_ilosc_zbiornikow + b_ilosc_zbiornikow) / 2, 0);
        czas_chlodzenia_zbiornika = masa_bisekcji * 0.15 * 60;
        zbiorniki = Zbiorniki(ilosc_zbiornikow, domyslna_temperatura_oleju, masa_bisekcji);
        for i = 0:krok_czasu:czas_symulacji
            if wymiana_preta_czas <= 0
                h_kwadratow = obliczanie_wielomianu(deltaT, a,temperatura_preta - zbiorniki.temperatura_aktualnego_zbiornika());
                y=ulepszony_euler(temperatura_preta, zbiorniki.temperatura_aktualnego_zbiornika(), cb, A, masa_bisekcji, cw, h_kwadratow, mb, krok_czasu);
                temperatura_preta = y(1,1);
                zbiorniki.uaktualnij_temperature_aktualnego_zbiornika(y(2,1));
            end
            % plot(i, temperatura_preta, 'o', i, zbiorniki.temperatura_aktualnego_zbiornika(), 'o');

            if temperatura_preta < temperatura_do_jakiej_chlodzic_prety
                temperatura_preta = domyslna_temperatura_preta;
                pozostala_ilosc_pretow = pozostala_ilosc_pretow - 1;
                wymiana_preta_czas = czas_wymiany_preta;
            end

            zbiorniki.uaktualnij_czas_studzenia_zbiornikow(krok_czasu, temperatura_gdy_zaczac_chlodzic_zbiornik);
            wymiana_preta_czas = wymiana_preta_czas - krok_czasu;
            % plot(i, pozostala_ilosc_pretow, 'o', i, ((ilosc_pretow_do_schlodzenia - pozostala_ilosc_pretow ) * 24) / 0.5 , 'o');
            if ((ilosc_pretow_do_schlodzenia - pozostala_ilosc_pretow ) * 24) / 0.5 >= ilosc_pretow_do_schlodzenia
                break
            end
        end

        ilosc_pretow_na_dobe = ((ilosc_pretow_do_schlodzenia - pozostala_ilosc_pretow ) * 24) / 0.5 

        koszt = 100 * masa_bisekcji + 20 * ilosc_zbiornikow;

        dane_o_kosztach = [dane_o_kosztach, [
            koszt
            masa_bisekcji
            ilosc_zbiornikow]
            ];

        ilosc_pretow_na_dobe
        dane_o_kosztach
        if (ilosc_pretow_na_dobe >= ilosc_pretow_do_schlodzenia) 
            if poprzedni_koszt - koszt <= 100 
                fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
                ilosc_danych = 0:length(dane_o_kosztach(1,:)) - 1;
                plot(ilosc_danych, dane_o_kosztach(1,:),ilosc_danych, dane_o_kosztach(2,:),ilosc_danych, dane_o_kosztach(3,:)  );
                xlabel('Numer bisekcji');
                legend('Koszta [PLN]', 'Masa oleju', 'Ilosc zbiornikow');
                saveas(fig,sprintf('Bisekcja.png'));
                close;
                break;
            end
            b_masa_zbiornika = masa_bisekcji;
            b_ilosc_zbiornikow = ilosc_zbiornikow;
            poprzedni_koszt = koszt;
        else
            a_ilosc_zbiornikow = ilosc_zbiornikow + 1;
            b_ilosc_zbiornikow = ilosc_zbiornikow + 2;
            'Wychodzi'
        end
    end
end