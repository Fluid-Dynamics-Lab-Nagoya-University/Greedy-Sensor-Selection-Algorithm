function [time_QD, H, sensors]=F_sensor_QD(U, p)

    [n,r]=size(U);
    if p <= r
        tic;
        [sensors] = F_sensor_QR_pivot(p, U);
        time_QD = toc;
        [H] = F_calc_sensormatrix(p, n, sensors);
    else
        tic;
        [isensors] = F_sensor_QR_pivot(r, U);
        [H] = F_calc_sensormatrix(r, n, isensors);
        [sensors] = F_sensor_DG_p(U, p, H, isensors');
        [H] = F_calc_sensormatrix(p, n, sensors);
        time_QD = toc;
    end
    
end