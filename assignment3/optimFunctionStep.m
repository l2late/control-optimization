function [y] = optimFunctionStep(u)
parameters;
u(1:kmax) = u(1:kmax)*20;
[x] = updateVal(u);

y = sum( T*x(9,:) + T*L*lambda*(x(1,:)+x(2,:)+x(3,:)+x(4,:)))/3600;

end