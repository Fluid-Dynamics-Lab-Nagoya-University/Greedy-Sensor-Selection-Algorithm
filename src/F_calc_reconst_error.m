function[Error_ave, Error_std]=F_calc_reconst_error(m, Xorg, U, Zestimate)

    for ii=1:m
        Xestimate = U*Zestimate(:,ii);
        Error(ii) = norm(Xestimate-Xorg(:,ii)) / norm(Xorg(:,ii));
    end
    Error_ave = mean(Error);
    Error_std = std(Error);
    
end