% function y=interpolacja_fn_sklejanymi_3_stopnia(xp, yp)
function y=interpolacja_fn_sklejanymi_3_stopnia(X, Y)
    N = length(Y);

    Num_eqns = N-1;
    Unknowns = 4*Num_eqns;

    %%%Create the Y vector
    B = zeros(2*(N-2)+2 + (N-2) + (N-2) + 2,1);

    %%%Creating H0 - This ensures that the spline passed through all data points
    Num_row = 2*(N-2) + 2;
    H0 = zeros(Num_row,Unknowns);
    for idx = 1:(Num_row/2)
    col = ((idx-1)*4+1);
    row = (idx-1)*2 + 1;
    for jdx = col:(col+3)
        H0(row,jdx) = X(idx)^(3-jdx+col);
        H0(row+1,jdx) = X(idx+1)^(3-jdx+col);
    end
    B(row,1) = Y(idx);
    B(row+1,1) = Y(idx+1);
    end

    %%%Creating H1 - this ensures that all first derivatives are the same
    H1 = zeros(N-2,Unknowns);
    for idx = 2:(N-1)
    col = 1 + (idx-2)*4;
    H1(idx-1,col) = 3*X(idx)^2;
    H1(idx-1,col+1) = 2*X(idx);
    H1(idx-1,col+2) = 1;
    H1(idx-1,col+3) = 0;
    H1(idx-1,col+4) = -3*X(idx)^2;
    H1(idx-1,col+5) = -2*X(idx);
    H1(idx-1,col+6) = -1;
    H1(idx-1,col+7) = 0;
    end

    %%%Create H2 - This ensures that all second derivatives are the same
    H2 = 0*H1;
    for idx = 2:(N-1)
    col = 1 + (idx-2)*4;
    H2(idx-1,col) = 6*X(idx);
    H2(idx-1,col+1) = 2;
    H2(idx-1,col+2) = 0;
    H2(idx-1,col+3) = 0;
    H2(idx-1,col+4) = -6*X(idx);
    H2(idx-1,col+5) = -2;
    H2(idx-1,col+6) = 0;
    H2(idx-1,col+7) = 0;
    end

    %%%This ensures that the second derivative at the endpoints must be zero
    Hepts = zeros(2,Unknowns);
    %%%1st end point
    Hepts(1,1) = 6*X(1);
    Hepts(1,2) = 2*X(1);
    Hepts(1,3) = 1;
    Hepts(2,end) = 1;
    Hepts(2,end-1) = 2*X(end);
    Hepts(2,end-2) = 6*X(end);

    %%%stack everything together
    H = [H0;H1;H2;Hepts];

    %%%Solve for coefficients
    ABCs = inv(H)*B;

    allxspline=[];
    allyspline=[];
    for idx = 1:Num_eqns
        row = 1 + (idx-1)*4;
        a = ABCs(row);
        b = ABCs(row+1);
        c = ABCs(row+2);
        d = ABCs(row+3);
        xspline = linspace(X(idx),X(idx+1),100);
        yspline = a*xspline.^3 + b*xspline.^2 + c*xspline + d;
        allxspline = [allxspline xspline];
        allyspline = [allyspline yspline];
        %p3 = plot(xspline,yspline,'b-');
    end
    plot(allxspline, allyspline, 'b');

    y = yspline;
end

