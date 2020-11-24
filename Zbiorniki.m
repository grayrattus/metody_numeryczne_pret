classdef Zbiorniki < handle
   properties
      zbiorniki
      obecny_indeks_zbiornika {mustBeNumeric}
      prety
      wymieniane_prety_czasy
      domyslna_temperatura_preta
      ilosc_wystudzonych_pretow_per_zbiornik
      a
      deltaT
      hMatrix
   end
   methods
        function obj = Zbiorniki(ilosc_zbiornikow, domyslna_temperatura_oleju, masa_zbiornika, domyslna_temperatura_preta)
            obj.zbiorniki = arrayfun(@(x) Zbiornik(domyslna_temperatura_oleju, masa_zbiornika), 1:ilosc_zbiornikow);
            obj.prety = arrayfun(@(x) domyslna_temperatura_preta, 1:ilosc_zbiornikow)
            obj.ilosc_wystudzonych_pretow_per_zbiornik = arrayfun(@(x) 0, 1:ilosc_zbiornikow)
            obj.wymieniane_prety_czasy = arrayfun(@(x) 0, 1:ilosc_zbiornikow)
            obj.obecny_indeks_zbiornika = 1;
            obj.domyslna_temperatura_preta = domyslna_temperatura_preta;

            obj.deltaT=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
            obj.hMatrix=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];

            obj.a=aproksymacja_najmniejszych_kwadratow(obj.deltaT, obj.hMatrix,5);
        end
        function wystudzonych = wystudz_prety(obj, temperatura_do_jakiej_chlodzic_prety, temperatura_ropoczecia_chlodzenia, domyslna_temperatura_preta, krok_czasu, czas_wymiany_preta, cb, A, masa_bisekcji, cw,mb)
            for i=1:length(obj.prety)
                if obj.wymieniane_prety_czasy(i) <= 0 && obj.zbiorniki(i).czas_chlodzenia <= 0
                  h_kwadratow = obliczanie_wielomianu(obj.deltaT, obj.a,obj.prety(i) - obj.zbiorniki(i).temperatura_oleju );
                  y=ulepszony_euler(obj.prety(i), obj.zbiorniki(i).temperatura_oleju, cb, A, masa_bisekcji, cw, h_kwadratow, mb, krok_czasu);
                  obj.prety(i) = y(1,1);
                  obj.zbiorniki(i).zaktualizuj_temperature(y(2,1));
                else 
                  obj.wymieniane_prety_czasy(i) = obj.wymieniane_prety_czasy(i) - krok_czasu;
                end
            end
            for i=1:length(obj.zbiorniki)
               obj.zbiorniki(i).zaktualizuj_stan(temperatura_ropoczecia_chlodzenia, krok_czasu);
            end
            wystudzonych = 0;
            for i=1:length(obj.prety)
               if obj.prety(i) < temperatura_do_jakiej_chlodzic_prety
                  wystudzonych = wystudzonych + 1;
                  obj.ilosc_wystudzonych_pretow_per_zbiornik(i) = obj.ilosc_wystudzonych_pretow_per_zbiornik(i) + 1;
                  obj.prety(i) = obj.domyslna_temperatura_preta;
                  obj.wymieniane_prety_czasy(i) = czas_wymiany_preta;
               end
            end
        end
        function ilosc_wymian_oleju = napelnij_zbiorniki(obj, ilosc_pretow_do_kupna_oleju)
         ilosc_wymian_oleju = 0;
         for i = 1:length(obj.ilosc_wystudzonych_pretow_per_zbiornik)
            if obj.ilosc_wystudzonych_pretow_per_zbiornik(i) > ilosc_pretow_do_kupna_oleju
               obj.zbiorniki(i).wymien_olej();
               obj.ilosc_wystudzonych_pretow_per_zbiornik(i) = 0;
               ilosc_wymian_oleju = ilosc_wymian_oleju + 1;
            end
         end
        end
   end
end