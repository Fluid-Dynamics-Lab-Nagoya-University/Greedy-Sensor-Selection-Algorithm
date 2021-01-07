function [time, H, sensors]=F_sensor_EG(U, p)
    % objective function: minimum eigenvalue(CCT), (CTC)
    
    [n,~]=size(U);
    tic;
    [sensors]=F_sensor_EG_calc_eigen(U, p);
    time=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
end