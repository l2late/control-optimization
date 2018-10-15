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

%% Question 1 & 2
fprintf('Question 1 & 2: \n')

% Get input from table
measurements = readtable('measurements.csv');
Qin = measurements{:,2};
Qout = measurements{:,3};
T = measurements{:,4};
Tamb = measurements{:,5};

endV = 101 + E1;
dt = 3600;

dT = Tamb - T;
dQ = Qin - Qout;

E = Tamb(1:endV-1);
Y = T(2:endV)-T(1:endV-1);
phi = [dt*dT(1:endV-1),dt*dQ(1:endV-1)];

H = 2*(phi'*phi);
c = -2*phi'*Y;

lb = [-0.99 -Inf]';
ub = [ 0.99  Inf]';

o = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
[x1,~,FLAG] = quadprog(H,c,[],[],[],[],lb,ub,[],o);
assert(FLAG>0)

a1 = x1(1);
a2 = x1(2);
A = 1-a1*dt;
B = [-a2,a2]*dt;
ck = a1*dt;

max(abs(T(2:endV)-(a1*dt*dT(1:endV-1) + a2*dt*dQ(1:endV-1)) - T(1:endV-1)));


fprintf('The values of the system parameters are: \n a1 = %1.4f E-7 \n a2 = %1.4f E-9 \n', a1*1E7, a2*1E9)
fprintf('Yielding: \n A  =  %1.5f \n B  = [%1.5f, %1.5f] E-5 \n ck = %1.5f E-4 * Tamb \n\n', A, B(1)*1E5, B(2)*1E5, ck*1E4)

%% Question 3
fprintf('Question 3: \n')

% Get input from tables
heatDemandT  = readtable('heatDemand.csv');
inputPricesT = readtable('inputPrices.csv');
Qout       = heatDemandT{:,2};        % [W]
inputPrices  = inputPricesT{:,2}; % [EUR/MWh]

T = zeros(size(Qout,1),1);
Tamb = ones(size(Qout,1),1) * (275 + E1);

N = 360;                        % [hours]
QinMax = (100+E2)*1E3;          % [W]
T(1) = 330 + E3;                % [K]
Tmin = 315;                     % [K]

a1 = 1.96E-7;
a2 = 3.8E-9;
A = 1-a1*dt;
B = [-a2,a2]*dt;
ck = a1*dt;

inputPrices = inputPrices/(1E6*N);  % [EUR/W]

for k = 1:(size(Qout,1)-1)
    
    c = [0,inputPrices(k)*dt];
    
    % Equality constraints
    Aeq = [1,-B(2)];
    beq = A*T(k) + B(1)*Qout(k) + ck*Tamb(k);
    
    % Inequality constraints
    Am = [];%[-1,0];
    b = [];%Tmin;
    
    lb = [Tmin,0]; %lower bound
    
    ub = [0,QinMax]; %upper bound
    
    options = optimoptions('linprog','Algorithm','dual-simplex','Display','off');
    
    [x2,~,exitflag,~,~] = linprog(c,Am,b,Aeq,beq,lb,ub,options);
    assert(exitflag > 0);
    
    T(k+1) = A*T(k) + B*[Qout(k);x2] + ck*Tamb(k);

end
cost = sum(c*x2);