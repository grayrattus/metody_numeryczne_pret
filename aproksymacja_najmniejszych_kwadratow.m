function a=aproksymacja_najmniejszych_kwadratow(xp, yp, stopien_wielomianu)
    ilosc_wartosci=length(xp)
    
    M=ones(ilosc_wartosci, stopien_wielomianu + 1);
    b=zeros(length(yp), 1)
    
    for indeks_wiersza=1:ilosc_wartosci
        for indeks_wspolczynnika=1:stopien_wielomianu
            M(indeks_wiersza, indeks_wspolczynnika + 1)=xp(indeks_wiersza)^indeks_wspolczynnika;
        end
        b(indeks_wiersza, 1)=yp(indeks_wiersza);
    end
    
    a = (transpose(M)*M) \ (transpose(M)*b);
end

