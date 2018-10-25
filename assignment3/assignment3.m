%% Assignment 2 Quadratic Programming
% Luca de Laat      - 4135040
% Nathan Timmers    - 4283449
clear all; close all; clc;
fprintf('Assignment 3 - Nonlinear Programming \n')
fprintf('Luca de Laat   - 4135040 \n')
fprintf('Nathan Timmers - 4283449 \n\n')

parameters;
%% Question 1 & 2
fprintf('Question 1 & 2: \n')

% Inequality constraints
A = [];
b = [];
% 
% % Equality constraints
Aeq = [];
beq = [];

nonlcon = [];

U0 =ones(kmax,1)*110;

lb = ones(size(U0,1),1)*60;
ub = ones(size(U0,1),1)*120;

options = optimoptions('fmincon','Display','off');
[U,FVAL,EXITFLAG] = fmincon(@(u)optimFunction(u),U0,A,b,Aeq,beq,lb,ub,nonlcon,options);
assert(EXITFLAG>0);

[x] = updateVal(U);

fprintf('Total Time Spent from start to end: %3.2f hours \n\n', FVAL)
if plotResult
    plotResults(x,kmax,U)
end

%% Question 3
fprintf('Question 3: \n')

U01 = [ones(kmax,1)]*60;
U02 = [ones(kmax,1)]*120;

% Initial VSL = 60;
[U,FVAL,EXITFLAG] = fmincon(@(u)optimFunction(u),U01,A,b,Aeq,beq,lb,ub,nonlcon,options);
if(EXITFLAG>0)
     fprintf('No optimal solution could be obtained for this intial value. \n');
else
    [x] = updateVal(U);
    
    fprintf('Total Time Spent from start to end with VSL = %d km/h: %3.2f hours \n',U01(1,1), FVAL)
    
    if plotResult
        plotResults(x,kmax,U)
    end
end

% initial VSL = 120;
[U,FVAL,EXITFLAG] = fmincon(@(u)optimFunction(u),U02,A,b,Aeq,beq,lb,ub,nonlcon,options);
assert(EXITFLAG>0);
[x] = updateVal(U);

fprintf('Total Time Spent from start to end with VSL = %d km/h: %3.2f hours \n',U02(1,1), FVAL)

if plotResult
    plotResults(x,kmax,U)
end
clear FVAL
%Find optimum starting point

tic;

FVAL = zeros(1,kmax);
for j=1:61
    
   U03 = ones(kmax,1)*(60+(j-1));
   [UF,FVAL(j),EXITFLAG] = fmincon(@(u)optimFunction(u),U03,A,b,Aeq,beq,lb,ub,nonlcon,options);
 
%    [~,FVAL(j),EXITFLAG] = patternsearch(@(u)optimFunction(u),UF,A,b,Aeq,beq,lb,ub)
%    simoptions = optimoptions(@simulannealbnd,'Display','iter');
%    [~,FVAL(j),EXITFLAG] = simulannealbnd(@(u)optimFunction(u),UF,lb,ub,simoptions)
%    gaoptions = optimoptions('ga','Display','iter');
%    [~,FVAL(j),EXITFLAG] = ga(@(u)optimFunction(u),size(UF,1),A,b,Aeq,beq,lb,ub,nonlcon,gaoptions);
   
   if~(EXITFLAG>0)
     fprintf('No optimal solution could be obtained for this initial value. \n');
     FVAL(j) = 9^999;
   end
end
toc;

fprintf('The optimal initial values for the VSL range from %d km/h to %d km/h \n', 59+find(FVAL == min(FVAL),1,'first'), 59+find(FVAL == min(FVAL),1,'last'))

%% Question 4
fprintf('Question 4: \n')

U0 =[ones(kmax,1)*120;ones(kmax,1)*0.7];
lb = [ones(kmax,1)*60;   zeros(kmax,1)];
ub = [ones(kmax,1)*120; ones(kmax,1)];

[U,FVAL,EXITFLAG] = fmincon(@(u)optimFunction(u),U0,A,b,Aeq,beq,lb,ub,nonlcon,options);
if (EXITFLAG>0)
    Umincon = U;
    gaoptions = optimoptions('ga','Display','off');
    [U,FVAL,EXITFLAG] = ga(@(u)optimFunction(u),size(U0,1),A,b,Aeq,beq,lb,ub,nonlcon,gaoptions);
    assert(EXITFLAG>0);
end
[x] = updateVal(U);

fprintf('Total Time Spent from start to end with on-ramp metering: %3.2f hours \n', FVAL)

if plotResult
    plotResults(x,kmax,U)
end

%% Question 6
fprintf('Question 6: \n')

IntCon = 1:kmax;
nonlcon = [];%@mycon;

U0 =[ones(kmax,1)*120/20;ones(kmax,1)*0.7];

lb = [ones(kmax,1)*60/20;   zeros(kmax,1)];
ub = [ones(kmax,1)*120/20; ones(kmax,1)];

tic;
gaoptions = optimoptions('ga','Display','off');
[U,FVAL,EXITFLAG] = ga(@(u)optimFunctionStep(u),size(U0,1),A,b,Aeq,beq,lb,ub,nonlcon,IntCon,gaoptions);
assert(EXITFLAG>0)
toc;

U(1:kmax) = 20*U(1:kmax);
[x] = updateVal(U);

if plotResult
    plotResults(x,kmax,U)
end

function [c,ceq] = mycon(u)
parameters;
c = 0     ;% Compute nonlinear inequalities at x.
ceq = mod(u(1:kmax),20)  ;% Compute nonlinear equalities at x.

end

