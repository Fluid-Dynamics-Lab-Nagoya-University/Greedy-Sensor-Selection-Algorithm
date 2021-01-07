function [time_QR, H, sensors]=F_sensor_QR(U, p)

    [n,~]=size(U);
    tic;
    [sensors]=F_sensor_QR_pivot(p, U);
    time_QR=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
end