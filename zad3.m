function zad3()
    y=[ 1200
        25 ];
    krok=0.001;
    t=0:krok:7;
    
    temperatury=[1200];
    masy_wody=[2.5];
    mw=0;
    wymagana_temperatura=125;
    for j = 1:99999999
        mw = mw + 0.01;
        temperatura=0;
        for i = 1:length(t)-1
            obliczone=y(:,i) + krok * f(t(i), y(:,i),mw);
            temperatura=obliczone(1);
            y(:,i+1)=obliczone;
        end
        temperatury = [temperatury temperatura];
        masy_wody = [masy_wody mw];
        if (temperatura <= wymagana_temperatura) 
            break
        end
    end
        
    plot(masy_wody, temperatury, 'o');
    % plot(t, y(1,:), t, y(2,:));
end

% Temperatura początkowa pręta powinna miec 1200 stopni C
% Temperatura oleju chłodzącego powinna mieć 25 stopni C

function dy = f(t, y, mw)
    Tb=y(1);
    Tw=y(2);
    cb=3.85; % pojemnośc cieplna metalu pręta
    A=0.0109; % powierzchnia pręta
    cw=4.1813; % pojemność cieplna 
    h=160; % współczynnik przewodnictwa cieplnego
    mb=0.2; % masa pręta

    dy=[
        ((Tw-Tb)*h*A)/(mb*cb)
        ((Tb-Tw)*h*A)/(mw*cw)
        ];    
end