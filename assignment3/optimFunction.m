function [y] = optimFunction(u)
parameters;
[x] = updateVal(u);

y = sum( T*x(9,:) + T*L*lambda*(x(1,:)+x(2,:)+x(3,:)+x(4,:)));
y = y + sum(betaa * max(0, x(9,:) - ones(1,kmax)*(20-E3)));
end