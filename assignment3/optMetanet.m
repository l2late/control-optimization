function [U, FVAL, EXITFLAG,x] = optMetanet(x,q0,rDef,U0,kmax,A,B,Aeq,beq,lb,ub,nonlcon,options)

    for k = 1:kmax

        [U(:,k),FVAL(k),EXITFLAG] = fmincon(@(u)optimFunction(u,x(:,k),q0(k),rDef),U0,A,B,Aeq,beq,lb,ub,nonlcon,options);
        assert(EXITFLAG>0);
        if(k<60)
           x(:,k+1) = updateVal(U(:,k),x(:,k),q0(k),rDef);
        end
        U0 = U(:,k);

    end
end