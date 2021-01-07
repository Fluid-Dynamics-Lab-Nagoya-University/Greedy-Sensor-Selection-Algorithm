function [sensors]=F_sensor_AG_calc_trace(U, p)
    % objective function: trace[inv(CCT)], trace[inv(CTC)]

    [n,r]= size(U);
    H    = zeros(p,n);
    C    = [];
    A1   = zeros(1,r);
    A2   = eye(r,r);
    % Sensor number loop ============================================
    for pp=1:1:p
        obj = zeros(1,n);
        if pp <= r
            for i=1:1:n
                obj(i) = ( norm(A1*U(i,:)',2)^2+1 ) / ( U(i,:)*A2*U(i,:)' ); %tr[inv(CCT)]
                % obj(i) = ( dot( A1*U(i,:)', A1*U(i,:)' ) + 1 ) / ( U(i,:)*A2*U(i,:)' ); <-- higher cost
            end
        else
            for i=1:1:n
                obj(i) = - ( U(i,:)*CTCI^2*U(i,:)' ) / ( 1+U(i,:)*CTCI*U(i,:)' ); %tr[inv(CTC)]
            end
        end
        [~,sensors(pp)] = min(obj);
        % Update for next step calculation ==========================
        C = [ C ; U(sensors(pp),:) ]; 
        if pp <= r
            A1   = inv(C*C')*C;
            A2   = eye(r,r)-C'*A1;
        end
        if pp >= r
            CTCI = inv(C'*C);
        end
        U(sensors(pp),:) = zeros(1,r); % zero reset to exclude from candidate
    end
    
end
