%% Assignment 2 Quadratic Programming
% Luca de Laat      - 4135040
% Nathan Timmers    - 4283449
clear all; close all; clc;
fprintf('Assignment 2 - Quadratic Programming \n')
fprintf('Luca de Laat   - 4135040 \n')
fprintf('Nathan Timmers - 4283449 \n\n')

%% Initializing Constants
E1 = 4;
E2 = 8;
E3 = 9;

%% Question 1
[~,Qin,Qout,T,Tamb] = importMeasurements('measurements.csv');
dt = 3600;

dT = Tamb - T;
dQ = Qin - Qout;

E = Tamb(1:end-1);
Y = T(2:end);

phi = -[dt*T(1:end-1),dt*dQ(1:end-1)];

H = 2*(phi'*phi);
c = -2*phi'*Y;

lb = [-0.99 -Inf]';
ub = [ 0.99  Inf]';

o = optimoptions('quadprog','Algorithm','interior-point-convex');
[x,~,FLAG] = quadprog(H,c,[],[],[],[],lb,ub,[],o)
assert(FLAG==1)

alpha1 = x(1);
alpha2 = x(2);
T(2:end)-(alpha1*dt*dT(1:end-1) + alpha2*dt*dQ(1:end-1)) - T(1:end-1)
