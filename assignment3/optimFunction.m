function [y] = optimFunction(u,x,q0)
parameters;


xNew = updateVal(u, x,q0);



y = (T*xNew(9) + T*L*lambda*( xNew(1)+xNew(2)+xNew(3)+xNew(4) ))/3600;

end