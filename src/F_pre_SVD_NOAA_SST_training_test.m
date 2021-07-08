function [U, S, V, Xorg, meansst, n, Xtest]...
= F_pre_SVD_NOAA_SST_training_test(m, time, mask, sst, NumCrossVal, CV)

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

    Iord = 1:m;%length(time); %Iord = 1:52*20;
    mtests = m/CV*(NumCrossVal-1)+1;
    mteste = m/CV*(NumCrossVal);
    Itest  = Iord(mtests:mteste);
    Itrain = Iord(~ismember(Iord,Itest));
    Xtest  = Xall(:,Itest);
    Xtrain = Xall(:,Itrain);
    meansst = mean(Xtrain,2);
    size(meansst);
    Xtrain = bsxfun(@minus,Xtrain,meansst);
    meanssttest = mean(Xtest,2);
    size(meanssttest);
    Xtest = bsxfun(@minus,Xtest,meanssttest);
    [U,S,V] = svd(Xtrain,'econ');
    Xorg = U*S*V';
    [n,~] = size(U);

% if NumCrossVal==1
%     Itrain = Iord(1:m/CV*(CV-1));
%     Xtrain = Xall(:,Itrain);
%     Itest = Iord(~ismember(Iord,Itrain));
%    Xtest = Xall(:,Itest);
% elseif NumCrossVal==CV
%     Itrain = Iord(m/CV+1:m);
%     Xtrain = Xall(:,Itrain);
%     Itest = Iord(~ismember(Iord,Itrain));
%     Xtest = Xall(:,Itest);
% else
%      Itrain_A = Iord(1:m/CV*(CV-1-NumCrossVal));
%      Xtrain_A = Xall(:,Itrain_A);
%      Itrain_B=Iord(m/CV*(CV-NumCrossVal)+1:m);
%      Xtrain = [Xtrain_A Xall(:,Itrain_B)];
%     Itest = Iord(~ismember(Iord,Itrain_A));
%     Itest = Itest(~ismember(Itest,Itrain_B));
%     Xtest = Xall(:,Itest);
% end
%
% %   Itrain = Iord(1:m); %Itrain = Iord(1:52*16);
% %Itest = Itrain;
%
% meansst = mean(Xtrain,2);
% size(meansst);
% Xtrain = bsxfun(@minus,Xtrain,meansst);
%
% meansst_test = mean(Xtest,2);
% Xtest = bsxfun(@minus,Xtest,meansst_test);
%
% [U,S,V] = svd(Xtrain,'econ');
% Xorg = U*S*V';
% [n,~] = size(U);

% [U_test,S_test,V_test] = svd(Xtest,'econ');
% Xtest = U_test*S_test*V_test';

end