function dy = f(Tb, Tw, cb, A, mw, cw, h, mb)
    dy=[
        ((Tw-Tb)*h*A)/(mb*cb)
        ((Tb-Tw)*h*A)/(mw*cw)
        ];    
end
