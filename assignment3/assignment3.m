%% Assignment 2 Quadratic Programming
% Luca de Laat      - 4135040
% Nathan Timmers    - 4283449
clear all; close all; clc;
fprintf('Assignment 3 - Nonlinear Programming \n')
fprintf('Luca de Laat   - 4135040 \n')
fprintf('Nathan Timmers - 4283449 \n\n')

%% Initializing Constants
E1 = (0+4)/2;
E2 = (4+4)/2;
E3 = (0+9)/2;

plotResult = true;

%% Question 1 & 2
fprintf('Question 1 & 2: \n')
parameters;
Tend    = 60*10;
kmax = Tend / T;

q0 = [ones(1,11)*(7000+100*E1),ones(1,kmax-11)*(2000+100*E2)];

wr = zeros(1,kmax);
qr = zeros(1,kmax);

x = zeros(9,kmax);
x(:,1) = x0;
FVAL = zeros(1,kmax);
% u = [VSL2; VSL3; r(k);
U0 = [115;100;0.99];
U = zeros(3,kmax);

lb = [60;60;0];
ub = [120;120;1];

% Inequality constraints
A = [];
B = [];

% Equality constraints
Aeq = [];
beq = [];

nonlcon = [];
options = optimoptions('fmincon','Display','off');

% optimFunction(U0,x0,q0(1))

rDef = 1;

[U0, FVAL, EXITFLAG,x] = optMetanet(x,q0,rDef,U0,kmax,A,B,Aeq,beq,lb,ub,nonlcon,options)

plotResults(x,kmax)

%% Question 3
fprintf('Question 3: \n')

U01 = [60;60;0.99];
U02 = [120;120;0.99];
U = zeros(3,kmax);
x = zeros(9,kmax);
FVAL = zeros(1,kmax);
x(:,1) = x0;

% Initial VSL = 60;
rDef = 1;

[U, FVAL, EXITFLAG,x] = optMetanet(x,q0,rDef,U01,kmax,A,B,Aeq,beq,lb,ub,nonlcon,options)

sum(FVAL)
plotResults(x,kmax)

% initial VSL = 120;
U = zeros(3,kmax);
x = zeros(9,kmax);
FVAL = zeros(1,kmax);
x(:,1) = x0;
rDef = 1;


[U, FVAL, EXITFLAG,x] = optMetanet(x,q0,rDef,U02,kmax,A,B,Aeq,beq,lb,ub,nonlcon,options);

sum(FVAL)
plotResults(x,kmax)