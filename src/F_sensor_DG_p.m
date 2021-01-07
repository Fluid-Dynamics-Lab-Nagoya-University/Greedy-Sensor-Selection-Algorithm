function[isensors]=F_sensor_DG_p(U, p, H, isensors)

    [n,r]=size(U);
    [ps,~]=size(isensors);
    ip=isensors';
    C=H*U;
    CTC=C'*C;

    for is=isensors'
        U(is,:)=zeros(1,r);
    end

    CTCI=inv(CTC);

    for pp=(ps+1):p
        for nn=1:n
            v(1,:)=U(nn,:);
            J(nn)=det(eye(1,1) + v*CTCI*v');
        end
        [~,ip(pp)]=max(J);
        v(1,:)=U(ip(pp),:);
        CTCI=CTCI*(eye(r,r)- v' * inv(eye(1,1)+v*CTCI*v') * v *CTCI);
        U(ip(pp),:)=zeros(1,r);
        CTC=CTC+v'*v;
        det(CTC);
        det(inv(CTCI));
    end
    isensors=ip';

end