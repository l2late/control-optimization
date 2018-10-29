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

U0 = ones(kmax,1)*110;
lb = ones(size(U0,1),1)*60;
ub = ones(size(U0,1),1)*120;

% Create multi start problem
problem = createOptimProblem('fmincon','x0',U0,'objective',@(u)optimFunction(u),'lb',lb, 'ub',ub);
U0s =  [ones(kmax,1)*60,ones(kmax,1)*70,ones(kmax,1)*80,ones(kmax,1)*90,ones(kmax,1)*100,ones(kmax,1)*110, ones(kmax,1)*120]';
U0s = CustomStartPointSet(U0s);

[U,FVAL,EXITFLAG,~,~] = run(MultiStart('UseParallel',true,'Display','off'),problem,U0s);
assert(EXITFLAG>0);

[x] = updateVal(U);

fprintf('Total Time Spent from start to end: %3.2f hours \n\n', FVAL)
if plotResult
    plotResults(x,kmax,U)
end
clear U0 U x U0s problem EXITFLAG FVAL  
%% Question 3
fprintf('Question 3: \n')
iteratewGA = false; % iterate with both fmincon and genetic? -> TRUE

U01 = ones(kmax,1)*60;
U02 = ones(kmax,1)*120;

% Initial VSL = 60;
[U,FVAL,EXITFLAG] = fmincon(@(u)optimFunction(u),U01,A,b,Aeq,beq,lb,ub,nonlcon,optionsFmincon);
if~(EXITFLAG>0)
    [U,FVAL,EXITFLAG] = ga(@(u)optimFunction(u),size(U01,1),A,b,Aeq,beq,lb,ub,nonlcon,gaoptions);
    if~(EXITFLAG>0)
        fprintf('No optimal solution could be obtained for this initial value. \n');
    end
end
if(EXITFLAG>0)
    [x] = updateVal(U);
    fprintf('Total Time Spent from start to end with VSL = %d km/h: %3.2f hours \n',U01(1,1), FVAL)
    if plotResult
        plotResults(x,kmax,U)
    end
end

% initial VSL = 120;
[U,FVAL,EXITFLAG] = fmincon(@(u)optimFunction(u),U02,A,b,Aeq,beq,lb,ub,nonlcon,optionsFmincon);
assert(EXITFLAG>0);
[x] = updateVal(U);

fprintf('Total Time Spent from start to end with VSL = %d km/h: %3.2f hours \n',U02(1,1), FVAL)

if plotResult
    plotResults(x,kmax,U)
end
clear FVAL

% Find optimum starting point
if (iteratewGA)
    fprintf('Iterating over different initial points using fmincon and genetic algorithm... \n');
else
    fprintf('Iterating over different initial points using only fmincon ... \n');
end

FVAL = zeros(1,kmax);
for j=1:61
    U03 = ones(kmax,1)*(60+(j-1));
    [~,FVAL(j),EXITFLAG] = fmincon(@(u)optimFunction(u),U03,A,b,Aeq,beq,lb,ub,nonlcon,optionsFmincon);
    
    if(~EXITFLAG>0 && iteratewGA)
        [~,FVAL(j),EXITFLAG] = ga(@(u)optimFunction(u),size(U03,1),A,b,Aeq,beq,lb,ub,nonlcon,gaoptions);
    end
    if ~(EXITFLAG>0)
        fprintf('No optimal solution could be obtained for this initial value. \n');
        FVAL(j) = 9^999;
    end
    
end

if (iteratewGA)
    fprintf('The initial values for the VSL for which the optimal value can be found range from %d km/h to %d km/h \n\n', ...
        59+find(FVAL == min(FVAL),1,'first'), 59+find(FVAL == min(FVAL),1,'last'));
else
    fprintf('The initial values for the VSL for which the optimal value can be found using only fmincon range from %d km/h to %d km/h \n\n',...
        59+find(FVAL == min(FVAL),1,'first'), 59+find(FVAL == min(FVAL),1,'last'));
end
clear U01 U02 U03 U x  EXITFLAG FVAL iteratewGA ub lb

%% Question 4
fprintf('Question 4: \n')
U0 =[ones(kmax,1)*110;ones(kmax,1)*0.8];
lb = [ones(kmax,1)*60;   zeros(kmax,1)];
ub = [ones(kmax,1)*120; ones(kmax,1)];

[U,FVAL,EXITFLAG] = ga(@(u)optimFunction(u),size(U0,1),A,b,Aeq,beq,lb,ub,nonlcon,gaoptions);
assert(EXITFLAG>0);
disp(FVAL)

[U,FVAL,EXITFLAG] = fmincon(@(u)optimFunction(u),U,A,b,Aeq,beq,lb,ub,nonlcon,optionsFmincon);
assert(EXITFLAG>0);
disp(FVAL)
[x] = updateVal(U);

fprintf('Total Time Spent from start to end with on-ramp metering: %3.2f hours \n', FVAL)

if plotResult
    plotResults(x,kmax,U)
end
clear U0 U0s U x EXITFLAG FVAL ub lb
%% Question 6
fprintf('Question 6: \n')

IntCon = 1:kmax;

% Without ramp metering
U0 = ones(kmax,1)*100/20;
lb = ones(kmax,1)*60/20;
ub = ones(kmax,1)*120/20;

[U,FVAL,EXITFLAG] = ga(@(u)optimFunctionStep(u),size(U0,1),A,b,Aeq,beq,lb,ub,nonlcon,IntCon,gaoptions);
assert(EXITFLAG>0)

U(1:kmax) = 20*U(1:kmax);
[x] = updateVal(U);

if plotResult
    plotResults(x,kmax,U)
end
disp(FVAL)
fprintf('Total Time Spent from start to end without on-ramp metering: %3.2f hours \n', FVAL)

%
clear U0 U x EXITFLAG FVAL ub lb

% With ramp metering
U0 = [ones(kmax,1)*100/20;ones(kmax,1)*0.7];
lb = [ones(kmax,1)*60/20;   zeros(kmax,1)];
ub = [ones(kmax,1)*120/20; ones(kmax,1)];

[U,FVAL,EXITFLAG] = ga(@(u)optimFunctionStep(u),size(U0,1),A,b,Aeq,beq,lb,ub,nonlcon,IntCon,gaoptions);
assert(EXITFLAG>0)

U(1:kmax) = 20*U(1:kmax);
[x] = updateVal(U);

if plotResult
    plotResults(x,kmax,U)
end
disp(FVAL)
fprintf('Total Time Spent from start to end with on-ramp metering: %3.2f hours \n', FVAL)


