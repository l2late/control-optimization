function [FVAL, U, EXITFLAG,x] = optMetanet(x,q0,U0,kmax,A,B,Aeq,beq,lb,ub,nonlcon)
parameters;
% options = optimoptions('fmincon','Display','iter');
options = optimoptions('ga','Display','off');
U = zeros(size(U0,1),kmax);
FVAL = zeros(1,kmax);
    for k = 1:kmax
        
        if (size(U0,1)>2)
            A = [0, 0, -T*Cr];
            B = 20 - E3 -T*Dr -x(9,k);
        end

%         [U(:,k),FVAL(k),EXITFLAG] = fmincon(@(u)optimFunction(u,x(:,k),q0(k)),U0,A,B,Aeq,beq,lb,ub,nonlcon,options);
        [U(:,k),FVAL(k),EXITFLAG] = ga(@(u)optimFunction(u,x(:,k),q0(k)),size(U0,1),A,B,Aeq,beq,lb,ub,nonlcon,options);
        assert(EXITFLAG>0);
        if(k<kmax)
           x(:,k+1) = updateVal(U(:,k),x(:,k),q0(k));
        end
        U0 = U(:,k);

    end
    FVAL = sum(FVAL);
    if nargout == 1
       clearvars -except FVAL
    end
end