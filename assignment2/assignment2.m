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

plotResult = true;

%% Question 1 & 2
fprintf('Question 1 & 2: \n')

% Get input from table
measurements = readtable('measurements.csv');
Qin  = measurements{:,2};
Qout = measurements{:,3};
T    = measurements{:,4};
Tamb = measurements{:,5};

endV    = 101 + E1;
dt      = 3600;

dT = Tamb - T;
dQ = Qin - Qout;

E       = Tamb(1:endV-1);
Y       = T(2:endV)-T(1:endV-1);
phi     = [dt*dT(1:endV-1),dt*dQ(1:endV-1)];

H = 2*(phi'*phi);
c = -2*phi'*Y;

lb = [-0.99 -Inf]';
ub = [ 0.99  Inf]';

o = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
[x,~,FLAG] = quadprog(H,c,[],[],[],[],lb,ub,[],o);
assert(FLAG>0)

a1  = x(1);
a2  = x(2);
A   = 1-a1*dt;
B   = [-a2,a2]*dt;
ck  = a1*dt;

fprintf('The values of the system parameters are: \n a1 = %d \n a2 = %d \n', a1, a2)
fprintf('Yielding: \n A  =  %1.5f \n B  = [%d, %d] \n ck = %d * Tamb \n\n', A, B(1), B(2), ck)

clearvars -except E1 E2 E3 dt plotResult

%% Question 3
fprintf('Question 3: \n')

% Get input from tables
heatDemandT  = readtable('heatDemand.csv');
inputPricesT = readtable('inputPrices.csv');
Qout         = heatDemandT{:,2};  % [W]
inputPrices  = inputPricesT{:,2}; % [EUR/MWh]

T       = zeros(size(Qout,1),1);
Tamb    = ones(size(Qout,1),1) * (275 + E1);

N       = 360;                     % [hours]
QinMax  = (100+E2)*1E3;            % [W]
T(1)    = 330 + E3;                % [K]
Tmin    = 315;                     % [K]

a1  = 1.96E-7;
a2  = 3.8E-9;
A   = 1-a1*dt;
B   = [-a2,a2]*dt;
ck  = a1*dt;

factor = 1/(1E6*dt); 
inputPrices = inputPrices*factor;  % [EUR/Wh]
fprintf('Prices multiplied with a factor of: 1/(1E6*dt) = %d \n', factor)

% Cost
c = [zeros(N,1),inputPrices(1:N)*dt]; % * dt?

% Equality constraints
Aeq             = [eye(N)*1,eye(N)*-B(2)];
Aeq(2:N,1:N-1)  = Aeq(2:N,1:N-1) + eye(N-1)*-A;

beq             = A*T(1:N) + B(1)*Qout(1:N) + ck*Tamb(1:N);

% Inequality constraints
Am = [];
b  = [];

lb = ones(N,1)*[Tmin,0]; %lower bound
ub = ones(N,1)*[inf,QinMax]; %upper bound

options = optimoptions('linprog','Algorithm','dual-simplex','Display','off');

[x,cost,FLAG,~,~] = linprog(c,Am,b,Aeq,beq,lb,ub,options);
assert(FLAG > 0);

fprintf('The optimal cost of buying the input energy is: %6.2f euro \n\n', cost)

if(plotResult)
    figure();
    subplot(3,1,1)
    plot(1:N,x(1:N),'LineWidth',3)
    title('Optimization of buyin input energy')
    ylabel('Temperature [K]')
    set(gca,'FontSize',20)
    
    subplot(3,1,2)
    plot(1:N,x(N+1:end),'LineWidth',3)
    ylabel('Q^i^n [W]')
    set(gca,'FontSize',20)
    
    subplot(3,1,3)
    plot(1:N,inputPrices(1:N),'LineWidth',3)
    xlabel('time [h]')
    ylabel('Price input heat [EUR/W]')
    set(gca,'FontSize',20)
end

clearvars -except E1 E2 E3 dt plotResult inputPrices Aeq beq Tmin N QinMax

%% Question 4
fprintf('Question 4: \n')

Tmax = 368;
Tref = 323;

penRef  = (0.1+E2/10);
H       = zeros(2*N);
H(N,N)  = 2*penRef;

c           = zeros(2*N,1);
c(N)        = -2*penRef*Tref;
c(N+1:end)  = inputPrices(1:N)*dt;

Am  = [];
b   = [];

lb = ones(N,1)*[Tmin,0]; %lower bound
ub = ones(N,1)*[Tmax,QinMax]; %upper bound

o = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
[x,cost,FLAG] = quadprog(H,c,Am,b,Aeq,beq,lb,ub,[],o);
assert(FLAG>0)

totalCost   = cost + penRef*Tref^2;
termCost    = penRef*(x(N)-Tref)^2;

fprintf('The optimal cost of buying the input energy is:  %6.2f euro \n', totalCost)
fprintf('The amount destined to pay the terminal cost is: %3.2f   euro \n\n', termCost)

if(plotResult)
    figure();
    subplot(3,1,1)
    plot(1:N,x(1:N),'LineWidth',3)
    title('Optimization of buyin input energy with extra constraint')
    ylabel('Temperature [K]')
    set(gca,'FontSize',20)
    
    subplot(3,1,2)
    plot(1:N,x(N+1:end),'LineWidth',3)
    ylabel('Q^i^n [W]')
    set(gca,'FontSize',20)
    
    subplot(3,1,3)
    plot(1:N,inputPrices(1:N),'LineWidth',3)
    xlabel('time [h]')
    ylabel('Price input heat [EUR/W]')
    set(gca,'FontSize',20)
end