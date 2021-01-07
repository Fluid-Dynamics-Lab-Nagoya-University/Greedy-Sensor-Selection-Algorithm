function [time_DG, H, sensors] = F_sensor_DG(U, p)

    [n,r]=size(U);
    if p <= r
        tic;
        [sensors] = F_sensor_DG_r(U, p);
        time_DG=toc;
        [H] = F_calc_sensormatrix(p, n, sensors);
    else
        tic;
        [isensors] = F_sensor_DG_r(U, r);
        [H] = F_calc_sensormatrix(r, n, isensors);
        [sensors] = F_sensor_DG_p(U, p, H, isensors);
        time_DG=toc;
        [H] = F_calc_sensormatrix(p, n, sensors);
    end

end