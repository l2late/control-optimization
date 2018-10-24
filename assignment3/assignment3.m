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
kmax = Tend / T + 1;

q0 = [ones(1,12)*(7000+100*E1),ones(1,kmax-12)*(2000+100*E2)];

x = zeros(9,kmax);
x(:,1) = x0;

% u = [VSL2; VSL3; r(k);
U0 = [80;80];

lb = [60;60];
ub = [120;120];

% Inequality constraints
A = [];
B = [];

% Equality constraints
Aeq = [];
beq = [];

nonlcon = [];

% optimFunction(U0,x0,q0(1))


[FVAL, U, ~,x] = optMetanet(x,q0,U0,kmax,A,B,Aeq,beq,lb,ub,nonlcon);
fprintf('Total Time Spent from start to end: %3.2f hours \n\n', FVAL)
if plotResult
    plotResults(x,kmax,U)
end

%% Question 3
fprintf('Question 3: \n')

U01 = [60;60];
U02 = [120;120];
x = zeros(9,kmax);
x(:,1) = x0;

% Initial VSL = 60;
[FVAL, U, ~,x] = optMetanet(x,q0,U01,kmax,A,B,Aeq,beq,lb,ub,nonlcon);

fprintf('Total Time Spent from start to end with VSL = %d km/h: %3.2f hours \n',U01(1), FVAL)

if plotResult
    plotResults(x,kmax,U)
end

% initial VSL = 120;
x = zeros(9,kmax);
x(:,1) = x0;


[FVAL, U, ~,x] = optMetanet(x,q0,U02,kmax,A,B,Aeq,beq,lb,ub,nonlcon,options);

fprintf('Total Time Spent from start to end with VSL = %d km/h: %3.2f hours \n',U02(1), FVAL)

if plotResult
    plotResults(x,kmax,U)
end

%Find optimum starting point
for j=1:61
   U03 = [60+(j-1);60+(j-1)];
   [FVAL(j), ~, ~,x] = optMetanet(x,q0,U03,kmax,A,B,Aeq,beq,lb,ub,nonlcon);
    
end

fprintf('The optimal initial values for the VSL range from %d km/h to %d km/h \n', 59+find(FVAL == min(FVAL),1,'first'), 59+find(FVAL == min(FVAL),1,'last'))

%% Question 4
fprintf('Question 4: \n')

U0 = [100;100;0.8];
x = zeros(9,kmax);
x(:,1) = x0;

% Initial VSL = 60;
rDef = [];

[FVAL, U, ~,x] = optMetanet(x,q0,U0,kmax,A,B,Aeq,beq,lb,ub,nonlcon);

fprintf('Total Time Spent from start to end with on-ramp metering: %3.2f hours \n', FVAL)

if plotResult
    plotResults(x,kmax,U)
end