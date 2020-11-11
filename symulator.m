function symulator
    czas = 0;
    krok_czasu = 0.01;
    ilosc_pretow_do_schlodzenia = 1000000;
    
    masa_zbiornika = 20;

    czas_wymiany_zbiornika = 30;
    czas_wymiany_preta = 5;
    czas_chlodzenia_zbiornika = masa_zbiornika * 0.15 * 60;

    domyslna_temperatura_preta = 1200;
    domyslna_temperatura_oleju = 25;
    domyslna_ilosc_zbiornikow = 5;


    zbiorniki = stworz_zbiorniki(domyslna_ilosc_zbiornikow);
    ilosc_dostepnych_zbiornikow = domyslna_ilosc_zbiornikow;
    zbiorniki = Zbiorniki(domyslna_ilosc_zbiornikow)
    %for 1:inf
    %    uaktualnij_czas_studzenia_zbiornikow();

    %    czas = czas + krok_czasu;
    %end

    function uaktualnij_czas_studzenia_zbiornikow
        czasy_studzenia_zbiornikow = czasy_studzenia_zbiornikow + krok_czasu;

        ilosc_zbiornikow_wystudzonych = find(czasy_studzenia_zbiornikow >= czas_chlodzenia_zbiornika);
        ilosc_dostepnych_zbiornikow = ilosc_dostepnych_zbiornikow + length(ilosc_zbiornikow_wystudzonych);
        czasy_studzenia_zbiornikow(ilosc_zbiornikow_wystudzonych) = [];
    end

    function wymien_pret
        ilosc_pretow_do_schlodzenia = ilosc_pretow_do_schlodzenia - 1;
        temperatura_preta = domyslna_temperatura_preta;
        czas = czas + czas_wymiany_preta;
    end

    function wymian_zbiornik
        temperatura_oleju = domyslna_temperatura_oleju; 
        ilosc_dostepnych_zbiornikow = ilosc_dostepnych_zbiornikow - 1;
        czas = czas + czas_wymiany_zbiornika;
    end
end

classdef Zbiorniki
   properties
      zbiorniki {Zbiornik}
   end
   methods
        function obj = Zbiorniki(ilosc_zbiornikow)
            obj.zbiorniki = arrayfun([0,0], 1:ilosc_zbiornikow);
        end
   end
end

classdef Zbiornik
   properties
      temperatura_oleju {mustBeNumeric}
      czas_chlodzenia {mustBeNumeric}
      ilosc_ochlodzen_oleju {mustBeNumeric}
   end
   methods
        function obj = Zbiornik(domyslna_temperatura_oleju)
                obj.temperatura_oleju = domyslna_temperatura_oleju;
        end
        function zaktualizuj_temperature(nowa_temperatura)
            obj.temperatura_oleju = nowa_temperatura;
        end
   end
end