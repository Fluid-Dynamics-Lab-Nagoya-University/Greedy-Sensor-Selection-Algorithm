function [eig_min]=F_calc_eig(p, H, U)
    
    [~,r]=size(U);
    C = H*U;
    if p <= r
        eig_min = min( eig(C*C') );
    else
        eig_min = min( eig(C'*C) );
    end
end