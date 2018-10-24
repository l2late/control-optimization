function [y] = optimF2(u)
parameters;
[x1,x2,x3,x4,~,~,~,~,x9] = updateVal(u);

y = sum( T*x9 + T*L*lambda*(x1+x2+x3+x4))/3600;

end