function zad1()
    deltaT=[-1500, -1000, -300,-50, -1, 1, 20, 50,200,400,1000,2000];
    h=[178, 176, 168, 161,160,160,160.2, 161, 165, 168, 174, 179];

    a=aproksymacja_wyklad(deltaT, h,6);
    % a=interpolacja_vandermond(deltaT, h);
    
    di = -1500:0.1:2000;
    dl = [];

    for i=1:length(di)
        % dl(i) = obliczanie_wielomianu(deltaT, h, a, di(i));
    end
    interpolacja_fn_sklejanymi_3_stopnia(deltaT, hz);
   % hold;
   % plot(deltaT, h, 'o');
end

function zad1_bez_interpolacji()
    y=[ 1200
        25 ];
    krok=0.001;
    t=0:krok:5;
    
    for i = 1:length(t)-1
        y(:,i+1)=y(:,i) + krok * f(t(i), y(:,i));
    end
        
    plot(t, y(1,:), t, y(2,:));
end

% Temperatura początkowa pręta powinna miec 1200 stopni C
% Temperatura oleju chłodzącego powinna mieć 25 stopni C

function dy = f(t, y)
    Tb=y(1);
    Tw=y(2);
    cb=3.85; % pojemnośc cieplna metalu pręta
    A=0.0109; % powierzchnia pręta
    mw=2.5; % masa oleju chłodzącego
    cw=4.1813; % pojemność cieplna 
    h=160; % współczynnik przewodnictwa cieplnego
    mb=0.2; % masa pręta

    dy=[
        ((Tw-Tb)*h*A)/(mb*cb)
        ((Tb-Tw)*h*A)/(mw*cw)
        ];    
end