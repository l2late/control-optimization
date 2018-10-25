function [x] = updateVal(u)

parameters;
x = zeros(9,(kmax));
x(:,1) = x0;

if (size(u,1)/kmax <3)
    r = ones(kmax,1);
else
    r = u(kmax+1:end);
end


for index = 1:(kmax-1)
    
    VSL =   [
    VSL0;...
    u(index);...
    u((index));...
    VSL0];

V  = [  
    min([ (1+alph)* VSL(1), vf*exp(-1/a*(x(1,index)/rhoc)^a)]);...
    min([ (1+alph)* VSL(2), vf*exp(-1/a*(x(2,index)/rhoc)^a)]);...
    min([ (1+alph)* VSL(3), vf*exp(-1/a*(x(3,index)/rhoc)^a)]);...
    min([ (1+alph)* VSL(4), vf*exp(-1/a*(x(4,index)/rhoc)^a)])];

q = [   
    lambda*x(1,index)*x(5,index);...
    lambda*x(2,index)*x(6,index);...
    lambda*x(3,index)*x(7,index);...
    lambda*x(4,index)*x(8,index)];

qr = min([1*Cr, Dr + x(9,index)/T, Cr* (rhom-x(4,index)/lambda)/(rhom-rhoc)]);
    
    
x(1,index+1) = x(1,index) + T/(lambda*L)*(q0(index) - q(1))/3600;
x(2,index+1) = x(2,index) + T/(lambda*L)*(q(1) - q(2))/3600;
x(3,index+1) = x(3,index) + T/(lambda*L)*(q(2) - q(3))/3600;
x(4,index+1) = x(4,index) + T/(lambda*L)*(q(3) - q(4) + qr)/3600;
x(5,index+1) = x(5,index) + T/tau * (V(1) - x(5,index))                                               - muu*T/(tau*L) * (x(2,index)-x(1,index))/(x(1,index)+K);
x(6,index+1) = x(6,index) + T/tau * (V(2) - x(6,index)) + T/L*x(6,index)*(x(5,index)-x(6,index))/3600 - muu*T/(tau*L) * (x(3,index)-x(2,index))/(x(2,index)+K);
x(7,index+1) = x(7,index) + T/tau * (V(3) - x(7,index)) + T/L*x(7,index)*(x(6,index)-x(7,index))/3600 - muu*T/(tau*L) * (x(4,index)-x(3,index))/(x(3,index)+K);
x(8,index+1) = x(8,index) + T/tau * (V(4) - x(8,index)) + T/L*x(8,index)*(x(7,index)-x(8,index))/3600 ;
x(9,index+1) = x(9,index) + T*(Dr - qr)/3600;

end

end

