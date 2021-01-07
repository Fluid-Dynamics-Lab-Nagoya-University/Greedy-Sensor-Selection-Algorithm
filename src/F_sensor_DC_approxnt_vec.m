function [zhat, L, ztilde, Utilde, NT_TOL_cal, iter] = F_sensor_DC_approxnt_vec(A, k, maxiteration)
    %% sens_sel_approxnt_vec
%The original code was extended to vector-measurement by Tohoku University (Japan) Dec 2019.

% % see paper Sensor Selection via Convex Optimization
% % www.stanford.edu/~boyd/papers/sensor_selection.html
% %
% % Nov 2007 Siddharth Joshi & Stephen Boyd

% Newton's method parameters
MAXITER  = maxiteration;
NT_TOL = 1e-4;
GAP = 1.005;
% Backtracking line search parameters
alpha = 0.01;
beta = 0.5;
[m n l] = size(A);
z = ones(m,1)*(k/m); % initialize
g = zeros(m,1);
ones_m = ones(m,1);
kappa = log(GAP)*n/m; 
% guarantees GM of lengths of semi-axes of ellipsoid corresponding to 
% ztilde <= 1.01 from optimal

%fprintf('\nIter.  Step_size  Newton_decr.  Objective  log_det\n');
AdA=zeros(n,n);
for ltmp=1:l
    AdA=AdA+((A(:,:,ltmp))'*diag(z)*A(:,:,ltmp));
end
fz = -log(det(AdA)) - kappa*sum(log(z) + log(1-z));

%fprintf('   0\t  -- \t     --   %10.3f  %10.3f\n', -fz, log(det(AdA)));

for iter=1:MAXITER

    AdA=zeros(n,n);
    for ltmp=1:l
        AdA=AdA+((A(:,:,ltmp))'*diag(z)*A(:,:,ltmp));
    end  
    W = inv(AdA);
    V=zeros(m,m);
    for ltmp=1:l
        V = V + A(:,:,ltmp)*W*(A(:,:,ltmp))';   
    end    

    g = -diag(V)- kappa*(1./z - 1./(1-z));
    H = V.*V + kappa*diag(1./(z.^2) + 1./((1-z).^2));

    R = chol(H);
    Hinvg = (R\(R'\g));
    Hinv1 = (R\(R'\ones_m));
    dz = -Hinvg + ((ones_m'*Hinvg) / (ones_m'*Hinv1))*Hinv1;

    deczi = find(dz < 0);
    inczi = find(dz > 0);
    s = min([1; 0.99*[-z(deczi)./dz(deczi) ; (1-z(inczi))./dz(inczi)]]);

    while (1)
        zp = z + s*dz;
        AdA=zeros(n,n);
        for ltmp=1:l
            AdA=AdA+((A(:,:,ltmp))'*diag(zp)*A(:,:,ltmp));
        end
        fzp = -log(det(AdA)) - kappa*sum(log(zp) + log(1-zp));

        if (fzp <= fz + alpha*s*g'*dz)
            break;
        end
        s = beta*s;
    end
    z = zp; fz = fzp;
    
    AdA=zeros(n,n);
    for ltmp=1:l
        AdA=AdA+((A(:,:,ltmp))'*diag(z)*A(:,:,ltmp));        
    end
    % fprintf('%4d %10.3f %10.3f %10.3f %10.3f\n', iter, s, -g'*dz/2, -fz, log(det(AdA)));
    NT_TOL_cal=-g'*dz/2;

    if(-g'*dz/2 <= NT_TOL)
        break;
    end
end

zsort=sort(z); 
thres=zsort(m-k); 
zhat=(z>thres);
AdA=zeros(n,n);
for ltmp=1:l
    AdA=AdA+((A(:,:,ltmp))'*diag(z)*A(:,:,ltmp));        
end
L = log(det(AdA));
ztilde = z; 
Utilde = log(det(AdA)) + 2*m*kappa;


