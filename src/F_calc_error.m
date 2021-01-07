function [Zestimate, Error, Error_std] = F_calc_error(m, Xorg, U, H)

    [Zestimate] = F_calc_reconst(Xorg, H, U);
    [Error, Error_std] = F_calc_reconst_error(m, Xorg, U, Zestimate);

end
