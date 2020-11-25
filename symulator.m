function symulator
    wielkosc_wykresu=[10 10 800 600];
    krok_czasu = 0.05;
    czas_symulacji = 3600 * 24;
    ilosc_pretow_do_schlodzenia = 100000;

    ilosc_pretow_do_kupna_oleju = 2000;

    minimalna_masa_zbiornika = 0.13;
    maksymalna_masa_zbiornika = 50;

    % czas_wymiany_zbiornika = 30;
    czas_wymiany_preta = 5;
    a_masa_zbiornika = minimalna_masa_zbiornika;
    b_masa_zbiornika = maksymalna_masa_zbiornika;

    % ilosc_czynnych_zbiornikow = 30;
    temperatura_gdy_zaczac_chlodzic_zbiornik = 80;

    domyslna_temperatura_preta = 1200;
    domyslna_temperatura_oleju = 25;

    minimalna_ilosc_zbiornikow = 1;
    maksymalna_ilosc_zbiornikow = 20;
    a_ilosc_zbiornikow = minimalna_ilosc_zbiornikow;
    b_ilosc_zbiornikow = maksymalna_ilosc_zbiornikow;

    temperatura_do_jakiej_chlodzic_prety = 120;

    cb=0.29; % pojemnośc cieplna metalu pręta
    A=0.0109; % powierzchnia pręta
    cw=4.1813; % pojemność cieplna 
    mb=0.2; % masa pręta

    poprzedni_koszt = 9999999999999999;

    dane_o_kosztach = [];
    dane_o_przebiegach_zbiornikow = [];

    for j = 1:inf
        pozostala_ilosc_pretow = ilosc_pretow_do_schlodzenia;
        masa_bisekcji = (a_masa_zbiornika + b_masa_zbiornika) / 2;
        ilosc_zbiornikow = round((a_ilosc_zbiornikow + b_ilosc_zbiornikow) / 2, 0);
        zbiorniki = Zbiorniki(ilosc_zbiornikow, domyslna_temperatura_oleju, masa_bisekcji, domyslna_temperatura_preta);
        koszt = 0;
        sumaryczna_ilosc_napelnionych = 0;
        for i = 0:krok_czasu:czas_symulacji
            wystudzone = zbiorniki.wystudz_prety(temperatura_do_jakiej_chlodzic_prety, temperatura_gdy_zaczac_chlodzic_zbiornik, domyslna_temperatura_preta, krok_czasu, czas_wymiany_preta, cb, A, masa_bisekcji, cw,mb);
            ilosc_napelnionych = zbiorniki.napelnij_zbiorniki(ilosc_pretow_do_kupna_oleju);
            sumaryczna_ilosc_napelnionych = sumaryczna_ilosc_napelnionych + ilosc_napelnionych;

            for i=1:ilosc_napelnionych
                koszt = koszt + 20 * masa_bisekcji;
            end
            pozostala_ilosc_pretow = pozostala_ilosc_pretow - wystudzone;
        end

        ilosc_pretow_na_dobe = ilosc_pretow_do_schlodzenia - pozostala_ilosc_pretow;

        koszt = koszt + (100 * masa_bisekcji)*ilosc_zbiornikow + (20 * ilosc_zbiornikow * masa_bisekcji);

        dane_o_kosztach = [dane_o_kosztach, [
            koszt
            masa_bisekcji
            ilosc_zbiornikow
            sumaryczna_ilosc_napelnionych
            ilosc_pretow_na_dobe
            ]
            ]

        ilosc_pretow_na_dobe
        dane_o_kosztach
        if (ilosc_pretow_na_dobe >= ilosc_pretow_do_schlodzenia) 
            if poprzedni_koszt - koszt <= 100 
                headery = {'koszt', 'masa', 'iloscZbiornikow','iloscNapelnien', 'iloscPretowNaDobe'};
                writecell(headery, 'symulator.csv');
                writematrix(transpose(dane_o_kosztach),'symulator.csv', 'WriteMode', 'append');

                headery_symulacji = {'krokCzasu', 'cb', 'A', 'cw', 'mb'};
                writecell(headery_symulacji, 'wspolczynniki_symulacji.csv');
                writematrix([krok_czasu, cb, A, cw, mb],'wspolczynniki_symulacji.csv', 'WriteMode', 'append');


                fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
                ilosc_danych = 0:length(dane_o_kosztach(1,:)) - 1;
                plot(ilosc_danych, dane_o_kosztach(1,:));
                xlabel('Numer bisekcji');
                ylabel('Koszta [PLN]');
                legend('Koszta [PLN]');
                saveas(fig,sprintf('Bisekcja.png'));
                close;  


                fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
                ilosc_danych = 0:length(dane_o_kosztach(1,:)) - 1;
                plot(ilosc_danych, dane_o_kosztach(2,:));
                xlabel('Numer bisekcji');
                ylabel('Masa wody[kg]');
                legend('Masa oleju');
                saveas(fig,sprintf('MasaOleju.png'));
                close;  

                fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
                ilosc_danych = 0:length(dane_o_kosztach(1,:)) - 1;
                plot(ilosc_danych, dane_o_kosztach(3,:));
                xlabel('Numer bisekcji');
                ylabel('Ilosc zbiornikow');
                legend('Ilosc zbiornikow');
                saveas(fig,sprintf('IloscZbiornikow.png'));
                close;  

                fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
                ilosc_danych = 0:length(dane_o_kosztach(1,:)) - 1;
                plot(ilosc_danych, dane_o_kosztach(4,:));
                xlabel('Numer bisekcji');
                ylabel('Ilosc napelnien zbiornikow');
                legend('Ilosc napelnien zbiornikow');
                saveas(fig,sprintf('IloscNapelnienZbiornikow.png'));
                close;  

                fig=figure('Renderer', 'painters', 'Position', wielkosc_wykresu)
                ilosc_danych = 0:length(dane_o_kosztach(1,:)) - 1;
                plot(ilosc_danych, dane_o_kosztach(5,:));
                xlabel('Numer bisekcji');
                ylabel('Prety na dobe');
                legend('Prety na dobe');
                saveas(fig,sprintf('PretyNaDobe.png'));
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