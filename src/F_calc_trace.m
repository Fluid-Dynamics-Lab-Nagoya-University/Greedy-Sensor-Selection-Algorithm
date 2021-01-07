function [tr_inv]=F_calc_trace(p, H, U)
    
    [~,r]=size(U);
    C = H*U;
    if p <= r
        tr_inv = trace( inv(C*C') );
    else
        tr_inv = trace( inv(C'*C) );
    end
    
end