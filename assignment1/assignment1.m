%% Assignment 1 Linear Programming
% Luca de Laat      - 4135040
% Nathan Timmers    - 4283449
clear all; close all; clc;
fprintf('Assignment 1 - Linear Programming \n')
fprintf('Luca de Laat   - 4135040 \n')
fprintf('Nathan Timmers - 4283449 \n\n')
%% Initializing Constants
E1 = 4;
E2 = 8;
E3 = 9;

% Battery constraints
bc = (5 + E1) * 10e6;       % battery cells
bw = 6*10e3;                % battery cells for W
br = 4*10e3;                % battery cells for R
bv = 2*10e3;                % battery cells for V

% Storage space contraints
avs = (15 + E3) * 10e3;     % available storage space
rssw = 12;                  % required storage space W
rssr = 10;                  % required storage space R
rssv = 8;                   % required storage space V

% Time constraints
hrw = 15;                   % hours required for W
hrr = 10;                   % hours required for R
hrv = 8;                    % hours required for V
nemp = 100 + E2;            % number of employees
hpm = 160;                  % hours per month per employee
thpm = nemp * hpm;          % total hours

% Costs
ms = 3000 + 50*E3;          % monthly salary
pr = 55000;                 % price R
pw = 75000;                 % price W
pv = 45000;                 % price V
mcr = 30000;                % manufacturing cost R
mcw = 45000;                % manufacturing cost W
mcv = 15000;                % manufacturing cost V

%% Question 1 & 2
fprintf('Question 1 & 2: \n')
c = [(mcr - pr), (mcw - pw)];

A =[br,     bw;
    rssr,   rssw;
    hrr,    hrw];

b = [bc, avs, thpm];

lb = [0 0]; %lower bound

ub = [inf inf]; %upper bound

options = optimoptions('linprog','Algorithm','dual-simplex','Display','off');

[x1,~,exitflag,~,~] = linprog(c,A,b,[],[],lb,ub,options);
assert(exitflag == 1);
round(x1);
profitQ2 =-c*round(x1) - nemp*ms; % Total profit
sQ2 = -(A*x1-b');

fprintf('Number of model R cars: %d \nNumber of model W cars: %d \n', x1(1), x1(2))
fprintf('Total optimal profit for Question 2: %3.0f \n\n', profitQ2)

%% Question 3
fprintf('Question 3: \n')
ub = [1000 inf]; % upper bound

[x2,~,exitflag,~,~] = linprog(c,A,b,[],[],lb,ub,options);
assert(exitflag == 1);
x2 = round(x2);
profitQ3 =-c*round(x2)  - nemp*ms; % Total profit

fprintf('Number of model R cars: %d \nNumber of model W cars: %d \n', x2(1), x2(2))
fprintf('Total optimal profit for Question 3: %3.0f \n\n', profitQ3)


%% Question 4 & 5
fprintf('Question 4 & 5: \n')
bc = (8 + E1) * 10e6;       % new battery cells constraint
avs = (22 + E3) * 10e3;     % new available storage space constraint

c = [(mcr - pr), (mcw - pw)];

lb = [0 0];                 % lower bound

ub = [1000 inf];            % upper bound

% Loop over extra hired workers
x_3 = 0:72;

for i = 1:length(x_3)
    
    whr = 5/60*x_3(i); % work time reduction per car
    
    A =[br,     bw;
        rssr,   rssw;
        hrr-whr,    hrw-whr];
    
    b = [bc, avs, thpm+160*x_3(i)];
    
    [x3(:,i),~,exitflag,~,~] = linprog(c,A,b,[],[],lb,ub,options);
    assert(exitflag == 1);
    round(x3(:,i));
    profitQ4(i) = -c*round(x3(:,i))-ms*x_3(i);
end

maxIndex = find(profitQ4 == max(profitQ4));
optWorkers = x_3(maxIndex);
maxProfitQ4 = profitQ4(maxIndex)  - nemp*ms; % Total profit
fprintf('Optimal amount of extra hired workers: %d \n', optWorkers)
fprintf('Number of model R cars: %d \nNumber of model W cars: %d \n', x3(1,maxIndex), round(x3(2,maxIndex)))
fprintf('Total optimal profit for Question 4: %3.0f \n \n', maxProfitQ4)

%% Question 6
fprintf('Question 6: \n')
whr = 5/60*optWorkers;

c4 = [(mcr - pr), (mcw - pw), (mcv - pv) ];

lb4 = [1250 1000 1500]; %lower bound

ub4 = [inf inf inf]; %upper bound

A4 = [br,        bw,         bv;
    rssr,      rssw,       rssv;
    hrr-whr,   hrw-whr,    hrv];

b4 = [bc, avs, thpm+160*optWorkers];

[x4,fval,exitflag,~,~] = linprog(c4,A4,b4,[],[],lb4,ub4,options);

if isempty(x4)
    msg = 'It is NOT economically beneficial to build the new model V';
    warning(msg);
    
    % check if x1 = 1500, x2 = 1000, x3 = 0 is within constraints
    xcheck = [1250;1000;0];
    
    if(A4*xcheck-(b4')>0)
        msg = 'Contract for Model W and Model R is not within constraints';
        warning(msg);
    else
        disp('Contract for Model W and Model R is within constraints');
    end

end
