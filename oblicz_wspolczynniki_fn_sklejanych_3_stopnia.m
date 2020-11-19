function wspolczynniki=oblicz_wspolczynniki_fn_sklejanych_3_stopnia(X, Y)
    ilosc_wartosci = length(Y);

    ilosc_rownan = ilosc_wartosci-1;
    ilosc_wspolczynnikow = 4*ilosc_rownan;

    m_wartosci = zeros(2*(ilosc_wartosci-2)+2 + (ilosc_wartosci-2) + (ilosc_wartosci-2) + 2,1);

    ilosc_wierszy = 2*(ilosc_wartosci-2) + 2;
    macierz_tridiagonalna = zeros(ilosc_wierszy,ilosc_wspolczynnikow);
    for i = 1:(ilosc_wierszy/2)
        kolumna = ((i-1)*4+1);
        wiersz = (i-1)*2 + 1;
        for j = kolumna:(kolumna+3)
            macierz_tridiagonalna(wiersz,j) = X(i)^(3-j+kolumna);
            macierz_tridiagonalna(wiersz+1,j) = X(i+1)^(3-j+kolumna);
        end
        m_wartosci(wiersz,1) = Y(i);
        m_wartosci(wiersz+1,1) = Y(i+1);
    end

    m_pochodnych = zeros(ilosc_wartosci-2,ilosc_wspolczynnikow);
    for i = 2:(ilosc_wartosci-1)
        kolumna = 1 + (i-2)*4;
        m_pierwszych_pochodnych(i-1,kolumna) = 3*X(i)^2;
        m_pierwszych_pochodnych(i-1,kolumna+1) = 2*X(i);
        m_pierwszych_pochodnych(i-1,kolumna+2) = 1;
        m_pierwszych_pochodnych(i-1,kolumna+3) = 0;
        m_pierwszych_pochodnych(i-1,kolumna+4) = -3*X(i)^2;
        m_pierwszych_pochodnych(i-1,kolumna+5) = -2*X(i);
        m_pierwszych_pochodnych(i-1,kolumna+6) = -1;
        m_pierwszych_pochodnych(i-1,kolumna+7) = 0;
    end

    m_drugich_pochodnych = 0*m_pochodnych;
    for i = 2:(ilosc_wartosci-1)
        kolumna = 1 + (i-2)*4;
        m_drugich_pochodnych(i-1,kolumna) = 6*X(i);
        m_drugich_pochodnych(i-1,kolumna+1) = 2;
        m_drugich_pochodnych(i-1,kolumna+2) = 0;
        m_drugich_pochodnych(i-1,kolumna+3) = 0;
        m_drugich_pochodnych(i-1,kolumna+4) = -6*X(i);
        m_drugich_pochodnych(i-1,kolumna+5) = -2;
        m_drugich_pochodnych(i-1,kolumna+6) = 0;
        m_drugich_pochodnych(i-1,kolumna+7) = 0;
    end

    m_druga_drugich_pochodnych = zeros(2,ilosc_wspolczynnikow);
    m_druga_drugich_pochodnych(1,1) = 6*X(1);
    m_druga_drugich_pochodnych(1,2) = 2*X(1);
    m_druga_drugich_pochodnych(1,3) = 0;
    m_druga_drugich_pochodnych(2,end) = 0;
    m_druga_drugich_pochodnych(2,end-1) = 2*X(end);
    m_druga_drugich_pochodnych(2,end-2) = 6*X(end);

    wspolczynniki = [macierz_tridiagonalna;m_pierwszych_pochodnych;m_drugich_pochodnych;m_druga_drugich_pochodnych]\m_wartosci;
end