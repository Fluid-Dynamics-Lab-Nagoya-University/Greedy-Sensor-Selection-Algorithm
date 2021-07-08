function[Error]=F_calc_reconst_error(m, Xorg, U, Zestimate)

    for ii=1:m
        Xestimate = U*Zestimate(:,ii);
    end
    Error = norm(Xestimate-Xorg,'fro') / norm(Xorg,'fro');
end