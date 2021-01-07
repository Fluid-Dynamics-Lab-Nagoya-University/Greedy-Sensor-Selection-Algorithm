function [Normalized]=F_data_normalize(ps, CNT, A1, A2, A3, A4, A5, A6, A7)

    for z=1:CNT
        Normalized(z,1) = ps(z);
        Normalized(z,2) = A1(z,1)/A3(z,1);
        Normalized(z,3) = A2(z,1)/A3(z,1);
        Normalized(z,4) = A3(z,1)/A3(z,1); %QR
        Normalized(z,5) = A4(z,1)/A3(z,1);
        Normalized(z,6) = A5(z,1)/A3(z,1);
        Normalized(z,7) = A6(z,1)/A3(z,1);
        Normalized(z,8) = A7(z,1)/A3(z,1);
    end

end


