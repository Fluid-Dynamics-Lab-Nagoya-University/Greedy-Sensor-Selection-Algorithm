function [U, Error_ave, Error_std]...
= F_pre_truncatedSVD(r, Xorg, Uorg, Sorg, Vorg, num_video, meansst, mask, time, m, videodir)

    p = 0;
    U = Uorg(:,1:r);
    X = U*Sorg(1:r,1:r)*Vorg(:,1:r)';
    filename = ['enso_proj_mode', num2str(r)];
    output = [videodir, '/', filename, '.avi'];
    F_map_videowriter(num_video, X, meansst, [], [], mask, time, p, output);

    for ii=1:m
        Error(ii) = norm(X(:,ii)-Xorg(:,ii)) / norm(Xorg(:,ii));
    end
    Error_ave = mean(Error);
    Error_std = std(Error);
    
end