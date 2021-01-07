function  [sensors]=F_sensor_QR_pivot(p, U)
% see paper "Data-Driven Sparse Sensor Placement for Reconstruction: Demonstrating the Benefits of Exploiting Known Patterns"
% https://ieeexplore.ieee.org/abstract/document/8361090
% Krithika Manohar, Bingni W. Brunton, J. Nathan Kutz, Steven L. Brunton
% Date of Publication: 18 May 2018 

    [~,r]=size(U);
    if p <= r
        V=U;
    else
        V=U;
        V=V*V';
    end
    [~,~,pivot] = qr(V','vector');

    sensors = pivot(1:p);

end