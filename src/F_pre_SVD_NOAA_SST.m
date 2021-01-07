function [U, S, V, Xorg, meansst, n] = F_pre_SVD_NOAA_SST(m, time, mask, sst)

    t0   = datenum('1-Jan-1800 00:00:00') + time(1);
    tfin = datenum('1-Jan-1800 00:00:00') + time(end);
    datestr(t0, 'yyyy/mm/dd');
    datestr(tfin, 'yyyy/mm/dd');

    [mm,nn,p] = size(sst);
    n_sst = mm*nn;
    n_X = length(mask(mask==1));
    Xall = zeros(n_X, length(time));

    for i=1:length(time)
        time_data(i) = datenum('1-Jan-1800 00:00:00')+time(i);
        snapshot = reshape(sst(:,:,i), n_sst, 1);
        Xall(:,i) = snapshot(mask==1);
        % day_name(i)=datestr(time_data(i));
    end

    Iord = 1:length(time); %Iord = 1:52*20;
    Itrain = Iord(1:m); %Itrain = Iord(1:52*16);
    Itest = Itrain; %Itest = Iord(~ismember(Iord,Itrain));
    Xtrain = Xall(:,Itrain);
    meansst = mean(Xtrain,2);
    size(meansst);
    Xtrain = bsxfun(@minus,Xtrain,meansst);
    [U,S,V] = svd(Xtrain,'econ');
    Xorg = U*S*V';
    [n,~] = size(U);

end 