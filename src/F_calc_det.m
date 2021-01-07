function [logdet]=F_calc_det(p, H, U)

    [~,r]=size(U);
    C = H*U;
    if p <= r
        logdet = log(det(C*C'));
    else
        logdet = log(det(C'*C));
    end
end
