function [SNSR]=F_sensor_EG_calc_eigen(U, p)
    % objective function: minimum eigenvalue(CCT), (CTC)

    [n,r]=size(U);
    H=zeros(p,n);
    C=[];
    for pp=1:1:p
        obj=zeros(1,n);
        if pp <= r
            for i=1:1:n
                obj(i)=min(eig( [C;U(i,:)] * [C' U(i,:)'])); % Fastest
                % obj(i)=eigs( [C;U(i,:)] * [C' U(i,:)'], 1, 'smallestabs'); %usable in R2020a but higher cost
                % obj(i)=svds( [C;U(i,:)] * [C' U(i,:)'], 1, 'smallest'); %usable in R2020a but higher cost
            end
        else
            for i=1:1:n
                obj(i)=min(eig( C'*C + U(i,:)'*U(i,:) ));
                % obj(i)=eigs( C'*C + U(i,:)'*U(i,:), 1, 'smallestabs');
                % obj(i)=svds( C'*C + U(i,:)'*U(i,:), 1, 'smallest');
            end
        end
        [~,SNSR(pp)]=max(obj);
        C=[C;U(SNSR(pp),:)]; % for next step calculation
        U(SNSR(pp),:)=zeros(1,r); % zero reset to exclude from candidate
    end
    
end