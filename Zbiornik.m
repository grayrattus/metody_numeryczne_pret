classdef Zbiornik < handle
   properties
      temperatura_oleju {mustBeNumeric}
      domyslna_temperatura_oleju {mustBeNumeric}
      czas_chlodzenia {mustBeNumeric}
      ilosc_ochlodzen_oleju {mustBeNumeric}
      masa_zbiornika {mustBeNumeric}
   end
   methods
        function obj = Zbiornik(domyslna_temperatura_oleju, masa_zbiornika)
                obj.domyslna_temperatura_oleju = domyslna_temperatura_oleju;
                obj.temperatura_oleju = domyslna_temperatura_oleju;
                obj.masa_zbiornika = masa_zbiornika;
                obj.czas_chlodzenia = 0;
        end
        function obj = zaktualizuj_temperature(obj, nowa_temperatura)
            obj.temperatura_oleju = nowa_temperatura;
        end
        function obj = zaktualizuj_czas_chlodzenia(obj, interwal)
            obj.czas_chlodzenia = obj.czas_chlodzenia - interwal;
            if (obj.czas_chlodzenia <= 0)
               obj.zaktualizuj_temperature(obj.domyslna_temperatura_oleju);
            end
        end
        function obj = zaktualizuj_stan(obj, temperatura_ropoczecia_chlodzenia, interwal)
            if temperatura_ropoczecia_chlodzenia <= obj.temperatura_oleju && obj.czas_chlodzenia <= 0
               obj.czas_chlodzenia = obj.masa_zbiornika * 15 * 60;
            else
               obj.zaktualizuj_czas_chlodzenia(interwal);
            end
        end
   end
end