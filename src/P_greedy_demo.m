%% Main program
%% ///////////////////////////////////////////////////////////////////
% Comments:
% 	Collaborator: Yuji Saito, Keigo Yamada, Taku Nonomura
%                 Kumi Nakai, Takayuki Nagata
% 	Last modified: 20221/7/8
% Nomenclature:
% - Scalars
%   n : Number of degrees of freedom of spatial POD modes (state dimension)
%   p : Number of sensors
%   r : Number of rank for truncated POD
%   m : Number of snaphot (temporal dimension)
% - Matrices
% 	X : Supervising data matrix
% 	Y : Observation matrix
% 	H : Sparse sensor location matrix
% 	U : Spatial POD modes matrix
% 	C : Measurement matrix
% 	Z : POD mode amplitude matrix
%% ===================================================================

clear; close all;
warning('off','all')

%% Selection of Problems ============================================
% num_problem=1; % //Randomized sensor problem//
% num_problem=2; % //NOAA-SST//
  num_problem=3; % //NOAA-SST K-fold cross-validation//
% !<NOAA-SST> It takes a long time to obtain the solution in the convex 
% !<NOAA-SST> approximation method and the convex method is commented out 
% !<NOAA_SST> as default setting for reduction of demo time.
%
%% Parameters =======================================================
r = 10;
% pmin = 1;
% pinc = 1;
% pmax = 20;
% ps   = pmin:pinc:pmax;
ps = [1 11];
num_ave = 50; % Number of iteration for averaging operation
CNT  = 0; % Counter
maxiteration = 200; % Max iteration for convex approximation
% //Randomized sensor problem//
n = 2000;
% //NOAA-SST//
m = 52*10; % 10-years (52weeks/year)
num_video = 1; % maxmum: m
CV = 5; % Number of K-fold cross-validation

%% Preparation of output directories ================================
workdir   = ('../work');
videodir  = [workdir,'/video'];
sensordir = [workdir,'/sensor_location'];
mkdir(workdir);
mkdir(videodir);
mkdir(sensordir);

%% Randomized sensor problem ========================================
if num_problem == 1

    %% Sensor selection =============================================
    for p = ps
        CNT = CNT+1;
        text = [ num2str(p),' sensor selection started --->' ];
        disp(text);

        %% Average loop =============================================
        for w=1:1:num_ave

            %% Preprocess for Randomized problem ====================
            U = randn(n,r);

            %% Random selection -------------------------------------
            [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
            det_rand (CNT,w+1) = F_calc_det  (p,H_rand,U);
            tr_rand  (CNT,w+1) = F_calc_trace(p,H_rand,U);
            eig_rand (CNT,w+1) = F_calc_eigen(p,H_rand,U);

            %% D-optimality - Convex---------------------------------
            %!! This is very time consuming proceduce, We do not recommend to try this
            % [time_DC(CNT,w+1), H_DC, sensors_DC, ...
            %  NT_TOL_cal_DC(CNT,w+1), iter_DC(CNT,w+1)] ...
            %  = F_sensor_DC(U,p,maxiteration);
            % det_DC (CNT,w+1) = F_calc_det  (p,H_DC,U);
            % tr_DC  (CNT,w+1) = F_calc_trace(p,H_DC,U);
            % eig_DC (CNT,w+1) = F_calc_eigen(p,H_DC,U);
            %!! I recommend you use the following dummy values
            %   if you do not need the solution in the convex approximation in NOAA-SST.        
            time_DC(CNT,w+1) = time_rand(CNT,w+1);
            det_DC (CNT,w+1) = det_rand (CNT,w+1);
            tr_DC  (CNT,w+1) = tr_rand  (CNT,w+1);
            eig_DC (CNT,w+1) = eig_rand (CNT,w+1);
            H_DC=H_rand;
            sensors_DC=sensors_rand;
            NT_TOL_cal_DC(CNT,w+1)=0;
            iter_DC(CNT,w+1)=0;
            
            %% Maximization of row norm - Greedy based on QR --------
            [time_QR(CNT,w+1), H_QR, sensors_QR] = F_sensor_QR(U,p);
            det_QR (CNT,w+1) = F_calc_det  (p,H_QR,U);
            tr_QR  (CNT,w+1) = F_calc_trace(p,H_QR,U);
            eig_QR (CNT,w+1) = F_calc_eigen(p,H_QR,U);

            %% D-optimality - Greedy --------------------------------
            [time_DG(CNT,w+1), H_DG, sensors_DG] = F_sensor_DG(U,p);
            det_DG (CNT,w+1) = F_calc_det  (p,H_DG,U);
            tr_DG  (CNT,w+1) = F_calc_trace(p,H_DG,U);
            eig_DG (CNT,w+1) = F_calc_eigen(p,H_DG,U);

            %% D-optimality - Hybrid of QR and DG -------------------
            [time_QD(CNT,w+1), H_QD, sensors_QD] = F_sensor_QD(U,p);
            det_QD (CNT,w+1) = F_calc_det  (p,H_QD,U);
            tr_QD  (CNT,w+1) = F_calc_trace(p,H_QD,U);
            eig_QD (CNT,w+1) = F_calc_eigen(p,H_QD,U);

            %% A-optimality -  Greedy -------------------------------
            [time_AG(CNT,w+1), H_AG, sensors_AG] = F_sensor_AG(U,p);
            det_AG (CNT,w+1) = F_calc_det  (p,H_AG,U);
            tr_AG  (CNT,w+1) = F_calc_trace(p,H_AG,U);
            eig_AG (CNT,w+1) = F_calc_eigen(p,H_AG,U);

            %% E-optimality -  Greedy -------------------------------
            [time_EG(CNT,w+1), H_EG, sensors_EG] = F_sensor_EG(U,p);
            det_EG (CNT,w+1) = F_calc_det  (p,H_EG,U);
            tr_EG  (CNT,w+1) = F_calc_trace(p,H_EG,U);
            eig_EG (CNT,w+1) = F_calc_eigen(p,H_EG,U);
        end
        
        %% Averaging ================================================
        [ time_rand, det_rand, tr_rand, eig_rand ]...
        = F_data_ave1( CNT, num_ave, time_rand, det_rand, tr_rand, eig_rand );
        [ time_DC, det_DC, tr_DC, eig_DC ]...
        = F_data_ave1( CNT, num_ave, time_DC, det_DC, tr_DC, eig_DC );
        [ time_QR, det_QR, tr_QR, eig_QR ]...
        = F_data_ave1( CNT, num_ave, time_QR, det_QR, tr_QR, eig_QR );
        [ time_DG, det_DG, tr_DG, eig_DG ]...
        = F_data_ave1( CNT, num_ave, time_DG, det_DG, tr_DG, eig_DG );
        [ time_QD, det_QD, tr_QD, eig_QD ]...
        = F_data_ave1( CNT, num_ave, time_QD, det_QD, tr_QD, eig_QD );
        [ time_AG, det_AG, tr_AG, eig_AG ]...
        = F_data_ave1( CNT, num_ave, time_AG, det_AG, tr_AG, eig_AG );
        [ time_EG, det_EG, tr_EG, eig_EG ]...
        = F_data_ave1( CNT, num_ave, time_EG, det_EG, tr_EG, eig_EG );
        NT_TOL_cal_DC(CNT,1)=mean(NT_TOL_cal_DC(CNT,2:w+1));
        iter_DC(CNT,1)=mean(iter_DC(CNT,2:w+1));
        
        %% Sensor location ==========================================
        sensor_memo = zeros(p,7);
        sensor_memo(1:p,1) = sensors_rand(1:p)';
        sensor_memo(1:p,2) = sensors_DC(1:p);
        sensor_memo(1:p,3) = sensors_QR(1:p)';
        sensor_memo(1:p,4) = sensors_DG(1:p);
        sensor_memo(1:p,5) = sensors_QD(1:p)';
        sensor_memo(1:p,6) = sensors_AG(1:p)';
        sensor_memo(1:p,7) = sensors_EG(1:p)';
        filename = [workdir, '/sensors_p_', num2str(p), '.mat'];
        save(filename,'sensor_memo');

        text = [ '---> ', num2str(p), ' sensor selection finished!' ];
        disp(text);
    end
end

%% NOAA-SST =========================================================
if num_problem == 2

    %% Preprocces for NOAA-SST ======================================
    text='Readinng/Arranging a NOAA-SST dataset';
    disp(text);
    [Lat, Lon, time, mask, sst]...
    = F_pre_read_NOAA_SST( ['sst.wkmean.1990-present.nc'], ['lsmask.nc'] );
    [Uorg, Sorg, Vorg, Xorg, meansst, n] = F_pre_SVD_NOAA_SST(m, time, mask, sst);
    F_map_original(num_video, Xorg, meansst, mask, time, videodir);
    [U, Error_ave_pod, Error_std_pod]...
    = F_pre_truncatedSVD(r, Xorg, Uorg, Sorg, Vorg, num_video, meansst, mask, time, m, videodir);
    Error_ave_pod = repmat( Error_ave_pod , size(ps,2) );
    text='Complete Reading/Arranging a NOAA-SST dataset!';
    disp(text);

    %% Sensor selection =============================================
    for p = ps
        CNT = CNT+1;
        text = [ num2str(p),' sensor selection started --->' ];
        disp(text);

        %% Random selection -----------------------------------------
        % Average loop
        for w=1:1:num_ave
            [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
            det_rand(CNT,w+1) = F_calc_det  (p,H_rand,U);
            tr_rand (CNT,w+1) = F_calc_trace(p,H_rand,U);
            eig_rand(CNT,w+1) = F_calc_eigen(p,H_rand,U);
            [Zestimate_rand, Error_rand(CNT,w+1)] ...
            = F_calc_error(m, Xorg, U, H_rand);
        end
        % Averaging
        [ time_rand, det_rand, tr_rand, eig_rand, Error_rand ]...
        = F_data_ave2( CNT, num_ave, time_rand, det_rand, tr_rand, eig_rand, Error_rand );

        %% D-optimality - Convex-------------------------------------
        %!! This is very time consuming proceduce, We do not recommend to try this
        % [time_DC(CNT,1), H_DC, sensors_DC, ...
        %  NT_TOL_cal_DC(CNT,1), iter_DC(CNT,1)] ...
        %  = F_sensor_DC(U,p,maxiteration);
        % det_DC(CNT,1) = F_calc_det(p,H_DC,U);
        % tr_DC(CNT,1)  = F_calc_trace(p,H_DC,U);
        % eig_DC(CNT,1) = F_calc_eigen(p,H_DC,U);
        %!! I recommend you use the following dummy values 
        %   if you do not need the solution in the convex approximation in NOAA-SST.
        time_DC(CNT,1) = time_rand(CNT,1);
        det_DC (CNT,1) = det_rand (CNT,1);
        tr_DC  (CNT,1) = tr_rand  (CNT,1);
        eig_DC (CNT,1) = eig_rand (CNT,1);
        H_DC=H_rand;
        sensors_DC=sensors_rand;
        NT_TOL_cal_DC(CNT,w+1)=0;
        iter_DC(CNT,w+1)=0;
        %!!
        [Zestimate_DC, Error_DC(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_DC);
        NT_TOL_cal_DC(CNT,1)=mean(NT_TOL_cal_DC(CNT,2:w+1));
        iter_DC(CNT,1)=mean(iter_DC(CNT,2:w+1));
        
        %% Maximization of row norm - Greedy based on QR ------------
        % [time_QR(CNT,1), H_QR, sensors_QR] = F_sensor_QR(U,p);
        % det_QR (CNT,1) = F_calc_det  (p,H_QR,U);
        % tr_QR  (CNT,1) = F_calc_trace(p,H_QR,U);
        % eig_QR (CNT,1) = F_calc_eigen(p,H_QR,U);
        %!! You can use the following dummy values
        time_QR(CNT,1) = time_rand(CNT,1);
        det_QR (CNT,1) = det_rand (CNT,1);
        tr_QR  (CNT,1) = tr_rand  (CNT,1);
        eig_QR (CNT,1) = eig_rand (CNT,1);
        H_QR=H_rand;
        sensors_QR=sensors_rand;
        %!!
        [Zestimate_QR, Error_QR(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_QR);

        %% D-optimality - Greedy ------------------------------------
        [time_DG(CNT,1), H_DG, sensors_DG] = F_sensor_DG(U,p);
        det_DG (CNT,1) = F_calc_det  (p,H_DG,U);
        tr_DG  (CNT,1) = F_calc_trace(p,H_DG,U);
        eig_DG (CNT,1) = F_calc_eigen(p,H_DG,U);
        [Zestimate_DG, Error_DG(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_DG);

        %% D-optimality - Hybrid of QR and DG -----------------------
        [time_QD(CNT,1), H_QD, sensors_QD] = F_sensor_QD(U,p);
        det_QD (CNT,1) = F_calc_det  (p,H_QD,U);
        tr_QD  (CNT,1) = F_calc_trace(p,H_QD,U);
        eig_QD (CNT,1) = F_calc_eigen(p,H_QD,U);
        [Zestimate_QD, Error_QD(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_QD);

        %% A-optimality -  Greedy -----------------------------------
        [time_AG(CNT,1), H_AG, sensors_AG] = F_sensor_AG(U,p);
        det_AG (CNT,1) = F_calc_det  (p,H_AG,U);
        tr_AG  (CNT,1) = F_calc_trace(p,H_AG,U);
        eig_AG (CNT,1) = F_calc_eigen(p,H_AG,U);
        [Zestimate_AG, Error_AG(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_AG);

        %% E-optimality -  Greedy -----------------------------------
        [time_EG(CNT,1), H_EG, sensors_EG] = F_sensor_EG(U,p);
        det_EG (CNT,1) = F_calc_det  (p,H_EG,U);
        tr_EG  (CNT,1) = F_calc_trace(p,H_EG,U);
        eig_EG (CNT,1) = F_calc_eigen(p,H_EG,U);
        [Zestimate_EG, Error_EG(CNT,1)] ...
        = F_calc_error(m, Xorg, U, H_EG);
        
        %% Sensor location ==========================================
        sensor_memo = zeros(p,7);
        sensor_memo(1:p,1) = sensors_rand(1:p)';
        sensor_memo(1:p,2) = sensors_DC(1:p);
        sensor_memo(1:p,3) = sensors_QR(1:p)';
        sensor_memo(1:p,4) = sensors_DG(1:p);
        sensor_memo(1:p,5) = sensors_QD(1:p)';
        sensor_memo(1:p,6) = sensors_AG(1:p)';
        sensor_memo(1:p,7) = sensors_EG(1:p)';
        filename = [workdir, '/sensors_p_', num2str(p), '.mat'];
        save(filename,'sensor_memo');

        %% Video ====================================================
        name='rand';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_rand, Zestimate_rand, name, videodir, sensordir)
        name='DC';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_DC, Zestimate_DC, name, videodir, sensordir)
        name='QR';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_QR, Zestimate_QR, name, videodir, sensordir)
        name='DG';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_DG, Zestimate_DG, name, videodir, sensordir)
        name='QD';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_QD, Zestimate_QD, name, videodir, sensordir)
        name='AG';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_AG, Zestimate_AG, name, videodir, sensordir)
        name='EG';
        F_map_reconst(r, num_video, Xorg, meansst, U, mask, time, p, ...
                        sensors_EG, Zestimate_EG, name, videodir, sensordir)
        
        text = [ '---> ', num2str(p), ' sensor selection finished!' ];
        disp(text);
    end
end

%% Data organization ================================================
% Arrange
if num_problem == 1 || num_problem == 2
    [time_all] = F_data_arrange1( ps,   CNT, time_rand, time_DC, time_QR,...
                                time_DG,   time_QD,   time_AG,     time_EG );
    [det_all]  = F_data_arrange1( ps,   CNT, det_rand,  det_DC,  det_QR, ...
                                det_DG,    det_QD,    det_AG,      det_EG  );
    [tr_all]   = F_data_arrange1( ps,   CNT, tr_rand,   tr_DC,   tr_QR,...
                                tr_DG,     tr_QD,     tr_AG,       tr_EG   );
    [eig_all]  = F_data_arrange1( ps,   CNT, eig_rand,  eig_DC,  eig_QR,...
                                eig_DG,    eig_QD,    eig_AG,      eig_EG  );
    [log_DC] = F_data_arrange3( ps, CNT, NT_TOL_cal_DC, iter_DC );
end
if num_problem == 2
    [Error] = F_data_arrange2( ps,  CNT, Error_rand, Error_DC, Error_QR,...
                               Error_DG, Error_QD,   Error_AG, Error_EG,...
                               Error_ave_pod );
end
% Normalize
if num_problem == 1 || num_problem == 2
    [Normalized_det] = F_data_normalize( ps, CNT, det_rand, det_DC, det_QR, ...
                                         det_DG,  det_QD,   det_AG, det_EG );
    [Normalized_tr]  = F_data_normalize( ps, CNT, tr_rand,  tr_DC,  tr_QR,  ...
                                         tr_DG,   tr_QD,    tr_AG,  tr_EG  );
    [Normalized_eig] = F_data_normalize( ps, CNT, eig_rand, eig_DC, eig_QR, ...
                                         eig_DG,  eig_QD,   eig_AG, eig_EG );
end

%% Save =============================================================
if num_problem == 1 || num_problem == 2
    cd(workdir)
    save('time.mat','time_all');
    save('det.mat','det_all');
    save('trace.mat','tr_all');
    save('eigen.mat','eig_all');
    save('Normalized_det.mat','Normalized_det');
    save('Normalized_trace.mat','Normalized_tr');
    save('Normalized_eigen.mat','Normalized_eig');
    save('time_rand.mat','time_rand');
    save('det_rand.mat','det_rand');
    save('trace_rand.mat','tr_rand');
    save('eigen_rand.mat','eig_rand');
    save('log_DC.mat','log_DC');
end
if num_problem == 1
    save('time_DC.mat','time_DC');
    save('time_QR.mat','time_QR');
    save('time_DG.mat','time_DG');
    save('time_QD.mat','time_QD');
    save('time_AG.mat','time_AG');
    save('time_EG.mat','time_EG');
    save('det_DC.mat','det_DC');
    save('det_QR.mat','det_QR');
    save('det_DG.mat','det_DG');
    save('det_QD.mat','det_QD');
    save('det_AG.mat','det_AG');
    save('det_EG.mat','det_EG');
    cd ../src
end
if num_problem == 2
    save('Error.mat','Error');
    save('Error_rand.mat','Error_rand');
    cd ../src
end

%% NOAA-SST cross-validation=========================================
if num_problem == 3

    %% Crossvalidation ==============================================
    for k=1:CV
        time_k = tic;
        text = ['Cross-validation: ' num2str(k),' started *************************' ];
        disp(text);
        
        %% Preprocces for NOAA-SST ==================================
        text='  Readinng/Arranging a NOAA-SST dataset';
        disp(text);
        [Lat, Lon, time, mask, sst]...
        = F_pre_read_NOAA_SST( ['sst.wkmean.1990-present.nc'], ['lsmask.nc'] );
        [Uorg, Sorg, Vorg, Xorg, meansst, n, Xtest]...
        = F_pre_SVD_NOAA_SST_training_test(m, time, mask, sst, k,CV);
        U = Uorg(:,1:r);
        Error_ave_pod =0;
        text ='  Complete Reading/Arranging a NOAA-SST dataset';
        disp(text);

        %% Sensor selection =========================================
        CNT = 0;
        for p = ps
            CNT = CNT+1;
            text = [ '  ', num2str(p),' sensor selection started --->' ];
            disp(text);
            
            %% Random selection -------------------------------------
            % Average loop
            for w=1:1:num_ave
                [time_rand(CNT,w+1), H_rand, sensors_rand] = F_sensor_random(n,p);
                det_rand(CNT,w+1) = F_calc_det  (p,H_rand,U);
                tr_rand (CNT,w+1) = F_calc_trace(p,H_rand,U);
                eig_rand(CNT,w+1) = F_calc_eigen(p,H_rand,U);
                [Zestimate_rand, Error_rand(CNT,w+1)] ...
                = F_calc_error(m/CV, Xtest, U, H_rand); %Test
            end
            % Averaging
            [ time_rand, det_rand, tr_rand, eig_rand, Error_rand ]...
            = F_data_ave2( CNT, num_ave, time_rand, det_rand, tr_rand, eig_rand, Error_rand );
            
            %% D-optimality - Convex---------------------------------
            %!! This is very time consuming proceduce, We do not recommend to try this
            % [time_DC(CNT,1), H_DC, sensors_DC, ...
            %     NT_TOL_cal_DC(CNT,1), iter_DC(CNT,1)] ...
            %     = F_sensor_DC(U,p,maxiteration);
            % det_DC(CNT,1) = F_calc_det(p,H_DC,U);
            % tr_DC(CNT,1)  = F_calc_trace(p,H_DC,U);
            % eig_DC(CNT,1) = F_calc_eigen(p,H_DC,U);
            %!! I recommend you use the following dummy values
            %   if you do not need the solution in the convex approximation in NOAA-SST.
            time_DC(CNT,1) = time_rand(CNT,1);
            det_DC (CNT,1) = det_rand (CNT,1);
            tr_DC  (CNT,1) = tr_rand  (CNT,1);
            eig_DC (CNT,1) = eig_rand (CNT,1);
            H_DC=H_rand;
            sensors_DC=sensors_rand;
            NT_TOL_cal_DC(CNT,w+1)=0;
            iter_DC(CNT,w+1)=0;
            %!!
            [Zestimate_DC, Error_DC(CNT,1)] ...
            = F_calc_error(m/CV, Xorg, U, H_DC);
            % NT_TOL_cal_DC(CNT,1)=mean(NT_TOL_cal_DC(CNT,2:w+1));
            % iter_DC(CNT,1)=mean(iter_DC(CNT,2:w+1));
            
            %% Maximization of row norm - Greedy based on QR --------
            % [time_QR(CNT,1), H_QR, sensors_QR] = F_sensor_QR(U,p);
            % det_QR (CNT,1) = F_calc_det  (p,H_QR,U);
            % tr_QR  (CNT,1) = F_calc_trace(p,H_QR,U);
            % eig_QR (CNT,1) = F_calc_eigen(p,H_QR,U);
            %!! You can use the following dummy values
            time_QR(CNT,1) = time_rand(CNT,1);
            det_QR (CNT,1) = det_rand (CNT,1);
            tr_QR  (CNT,1) = tr_rand  (CNT,1);
            eig_QR (CNT,1) = eig_rand (CNT,1);
            H_QR=H_rand;
            sensors_QR=sensors_rand;
            
            [Zestimate_QR, Error_QR(CNT,1)] ...
            = F_calc_error(m/CV, Xtest, U, H_QR);%Test
            
            %% D-optimality - Greedy --------------------------------
            [time_DG(CNT,1), H_DG, sensors_DG] = F_sensor_DG(U,p);
            det_DG (CNT,1) = F_calc_det  (p,H_DG,U);
            tr_DG  (CNT,1) = F_calc_trace(p,H_DG,U);
            eig_DG (CNT,1) = F_calc_eigen(p,H_DG,U);
            [Zestimate_DG, Error_DG(CNT,1)] ...
            = F_calc_error(m/CV, Xtest, U, H_DG);%Test
            
            %% D-optimality - Hybrid of QR and DG -------------------
            [time_QD(CNT,1), H_QD, sensors_QD] = F_sensor_QD(U,p);
            det_QD (CNT,1) = F_calc_det  (p,H_QD,U);
            tr_QD  (CNT,1) = F_calc_trace(p,H_QD,U);
            eig_QD (CNT,1) = F_calc_eigen(p,H_QD,U);
            [Zestimate_QD, Error_QD(CNT,1)] ...
            = F_calc_error(m/CV, Xtest, U, H_QD);%Test
            
            %% A-optimality -  Greedy -------------------------------
            [time_AG(CNT,1), H_AG, sensors_AG] = F_sensor_AG(U,p);
            det_AG (CNT,1) = F_calc_det  (p,H_AG,U);
            tr_AG  (CNT,1) = F_calc_trace(p,H_AG,U);
            eig_AG (CNT,1) = F_calc_eigen(p,H_AG,U);
            [Zestimate_AG, Error_AG(CNT,1)] ...
            = F_calc_error(m/CV, Xtest, U, H_AG);%Test
            
            %% E-optimality -  Greedy -------------------------------
            [time_EG(CNT,1), H_EG, sensors_EG] = F_sensor_EG(U,p);
            det_EG (CNT,1) = F_calc_det  (p,H_EG,U);
            tr_EG  (CNT,1) = F_calc_trace(p,H_EG,U);
            eig_EG (CNT,1) = F_calc_eigen(p,H_EG,U);
            [Zestimate_EG, Error_EG(CNT,1)] ...
            = F_calc_error(m/CV, Xtest, U, H_EG);%Test
            
            %% Sensor location ======================================
            sensor_memo = zeros(p,7);
            sensor_memo(1:p,1) = sensors_rand(1:p)';
            sensor_memo(1:p,2) = sensors_DC(1:p);
            sensor_memo(1:p,3) = sensors_QR(1:p)';
            sensor_memo(1:p,4) = sensors_DG(1:p);
            sensor_memo(1:p,5) = sensors_QD(1:p)';
            sensor_memo(1:p,6) = sensors_AG(1:p)';
            sensor_memo(1:p,7) = sensors_EG(1:p)';
            filename = [workdir, '/sensors_CV_', num2str(k), '_p_', num2str(p), '.mat'];
            save(filename,'sensor_memo');
            
        end
        
        %% Data organization ========================================
        % Arrange
        [time_all] = F_data_arrange1( ps, CNT, time_rand, time_DC, time_QR,...
                                      time_DG, time_QD,   time_AG, time_EG );
        [det_all]  = F_data_arrange1( ps, CNT, det_rand,  det_DC,  det_QR, ...
                                      det_DG,  det_QD,    det_AG,  det_EG  );
        [tr_all]   = F_data_arrange1( ps, CNT, tr_rand,   tr_DC,   tr_QR,...
                                      tr_DG,   tr_QD,     tr_AG,   tr_EG   );
        [eig_all]  = F_data_arrange1( ps, CNT, eig_rand,  eig_DC,  eig_QR,...
                                      eig_DG,  eig_QD,    eig_AG,  eig_EG  );
        [Error] = F_data_arrange2( ps,  CNT, Error_rand, Error_DC, Error_QR,...
                                   Error_DG, Error_QD,   Error_AG, Error_EG,...
                                   Error_ave_pod );
        [log_DC] = F_data_arrange3( ps, CNT, NT_TOL_cal_DC, iter_DC );
        
        % Normalize
        [Normalized_det] = F_data_normalize( ps, CNT, det_rand, det_DC, det_QR, ...
                                             det_DG,  det_QD,   det_AG, det_EG );
        [Normalized_tr]  = F_data_normalize( ps, CNT, tr_rand,  tr_DC,  tr_QR,  ...
                                             tr_DG,   tr_QD,    tr_AG,  tr_EG  );
        [Normalized_eig] = F_data_normalize( ps, CNT, eig_rand, eig_DC, eig_QR, ...
                                             eig_DG,  eig_QD,   eig_AG, eig_EG );
        
        %% Save =====================================================
        cd(workdir)
        filename=['Error_CV_',num2str(k),'.mat'];
        save(filename,'Error');
        filename=['time_CV_',num2str(k),'.mat'];
        save(filename,'time_all');
        filename=['det_CV_',num2str(k),'.mat'];
        save(filename,'det_all');
        filename=['trace_CV_',num2str(k),'.mat'];
        save(filename,'tr_all');
        filename=['eigen_CV_',num2str(k),'.mat'];
        save(filename,'eig_all');
        filename=['Normalized_det_CV_',num2str(k),'.mat'];
        save(filename,'Normalized_det');
        filename=['Normalized_trace_CV_',num2str(k),'.mat'];
        save(filename,'Normalized_tr');
        filename=['Normalized_eigen_CV_',num2str(k),'.mat'];
        save(filename,'Normalized_eig');
        filename=['time_rand_',num2str(k),'.mat'];
        save(filename,'time_rand');
        filename=['det_rand_CV_',num2str(k),'.mat'];
        save(filename,'det_rand');
        filename=['trace_rand_CV_',num2str(k),'.mat'];
        save(filename,'tr_rand');
        filename=['eigen_rand_CV_',num2str(k),'.mat'];
        save(filename,'eig_rand');
        filename=['Error_rand_CV_',num2str(k),'.mat'];
        save(filename,'Error_rand');
        filename=['log_DC_CV_',num2str(k),'.mat'];
        save(filename,'log_DC');
        cd ../src
        toc(time_k);

    end
end


warning('on','all')
disp('Congratulations!');
% cd ../src
%% ///////////////////////////////////////////////////////////////////
%% Main program end