function zad2
     zbiorniki = { zbiornik(200), @zbiornik };
     
     zbiorniki{1};
end

function [pokaz_pojemnosc, pokaz_dwa] = zbiornik(pojemnosc)
    pokaz_pojemnosc = @(x) pojemnosc;
    pokaz_dwa = @(x) 2;
end
