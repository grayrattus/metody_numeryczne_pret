classdef Zbiorniki < handle
   properties
      zbiorniki
      obecny_indeks_zbiornika {mustBeNumeric}
   end
   methods
        function obj = Zbiorniki(ilosc_zbiornikow, domyslna_temperatura_oleju, masa_zbiornika)
            obj.zbiorniki = arrayfun(@(x) Zbiornik(domyslna_temperatura_oleju, masa_zbiornika), 1:ilosc_zbiornikow);
            obj.obecny_indeks_zbiornika = 1;
        end
        function obj = uaktualnij_czas_studzenia_zbiornikow(obj, interwal, temperatura_rozpoczenia_chlodzenia)
            for i = 1:length(obj.zbiorniki)
               if i ~= obj.obecny_indeks_zbiornika
                  obj.zbiorniki(i).zaktualizuj_stan(temperatura_rozpoczenia_chlodzenia, interwal);
               end 
            end

            if obj.zbiorniki(obj.obecny_indeks_zbiornika).temperatura_oleju >= temperatura_rozpoczenia_chlodzenia
               for i = 1:length(obj.zbiorniki)
                  if obj.zbiorniki(i).czas_chlodzenia <= 0 && i ~= obj.obecny_indeks_zbiornika
                     obj.obecny_indeks_zbiornika = i;
                     break;
                  end
               end
            end
        end
        function obj = uaktualnij_temperature_aktualnego_zbiornika(obj, temperatura)
            obj.zbiorniki(obj.obecny_indeks_zbiornika).zaktualizuj_temperature(temperatura);
        end
        function temperatura = temperatura_aktualnego_zbiornika(obj)
            temperatura = obj.zbiorniki(obj.obecny_indeks_zbiornika).temperatura_oleju;
        end
   end
end