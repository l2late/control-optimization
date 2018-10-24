function [x1,x2,x3,x4,x5,x6,x7,x8,x9] = updateVal(u)

parameters;
x = zeros(9*(kmax),1);
x(1) = x0(1);
x(1*kmax+1) = x0(2);
x(2*kmax+1) = x0(3);
x(3*kmax+1) = x0(4);
x(4*kmax+1) = x0(5);
x(5*kmax+1) = x0(6);
x(6*kmax+1) = x0(7);
x(7*kmax+1) = x0(8);
x(8*kmax+1) = x0(9);

if (size(u,1)/kmax <3)
    r = ones(kmax,1);
else
    r = u(2*kmax+1:end);
end


for index = 1:(kmax-1)
    
    VSL =   [
    VSL0;...
    u(index);...
    u((index+kmax));...
    VSL0];

V  = [  
    min([ (1+alph)* VSL(1), vf*exp(-1/a*(x(index)/rhoc)^a)]);...
    min([ (1+alph)* VSL(2), vf*exp(-1/a*(x(index+1*kmax)/rhoc)^a)]);...
    min([ (1+alph)* VSL(3), vf*exp(-1/a*(x(index+2*kmax)/rhoc)^a)]);...
    min([ (1+alph)* VSL(4), vf*exp(-1/a*(x(index+3*kmax)/rhoc)^a)])];

q = [   
    lambda*x(index)*x(index+4*kmax);...
    lambda*x(index+1*kmax)*x(index+5*kmax);...
    lambda*x(index+2*kmax)*x(index+6*kmax);...
    lambda*x(index+3*kmax)*x(index+7*kmax)];

qr = min([1*Cr, Dr + x(index+8*kmax)/T, Cr* (rhom-x(index+3*kmax)/lambda)/(rhom-rhoc)]);
    
    
x(index+1) = x(index) + T/(lambda*L)*(q0(index) - q(1))/3600;
x(index+1+1*kmax) = x(index+1*kmax) + T/(lambda*L)*(q(1) - q(2))/3600;
x(index+1+2*kmax) = x(index+2*kmax) + T/(lambda*L)*(q(2) - q(3))/3600;
x(index+1+3*kmax) = x(index+3*kmax) + T/(lambda*L)*(q(3) - q(4) + qr)/3600;
x(index+1+4*kmax) = x(index+4*kmax) + T/tau * (V(1) - x(index+4*kmax))                                                              - muu*T/(tau*L) * (x(index+1*kmax)-x(index))/(x(index)+K);
x(index+1+5*kmax) = x(index+5*kmax) + T/tau * (V(2) - x(index+5*kmax)) + T/L*x(index+5*kmax)*(x(index+4*kmax)-x(index+5*kmax))/3600 - muu*T/(tau*L) * (x(index+2*kmax)-x(index+1*kmax))/(x(index+1*kmax)+K);
x(index+1+6*kmax) = x(index+6*kmax) + T/tau * (V(3) - x(index+6*kmax)) + T/L*x(index+6*kmax)*(x(index+5*kmax)-x(index+6*kmax))/3600 - muu*T/(tau*L) * (x(index+3*kmax)-x(index+2*kmax))/(x(index+2*kmax)+K);
x(index+1+7*kmax) = x(index+7*kmax) + T/tau * (V(4) - x(index+7*kmax)) + T/L*x(index+7*kmax)*(x(index+6*kmax)-x(index+7*kmax))/3600 ;
x(index+1+8*kmax) = x(index+8*kmax) + T*(Dr - qr)/3600;

end

x1 = x(1:kmax);
x2 = x(1*kmax+1:2*kmax);
x3 = x(2*kmax+1:3*kmax);
x4 = x(3*kmax+1:4*kmax);
x5 = x(4*kmax+1:5*kmax);
x6 = x(5*kmax+1:6*kmax);
x7 = x(6*kmax+1:7*kmax);
x8 = x(7*kmax+1:8*kmax);
x9 = x(8*kmax+1:end);

end

