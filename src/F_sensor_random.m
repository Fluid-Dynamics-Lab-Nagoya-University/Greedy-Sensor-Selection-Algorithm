function [time_rand, H, sensors]=F_sensor_random(n,p)

    tic;
    sensors = randperm(n,p);
    time_rand=toc;
    [H]=F_calc_sensormatrix(p, n, sensors);
    
end