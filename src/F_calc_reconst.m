function [Zestimate] = F_calc_reconst(Xorg, H, U)

    Y = H*Xorg;
    C = H*U;
    Zestimate = pinv(C)*Y; %B = pinv(A) returns the Moore-Penrose Pseudoinverse of matrix A.

end
