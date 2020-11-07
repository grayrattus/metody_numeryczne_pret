function zad1()
    wykresy_dla_tabeli();
end

function wykresy_dla_tabeli()
    Tb0 = [1200, 800, 1100, 1200, 800, 1100, 1100, 1100, 1100, 1100];
    Tw0 = [25, 25, 70, 25, 25, 70, 70, 70, 70, 70];
    Mw = [2.5, 2.5, 2.5, 2.5, 2.5, 2.5, 5, 10, 2.5, 2.5];
    czasy = [3, 3, 3, 5, 5, 2, 2, 2, 4, 5];
    Tbk = [107.7, 79.1, 142.1, 105.7, 78.2, 150.1, 116.6, 99.1, 141.2, 140.9];
    Twk = [105.1, 78.0, 139.1, 105.5, 78.1, 138.2, 105.1, 88.1, 139.8, 140.1];

    for nr_pomiaru = 1:length(Tb0)
        krok=0.1;
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
            y(:,i+1)=euler(t(i), y(1,i), y(2,i), cb, A, Mw(nr_pomiaru), cw, h, mb, krok);
        end

        ostatni_wynik = y(:,length(y));
        
        blad_Tb = blad_wzgledny(Tbk(nr_pomiaru), ostatni_wynik(1));
        blad_Tw = blad_wzgledny(Twk(nr_pomiaru), ostatni_wynik(2));

        fig=figure('Renderer', 'painters', 'Position', [10 10 1920 1080])
        hold on;
        plot(t, y(1,:), t, y(2,:));

        for i = 1:length(t)-1
            y(:,i+1)=ulepszony_euler(t(i), y(1,i), y(2,i), cb, A, Mw(nr_pomiaru), cw, h, mb, krok);
        end

        ostatni_wynik = y(:,length(y));
        
        blad_Tb = blad_wzgledny(Tbk(nr_pomiaru), ostatni_wynik(1));
        blad_Tw = blad_wzgledny(Twk(nr_pomiaru), ostatni_wynik(2));

        plot(t, y(1,:), t, y(2,:));
        title(sprintf('Wykres dla Tb0(%d),Tw0(%d),czasu(%0.0f),Mw(%d),krok(%0.3f),blądTb(%0.3f),blądTk(%0.3f)',Tb0(nr_pomiaru), Tw0(nr_pomiaru),czasy(nr_pomiaru), Mw(nr_pomiaru), krok, blad_Tb, blad_Tw));
        xlabel('Czas [s]');
        ylabel('Temperatura [stopnie celsiusza]');
        legend('Euler: Temperatura pręta','Euler: Temperatura wody', 'Ulepszony Euler: Temperatura pręta', 'Ulepszony Euler: Temperatura wody');
        saveas(fig,sprintf('Pomiar_%d.png',nr_pomiaru));

        hold off;
        close;
    end
end

function r = euler(t, Tb, Tw, cb, A, mw, cw, h, mb, krok)
    y = [
        Tb,
        Tw
    ]
    r = y(:,1) + krok * f(t, Tb, Tw, cb, A, mw, cw, h, mb);
end

function r = ulepszony_euler(t, Tb, Tw, cb, A, mw, cw, h, mb, krok)
    y = [
        Tb,
        Tw
    ]
    yp = y(:, 1) + krok/2 * f(t, Tb, Tw, cb, A, mw, cw, h, mb);
    r = y(:, 1) + krok * f(t, yp(1), yp(2), cb, A, mw, cw, h, mb); 
end

% Temperatura początkowa pręta powinna miec 1200 stopni C
% Temperatura oleju chłodzącego powinna mieć 25 stopni C

function dy = f(t, Tb, Tw, cb, A, mw, cw, h, mb)
    dy=[
        ((Tw-Tb)*h*A)/(mb*cb)
        ((Tb-Tw)*h*A)/(mw*cw)
        ];    
end